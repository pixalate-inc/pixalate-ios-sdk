//
//  Pixalate.m
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#include <stdlib.h>
#import "Pixalate.h"
#import "PXLogger.h"
#import "PXBlockingResult.h"
#import "PXTimer.h"

NSString *const PXBaseImpressionURL = @"https://adrta.com/i";
NSString *const PXBaseFraudURL = @"https://api.adrta.com/services/2012/Suspect/get";

NSTimeInterval const PXRetryIntervals[] = { 1, 2, 4, 8, 16 };
int const PXRetryIntervalsSize = (sizeof PXRetryIntervals) / (sizeof PXRetryIntervals[0]);

@implementation Pixalate

#define CacheResultError(parameters,error) \
if( Pixalate.globalConfig.cacheAge > 0 ) { \
    [blockingCache setObject:[PXBlockingResult makeWithError:error] forKey:[parameters copy]]; \
}

#define CacheResult(parameters,probability) \
if( Pixalate.globalConfig.cacheAge > 0 ) { \
    [blockingCache setObject:[PXBlockingResult makeWithProbability:[probability doubleValue]] forKey:[parameters copy]]; \
}

static PXGlobalConfig* config;
static NSCache<PXBlockingParameters*,PXBlockingResult*>* blockingCache;

+(void)initialize {
    blockingCache = [[NSCache<PXBlockingParameters*,PXBlockingResult*> alloc] init];
}

+(PXGlobalConfig*)globalConfig {
    @synchronized (self) {
        return config;
    }
}

+(void)setGlobalConfig:(PXGlobalConfig *)val {
    @synchronized (self) {
        config = val;
    }
}

+ (void) setLogLevel: (PXLogLevel)level {
    [PXLogger setLogLevel:level];
}

// no need to follow redirects manually
+ (void) sendImpressionWithURL:(NSURL *)url retry:(int) retry {
    
    [PXLogger logWithFormat:PXLogLevelDebug message:@"Impression URL: %@",url.absoluteString];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"HEAD";
    
    NSURLSessionDataTask* task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData* data, NSURLResponse* response, NSError* error) {
        if( error != nil ) {
            [PXLogger logWithFormat:PXLogLevelDebug message:@"Error sending impression: %@", error];
            
            if( retry < PXRetryIntervalsSize ) {
                [PXTimer scheduledTimerWithTimeInterval:PXRetryIntervals[ retry ] block:^{
                    [Pixalate sendImpressionWithURL:url retry:retry+1];
                }];
            }
        }
        
        NSHTTPURLResponse* httpResponse = (NSHTTPURLResponse*)response;
        
        NSInteger statusCode = httpResponse.statusCode;
        
        if( statusCode != 200 ) {
            [PXLogger logWithFormat:PXLogLevelDebug message:@"Error sending impression: %ld", (long)statusCode];
            
            if( retry < PXRetryIntervalsSize ) {
                [PXTimer scheduledTimerWithTimeInterval:PXRetryIntervals[ retry ] block:^{
                    [Pixalate sendImpressionWithURL:url retry:retry+1];
                }];
            }
        }
    }];
    [task resume];
}
+ (void) sendImpression: (PXImpression*) impression {
    NSURLComponents* urlBuilder = [[NSURLComponents alloc] initWithString:PXBaseImpressionURL];
    
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray<NSURLQueryItem*> alloc] initWithCapacity:impression.urlParameters.count];
    
    for (id key in impression.urlParameters) {
        NSURLQueryItem* item = [[NSURLQueryItem alloc] initWithName:key value:[impression.urlParameters objectForKey:key]];
        [items addObject:item];
    }
    
    // add cachebuster to end of url
    [items addObject:[[NSURLQueryItem alloc] initWithName:@"cb" value:[@(arc4random_uniform(999999)) stringValue]]];
     
    [urlBuilder setQueryItems:items];
    
    NSURL* url = urlBuilder.URL;
    
    [Pixalate sendImpressionWithURL:url retry:0];
}

+ (void)requestBlockStatus:(PXBlockingParameters*)parameters responseHandler:(void (^)(BOOL, NSError*))handler {
    if( Pixalate.globalConfig == nil ) {
        @throw [[NSException alloc] initWithName:@"PXInvalidStateException" reason:@"You must configure Pixalate.globalConfig before you can request block status." userInfo:nil];
    }
    
    PXBlockingResult *result = [blockingCache objectForKey:parameters];
    
    if( Pixalate.globalConfig.cacheAge > 0 ) {
        if( result != nil ) {
            if( result.valid ) {
                BOOL res = result.probability > Pixalate.globalConfig.threshold;
                handler( res, nil );
            } else {
                [blockingCache removeObjectForKey:parameters];
            }
        }
    }
    
    NSURLComponents *urlBuilder = [[NSURLComponents alloc] initWithString:PXBaseFraudURL];
    
    NSMutableArray<NSURLQueryItem*>* items = [[NSMutableArray<NSURLQueryItem*> alloc] initWithCapacity:5];
    
    [items addObject:[[NSURLQueryItem alloc] initWithName:@"username" value:Pixalate.globalConfig.username]];
    [items addObject:[[NSURLQueryItem alloc] initWithName:@"password" value:Pixalate.globalConfig.password]];
    if( parameters.deviceId != nil ) [items addObject:[[NSURLQueryItem alloc] initWithName:@"deviceId" value:parameters.deviceId]];
    if( parameters.userAgent != nil ) [items addObject:[[NSURLQueryItem alloc] initWithName:@"userAgent" value:parameters.userAgent]];
    if( parameters.ip != nil ) [items addObject:[[NSURLQueryItem alloc] initWithName:@"userAgent" value:parameters.ip]];
    
    [urlBuilder setQueryItems:items];
    
    NSURL* url = urlBuilder.URL;
    
    [PXLogger logWithFormat:PXLogLevelInfo message:@"Block Status URL: %@", url.absoluteString];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = Pixalate.globalConfig.timeoutInterval;
    
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if( error != nil ) {
            [PXLogger logWithFormat:PXLogLevelDebug message:@"Error retrieving block status: %@", error];
            // dont cache erroring results
            // CacheResultError(parameters, error);
            handler( NO, error );
            return;
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if( error != nil ) {
            [PXLogger logWithFormat:PXLogLevelDebug message:@"Error retrieving block status: %@", error];
            // dont cache erroring results
            // CacheResultError(parameters, error);
            handler( NO, error );
            return;
        }
        
        NSNumber *status = json[ @"status" ];
        
        if( status != nil ) {
            NSString *desc = NSLocalizedString(json[ @"message" ], nil);
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey: desc
                                       };
            NSError *error = [[NSError alloc] initWithDomain:NSURLErrorDomain code:[status integerValue] userInfo:userInfo];
            // dont cache erroring results
            // CacheResultError(parameters, error);
            handler( NO, error );
            return;
        }
        
        NSNumber *probability = json[ @"probability" ];
        
        [PXLogger logWithFormat:PXLogLevelDebug message:@"Probability: %@", probability];
        
        BOOL res = [probability doubleValue] > Pixalate.globalConfig.threshold;
        
        CacheResult(parameters, probability);
        handler( res, error );
    }];
    [task resume];
}

@end

NSString *const PXPlatformId = @"paid";
NSString *const PXAdvertiserId = @"avid";
NSString *const PXCampaignId = @"caid";
NSString *const PXCreativeId = @"plid";

NSString *const PXPublisherId = @"publisherId";
NSString *const PXSiteId = @"siteId";
NSString *const PXLineItemId = @"lineItemId";
NSString *const PXBidPrice = @"priceBid";
NSString *const PXClearPrice = @"pricePaid";

NSString *const PXCreativeSize = @"kv1";
NSString *const PXPageUrl = @"kv2";
NSString *const PXUserId = @"kv3";
NSString *const PXUserIp = @"kv4";
NSString *const PXSellerId = @"kv7";
NSString *const PXVideoLength = @"kv9";

NSString *const PXIsp = @"kv10";
NSString *const PXImpressionId = @"kv11";
NSString *const PXPlacementId = @"kv12";
NSString *const PXContentId = @"kv13";
NSString *const PXMraidVersion = @"kv14";
NSString *const PXGeographicRegion = @"kv15";
NSString *const PXLatitude = @"kv16";
NSString *const PXLongitude = @"kv17";
NSString *const PXAppId = @"kv18";
NSString *const PXDeviceId = @"kv19";

NSString *const PXCarrierId = @"kv23";
NSString *const PXAppName = @"kv25";
NSString *const PXUserAgent = @"kv27";
NSString *const PXDeviceModel = @"kv28";

NSString *const PXVideoPlayStatus = @"kv44";

// internal keys
