//
//  UserInfo.h
//  USA-B
//
//  Created by 永来 付 on 15/1/5.
//  Copyright (c) 2015年 fuyonglai. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, UserStatus) {
    UserStatusUnreview = 0,             //未审核
    UserStatusComplete = 1,             //审核通过
    UserStatusUnreviewAndAddresss = 2,  //未审核且未添加地址
    UserStatusReviewing = 3,            //审核中
    UserStatusReject = 4                //被拒绝
};

@interface UserInfo : NSObject

+ (BOOL)isLogin;

+ (NSString*)getLoginName;

+ (NSString*)getBussinessName;
+ (void)saveBussinessName:(NSString*)bussinessName;

+ (NSInteger)getStatus;
+ (NSString*)getStatusStr;

+ (void)saveStatus:(NSInteger)status;

+ (void)setCustomerName:(NSString*)customerName;

//是否为一键发单
+ (BOOL)isOneKeyPubOrder;
+ (void)setIsOneKeyPubOrder:(NSNumber*)isOneKeyPuborder;

+ (CGFloat)getDistribSubsidy;  /**< 配送费 */
+ (void)saveDistribSubsidy:(CGFloat)distribSubsidy;    /**< 保存配送费 */

+ (NSString*)getAddress;

+ (void)setAddress:(NSString*)address;

+ (NSString*)getUserId;

+ (NSString*)getTelephoneNum;

+ (void)setUserImageUrl:(NSString*)imageUrl;

+ (NSString*)getUserImage;

+ (void)setTelephoneNum:(NSString*)time;

+ (void)saveUserInfo:(NSDictionary*)data;

+ (void)clearUserInfo;



/// tyh_token
+ (NSString*)getToken;

+ (void)saveToken:(NSString*)token;

/// appkey
+ (void)saveAppkey:(NSString *)appkey;
+ (NSString *)getAppkey;

/// uuid
+ (NSString *)getUUID;

/// MaxDate 同步发单历史电话号码
+ (void)saveMaxDate:(NSString *)maxDate;
+ (NSString *)getMaxDate;




+ (void)setLoginName:(NSString*)name;

+ (NSDictionary *)getUserInfo;

//存储密码
+ (void)setCustomerPassword:(NSString *)customerPassword;
// 获取密码
+ (NSString*)getCustomerPassword;

/// 商户手机号
+ (NSString*)getbussinessPhone;
+ (void)setbussinessPhone:(NSString*)bussinessPhone;

@end
