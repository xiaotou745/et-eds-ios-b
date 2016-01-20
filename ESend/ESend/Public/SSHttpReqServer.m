//
//  SSHttpReqServer.m
//  ESend
//
//  Created by 台源洪 on 15/12/1.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSHttpReqServer.h"

@implementation SSHttpReqServer

+ (AFHTTPRequestOperationManager *)_manager{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    NSDictionary * headerDict = [Encryption ESendB_Encryptioin];
    //NSLog(@"headerDicts:%@",headerDict);
    NSArray * keys = [headerDict allKeys];
    for (NSString * key in keys) {
        [manager.requestSerializer setValue:[headerDict objectForKey:key] forHTTPHeaderField:key];
    }
    return manager;
    
}

/*
 1.1.1发单
 url:/order/flashpush post 参数
 */
+ (AFHTTPRequestOperation *)orderflashpush:(NSDictionary *)dict
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;{
    NSString * URLString = [NSString stringWithFormat:@"%@order/flashpush",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/*
 1.1.3 获取任务配送费配置
 url:/common/gettaskdistributionconfig POST
 */
+ (AFHTTPRequestOperation *)gettaskdistributionconfigsuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@common/gettaskdistributionconfig",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/*
 1.1.8 商戶端 发送短信验证码
 url:/business/sendcode POST
 */
+ (AFHTTPRequestOperation *)businesssendcode:(NSDictionary *)dict
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                     failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@business/sendcode",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/*
 1.1.9 商户app首页获取商家订单列表
 url:/order/shansongqueryorderb POST
 */
+ (AFHTTPRequestOperation *)shanSongQueryOrderB:(NSDictionary *)dict
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@order/shansongqueryorderb",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/*
 1.1.2获取订单详情
 
 url:/order/getorderdetails 创建人：胡灵波 post 参数
 
 参数	描述	允许为空
 orderId	订单id	否
 businessId	商户id,商户ID大于0返回取货码	是
 */
+ (AFHTTPRequestOperation *)shanSongGetOrderDetails:(NSDictionary *)dict
                                            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@order/getorderdetails",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}


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
                                           failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@Pay/CreateFlashPay",OPEN_API_SEVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

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
                                            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@order/orderbalancepay",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}


/*
 1.1.12取消订单
 url:/order/SSCancelOrder 创建人：胡灵波 POST
 参数	描述	允许为空
 orderId	订单id	否
 OptUserName	操作人	否
 OptLog	操作描述	否
 Remark	备注	否
 Platform	来源	否
 */
+ (AFHTTPRequestOperation *)shanSongSSCancelOrder:(NSDictionary *)dict
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@order/SSCancelOrder",OPEN_API_SEVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}


/*
 1.1.7 获取小费
 url:/order/getordertipdetails 胡灵波
 POST
 */
+ (AFHTTPRequestOperation *)getOrderTipDetailSsuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@order/getordertipdetails",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/*
 1.1.13更新下单人是否收到验证码
 url:/order/getreceivecode 创建人：胡灵波 POST
 参数	描述	允许为空
 orderId	订单id	否
 */
+ (AFHTTPRequestOperation *)getReceiveCode:(NSDictionary *)dict
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@order/getreceivecode",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/*
 1.1.14获取订单状态
 url:/order/getorderstatus 创建人：胡灵波 post 参数
 参数	描述	允许为空
 orderId	订单id	否
 */
+ (AFHTTPRequestOperation *)getOrderStatus:(NSDictionary *)dict
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@order/getorderstatus",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}
@end
