//
//  PXBlockingParameters.h
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#ifndef PXBlockingParameters_h
#define PXBlockingParameters_h

#import <Foundation/Foundation.h>

@interface PXBlockingParametersBuilder : NSObject

@property(nonatomic,copy) NSString* _Nullable deviceId;
@property(nonatomic,copy) NSString* _Nullable userAgent;
@property(nonatomic,copy) NSString* _Nullable ip;

@end

@interface PXBlockingParameters : NSObject <NSCopying>

@property(nonatomic,copy,readonly) NSString* _Nullable deviceId;
@property(nonatomic,copy,readonly) NSString* _Nullable userAgent;
@property(nonatomic,copy,readonly) NSString* _Nullable ip;

- (instancetype _Nonnull) init NS_SWIFT_UNAVAILABLE("use initWithBuilder:");
- (instancetype _Nonnull) initWithBuilder:(PXBlockingParametersBuilder * _Nonnull) builder;

+ (instancetype _Nonnull) makeWithBuilder:(void (^ _Nonnull)(PXBlockingParametersBuilder* _Nonnull))updateBlock;

@end

#endif /* PXBlockingParameters_h */
