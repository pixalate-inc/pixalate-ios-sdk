//
//  PXImpression.h
//  pxsdk-lib-ios
//
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#ifndef PXImpression_h
#define PXImpression_h

@interface PXImpressionBuilder : NSObject

@property(nonatomic) BOOL isVideo;
@property(nonatomic,copy,readonly) NSString* _Nonnull clientId;
@property(nonatomic,readonly) NSMutableDictionary<NSString*,NSString*> *_Nonnull urlParameters;

- (instancetype _Nonnull)init NS_SWIFT_UNAVAILABLE("use initWithClientId:");
- (instancetype _Nonnull)initWithClientId: (NSString * _Nonnull)clientId;

- (void)setParameter:(NSString* _Nonnull)key withValue:(NSString* _Nullable)value;

- (NSString* _Nullable)objectForKeyedSubscript:(NSString* _Nonnull)key;
- (void)setObject:(NSString* _Nullable)obj forKeyedSubscript:(NSString* _Nonnull)key;

@end


@interface PXImpression : NSObject

@property(nonatomic, readonly) NSDictionary<NSString*,NSString*> *_Nonnull urlParameters;

- (instancetype _Nonnull)init NS_SWIFT_UNAVAILABLE("use initWithBuilder:");
- (instancetype _Nonnull)initWithBuilder:(PXImpressionBuilder* _Nonnull)builder;

+ (instancetype _Nonnull)makeWithClientId:(NSString* _Nonnull)clientId builder:(void (^ _Nonnull)(PXImpressionBuilder* _Nonnull))updateBlock NS_SWIFT_NAME(make(clientId:builder:));

@end

#endif /* PXImpression_h */
