//
//  ZiMuOrderService.h
//  ZiMuSDK
//
//  Created by Comodo on 2022/3/8.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZiMuOrderService : NSObject

/// 当前的vc
@property (nonatomic , strong ,nullable) UIViewController * currentViewController;

/**
 *  SDK单例
 */
+(instancetype)shareInstance;

/**
 打开订单Url
 
 @param url Url
 */
- (void)openOrderURL:(NSString *)url;


@end

NS_ASSUME_NONNULL_END
