//
//  PaymentServiceProtocol.m
//  ZiMuPayService
//
//  Created by gongjing.yin on 03/01/2022.
//  Copyright (c) 2022 gongjing.yin. All rights reserved.
//


#import "ZiMuPaymentServiceProtocol.h"

@implementation ZiMuPaymentServiceProtocol

/**
 *  生成支付订单
 *
 *  @param charge Charge 对象(JSON 格式字符串 或 NSDictionary)
 */
- (NSObject * _Nonnull)generatePayOrder:(NSDictionary * _Nonnull)charge {

    return nil;
}


/**
 @bref  进行支付
 
 @param order 订单信息
 @param resultHandle 支付结果回调
 @param secheme 要调起的三方APP的配置URLSecheme
 */
- (void)payWithOrder:(NSObject * _Nonnull)order
             secheme:(NSString * _Nullable )secheme
              result:(_Nonnull ZiMuPayResultHandle)resultHandle
{


}



/**
 @bref 支付
 
 @param order 订单信息
 @param viewController 调用支付的VC（这个主要是针对的是使用银联支付的情况，银联支付需要）
 @param resultHandle 结果回调
 @param secheme 要调起的三方APP的配置URLSecheme
 */
- (void)payWithOrder:( NSObject * _Nonnull )order
      viewController:( UIViewController * _Nullable )viewController
             secheme:(NSString * _Nullable )secheme
      resultCallBack:(ZiMuPayResultHandle _Nullable )resultHandle {


}

@end
