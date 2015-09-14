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


#define EDS_APP_ID          @"wxbb8fb40942327ec6"                       //APPID
#define EDS_APP_SECRET      @"c0cb93c7fb3f7322326b0c853f0cba46"         //appsecret
//商户号，填写商户对应参数
#define EDS_MCH_ID          @"1264102901"
//商户API密钥，填写相应参数
#define EDS_PARTNER_ID      @"10852AFB8F4044D88F5A24E978BBC053"

@interface WechatPay : NSObject


/// 微信支付
+ (void)wechatPayWithPrice:(CGFloat)price orderNo:(NSString*)orderNo notifyURL:(NSString*)url prepayId:(NSString *)prepayId;


@end
