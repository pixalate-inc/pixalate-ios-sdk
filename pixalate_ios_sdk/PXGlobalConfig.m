//
//  PXGlobalConfig.m
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#import "PXGlobalConfig.h"

const int PXDefaultCacheAge = 60 * 60 * 8; // 8 hours in seconds
const double PXDefaultThreshold = 0.75;
const double PXDefaultTimeoutInterval = 2; // in seconds


@implementation PXGlobalConfigBuilder

@synthesize threshold = _threshold;
@synthesize timeoutInterval = _timeoutInterval;
@synthesize cacheAge = _cacheAge;

-(void) setThreshold:(double)threshold {
    if( threshold < 0.1 || threshold > 1 ) {
        @throw [NSException exceptionWithName:NSRangeException reason:[NSString stringWithFormat:@"Threshold must be within 0.1 and 1 inclusive (got %f).", threshold] userInfo:nil];
    }

    _threshold = threshold;
}

-(void) setTimeoutInterval:(double)timeoutInterval {
    if( timeoutInterval <= 0 ) {
        @throw [NSException exceptionWithName:NSRangeException reason:[NSString stringWithFormat:@"Timeout interval must be greater that 0 (got %f).", timeoutInterval] userInfo:nil];
    }

    _timeoutInterval = timeoutInterval;
}

-(void) setCacheAge:(double)cacheAge {
    if( cacheAge < 0 ) cacheAge = 0;
    _cacheAge = cacheAge;
}

-(instancetype)init NS_SWIFT_UNAVAILABLE("use initWithUsername:password:") {
    return self;
}

-(instancetype)initWithUsername:(NSString*)username password:(NSString*)password {
    return [self initWithUsername:username password:password threshold:PXDefaultThreshold cacheAge:PXDefaultCacheAge timeoutInterval:PXDefaultTimeoutInterval];
}
-(instancetype)initWithUsername:(NSString*)username password:(NSString*)password threshold:(double)threshold {
    return [self initWithUsername:username password:password threshold:threshold cacheAge:PXDefaultCacheAge];
}
-(instancetype)initWithUsername:(NSString*)username password:(NSString*)password threshold:(double)threshold cacheAge:(int)age {
    return [self initWithUsername:username password:password threshold:threshold cacheAge:age];
}
-(instancetype)initWithUsername:(NSString*)username password:(NSString*)password threshold:(double)threshold cacheAge:(int)age timeoutInterval:(double)timeoutInterval {
    self.username = username;
    self.password = password;
    self.threshold = threshold;
    self.cacheAge = age;
    self.timeoutInterval = timeoutInterval;

    return self;
}
@end

@interface PXGlobalConfig ()

@property(nonatomic,copy) NSString* username;
@property(nonatomic,copy) NSString* password;
@property(nonatomic) double threshold;
@property(nonatomic) double cacheAge;
@property(nonatomic) double timeoutInterval;

@end

@implementation PXGlobalConfig

-(instancetype)init NS_SWIFT_UNAVAILABLE("use initWithBuilder:") {
    return self;
}

-(instancetype)initWithBuilder:(PXGlobalConfigBuilder*)builder {
    self.username = builder.username;
    self.password = builder.password;
    self.threshold = builder.threshold;
    self.cacheAge = builder.cacheAge;
    self.timeoutInterval = builder.timeoutInterval;
    return self;
}

+(instancetype)makeWithUsername:(NSString*)username password:(NSString*)password {
    PXGlobalConfigBuilder *builder = [[PXGlobalConfigBuilder alloc] init];
    builder.username = username;
    builder.password = password;
    
    PXGlobalConfig *config = [[PXGlobalConfig alloc] initWithBuilder:builder];
    return config;
}

+(instancetype)makeWithUsername:(NSString*)username password:(NSString*)password builder:(void (^)(PXGlobalConfigBuilder*))updateBlock {
    PXGlobalConfigBuilder *builder = [[PXGlobalConfigBuilder alloc] init];
    builder.username = username;
    builder.password = password;
    updateBlock( builder );
    
    PXGlobalConfig *config = [[PXGlobalConfig alloc] initWithBuilder:builder];
    return config;
}

@end
