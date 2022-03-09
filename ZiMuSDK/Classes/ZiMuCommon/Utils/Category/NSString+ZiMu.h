//
//  NSString+ZiMu.h
//  ZiMuSDK
//
//  Created by Comodo on 2022/3/9.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (ZiMu)
/**
判断字符串是否为空

@param string NSString
@return BOOL值
*/
+ (BOOL)isEmpty:(NSString *)string;

/*********************base64处理******************************/
/// 将文本转换为base64格式字符串
/// @param text 文本
+ (NSString *)base64StringFromText:(NSString *)text;
@end

NS_ASSUME_NONNULL_END
