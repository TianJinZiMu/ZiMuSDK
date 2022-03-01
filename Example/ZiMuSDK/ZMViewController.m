//
//  ZMViewController.m
//  ZiMuSDK
//
//  Created by gongjing.yin on 03/01/2022.
//  Copyright (c) 2022 gongjing.yin. All rights reserved.
//

#import "ZMViewController.h"
#import <ZiMuSDK/ZiMuSDK.h>
@interface ZMViewController ()

@end

@implementation ZMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[ZiMuSDK shareInstance]createPayment:nil viewController:self appURLScheme:@"xyqb" withCompletion:^(NSString * _Nonnull result, ZiMuSDKError * _Nullable error) {
            
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
