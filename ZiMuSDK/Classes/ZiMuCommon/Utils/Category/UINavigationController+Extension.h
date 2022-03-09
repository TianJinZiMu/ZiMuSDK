//
//  UINavigationController+Extension.h
//  ZiMuSDK
//
//  Created by Comodo on 2022/3/7.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UINavigationController (Extension)

/// 获取当前NavigationController
+ (UINavigationController *)currentNC;


/// 根据页面获取当前NavigationController
/// @param vc 当前页面
+ (UINavigationController *)getCurrentNavigationControllerFrom:(UIViewController *)vc;

- (UIWindow *)currentWindow;
@end

NS_ASSUME_NONNULL_END
