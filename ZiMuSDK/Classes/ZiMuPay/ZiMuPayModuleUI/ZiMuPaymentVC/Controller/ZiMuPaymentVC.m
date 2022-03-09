//
//  ZiMuPaymentVC.m
//  ZiMuSDK_Example
//
//  Created by Comodo on 2022/3/7.
//  Copyright © 2022 gongjing.yin. All rights reserved.
//

#import "ZiMuPaymentVC.h"
#import "ZiMuRequestCenter.h"
@interface ZiMuPaymentVC ()

@end

@implementation ZiMuPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    
    NSString *urlString =@"open/trade/v1/order/created";
    [[ZiMuRequestCenter shareManager] encryptionPOST:urlString headers:nil parameters:@{} success:^(id  _Nonnull responseObject) {
        
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
            NSLog(@"错误了：%@",[ZiMuBaseNetwork getMessageWithFailureError:error]);

        }];
    
} 

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
