//
//  EDSStatisticsInfoModel.h
//  ESend
//
//  Created by 台源洪 on 15/9/19.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"
#import "EDSStatisticsInfoClienterInfoModel.h"


@interface EDSStatisticsInfoModel : BaseModel

@property (nonatomic,copy) NSString * dateInfo;             // 27日
@property (nonatomic,copy) NSString * monthDate;            // 日期 format 2015-09-12
@property (nonatomic,assign) long orderCount;               // 订单数量
@property (nonatomic,assign) long serviceClienterCount;     // 服务骑士数量
@property (nonatomic,strong) NSArray * serviceClienters;    // 服务骑士们

@end
