//
//  BankModel.h
//  ESend
//
//  Created by 永来 付 on 15/6/16.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, AccountType) {
    AccountTypePerson = 0,
    AccountTypeCompany = 1
};

@interface BankModel : BaseModel

@property (nonatomic, copy) NSString *binkId;
//开户名
@property (nonatomic, copy) NSString *bankUserName;
//银行卡号
@property (nonatomic, copy) NSString *bankCardNumber;

//1网银 2支付宝 3微信 4财付通 5百度钱包
@property (nonatomic, assign) NSInteger accountType;
//0 个人账户 1 公司账户
@property (nonatomic, assign) NSInteger BelongType;

//身份证号或营业执照号
@property (nonatomic, copy) NSString *cardId;

//创建者
@property (nonatomic, copy) NSString *createBy;

//开户行
@property (nonatomic, copy) NSString *openBank;
//开户支行
@property (nonatomic, copy) NSString *openSubBank;

@property (nonatomic, copy) NSString *city;
@property (nonatomic, assign) NSInteger cityCode;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, assign) NSInteger provinceCode;

@end
