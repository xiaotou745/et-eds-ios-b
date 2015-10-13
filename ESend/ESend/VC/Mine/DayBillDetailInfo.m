//
//  DayBillDetailInfo.m
//  ESend
//
//  Created by 台源洪 on 15/10/11.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "DayBillDetailInfo.h"

@implementation DayBillDetailInfo
- (id)initWithDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        self.amount = [dic getDoubleWithKey:@"amount"];
        self.operateTime = [dic getStringWithKey:@"operateTime"];
        self.recordId = [dic getIntegerWithKey:@"recordId"];
        self.recordType = [dic getStringWithKey:@"recordType"];
        self.relationNo = [dic getStringWithKey:@"relationNo"];
    }
    return self;
}
@end
