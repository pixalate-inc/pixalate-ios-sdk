//
//  PXGlobalConfig.h
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#ifndef PXGlobalConfig_h
#define PXGlobalConfig_h

@interface PXGlobalConfig : NSObject

@property(nonatomic,copy) NSString* _Nonnull username;
@property(nonatomic,copy) NSString* _Nonnull password;
@property(nonatomic) double threshold;
@property(nonatomic) int cacheAge;

-(instancetype _Nonnull)initWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password;
-(instancetype _Nonnull)initWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password threshold:(double)threshold;
-(instancetype _Nonnull)initWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password threshold:(double)threshold cacheAge:(int)age;

+(instancetype _Nonnull)makeWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password;
+(instancetype _Nonnull)makeWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password threshold:(double)threshold;
+(instancetype _Nonnull)makeWithUsername:(NSString* _Nonnull)username password:(NSString* _Nonnull)password threshold:(double)threshold cacheAge:(int)age;

@end

#endif /* PXGlobalConfig_h */
