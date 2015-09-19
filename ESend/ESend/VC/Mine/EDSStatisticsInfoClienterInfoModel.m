//
//  EDSStatisticsInfoClienterInfoModel.m
//  ESend
//
//  Created by 台源洪 on 15/9/19.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSStatisticsInfoClienterInfoModel.h"

@implementation EDSStatisticsInfoClienterInfoModel


- (id)initWithDic:(NSDictionary *)dic {
    if (self = [super init]) {
        self.clienterId = [dic getIntegerWithKey:@"clienterId"];
        self.clienterName = [dic getStringWithKey:@"clienterName"];
        self.clienterPhone = [dic getStringWithKey:@"clienterPhone"];
        self.clienterPhoto = [dic getStringWithKey:@"clienterPhoto"];
        self.orderCount = [dic getIntegerWithKey:@"orderCount"];
        self.pubDate = [dic getStringWithKey:@"pubDate"];
    }
    return self;
}
@end
