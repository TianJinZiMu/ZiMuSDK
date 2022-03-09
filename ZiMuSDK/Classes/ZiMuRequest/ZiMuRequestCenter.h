//
//  ZiMuRequestCenter.h
//  ZiMuSDK
//
//  Created by Comodo on 2022/3/9.
//

#import "ZiMuBaseNetwork.h"

NS_ASSUME_NONNULL_BEGIN

@interface ZiMuRequestCenter : ZiMuBaseNetwork
/**
 支持加密GET请求
 */
- (void)encryptionGET:(NSString *)URLString headers:(nullable NSDictionary <NSString *, NSString *> *)headers parameters:(nullable NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure;

/**
 支持加密POST请求
 */
- (void)encryptionPOST:(NSString *)URLString headers:(nullable NSDictionary <NSString *, NSString *> *)headers parameters:(nullable NSDictionary *)parameters success:(BaseRequestSuccessBlock)success failure:(BaseRequestFailureBlock)failure;
@end

NS_ASSUME_NONNULL_END
