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

/// 忘记密码PostForgetPwd_B 忘记密码
+ (AFHTTPRequestOperation*)getChangePassword:(NSDictionary *)data
                                successBlock:(successBlock)successBlock
                                     failure:(failureBlock)failure;


/// ModifyPwd_B     修改密码
+ (AFHTTPRequestOperation*)getModifyPwd_B:(NSDictionary *)data
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

//获取商户信息
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

/// 2.1.14 B端商户拉取收货人地址缓存到本地consigneeaddressb
+ (AFHTTPRequestOperation *)consigneeAddress:(NSDictionary *)data
                                successBlock:(successBlock)successBlock
                                     failure:(failureBlock)failure;

///2.1.20商户投诉骑士
+ (AFHTTPRequestOperation *)businessComplainClienter:(NSDictionary *)data
                                        successBlock:(successBlock)successBlock
                                             failure:(failureBlock)failure;


/// 2.1.15商户端删除缓存地址
+ (AFHTTPRequestOperation *)RemoveAddressB:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure;

/// java 1.1.5 意见反馈
+ (AFHTTPRequestOperation *)feedbackB:(NSDictionary *)data
                         successBlock:(successBlock)successBlock
                              failure:(failureBlock)failure;

/// java 1.1.1 b端首页未读消息接口 message/newmessageb
+ (AFHTTPRequestOperation *)newMessageB:(NSDictionary *)data
                           successBlock:(successBlock)successBlock
                                failure:(failureBlock)failure;

///  java 1.1.7 商户app首页获取商家订单列表
///  url:/order/queryorderb POST
+ (AFHTTPRequestOperation *)queryorderb:(NSDictionary *)data
                           successBlock:(successBlock)successBlock
                                failure:(failureBlock)failure;

/// java 1.1.9 B端任务统计接口
/// url:/order/orderstatisticsb POST
+ (AFHTTPRequestOperation *)orderstatisticsb:(NSDictionary *)data
                                successBlock:(successBlock)successBlock
                                     failure:(failureBlock)failure;

/// java 1.2.0 B端已完成任务列表或者某个配送员配送列表
//url:/order/getcompliteorderb POST
+ (AFHTTPRequestOperation *)getcompliteorderb:(NSDictionary *)data
                                 successBlock:(successBlock)successBlock
                                      failure:(failureBlock)failure;

/// java 1.1.8 B端商户点击账单按钮 获取所有的筛选条件类型
// url:/common/getrecordtypeb POST
+ (AFHTTPRequestOperation *)getrecordtypebSuccessBlock:(successBlock)successBlock
                                               failure:(failureBlock)failure;

@end
