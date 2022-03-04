//
//  WXPaymentService.m
//  ZiMuPayService
//
//  Created by gongjing.yin on 03/01/2022.
//  Copyright (c) 2022 gongjing.yin. All rights reserved.
//

#import "ZiMuWXPaymentService.h"
#import <WXApi.h>

@interface ZiMuWXPaymentService ()<WXApiDelegate>

@end

@implementation ZiMuWXPaymentService

+ (instancetype)shareInstance {
    static ZiMuWXPaymentService * instance = nil;
    static dispatch_once_t  onceToken ;
    dispatch_once(&onceToken, ^{
        instance = [[ZiMuWXPaymentService alloc] init];
    });
    return instance;

}

- (void)payWithOrder:(NSObject *)order viewController:(UIViewController *)viewController secheme:(NSString *)secheme resultCallBack:(ZiMuPayResultHandle)resultHandle {
    if (![self isInstalled]) {
        NSError * error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kZiMuPayErrorCode userInfo:@{NSLocalizedDescriptionKey:@"应用未安装"}];
        resultHandle(ZiMuPayResultStatusUnInstall, nil, error);
        return;
    } else if (![WXApi isWXAppSupportApi]) {
        NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kZiMuPayErrorCode userInfo:@{NSLocalizedDescriptionKey:@"该版本微信不支持支付"}];
        resultHandle(ZiMuPayResultStatusCancel, nil, error);
        return;
    }
    
    PayReq * req = (PayReq *)order;
    //调用支付
    [WXApi sendReq:req];
    
    self.paymentHandle = resultHandle;

}


- (void)payWithOrder:(NSObject *)order result:(ZiMuPayResultHandle)resultHandle secheme:(NSString * _Nullable)secheme{
  
    if (![self isInstalled]) {
        NSError * error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kZiMuPayErrorCode userInfo:@{NSLocalizedDescriptionKey:@"应用未安装"}];
        
        if (resultHandle) {
            resultHandle(ZiMuPayResultStatusUnInstall, nil, error);
             self.paymentHandle = resultHandle;
        }
        return;
    } else if (![WXApi isWXAppSupportApi]) {
        NSError *error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kZiMuPayErrorCode userInfo:@{NSLocalizedDescriptionKey:@"该版本微信不支持支付"}];
        if (resultHandle) {
            resultHandle(ZiMuPayResultStatusUnInstall, nil, error);
             self.paymentHandle = resultHandle;
        }
        return;
    }
    
    PayReq * req = (PayReq *)order;
    //调用支付
    [WXApi sendReq:req];

   
    
}

- (BOOL)isInstalled {
   return  [WXApi isWXAppInstalled];
}

- (NSObject *)generatePayOrder:(NSDictionary *)charge {
    //发送请求订单
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = [charge objectForKey:@"partnerid"];
    req.prepayId = [charge objectForKey:@"prepayid"];
    req.nonceStr = [charge objectForKey:@"noncestr"];
    req.timeStamp = [[charge objectForKey:@"timestamp"] intValue];
    req.package = [charge objectForKey:@"packagevalue"];
    req.sign = [charge objectForKey:@"sign"];
    return req;

}

- (BOOL)handleOpenURL:(NSURL *)url {
    if ([url.scheme hasPrefix:@"wx"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    return YES;

}

- (NSDictionary *)errorMessage {
    return @{@(WXSuccess):kZiMuPaySuccessMessage,
             @(WXErrCodeCommon):kZiMuPayFailureMessage,
             @(WXErrCodeUserCancel):kZiMuPayCancelMessage
             };
}

#pragma mark 
#pragma mark --WXApiDelegate
- (void)onResp:(BaseResp *)resp {
    if ([resp isKindOfClass:[PayResp class]]) {
        ZiMuPayResultStatus payResultStatus = ZiMuPayResultStatusFailure;
        switch (resp.errCode) {
            case WXSuccess:
                payResultStatus = ZiMuPayResultStatusSuccess;
                break;
            case WXErrCodeCommon:
                //这个错误码指定的错误范围比较广：签名错误、未注册appid
                payResultStatus = ZiMuPayResultStatusFailure;
                break;
            case WXErrCodeUserCancel:
                payResultStatus = ZiMuPayResultStatusCancel;
                break;
                
            default:
                break;
        }
    
        //组合error信息
    NSDictionary * errorMessageDic = [self errorMessage];
    NSString * errorDescription = resp.errStr;
    if (!errorDescription) {
        errorDescription = errorMessageDic[@(resp.errCode)];
    }
    NSError * error = [NSError errorWithDomain:NSStringFromClass(self.class) code:kZiMuPayErrorCode userInfo:@{NSLocalizedDescriptionKey:errorDescription}];
        if (self.paymentHandle) {
                self.paymentHandle(payResultStatus,errorMessageDic,error);
        }

        
         }
    
}


@end
