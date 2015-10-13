//
//  DayBillInfo.m
//  ESend
//
//  Created by 台源洪 on 15/10/11.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "DayBillInfo.h"

@implementation DayBillInfo

- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        self.hasDatas = [dic getIntegerWithKey:@"hasDatas"];
        self.dayInfo = [dic getStringWithKey:@"dayInfo"];
        self.inMoney = [dic getDoubleWithKey:@"inMoney"];
        self.outMoney = [dic getDoubleWithKey:@"outMoney"];
    }
    return self;
}

@end
