//
//  AliPaymentService.h
//  ZiMuPayService
//
//  Created by gongjing.yin on 03/01/2022.
//  Copyright (c) 2022 gongjing.yin. All rights reserved.
//

#import "ZiMuPaymentServiceProtocol.h"

@interface ZiMuAliPaymentService : ZiMuPaymentServiceProtocol

+ (instancetype)shareInstance;

@end
