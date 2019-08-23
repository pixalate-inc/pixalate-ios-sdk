//
//  PXGlobalConfig.m
//  pxsdk-lib-ios
//
//  Created by Pixalate on 8/13/19.
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#import "PXGlobalConfig.h"

const int PXDefaultCacheAge = 1000 * 60 * 60 * 8; // 8 hours
const double PXDefaultThreshold = 0.75;

@implementation PXGlobalConfig

-(instancetype _Nonnull)initWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password {
    return [self initWithUsername:username password:password threshold:PXDefaultThreshold cacheAge:PXDefaultCacheAge];
}
-(instancetype _Nonnull)initWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password threshold:(double)threshold {
    return [self initWithUsername:username password:password threshold:threshold cacheAge:PXDefaultCacheAge];
}
-(instancetype _Nonnull)initWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password threshold:(double)threshold cacheAge:(int)age {
    if( threshold < 0.1 || threshold > 1 ) {
        @throw [NSException exceptionWithName:NSRangeException reason:@"Threshold must be within 0.1 and 1 (inclusive)." userInfo:nil];
    }
    if( age < 0 ) age = 0;
    
    self.username = username;
    self.password = password;
    self.threshold = threshold;
    self.cacheAge = age;
    
    return self;
}

+(instancetype _Nonnull)makeWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password {
    return [[PXGlobalConfig alloc] initWithUsername:username password:password];
}
+(instancetype _Nonnull)makeWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password threshold:(double)threshold {
    return[[PXGlobalConfig alloc] initWithUsername:username password:password threshold:threshold];
}
+(instancetype _Nonnull)makeWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password threshold:(double)threshold cacheAge:(int)age {
    return[[PXGlobalConfig alloc] initWithUsername:username password:password threshold:threshold cacheAge:age];
}

@end
