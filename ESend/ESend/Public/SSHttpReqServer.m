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

@end
