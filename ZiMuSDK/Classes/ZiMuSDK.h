//
//  ZiMuSDK.h
//  Pods-ZiMuSDK_Example
//
//  Created by Comodo on 2022/3/1.
//

#import <Foundation/Foundation.h>
#import "ZiMuPayReq.h"

@class ZiMuSDKError;
NS_ASSUME_NONNULL_BEGIN

@interface ZiMuSDKError : NSObject


@end


typedef void (^ZiMuSDKCompletion)(NSString *result, ZiMuSDKError * _Nullable error);

@interface ZiMuSDK : NSObject

/// 租户ID
@property (nonatomic, strong) NSString * tenantId;



/**
 *  SDK单例
 */
+(instancetype)shareInstance;

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
       withCompletion:(nonnull ZiMuSDKCompletion)completionBlock;


@end

NS_ASSUME_NONNULL_END
