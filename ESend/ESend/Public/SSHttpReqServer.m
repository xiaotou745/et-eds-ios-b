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

@end
