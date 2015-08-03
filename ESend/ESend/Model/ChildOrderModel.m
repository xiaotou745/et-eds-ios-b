//
//  ChildOrderModel.m
//  ESend
//
//  Created by 永来 付 on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ChildOrderModel.h"

@implementation ChildOrderModel

- (instancetype)initWithDic:(NSDictionary *)dic {

    self = [super init];
    if (self) {
        self.orderNumber = [dic getStringWithKey:@"ChildId"];
        self.goodPrice = [dic getFloatWithKey:@"GoodPrice"];
        self.deliverPrice = [dic getFloatWithKey:@"DeliveryPrice"];
        self.totalPrice = [dic getFloatWithKey:@"TotalPrice"];
    }
    return self;
}

@end
