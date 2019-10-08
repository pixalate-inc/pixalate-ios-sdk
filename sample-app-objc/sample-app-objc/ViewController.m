//
//  ViewController.m
//  sample-app-objc
//
//  Copyright © 2019 Pixalate. All rights reserved.
//

#import "ViewController.h"

NSString* const APP_UNIT_ID = @"0ac59b0996d947309c33f59d6676399f";
const CGFloat AD_SIZE_WIDTH = 320;
const CGFloat AD_SIZE_HEIGHT = 50;

@interface ViewController ()

@property(atomic,readwrite) MPAdView* adView;

@end

@implementation ViewController

- (UIViewController *)viewControllerForPresentingModalView {
    return self;
}

- (void)adViewDidLoadAd:(MPAdView *)view adSize:(CGSize)adSize {
    [Pixalate sendImpression:[PXImpression makeWithClientId:@"[CLIENT_ID]" builder:^(PXImpressionBuilder* builder) {
       
        builder[ PXCampaignId ] = @"[CAMPAIGN_ID]";
        builder[ PXCreativeSize ] = [NSString stringWithFormat:@"%dx%d", (int)AD_SIZE_WIDTH, (int)AD_SIZE_HEIGHT];
        builder[ PXAppId ] = @"com.example.app";
    }]];
}

- (void)loadAd {
    self.adView = [[MPAdView alloc] initWithAdUnitId:APP_UNIT_ID];
    self.adView.delegate = self;
    
    self.adView.frame = CGRectMake( (self.view.bounds.size.width - AD_SIZE_WIDTH)/2, 100,
                                   AD_SIZE_WIDTH, AD_SIZE_HEIGHT);
    
    [self.view addSubview:self.adView];
    [self.adView loadAd];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [Pixalate setLogLevel:PXLogLevelDebug];
    
    [Pixalate setGlobalConfig:[PXGlobalConfig makeWithUsername:@"[USERNAME]" password:@"[PASSWORD]" builder:^(PXGlobalConfigBuilder* builder) {
        
        builder.timeoutInterval = 2;
        builder.threshold = 0.75;
    }]];
    
    MPMoPubConfiguration* mopubConfig = [[MPMoPubConfiguration alloc] initWithAdUnitIdForAppInitialization:APP_UNIT_ID];
    
    mopubConfig.globalMediationSettings = @[];
    mopubConfig.loggingLevel = MPBLogLevelInfo;
    
    [MoPub.sharedInstance initializeSdkWithConfiguration:mopubConfig completion:^{
        PXBlockingParameters* params = [PXBlockingParameters makeWithBuilder:^(PXBlockingParametersBuilder* builder) {
            
            builder.userAgent = @"[USER_AGENT]";
            builder.ip = @"[IP_ADDRESS]";
            builder.deviceId = @"[DEVICE_ID]";
        }];
        
        [Pixalate requestBlockStatus:params responseHandler:^(BOOL block, NSError* error) {
           
            if( error != nil ) {
                // An error occurred in the request. (authentication, internet connectivity issues, etc.)
                NSLog( @"%@", error );
                
                // It may make the most sense to simply try to continue loading the ad in this situation.
                
                [self loadAd];
                return;
            }
            
            if( block ) {
                // Traffic is above the threshold and should be blocked.
                NSLog( @"Ad load was blocked." );
            } else {
                // Traffic is below the threshold and can be allowed.
                NSLog( @"Ad load was allowed." );
                
                // Ad loading code could go here.
                [self loadAd];
            }
        }];
        }
     ];
}

@end
