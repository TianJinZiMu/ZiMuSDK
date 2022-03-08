//
//  ZiMuOrderService.m
//  ZiMuSDK
//
//  Created by Comodo on 2022/3/8.
//

#import "ZiMuOrderService.h"
#import "UINavigationController+Extension.h"
#import "ZiMuOrderVC.h"
@implementation ZiMuOrderService
#pragma mark - SDK 函数接口
/**
 *  SDK单例
 */
+(instancetype)shareInstance
{
    static ZiMuOrderService * shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ZiMuOrderService alloc] init];
        
    });
    return shareInstance;
}

/**
 打开订单Url
 
 @param url Url
 */
- (void)openOrderURL:(NSString *)url {
    UINavigationController *nav = [UINavigationController getCurrentNCFrom:self.currentViewController];
    if (nav) {
        ZiMuOrderVC *vc = [[ZiMuOrderVC alloc]init];
        [nav pushViewController:vc animated:YES];
    }else {
        NSLog(@"当前页面无导航控制器,请设置当前currentViewController");

    }
}

@end
