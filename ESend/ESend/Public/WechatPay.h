//
//  WechatPay.h
//  ESend
//
//  Created by 台源洪 on 15/9/11.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"
//APP端签名相关头文件
#import "payRequsestHandler.h"

@interface WechatPay : NSObject


/// 微信支付
+ (void)wechatPayWithPrice:(CGFloat)price orderNumber:(NSString*)orderNumber notifyURL:(NSString*)url prepayId:(NSString *)prepayId;


@end
