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

@end
