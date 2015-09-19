//
//  EDSStatisticsInfoModel.m
//  ESend
//
//  Created by 台源洪 on 15/9/19.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSStatisticsInfoModel.h"

@implementation EDSStatisticsInfoModel

- (id)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        self.monthDate = [dic getStringWithKey:@"monthDate"];
        self.dateInfo = [dic getStringWithKey:@"dateInfo"];
        self.orderCount = [dic getIntegerWithKey:@"orderCount"];
        self.serviceClienterCount = [dic getIntegerWithKey:@"serviceClienterCount"];
        NSArray * dataArray = [dic getArrayWithKey:@"serviceClienters"];
        NSMutableArray * tempArray = [NSMutableArray array];
        for (NSDictionary * clienterInfoDic in dataArray) {
            EDSStatisticsInfoClienterInfoModel * clienterModel = [[EDSStatisticsInfoClienterInfoModel alloc] initWithDic:clienterInfoDic];
            [tempArray addObject:clienterModel];
        }
        self.serviceClienters = [[NSArray alloc] initWithArray:tempArray];
    }
    return self;
}

@end
