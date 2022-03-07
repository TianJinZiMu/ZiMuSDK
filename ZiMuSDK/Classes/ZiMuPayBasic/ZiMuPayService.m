//
//  ZiMuPayService.m
//  Pods-ZiMuSDK_Example
//
//  Created by Comodo on 2022/3/1.
//

#import "ZiMuPayService.h"
#import "ZiMuAliPaymentService.h"
#import "ZiMuWXPaymentService.h"

@implementation ZiMuPayService


#pragma mark - SDK 函数接口
/**
 *  SDK单例
 */
+(instancetype)shareInstance
{
    static ZiMuPayService * shareInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shareInstance = [[ZiMuPayService alloc] init];
        
    });
    return shareInstance;
}

#pragma mark - init
- (instancetype)init NS_UNAVAILABLE {
    self = [super init];
    if (self) {
        _version = @"0.1.15";
        NSLog(@"版本号：%@",_version);
    }
    return self;
}



/**
 打开支付Url
 
 @param url Url
 @return 是否打开
 */
- (BOOL)openPayURL:(NSURL *)url {
    if ([url.host isEqualToString:@"pay"]) {
        //  微信
        
    } else if ([url.host isEqualToString:@"safepay"]) {
        //  支付宝
        //  跳转支付宝钱包进行支付，处理支付结果
        
    } else if ([url.host isEqualToString:@"ZiMuSDK"]) {
        
    }
    return YES;
}

+ (void)payWithOrder:(NSObject *)order paymentChannel:(ZiMuPaymentChannel)paymentChannel viewController:(UIViewController *)viewController secheme:(NSString *)secheme resultHandle:(ZiMuPayResultHandle)resultHandle {
    
    ZiMuPayService * payment = [ZiMuPayService shareInstance];
    payment.paymentService = nil;
    switch (paymentChannel) {
        case ZiMuPaymentChannelAliPay:
            payment.paymentService = [ZiMuAliPaymentService shareInstance];
            break;

        case ZiMuPaymentChannelWX:
            payment.paymentService = [ZiMuWXPaymentService shareInstance];
            break;
            
        
        default:
            break;
    }
    
    [payment.paymentService payWithOrder:order viewController:viewController secheme:secheme resultCallBack:resultHandle];
    
    
}


@end
