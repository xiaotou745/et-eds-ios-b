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
@end
