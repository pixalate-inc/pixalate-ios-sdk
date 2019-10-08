//
//  ViewController.h
//  sample-app-objc
//
//  Created by Nate Tessman on 8/26/19.
//  Copyright © 2019 Pixalate. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoPub.h"
#import "Pixalate.h"

@interface ViewController : UIViewController<MPAdViewDelegate>

-(UIViewController *)viewControllerForPresentingModalView;
-(void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize;

-(void)loadAd;

@end

