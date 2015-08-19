//
//  BankModel.m
//  ESend
//
//  Created by 永来 付 on 15/6/16.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BankModel.h"

@implementation BankModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        self.binkId = [dic getStringWithKey:@"Id"];
        self.bankUserName = [dic getStringWithKey:@"TrueName"];
        
        self.bankCardNumber = [Security AesDecrypt:[dic getStringWithKey:@"AccountNo"]];  // 揭秘
        
        self.accountType = [dic getIntegerWithKey:@"AccountType"];
        self.BelongType = [dic getIntegerWithKey:@"BelongType"];

        self.openBank = [dic getStringWithKey:@"OpenBank"];
        self.openSubBank = [dic getStringWithKey:@"OpenSubBank"];
        
        self.province = [dic getStringWithKey:@"OpenProvince"];
        self.provinceCode = [dic getIntegerWithKey:@"OpenProvinceCode"];
        self.city = [dic getStringWithKey:@"OpenCity"];
        self.cityCode = [dic getIntegerWithKey:@"OpenCityCode"];
        
        self.cardId = [dic getStringWithKey:@"IDCard"];
    }
    return self;
}

@end
