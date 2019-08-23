//
//  MyViewController.m
//  pxsdk-lib-ios
//
//  Created by Nate Tessman on 08/13/2019.
//  Copyright (c) 2019 Nate Tessman. All rights reserved.
//

#import "MyViewController.h"
#import "Pixalate.h"

@interface MyViewController ()

@end

@implementation MyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    Pixalate.globalConfig = [PXGlobalConfig makeWithUsername:@"jason" password:@"brest" threshold:0.75 cacheAge:1000*60*60*2];
    
    [Pixalate requestBlockStatus:[PXBlockingParameters makeWithBuilder:^(PXBlockingParametersBuilder *builder) {
//        builder.deviceId = @"asdf1234";
        builder.userAgent = @"Bot Googlebot/2.1 (iPod; N; RISC OS 2.4.35; IBM360; rv1.3.1) Alligator/20080524 Jungledog/3.0";
//        builder.userAgent = @"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/75.0.3770.142 Safari/537.36";
//        builder.ip = @"asdf1234";
    }] responseHandler:^(BOOL blocked, NSError *error) {
        if( error != nil ) {
            NSLog( @"Encountered error: %@", error );
        }
    }];
    
//    [Pixalate sendImpression:
//     [PXImpression makeWithClientId: @"px" builder:
//      ^(PXImpressionBuilder *builder){
//          builder.isVideo = NO;
//          builder[ PXAppId ] = @"com.adrta.testbed";
//          builder[ PXUserAgent ] = @"blahblahblah";
//      }
//      ]
//     ];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
