//
//  FHQNetWorkingAPI.m
//  USA
//
//  Created by 永来 付 on 14/11/24.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import "FHQNetWorkingAPI.h"
#import "AFNetworkActivityIndicatorManager.h"


#define NoNetworkReachableMsg @"暂无网络连接，请检查您的网络"


@implementation FHQNetWorkingAPI

//更新
+ (AFHTTPRequestOperation*)update:(NSDictionary *)data
                     successBlock:(successBlock)successBlock
                          failure:(failureBlock)failure{
    NSString *url = @"Common/VersionCheck";
    
    AFHTTPRequestOperation * operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    } isShowFailAlert:NO failAlertString:@"" host:UPDATE_APP_API_SERVER];
    
    return operation;
    
}


//手机验证码
+ (AFHTTPRequestOperation*)phoneNumberCode:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    
    
    NSString *url = @"BusinessAPI/CheckCode";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"GET" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//手机验证码
+ (AFHTTPRequestOperation*)modifyPasswordPhoneCode:(NSDictionary *)data
                                      successBlock:(successBlock)successBlock
                                           failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    
    NSString *url = @"BusinessAPI/CheckCodeFindPwd";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"GET" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

+ (AFHTTPRequestOperation*)getAudioVerifyCode:(NSDictionary *)data
                                 successBlock:(successBlock)successBlock
                                      failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    
    NSString *url = @"BusinessAPI/VoiceCheckCode";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

+ (AFHTTPRequestOperation*)registerAccount:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    
    NSString *url = @"BusinessAPI/PostRegisterInfo_B";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//获取商户状态
+ (AFHTTPRequestOperation*)getBusinessStatus:(NSDictionary *)data
                                successBlock:(successBlock)successBlock
                                     failure:(failureBlock)failure {
    NSString *url = @"BusinessAPI/GetUserStatus";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    } isShowFailAlert:NO failAlertString:nil];
    
    return operation;
}

//完善用户信息
+ (AFHTTPRequestOperation*)prefectAccount:(NSDictionary *)data
                                imageList:(NSArray*)imageList
                             successBlock:(successBlock)successBlock
                                  failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    
    
    NSString *url = @"business/UpdateBusinessInfoB";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data imageDatas:imageList success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    } isShowFailAlert:YES failAlertString:@"" host:UPLOAD_IMAGE_API_SERVER];
    
    return operation;
}

/// 忘记密码PostForgetPwd_B 忘记密码
+ (AFHTTPRequestOperation*)getChangePassword:(NSDictionary *)data
                                successBlock:(successBlock)successBlock
                                     failure:(failureBlock)failure
{
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    
    NSString *url = @"BusinessAPI/PostForgetPwd_B";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    } isShowFailAlert:NO failAlertString:nil];
    
    return operation;
}


/// ModifyPwd_B     修改密码
+ (AFHTTPRequestOperation*)getModifyPwd_B:(NSDictionary *)data
                             successBlock:(successBlock)successBlock
                                  failure:(failureBlock)failure{
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    
    NSString *url = @"BusinessAPI/ModifyPwd_B";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    } isShowFailAlert:NO failAlertString:nil];
    
    return operation;
}

//// !!!!!! URL 肯定错了
+ (AFHTTPRequestOperation*)getVersion:(successBlock)successBlock failure:(failureBlock)failure isShowError:(BOOL)show {
    
    NSString *url = @"BusinessAPI/PostForgetPwd_B";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"GET" prameters:nil success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }

    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    } isShowFailAlert:show failAlertString:@""];
    
    return operation;
}

+ (AFHTTPRequestOperation*)getCityList:(NSDictionary *)data
                          successBlock:(successBlock)successBlock
                               failure:(failureBlock)failure
                           isShowError:(BOOL)show {
    
    NSString *url = @"BusinessAPI/GetOpenCity";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"GET" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    } isShowFailAlert:show failAlertString:@""];
    
    return operation;
}

+ (AFHTTPRequestOperation*)getBankCityList:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure
                               isShowError:(BOOL)show {
    NSString *url = @"Finance/GetBankProvinceCity";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    } isShowFailAlert:show failAlertString:@""];
    
    return operation;
}

+ (AFHTTPRequestOperation*)login:(NSDictionary *)data
                    successBlock:(successBlock)successBlock
                         failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    
    NSString *url = @"BusinessAPI/PostLogin_B";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }

        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//获取订单列表
+ (AFHTTPRequestOperation*)getOrderList:(NSDictionary *)data
                          successBlock:(successBlock)successBlock
                               failure:(failureBlock)failure
                           isShowError:(BOOL)show {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    NSString *url = @"BusinessAPI/GetOrderList_B";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"GET" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    } isShowFailAlert:show failAlertString:@""];
    
    return operation;
}

//获取订单详情
+ (AFHTTPRequestOperation*)getOrderDetail:(NSDictionary *)data
                             successBlock:(successBlock)successBlock
                                  failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    NSString *url = @"Order/GetDetails";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//发布订单
+ (AFHTTPRequestOperation*)releseOrder:(NSDictionary *)data
                          successBlock:(successBlock)successBlock
                               failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    NSString *url = @"Order/Push";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//获取配送费
+ (AFHTTPRequestOperation*)getDistribSubsidy:(NSDictionary *)data
                                successBlock:(successBlock)successBlock
                                     failure:(failureBlock)failure {
    
    NSString *url = @"Business/GetDistribSubsidy";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//获取收支明细
+ (AFHTTPRequestOperation*)getPaymentDetail:(NSDictionary *)data
                               successBlock:(successBlock)successBlock
                                    failure:(failureBlock)failure
                                isShowError:(BOOL)show {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    NSString *url = @"business/records";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    } isShowFailAlert:show failAlertString:@""];
    
    return operation;
}

//获取银行列表
+ (AFHTTPRequestOperation*)getBankList:(NSDictionary *)data
                          successBlock:(successBlock)successBlock
                               failure:(failureBlock)failure
                           isShowError:(BOOL)show {
    
    NSString *url = @"Bank/Get";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    } isShowFailAlert:show failAlertString:@""];
    
    return operation;
}

//获取商户信息
+ (AFHTTPRequestOperation*)getSupplierInfo:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    
    NSString *url = @"Business/Get";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//绑定银行卡
+ (AFHTTPRequestOperation*)bindingBank:(NSDictionary *)data
                                isBind:(BOOL)isBind
                          successBlock:(successBlock)successBlock
                               failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    NSString *url = isBind ? @"finance/cardbindb" : @"finance/cardmodifyb";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//获取商户信息
+ (AFHTTPRequestOperation*)getPayInfo:(NSDictionary *)data
                         successBlock:(successBlock)successBlock
                              failure:(failureBlock)failure {
    NSString *url = @"pay/businessrecharge";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//获取消息列表
+ (AFHTTPRequestOperation*)getMessageList:(NSDictionary *)data
                             successBlock:(successBlock)successBlock
                                  failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    NSString *url = @"message/listb";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//获取商户信息
+ (AFHTTPRequestOperation*)getMessageDetail:(NSDictionary *)data
                               successBlock:(successBlock)successBlock
                                    failure:(failureBlock)failure {
    NSString *url = @"message/readb";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//获取收支明细
+ (AFHTTPRequestOperation*)getExpense:(NSDictionary *)data
                         successBlock:(successBlock)successBlock
                              failure:(failureBlock)failure{
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    NSString *url = @"business/records";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//订单统计
+ (AFHTTPRequestOperation*)getOrderCount:(NSDictionary *)data
                            successBlock:(successBlock)successBlock
                                 failure:(failureBlock)failure {
    NSString *url = @"businessapi/OrderCount_B";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"GET" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//取消订单
+ (AFHTTPRequestOperation*)cancelOrder:(NSDictionary *)data
                          successBlock:(successBlock)successBlock
                               failure:(failureBlock)failure{
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    NSString *url = @"BusinessAPI/CancelOrder_B";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

//提现
+ (AFHTTPRequestOperation*)withdrew:(NSDictionary *)data
                       successBlock:(successBlock)successBlock
                            failure:(failureBlock)failure {
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    NSString *url = @"finance/withdrawb";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

/// 2.1.19获取Token
+ (AFHTTPRequestOperation *)getToken:(NSDictionary *)data
                        successBlock:(successBlock)successBlock
                             failure:(failureBlock)failure{
    NSString *url = @"Common/GetToken";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

/// 2.1.14 B端商户拉取收货人地址缓存到本地consigneeaddressb
+ (AFHTTPRequestOperation *)consigneeAddress:(NSDictionary *)data
                                successBlock:(successBlock)successBlock
                                     failure:(failureBlock)failure{
    NSString *url = @"order/consigneeaddressb";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}

///2.1.20商户投诉骑士
+ (AFHTTPRequestOperation *)businessComplainClienter:(NSDictionary *)data
                                        successBlock:(successBlock)successBlock
                                             failure:(failureBlock)failure{
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    NSString *url = @"Complain/BusinessComplainClienter";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}


/// 2.1.15商户端删除缓存地址
+ (AFHTTPRequestOperation *)RemoveAddressB:(NSDictionary *)data
                              successBlock:(successBlock)successBlock
                                   failure:(failureBlock)failure{
    NSString *url = @"order/RemoveAddressB";
    AFHTTPRequestOperation *operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error, operation);
        }
    }];
    
    return operation;
}


/// 意见反馈
+ (AFHTTPRequestOperation *)feedbackB:(NSDictionary *)data
                         successBlock:(successBlock)successBlock
                              failure:(failureBlock)failure{
    
    /// 网络状态
    if (![AFNetworkReachabilityManager sharedManager].reachable) {
        
        [Tools showHUD:NoNetworkReachableMsg];
        
        failure(nil,nil);
        
        return nil;
    }
    
    NSString *url = @"feedback/feedbackb";

    AFHTTPRequestOperation * operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error,operation);
        }
    } isShowFailAlert:NO failAlertString:nil host:Java_API_SERVER];
    
    return operation;
}


/// java 1.1.1 b端首页未读消息接口 message/newmessageb
+ (AFHTTPRequestOperation *)newMessageB:(NSDictionary *)data
                           successBlock:(successBlock)successBlock
                                failure:(failureBlock)failure{
    NSString *url = @"message/newmessageb";
    
    AFHTTPRequestOperation * operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error,operation);
        }
    } isShowFailAlert:NO failAlertString:nil host:Java_API_SERVER];
    
    return operation;
}

///  java 1.1.7 商户app首页获取商家订单列表
///  url:/order/queryorderb POST
+ (AFHTTPRequestOperation *)queryorderb:(NSDictionary *)data
                           successBlock:(successBlock)successBlock
                                failure:(failureBlock)failure{
    NSString *url = @"order/queryorderb";
    
    AFHTTPRequestOperation * operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error,operation);
        }
    } isShowFailAlert:NO failAlertString:nil host:Java_API_SERVER];
    
    return operation;
}

/// java 1.1.9 B端任务统计接口
/// url:/order/orderstatisticsb POST
+ (AFHTTPRequestOperation *)orderstatisticsb:(NSDictionary *)data
                                successBlock:(successBlock)successBlock
                                     failure:(failureBlock)failure{
    
    NSString *url = @"order/orderstatisticsb";
    AFHTTPRequestOperation * operation = [FHQNetWorkingKit httpRequestWithUrl:url methodType:@"POST" prameters:data success:^(id result, AFHTTPRequestOperation *operation) {
        if (successBlock) {
            successBlock(result, operation);
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        if (failure) {
            failure(error,operation);
        }
    } isShowFailAlert:NO failAlertString:nil host:Java_API_SERVER];
    
    return operation;
}

@end
