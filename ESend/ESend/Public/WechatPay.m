//
//  WechatPay.m
//  ESend
//
//  Created by 台源洪 on 15/9/11.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "WechatPay.h"
#import "WXUtil.h"



@implementation WechatPay

/// 微信支付
+ (void)wechatPayWithPrice:(CGFloat)price orderNo:(NSString*)orderNo notifyURL:(NSString*)url prepayId:(NSString *)prepayId{
    payRequsestHandler *pay=[payRequsestHandler alloc];
    [pay init:APP_ID mch_id:MCH_ID];
    [pay setKey:PARTNER_ID];
    
    //获取到prepayid后进行第二次签名
    
    NSString    *package, *time_stamp, *nonce_str;
    //设置支付参数
    time_t now;
    time(&now);
    time_stamp  = [NSString stringWithFormat:@"%ld", now];
    nonce_str	= [WXUtil md5:time_stamp];
    //重新按提交格式组包，微信客户端暂只支持package=Sign=WXPay格式，须考虑升级后支持携带package具体参数的情况
    //package       = [NSString stringWithFormat:@"Sign=%@",package];
    package         = @"Sign=WXPay";
    //第二次签名参数列表
    NSMutableDictionary *signParams = [NSMutableDictionary dictionary];
    [signParams setObject: APP_ID        forKey:@"appid"];
    [signParams setObject: nonce_str    forKey:@"noncestr"];
    [signParams setObject: package      forKey:@"package"];
    [signParams setObject: PARTNER_ID        forKey:@"partnerid"];
    [signParams setObject: time_stamp   forKey:@"timestamp"];
    [signParams setObject: prepayId     forKey:@"prepayid"];
    
    //[signParams setObject: @"MD5"       forKey:@"signType"];
    //生成签名
    NSString *sign  = [pay createMd5Sign:signParams];
    
    //添加签名
    [signParams setObject: sign         forKey:@"sign"];
    
    //[debugInfo appendFormat:@"第二步签名成功，sign＝%@\n",sign];
    
    //返回参数列表
    // return signParams;
    
    
    NSMutableString *stamp  = [signParams objectForKey:@"timestamp"];
    
    //调起微信支付
    PayReq* req             = [[PayReq alloc] init];
    req.openID              = [signParams objectForKey:@"appid"];
    req.partnerId           = [signParams objectForKey:@"partnerid"];
    req.prepayId            = [signParams objectForKey:@"prepayid"];
    req.nonceStr            = [signParams objectForKey:@"noncestr"];
    req.timeStamp           = stamp.intValue;
    req.package             = [signParams objectForKey:@"package"];
    req.sign                = [signParams objectForKey:@"sign"];
    
    [WXApi sendReq:req];
}



@end
