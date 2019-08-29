//
//  Pixalate.m
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#include <stdlib.h>
#import "Pixalate.h"

NSString *const PXBaseImpressionURL = @"http://localhost:3000/i";
NSString *const PXBaseFraudURL = @"https://api.adrta.com/services/2012/Suspect/get?";

@interface PXBlockingResult : NSObject

@property(nonatomic,copy) NSError* _Nullable error;
@property(nonatomic) double probability;
@property(nonatomic) double time;
@property(nonatomic,readonly) BOOL valid;

+(instancetype _Nonnull)makeWithError:(NSError* _Nonnull)err;
+(instancetype _Nonnull)makeWithProbability:(double)probability;

-(BOOL)getValid;

@end

@implementation PXBlockingResult

+(instancetype)makeWithError:(NSError *)err {
    PXBlockingResult *res = [[PXBlockingResult alloc] init];
    res.error = err;
    res.time = [[NSDate date] timeIntervalSince1970] + Pixalate.globalConfig.cacheAge;
    res.probability = 0;
    
    return res;
}

+(instancetype)makeWithProbability:(double)probability {
    PXBlockingResult *res = [[PXBlockingResult alloc] init];
    res.error = nil;
    res.probability = probability;
    res.time = [[NSDate date] timeIntervalSince1970] + Pixalate.globalConfig.cacheAge;
    
    return res;
}

-(BOOL)getValid {
    return self.time > [[NSDate date] timeIntervalSince1970];
}

@end

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
    
    NSLog( @"%@", url.absoluteString );
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"HEAD";
    
    NSURLSessionDataTask* task = [NSURLSession.sharedSession dataTaskWithRequest:request];
    [task resume];
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
    
    NSLog( @"%@", url.absoluteString );
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    request.HTTPMethod = @"GET";
    request.timeoutInterval = Pixalate.globalConfig.timeoutInterval;
    
    NSURLSessionDataTask *task = [NSURLSession.sharedSession dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if( error != nil ) {
            CacheResultError(parameters, error);
            handler( NO, error );
            return;
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if( error != nil ) {
            CacheResultError(parameters, error);
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
            CacheResultError(parameters, error);
            handler( NO, error );
            return;
        }
        
        NSNumber *probability = json[ @"probability" ];
//        NSLog( @"JSON RESPONSE: %@", probability );
//        NSLog( @"%@", response );
//        NSLog( @"%@", error );
        
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
