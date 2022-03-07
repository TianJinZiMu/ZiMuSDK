//
//  ZiMuPayService.h
//  Pods-ZiMuSDK_Example
//
//  Created by Comodo on 2022/3/1.
//

#import <Foundation/Foundation.h>
#import "ZiMuPayReq.h"
#import "ZiMuPaymentServiceProtocol.h"
/**
 支付渠道

*/
typedef NS_ENUM(NSInteger , ZiMuPaymentChannel){
    /**
     *  alipay支付渠道
     */
    ZiMuPaymentChannelAliPay,
    /**
     *  微信支付渠道
     */
    ZiMuPaymentChannelWX,

};

typedef NS_ENUM(NSUInteger, ZiMuPayErrorCode) {
    ZiMuErrorCodeSuccess                 = 0,        //  支付成功
    ZiMuErrorCodeUnknown                 = 100000,   //  未知错误
    ZiMuErrorCodeNotInstalled            = 100001,   //  程序未安装
    ZiMuErrorCodeFailed                  = 100002,   //  支付失败
    ZiMuErrorCodeCancel                  = 100003,   //  支付取消
    ZiMuErrorCodeDealing                 = 100004,   //  交易处理中
    ZiMuErrorCodeTemporarilyNotOpened    = 100099    //  功能暂未开放
};

NS_ASSUME_NONNULL_BEGIN

@interface ZiMuPayService : NSObject

/// SDK版本号
@property (nonatomic, readonly, copy) NSString *version;

@property (nonatomic , strong ,nullable) ZiMuPaymentServiceProtocol * paymentService;

/**
 *  SDK单例
 */
+(instancetype)shareInstance;


/**
 打开支付Url
 
 @param url Url
 @return 是否打开
 */
- (BOOL)openPayURL:(NSURL *)url;

/**
 支付订单

 @param order order信息
 @param paymentChannel 支付渠道
 @param viewController 支付所在VC
 @param secheme 对应的secheme
 @param resultHandle 结果回调
 */
- (void)payWithOrder:(ZiMuPayReq *)order paymentChannel:(ZiMuPaymentChannel)paymentChannel viewController:(UIViewController *)viewController secheme:(NSString *)secheme resultHandle:(ZiMuPayResultHandle)resultHandle;


@end

NS_ASSUME_NONNULL_END
