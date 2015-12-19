//
//  SSHttpReqServer.h
//  ESend
//
//  Created by 台源洪 on 15/12/1.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "Encryption.h"

@interface SSHttpReqServer : NSObject

/*
 1.1.1发单
 url:/order/flashpush post 参数
 */
+ (AFHTTPRequestOperation *)orderflashpush:(NSDictionary *)dict
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 1.1.3 获取任务配送费配置
 url:/common/gettaskdistributionconfig POST
 */
+ (AFHTTPRequestOperation *)gettaskdistributionconfigsuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 1.1.8 商戶端 发送短信验证码
 url:/business/sendcode POST
 */
+ (AFHTTPRequestOperation *)businesssendcode:(NSDictionary *)dict
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 1.1.9 商户app首页获取商家订单列表
 url:/order/shansongqueryorderb POST
 */
///来源（默认1、旧后台，2新后台 3闪送）,例如：1,3
///0:待接单订单列表 2 待取货订单列表 4 配送中订单列表 50待支付 1已完成
+ (AFHTTPRequestOperation *)shanSongQueryOrderB:(NSDictionary *)dict
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 1.1.2获取订单详情
 
 url:/order/getorderdetails 创建人：胡灵波 post 参数
 
 参数	描述	允许为空
 orderId	订单id	否
 businessId	商户id,商户ID大于0返回取货码	是
 */
+ (AFHTTPRequestOperation *)shanSongGetOrderDetails:(NSDictionary *)dict
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 1.1.10 发单，抢单（支付宝或微信支付) url:/Pay/CreateFlashPay 胡灵波 POST
 参数	描述	允许为空
 orderId	订单id	否
 payStyle	付款方式1扫码，其它非扫码	否
 tipAmount	支付金额	否
 payType	支付类型 1支付宝,2微信	否
 */
+ (AFHTTPRequestOperation *)shanSongCreateFlashPay:(NSDictionary *)dict
                                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 1.1.11 发单，抢单(余额支付)
 url:/order/orderbalancepay 创建人：胡灵波 POST
 参数	描述	允许为空
 orderId	订单id	否
 orderChildId	子订单id	否
 businessId	商户id	否
 type	1发单，2抢单	否
 tipAmount	抢单时此值不能为空	是
 */
+ (AFHTTPRequestOperation *)shanSongOrderBalancePay:(NSDictionary *)dict
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
