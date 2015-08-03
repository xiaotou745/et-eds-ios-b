//
//  ExpensesMonthDataModel.h
//  ESend
//
//  Created by LiMingjie on 15/6/27.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface ExpensesMonthDataModel : BaseModel

@property (nonatomic,copy) NSString * month; // 月份

@property (nonatomic,strong) NSMutableArray * dataArr; // 当前月份数据


@end
