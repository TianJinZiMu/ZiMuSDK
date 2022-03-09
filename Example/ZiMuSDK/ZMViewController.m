//
//  ZMViewController.m
//  ZiMuPayService
//
//  Created by gongjing.yin on 03/01/2022.
//  Copyright (c) 2022 gongjing.yin. All rights reserved.
//

#import "ZMViewController.h"
#import <ZiMuSDK/ZiMuPayService.h>

@interface ZMViewController ()

@end

@implementation ZMViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    ZiMuPayReq *req = [[ZiMuPayReq alloc]init];
    [[ZiMuPayService shareInstance] payWithOrder:req viewController:self secheme:@"xyqb" resultHandle:^(ZiMuPayResultStatus status, NSDictionary * _Nullable info, NSError * _Nullable error) {
                
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
