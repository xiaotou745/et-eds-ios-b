//
//  FHQNetWorkingAPI.h
//  USA
//
//  Created by 永来 付 on 14/11/24.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import "FHQNetWorkingKit.h"

@interface FHQNetWorkingAPI : NSObject

//升级
+ (AFHTTPRequestOperation*)update:(NSDictionary*)data
                    successBlock:(successBlock)successBlock
                         failure:(failureBlock)failure;

//登陆
+ (AFHTTPRequestOperation*)login:(NSDictionary*)data
                    successBlock:(successBlock)successBlock
                         failure:(failureBlock)failure;

//登录验证码
+ (AFHTTPRequestOperation*)phoneNumberCode:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure;

//修改密码验证码
+ (AFHTTPRequestOperation*)modifyPasswordPhoneCode:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure;

//语音手机验证码
+ (AFHTTPRequestOperation*)getAudioVerifyCode:(NSDictionary *)data
                               successBlock:(successBlock)successBlock
                                    failure:(failureBlock)failure;

//注册
+ (AFHTTPRequestOperation*)registerAccount:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure;

//获取商户状态
+ (AFHTTPRequestOperation*)getBusinessStatus:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure;

//完善用户信息
+ (AFHTTPRequestOperation*)prefectAccount:(NSDictionary *)data
                                imageList:(NSArray*)imageList
                             successBlock:(successBlock)successBlock
                                  failure:(failureBlock)failure;

//修改密码
+ (AFHTTPRequestOperation*)getChangePassword:(NSDictionary *)data
                                successBlock:(successBlock)successBlock
                                     failure:(failureBlock)failure;

//获取版本
+ (AFHTTPRequestOperation*)getVersion:(successBlock)successBlock
                              failure:(failureBlock)failure
                          isShowError:(BOOL)show;


//获取城市列表
+ (AFHTTPRequestOperation*)getCityList:(NSDictionary *)data
                          successBlock:(successBlock)successBlock
                              failure:(failureBlock)failure
                          isShowError:(BOOL)show;

///获取银行支持城市列表
+ (AFHTTPRequestOperation*)getBankCityList:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure
                               isShowError:(BOOL)show;

//获取订单列表
+ (AFHTTPRequestOperation*)getOrderList:(NSDictionary *)data
                          successBlock:(successBlock)successBlock
                               failure:(failureBlock)failure
                           isShowError:(BOOL)show;

//获取订单详情
+ (AFHTTPRequestOperation*)getOrderDetail:(NSDictionary *)data
                                 successBlock:(successBlock)successBlock
                                      failure:(failureBlock)failure;

//发布订单
+ (AFHTTPRequestOperation*)releseOrder:(NSDictionary*)data
                          successBlock:(successBlock)successBlock
                               failure:(failureBlock)failure;

///获取订单配送费
+ (AFHTTPRequestOperation*)getDistribSubsidy:(NSDictionary*)data
                          successBlock:(successBlock)successBlock
                               failure:(failureBlock)failure;

//收支明细
+ (AFHTTPRequestOperation*)getPaymentDetail:(NSDictionary *)data
                           successBlock:(successBlock)successBlock
                                failure:(failureBlock)failure
                            isShowError:(BOOL)show;

//获取银行列表
+ (AFHTTPRequestOperation*)getBankList:(NSDictionary *)data
                               successBlock:(successBlock)successBlock
                                    failure:(failureBlock)failure
                                isShowError:(BOOL)show;

//修改密码
+ (AFHTTPRequestOperation*)getSupplierInfo:(NSDictionary *)data
                                successBlock:(successBlock)successBlock
                                     failure:(failureBlock)failure;


//绑定银行卡
+ (AFHTTPRequestOperation*)bindingBank:(NSDictionary *)data
                                isBind:(BOOL)isBind
                          successBlock:(successBlock)successBlock
                               failure:(failureBlock)failure;


//获取支付信息
+ (AFHTTPRequestOperation*)getPayInfo:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure;

//获取消息列表
+ (AFHTTPRequestOperation*)getMessageList:(NSDictionary *)data
                         successBlock:(successBlock)successBlock
                              failure:(failureBlock)failure;


//获取消息列表
+ (AFHTTPRequestOperation*)getMessageDetail:(NSDictionary *)data
                             successBlock:(successBlock)successBlock
                                  failure:(failureBlock)failure;


//获取收支明细
+ (AFHTTPRequestOperation*)getExpense:(NSDictionary *)data
                               successBlock:(successBlock)successBlock
                                    failure:(failureBlock)failure;

//获取订单统计
+ (AFHTTPRequestOperation*)getOrderCount:(NSDictionary *)data
                         successBlock:(successBlock)successBlock
                              failure:(failureBlock)failure;

//取消订单
+ (AFHTTPRequestOperation*)cancelOrder:(NSDictionary *)data
                            successBlock:(successBlock)successBlock
                                 failure:(failureBlock)failure;

//取消订单
+ (AFHTTPRequestOperation*)withdrew:(NSDictionary *)data
                          successBlock:(successBlock)successBlock
                               failure:(failureBlock)failure;

/// 2.1.19获取Token
+ (AFHTTPRequestOperation *)getToken:(NSDictionary *)data
                        successBlock:(successBlock)successBlock
                             failure:(failureBlock)failure;
@end
