//
//  ZiMuSDK.m
//  Pods-ZiMuSDK_Example
//
//  Created by Comodo on 2022/3/1.
//

#import "ZiMuSDK.h"

static NSString *const ZiMuPayErrorDomain    = @"ZiMuPaySDKDemo Pay Error";

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

#pragma mark - init
- (instancetype)init NS_UNAVAILABLE {
    self = [super init];
    if (self) {
        _version = @"0.1.10";
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
       withCompletion:(void (^)(BOOL success, NSError *error))completionBlock {
    
    // 交易失败
    NSError *error = [NSError errorWithDomain:ZiMuPayErrorDomain
                                         code:ZiMuErrorCodeFailed
                                     userInfo:@{NSLocalizedDescriptionKey : @"交易失败"}];
    if (completionBlock) {
        completionBlock(NO, error);
    }
    
}

@end
