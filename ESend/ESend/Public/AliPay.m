//
//  AliPay.m
//  ESend
//
//  Created by 永来 付 on 15/6/26.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "AliPay.h"
#import <AlipaySDK/AlipaySDK.h>
#import "Order.h"
#import "DataSigner.h"
#import "UserInfo.h"

@implementation AliPay

+ (NSString *)generateTradeNO
{
    static int kNumber = 15;
    
    NSString *sourceStr = @"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    NSMutableString *resultStr = [[NSMutableString alloc] init];
    srand((unsigned)time(0));
    for (int i = 0; i < kNumber; i++)
    {
        unsigned index = rand() % [sourceStr length];
        NSString *oneStr = [sourceStr substringWithRange:NSMakeRange(index, 1)];
        [resultStr appendString:oneStr];
    }
    return resultStr;
}

+ (void)payWithPrice:(float)price orderNumber:(NSString*)orderNumber notifyURL:(NSString*)url productName:(NSString *)productName{
    /*============================================================================*/
    /*=======================需要填写商户app申请的===================================*/
    /*============================================================================*/
    NSString *partner = @"2088911703660069";
    NSString *seller = @"2088911703660069";
    NSString *privateKey = @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBAKBsT+MdkRhwFcX0BoK4dAkQT3jDci6inccxY/CKtpOr+oevTaC6SW16yTLUpoRdwZOkuPfjkuL0G4+CpGI1IscVTaRGhnubMJKYO8zcahbUMn9zulHjBdAq9puf9HMtqfrhd/XdwkW9LDLj/zTTWAoGj3ZMOdkPnp/BgQe5T0WBAgMBAAECgYA9RsIJBX0rsXyPnVNzURN5dtJ0VWti5tiPgo0jD0kIBRPwCgUD1MRBXjpGATYNr2ZGiA/jF/k+WXHBkmxJ2vQKLoY++lvhC7ghp7TQFwAwVvz35FIsCpAUX2TQCEVtyavZHfC/4yX1/Nkpphf6r8JIC77rnpS7HeVW8boTp2tL9QJBAMvr7uQqwCkhmDmM8mXVbW+1QMUv197zNwQbzqJpapLF0mBA2bRN4uY09Qez3/8HC5oBaTmeobxWTweEnCckcisCQQDJZIQDw8CFoVX7AsDwlHv+yzPjz2Op2my7tbHT9Rou8atqldw8s9R1RT6LBy8oWQ3oHKANlN5ZLbKINqLCIU0DAkAvS6k8gi3PXFtR/b66n6WiIwfCtDX9H6vC6DAkuw5cvETuzhuwFeBqRB4Qi0eIfrnSHkGpe4FHjT0HIVqWOX3BAkBfgr0dL/QZK/ej8J1iO3lG0EYOr2d7wWw55aStehtt0g1Sojnty/dhmnJb6w9RWlK/FvxNFKIStxppgUfVO4fTAkEAxJE0C0mqGxqnUUJNnLK8DwYzsOdb4JjN/mvR63hNvpj3Dq/rhiFsVSSmHTbSxPdHixBuXwKMePtfmZA7CceGWA==";
    /*============================================================================*/
    /*============================================================================*/
    /*============================================================================*/
    
    //partner和seller获取失败,提示
    if ([partner length] == 0 ||
        [seller length] == 0 ||
        [privateKey length] == 0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"缺少partner或者seller或者私钥。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    /*
     *生成订单信息及签名
     */
    //将商品信息赋予AlixPayOrder的成员变量
    Order *order = [[Order alloc] init];
    order.partner = partner;
    order.seller = seller;
    order.tradeNO = orderNumber; //订单ID（由商家自行制定）
    order.productName = productName; //商品标题
    order.productDescription = [UserInfo getUserId]; //商品描述
    order.amount = [NSString stringWithFormat:@"%.2f",price]; //商品价格
    order.notifyURL =  url; //回调URL
    
    order.service = @"mobile.securitypay.pay";
    order.paymentType = @"1";
    order.inputCharset = @"utf-8";
    order.itBPay = @"30m";
    order.showUrl = @"m.alipay.com";
    
    //应用注册scheme,在AlixPayDemo-Info.plist定义URL types
    NSString *appScheme = @"EsendSSAipay";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    NSLog(@"orderSpec = %@",orderSpec);
    
    //获取私钥并将商户信息签名,外部商户可以根据情况存放私钥和签名,只需要遵循RSA签名规范,并将签名字符串base64编码和UrlEncode
    id<DataSigner> signer = CreateRSADataSigner(privateKey);
    NSString *signedString = [signer signString:orderSpec];
    
    //将签名成功字符串格式化为订单字符串,请严格按照该格式
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",
                       orderSpec, signedString, @"RSA"];
        
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"alipay.m === reslut = %@",resultDic);
            if ([resultDic getIntegerWithKey:@"resultStatus"] == 9000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AliPaySuccessNotification object:nil];
            } else {
                [Tools showHUD:@"支付失败"];
            }
        }];
        
    }

}

@end
