//
//  ZiMuSDK.m
//  Pods-ZiMuSDK_Example
//
//  Created by Comodo on 2022/3/1.
//

#import "ZiMuSDK.h"

@implementation ZiMuSDKError


@end

@implementation ZiMuSDK


#pragma mark - SDK 函数接口
/**
 *  SDK单例
 */
+(instancetype)shareInstance
{
    static ZiMuSDK * shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ZiMuSDK alloc] init];
        
    });
    return shareInstance;
}
/**
 *  支付调用接口
 *
 *  @param payReq           ZiMuPayReq 对象
 *  @param viewController   银联渠道需要
 *  @param scheme           URL Scheme，支付宝渠道回调需要
 *  @param completionBlock  支付结果回调 Block
 */
- (void)createPayment:(nonnull ZiMuPayReq *)payReq
       viewController:(nonnull UIViewController*)viewController
         appURLScheme:(nonnull NSString *)scheme
       withCompletion:(nonnull ZiMuSDKCompletion)completionBlock {
    
}

@end
