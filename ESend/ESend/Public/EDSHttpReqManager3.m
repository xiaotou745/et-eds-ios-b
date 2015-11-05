//
//  EDSHttpReqManager3.m
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSHttpReqManager3.h"


@implementation EDSHttpReqManager3

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

+ (AFHTTPRequestOperation *)getorderregion:(NSDictionary *)dict
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@orderregion/getorderregion",Java_API_SERVER];
    
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

+ (AFHTTPRequestOperation *)getisallowinputmoney:(NSDictionary *)dict success:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@business/getisallowinputmoney",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}


/// 获取用户状态接口
+ (AFHTTPRequestOperation *)getUserStatusData:(NSDictionary *)data
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@BusinessAPI/GetUserStatus",OPEN_API_SEVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/// 1.1.5 商户发单 url:/order/push POST
+ (AFHTTPRequestOperation *)pushOrderData:(NSDictionary *)data
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@order/push",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/// 1.1.7 商戶端 我的骑士列表 url:/business/getmyserviceclienters POST
+ (AFHTTPRequestOperation *)getmyserviceclienters:(NSDictionary *)data
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@business/getmyserviceclienters",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/// 1.1.8 商戶端 我的骑士 申请中 同意/拒绝功能 url:/business/optbindclienter POST
+ (AFHTTPRequestOperation *)optbindclienter:(NSDictionary *)data
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@business/optbindclienter",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/// 1.1.9 商戶端 解除绑定骑士 url:/business/removerelation POST
+ (AFHTTPRequestOperation *)removerelation:(NSDictionary *)data
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@business/removerelation",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/// 1.1.3 获取任务(取货中、配送中、已完成) url:/business/getmyorderb POST
+ (AFHTTPRequestOperation *)businessGetmyorderb:(NSDictionary *)data
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    NSString * URLString = [NSString stringWithFormat:@"%@business/getmyorderb",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

/// 1.1.4 获取(取货中、配送中、已完成)任务详情 url:/business/getmyorderdetailb POST
+ (AFHTTPRequestOperation *)businessGetmyorderdetailb:(NSDictionary *)data
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * URLString = [NSString stringWithFormat:@"%@business/getmyorderdetailb",Java_API_SERVER];
    AFHTTPRequestOperation * operation = [[self _manager] POST:URLString parameters:data success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failure(operation,error);
    }];
    return operation;
}

@end
