//
//  Pixalate.h
//  pxsdk-lib-ios
//
//  Created by Pixalate on 8/13/19.
//  Copyright © 2019 Pixalate, Inc. All rights reserved.
//

#ifndef Pixalate_h
#define Pixalate_h

#import "PXImpression.h"
#import "PXGlobalConfig.h"
#import "PXBlockingParameters.h"

@interface Pixalate : NSObject

+ (PXGlobalConfig* _Nullable)globalConfig;
+ (void)setGlobalConfig:(PXGlobalConfig* _Nullable)val;

+ (void)sendImpression:(PXImpression* _Nullable)impression;
+ (void)requestBlockStatus:(PXBlockingParameters* _Nullable)parameters responseHandler:(void (^ _Nonnull)(BOOL block, NSError * _Nullable error))handler;

@end

FOUNDATION_EXPORT NSString * _Nonnull const PXPlatformId;
FOUNDATION_EXPORT NSString * _Nonnull const PXAdvertiserId;
FOUNDATION_EXPORT NSString * _Nonnull const PXCampaignId;
FOUNDATION_EXPORT NSString * _Nonnull const PXCreativeId;

FOUNDATION_EXPORT NSString * _Nonnull const PXPublisherId;
FOUNDATION_EXPORT NSString * _Nonnull const PXSiteId;
FOUNDATION_EXPORT NSString * _Nonnull const PXLineItemId;
FOUNDATION_EXPORT NSString * _Nonnull const PXBidPrice;
FOUNDATION_EXPORT NSString * _Nonnull const PXClearPrice;

FOUNDATION_EXPORT NSString * _Nonnull const PXCreativeSize;
FOUNDATION_EXPORT NSString * _Nonnull const PXPageUrl;
FOUNDATION_EXPORT NSString * _Nonnull const PXUserId;
FOUNDATION_EXPORT NSString * _Nonnull const PXUserIp;
FOUNDATION_EXPORT NSString * _Nonnull const PXSellerId;
FOUNDATION_EXPORT NSString * _Nonnull const PXVideoLength;

FOUNDATION_EXPORT NSString * _Nonnull const PXIsp;
FOUNDATION_EXPORT NSString * _Nonnull const PXImpressionId;
FOUNDATION_EXPORT NSString * _Nonnull const PXPlacementId;
FOUNDATION_EXPORT NSString * _Nonnull const PXContentId;
FOUNDATION_EXPORT NSString * _Nonnull const PXMraidVersion;
FOUNDATION_EXPORT NSString * _Nonnull const PXGeographicRegion;
FOUNDATION_EXPORT NSString * _Nonnull const PXLatitude;
FOUNDATION_EXPORT NSString * _Nonnull const PXLongitude;
FOUNDATION_EXPORT NSString * _Nonnull const PXAppId;
FOUNDATION_EXPORT NSString * _Nonnull const PXDeviceId;

FOUNDATION_EXPORT NSString * _Nonnull const PXCarrierId;
FOUNDATION_EXPORT NSString * _Nonnull const PXAppName;
FOUNDATION_EXPORT NSString * _Nonnull const PXUserAgent;
FOUNDATION_EXPORT NSString * _Nonnull const PXDeviceModel;

FOUNDATION_EXPORT NSString * _Nonnull const PXVideoPlayStatus;

#endif /* Pixalate_h */
