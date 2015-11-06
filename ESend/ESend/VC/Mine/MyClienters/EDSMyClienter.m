//
//  EDSMyClienter.m
//  ESend
//
//  Created by 台源洪 on 15/11/6.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSMyClienter.h"

@implementation EDSMyClienter

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.clienterId = [dic getIntegerWithKey:@"clienterId"];
        self.headPhoto = [dic getStringWithKey:@"headPhoto"];
        self.phoneNo = [dic getStringWithKey:@"phoneNo"];
        self.relationId = [dic getIntegerWithKey:@"relationId"];
        self.trueName = [dic getStringWithKey:@"trueName"];
    }
    return self;
}
@end
