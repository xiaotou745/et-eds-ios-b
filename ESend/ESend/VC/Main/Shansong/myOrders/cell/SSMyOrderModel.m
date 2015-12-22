//
//  SSMyOrderModel.m
//  ESend
//
//  Created by 台源洪 on 15/12/16.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSMyOrderModel.h"

@implementation SSMyOrderModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        if (isCanUseObj([dic objectForKey:@"pickupCode"])) {
            self.pickupCode = [dic objectForKey:@"pickupCode"];
        }
        self.pickUpAddress = [dic objectForKey:@"pickUpAddress"];
        self.orderId = [[dic objectForKey:@"orderId"] integerValue];
        self.platform = [[dic objectForKey:@"platform"] integerValue];
        if (isCanUseObj([dic objectForKey:@"pubDate"])) {
            self.pubDate = [dic objectForKey:@"pubDate"];
        }
        self.isPay = [[dic objectForKey:@"isPay"] boolValue];
        if (isCanUseObj([dic objectForKey:@"grabTime"])) {
            self.grabTime = [dic objectForKey:@"grabTime"];
        }
        self.receviceAddress = [dic objectForKey:@"receviceAddress"];
        self.status = [[dic objectForKey:@"status"] integerValue];
        self.orderCommission = [[dic objectForKey:@"orderCommission"] doubleValue];
        self.orderNo = [dic objectForKey:@"orderNo"];
        if (isCanUseObj([dic objectForKey:@"actualDoneDate"])) {
            self.actualDoneDate = [dic objectForKey:@"actualDoneDate"];
        }
        if (isCanUseObj([dic objectForKey:@"km"])) {
            self.km = [[dic objectForKey:@"km"] doubleValue];
        }
        if (isCanUseObj([dic objectForKey:@"weight"])) {
            self.weight = [[dic objectForKey:@"weight"] doubleValue];
        }
        if (isCanUseObj([dic objectForKey:@"totalAmount"])) {
            self.totalAmount = [[dic objectForKey:@"totalAmount"] doubleValue];
        }
        
        if (isCanUseObj([dic objectForKey:@"balancePrice"])) {
            self.balancePrice = [[dic objectForKey:@"balancePrice"] doubleValue];

        }
    }
    return self;
}

@end
