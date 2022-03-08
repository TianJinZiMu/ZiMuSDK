//
//  ZiMuPayReq.h
//  Pods-ZiMuSDK_Example
//
//  Created by Comodo on 2022/3/1.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZiMuPayReq : NSObject

/// 租户ID
@property (nonatomic, strong) NSString * tenantId;

/// 随机串
@property (nonatomic, strong) NSString * nonce;

/// 签名
@property (nonatomic, strong) NSString * sign;

/// 时间：2022-01-20 15:41:56
@property (nonatomic, strong) NSString * timestamp;

/// 加密的随机串
@property (nonatomic, assign) NSString *  encryptKey;

/// 加密的请求体
@property (nonatomic, assign) NSString *  body;

@end

NS_ASSUME_NONNULL_END
