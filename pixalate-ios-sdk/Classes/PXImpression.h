//
//  PXImpression.h
//  pxsdk-lib-ios
//
//  Created by Pixalate on 8/13/19.
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#ifndef PXImpression_h
#define PXImpression_h

@interface PXImpressionBuilder : NSObject

@property(nonatomic) BOOL isVideo;
@property(nonatomic,copy,readonly) NSString* _Nonnull clientId;
@property(nonatomic,readonly) NSMutableDictionary<NSString*,NSString*> *_Nonnull urlParameters;

-(void)setParameter:(NSString* _Nonnull)key withValue:(NSString* _Nullable)value;

- (NSString* _Nullable)objectForKeyedSubscript:(NSString* _Nonnull)key API_AVAILABLE(macos(10.8), ios(6.0), watchos(2.0), tvos(9.0));

- (void)setObject:(NSString* _Nonnull)anObject forKeyedSubscript:(NSString* _Nullable)aKey;

@end


@interface PXImpression : NSObject

@property(nonatomic, readonly) NSDictionary<NSString*,NSString*> *_Nonnull urlParameters;

- (instancetype _Nonnull)initWithBuilder:(PXImpressionBuilder* _Nonnull)builder;
+ (instancetype _Nonnull)makeWithClientId:(NSString* _Nonnull)clientId builder:(void (^ _Nonnull)(PXImpressionBuilder* _Nonnull))updateBlock;

@end

#endif /* PXImpression_h */
