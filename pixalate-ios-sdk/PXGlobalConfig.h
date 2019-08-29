//
//  PXGlobalConfig.h
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#ifndef PXGlobalConfig_h
#define PXGlobalConfig_h

@interface PXGlobalConfigBuilder : NSObject

@property(nonatomic,copy) NSString* _Nonnull username;
@property(nonatomic,copy) NSString* _Nonnull password;
@property(nonatomic) double threshold;
@property(nonatomic) double cacheAge;
@property(nonatomic) double timeoutInterval;

- (instancetype _Nonnull)init NS_SWIFT_UNAVAILABLE("use initWithUsername:password:");
-(instancetype _Nonnull)initWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password;
-(instancetype _Nonnull)initWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password threshold:(double)threshold;
-(instancetype _Nonnull)initWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password threshold:(double)threshold cacheAge:(int)age;
-(instancetype _Nonnull)initWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password threshold:(double)threshold cacheAge:(int)age timeoutInterval:(double)timeoutInterval;

@end

@interface PXGlobalConfig : NSObject

@property(nonatomic,copy,readonly) NSString* _Nonnull username;
@property(nonatomic,copy,readonly) NSString* _Nonnull password;
@property(nonatomic,readonly) double threshold;
@property(nonatomic,readonly) double cacheAge;
@property(nonatomic,readonly) double timeoutInterval;

- (instancetype _Nonnull) init NS_SWIFT_UNAVAILABLE("use initWithBuilder:");
- (instancetype _Nonnull) initWithBuilder:(PXGlobalConfigBuilder * _Nonnull) builder;

+ (instancetype _Nonnull) makeWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password NS_SWIFT_NAME(make(username:password:));
+ (instancetype _Nonnull) makeWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password builder:(void (^ _Nonnull)(PXGlobalConfigBuilder* _Nonnull))updateBlock NS_SWIFT_NAME(make(username:password:builder:));

@end

#endif /* PXGlobalConfig_h */
