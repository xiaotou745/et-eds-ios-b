//
//  TaskInRegionModel.m
//  ESend
//
//  Created by 台源洪 on 15/11/4.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "TaskInRegionModel.h"

@implementation TaskInRegionModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.actualDoneDate = [dic getStringWithKey:@"actualDoneDate"];
        self.clienterHeadPhoto = [dic getStringWithKey:@"clienterHeadPhoto"];
        self.clienterId = [dic getIntegerWithKey:@"clienterId"];
        self.clienterName = [dic getStringWithKey:@"clienterName"];
        self.clienterPhoneNo = [dic getStringWithKey:@"clienterPhoneNo"];
        self.grabOrderId = [dic getIntegerWithKey:@"grabOrderId"];
        self.grabTime = [dic getStringWithKey:@"grabTime"];
        self.orderCount = [dic getIntegerWithKey:@"orderCount"];
        self.orderRegionOneName = [dic getStringWithKey:@"orderRegionOneName"];
        self.orderRegionTwoName = [dic getStringWithKey:@"orderRegionTwoName"];
        self.pickUpTime = [dic getStringWithKey:@"pickUpTime"];
        self.status = [dic getIntegerWithKey:@"status"];
    }
    return self;
}

@end
