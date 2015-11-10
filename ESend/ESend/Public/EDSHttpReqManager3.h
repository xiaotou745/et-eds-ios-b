//
//  EDSHttpReqManager3.h
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperationManager.h"
#import "Encryption.h"

/// 针对3.0接口的网络请求类
@interface EDSHttpReqManager3 : NSObject
/*
 1.1 商家端 API
 1.1.1 获取区域信息接口
 url:/orderregion/getorderregion POST
 */
/// 获取区域信息接口
+ (AFHTTPRequestOperation *)getorderregion:(NSDictionary *)dict
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 1.1.2 获取商家是否需要录入金额才可以发单
 url:/business/getisallowinputmoney POST
 */
/// 获取商家是否需要录入金额才可以发单
+ (AFHTTPRequestOperation *)getisallowinputmoney:(NSDictionary *)dict
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/// 获取用户状态接口
+ (AFHTTPRequestOperation *)getUserStatusData:(NSDictionary *)data
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/// 1.1.5 商户发单 url:/order/push POST
+ (AFHTTPRequestOperation *)pushOrderData:(NSDictionary *)data
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/// 1.1.7 商戶端 我的骑士列表 url:/business/getmyserviceclienters POST
+ (AFHTTPRequestOperation *)getmyserviceclienters:(NSDictionary *)data
                                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///// 1.1.6 骑士绑定商户 url:/services/business/bindclienterbusiness POST  // 骑士端接口
//+ (AFHTTPRequestOperation *)bindclienterbusiness:(NSDictionary *)data
//                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
//                                         failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/// 1.1.8 商戶端 我的骑士 申请中 同意/拒绝功能 url:/business/optbindclienter POST
+ (AFHTTPRequestOperation *)optbindclienter:(NSDictionary *)data
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/// 1.1.9 商戶端 解除绑定骑士 url:/business/removerelation POST
+ (AFHTTPRequestOperation *)removerelation:(NSDictionary *)data
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/// 1.1.3 获取任务(取货中、配送中、已完成) url:/business/getmyorderb POST
+ (AFHTTPRequestOperation *)businessGetmyorderb:(NSDictionary *)data
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/// 1.1.4 获取(取货中、配送中、已完成)任务详情 url:/business/getmyorderdetailb POST
+ (AFHTTPRequestOperation *)businessGetmyorderdetailb:(NSDictionary *)data
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
@end
