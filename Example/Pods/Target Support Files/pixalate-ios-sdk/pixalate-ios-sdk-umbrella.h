#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "Pixalate.h"
#import "PXBlockingParameters.h"
#import "PXGlobalConfig.h"
#import "PXImpression.h"
#import "PXImpressionBuilder.h"

FOUNDATION_EXPORT double pixalate_ios_sdkVersionNumber;
FOUNDATION_EXPORT const unsigned char pixalate_ios_sdkVersionString[];

