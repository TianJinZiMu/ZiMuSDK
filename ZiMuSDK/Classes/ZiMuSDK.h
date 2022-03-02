//
//  ZiMuSDK.h
//  Pods-ZiMuSDK_Example
//
//  Created by Comodo on 2022/3/1.
//

#import <Foundation/Foundation.h>
#import "ZiMuPayReq.h"

typedef NS_ENUM(NSUInteger, ZiMuPayChannel) {
    CCPayChannelALIPAY_MOBILE,  //  支付宝App支付
    ZiMuChannelWX_APP,         //  微信App支付
    ZiMuChannelUNION_APP       //  银联App支付
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

@interface ZiMuSDK : NSObject

/// SDK版本号
@property (nonatomic, readonly, copy) NSString *version;

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
       withCompletion:(void (^)(BOOL success, NSError *error))completionBlock;


@end

NS_ASSUME_NONNULL_END
