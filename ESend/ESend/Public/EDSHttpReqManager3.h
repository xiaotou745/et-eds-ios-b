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

@end
