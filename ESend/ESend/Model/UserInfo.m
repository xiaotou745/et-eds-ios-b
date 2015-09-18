//
//  UserInfo.m
//  USA-B
//
//  Created by 永来 付 on 15/1/5.
//  Copyright (c) 2015年 fuyonglai. All rights reserved.
//

#import "UserInfo.h"

static NSString *UserInfoKey = @"userInfoKey";

@implementation UserInfo

+ (BOOL)isLogin {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    if ([[userDefault objectForKey:UserInfoKey] objectForKey:@"userId"]) {
        return YES;
    }
    return NO;
}

+ (NSString*)getLoginName {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    return [[userDefault objectForKey:UserInfoKey] objectForKey:@"LoginName"];
}

+ (NSInteger)getStatus {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    return [[userDefault objectForKey:UserInfoKey] getIntegerWithKey:@"status"];
}

+ (NSString*)getStatusStr {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    NSInteger status = [[userDefault objectForKey:UserInfoKey] getIntegerWithKey:@"status"];
    switch (status) {
        case UserStatusUnreview:
            return @"未审核";
        case UserStatusComplete:
            return @"已通过";
        case UserStatusUnreviewAndAddresss:
            return @"未审核";
        case UserStatusReviewing:
            return @"审核中";
        case UserStatusReject:
            return @"审核失败";
            
        default:
            return @"";
            break;
    }
}

+ (void)saveStatus:(NSInteger)status {
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey]];
    [userInfo setValue:[NSNumber numberWithInteger:status] forKey:@"status"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:UserInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+ (void)setLoginName:(NSString*)name {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    [userDefault setObject:name forKey:@"LoginName"];
    [userDefault synchronize];
}

+ (NSString*)getBussinessName {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    return [[userDefault objectForKey:UserInfoKey] objectForKey:@"Name"];
}

+ (void)saveBussinessName:(NSString*)bussinessName {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey]];
    [userInfo setValue:bussinessName forKey:@"Name"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:UserInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)setCustomerName:(NSString*)customerName {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    [userDefault setObject:customerName forKey:@"CustomerName"];
    [userDefault synchronize];
}

+ (BOOL)isOneKeyPubOrder {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    return [[[userDefault objectForKey:UserInfoKey] objectForKey:@"OneKeyPubOrder"] boolValue];
}

//设置一键发单
+ (void)setIsOneKeyPubOrder:(NSNumber*)isOneKeyPuborder {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey]];
    [userInfo setValue:isOneKeyPuborder forKey:@"OneKeyPubOrder"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:UserInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//获取配送费
+ (CGFloat)getDistribSubsidy {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    return [[userDefault objectForKey:UserInfoKey] getFloatWithKey:@"DistribSubsidy"];
    
}

+ (void)saveDistribSubsidy:(CGFloat)distribSubsidy {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey]];
    [userInfo setValue:[NSNumber numberWithFloat:distribSubsidy] forKey:@"DistribSubsidy"];
    [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:UserInfoKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//存储密码
+ (void)setCustomerPassword:(NSString *)customerPassword {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    [userDefault setObject:customerPassword forKey:@"CustomerPassword"];
    [userDefault synchronize];

}
// 获取密码
+ (NSString*)getCustomerPassword {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"CustomerPassword"];
}

+ (NSString*)getAddress {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"Address"];
}

+ (void)setAddress:(NSString*)address {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    [userDefault setObject:address forKey:@"Address"];
    [userDefault synchronize];
}

+ (NSString*)getUserId {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    return [NSString stringWithFormat:@"%@",[[userDefault objectForKey:UserInfoKey] objectForKey:@"userId"]];
}

+ (NSString*)getTelephoneNum {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    return [NSString stringWithFormat:@"%@",[[userDefault objectForKey:UserInfoKey] objectForKey:@"phoneNo"]];
}

+ (void)setTelephoneNum:(NSString*)time {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    [userDefault setObject:time forKey:@"LoginName"];
    [userDefault synchronize];
}

+ (void)setUserImageUrl:(NSString *)imageUrl {
    if (isCanUseString(imageUrl)) {
        NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey]];
        [userInfo setValue:imageUrl forKey:@"ImagePath"];
        [[NSUserDefaults standardUserDefaults] setObject:userInfo forKey:UserInfoKey];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (NSString*)getUserImage {
    return [[[NSUserDefaults standardUserDefaults] objectForKey:UserInfoKey] objectForKey:@"ImagePath"];
}

+ (void)saveUserInfo:(NSDictionary*)data {
    
    NSMutableDictionary *dic = [[self class] clearNullData:data];
    
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    [userDefault setObject:dic forKey:UserInfoKey];
    [userDefault synchronize];
}

+ (NSDictionary *)getUserInfo
{
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:UserInfoKey];

}


+ (NSMutableDictionary*)clearNullData:(NSDictionary*)data
{
    NSMutableDictionary *newDic = [NSMutableDictionary dictionary];
    NSArray *keys = [data allKeys];
    for (NSString *key in keys) {
        if ([data objectForKey:key] && ![[data objectForKey:key] isKindOfClass:[NSNull class]]) {
            [newDic setObject:[data objectForKey:key] forKey:key];
        }
    }
    return newDic;
}

+ (void)clearUserInfo {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:nil forKey:UserInfoKey];
    [userDefaults synchronize];
}

+ (void)saveToken:(NSString *)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"UserToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)getToken {
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"UserToken"];
}



/*15-08-11*/
/// tyh_token
+ (NSString *)getTyhToken{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"ttttoken"];
}
+ (void)saveTyhToken:(NSString *)token{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"ttttoken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveAppkey:(NSString *)appkey{
    [[NSUserDefaults standardUserDefaults] setObject:appkey forKey:@"appkey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString *)getAppkey{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"appkey"];
}

/// uuid
+ (NSString *)getUUID{
    return [[[UIDevice currentDevice] identifierForVendor] UUIDString];
}

/// MaxDate 同步发单历史电话号码
+ (void)saveMaxDate:(NSString *)maxDate{
    [[NSUserDefaults standardUserDefaults] setObject:maxDate forKey:@"maxDate"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
+ (NSString *)getMaxDate{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"maxDate"];
}


/// 商户手机号
+ (NSString*)getbussinessPhone {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    return [userDefault objectForKey:@"bussinessPhone"];
}

+ (void)setbussinessPhone:(NSString*)bussinessPhone {
    NSUserDefaults *userDefault =  [NSUserDefaults standardUserDefaults];
    [userDefault setObject:bussinessPhone forKey:@"bussinessPhone"];
    [userDefault synchronize];
}

@end
