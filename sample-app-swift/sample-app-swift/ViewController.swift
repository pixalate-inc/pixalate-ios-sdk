//
//  ViewController.swift
//  sample-app-swift
//
//  Created by Nate Tessman on 8/26/19.
//  Copyright © 2019 Pixalate. All rights reserved.
//

import UIKit
import pixalate_ios_sdk
import MoPub



class ViewController: UIViewController, MPAdViewDelegate {
    
    let APP_UNIT_ID = "0ac59b0996d947309c33f59d6676399f"
    let AD_SIZE = CGRect(x: 0,y: 0,width: 320,height: 50)
    
    var adView:MPAdView!
    
    func viewControllerForPresentingModalView() -> UIViewController! {
        return self;
    }
    
    func adViewDidLoadAd(_ view: MPAdView!, adSize: CGSize) {
        // Send your impression as close to Begin to Render as possible, according to MRC guidelines.
        Pixalate.sendImpression(PXImpression.make(clientId: "[CLIENT ID]", builder: { builder in
            builder[ PXCampaignId ] = "[CAMPAIGN_ID]"
            builder[ PXCreativeSize ] = String(format: "%dx%d", Int(self.AD_SIZE.width), Int(self.AD_SIZE.height))
            builder[ PXAppId ] = "com.example.app"
        }))
    }

    func loadAd() {
        adView = MPAdView(adUnitId: APP_UNIT_ID)
        adView.delegate = self
        
        adView.frame = CGRect(x: (view.bounds.size.width - AD_SIZE.width)/2, y: 100,
                                   width: AD_SIZE.width, height: AD_SIZE.height)
        
        view.addSubview(adView)
        adView.loadAd()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Pixalate.setLogLevel(PXLogLevel.debug);
        
        Pixalate.setGlobalConfig(
            PXGlobalConfig.make(
                username: "[USERNAME]",
                password: "[PASSWORD]",
                builder: {
                    $0.timeoutInterval = 2
                    $0.threshold = 0.75
            })
        )
        
        let mopubConfig:MPMoPubConfiguration = MPMoPubConfiguration(adUnitIdForAppInitialization: APP_UNIT_ID)
        mopubConfig.globalMediationSettings = []
        mopubConfig.loggingLevel = MPBLogLevel.info
        
        MoPub.sharedInstance().initializeSdk(with: mopubConfig, completion: {
            let params = PXBlockingParameters.make {
                $0.userAgent = "[USER_AGENT]";
                $0.ip = "[IP_ADDRESS]";
                $0.deviceId = "[DEVICE_ID]";
            }
            
            Pixalate.requestBlockStatus(
                params,
                responseHandler: { block, err in
                    if( err != nil ) {
                        // An error occurred in the request. (authentication, internet connectivity issues, etc.)
                        print( err! )
                        
                        // It may make the most sense to simply try to continue loading the ad in this situation.
                        self.loadAd()
                        return
                    }
                    
                    if( block ) {
                        // Traffic is above the threshold and should be blocked.
                        print( "Ad load was blocked." )
                    } else {
                        // Traffic is below the threshold and can be allowed.
                        print( "Ad load was allowed." )
                        
                        // Ad loading code could go here.
                        self.loadAd()
                    }
                }
            )
        })
        
    }
}

