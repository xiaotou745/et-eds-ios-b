//
//  DayBillInfo.h
//  ESend
//
//  Created by 台源洪 on 15/10/11.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

/// 月账单数据集元素
@interface DayBillInfo : BaseModel

@property (nonatomic, copy) NSString * dayInfo;     // 天数信息
@property (nonatomic, assign) double inMoney;       // 当天总收入
@property (nonatomic, assign) double outMoney;      // 当天总支出
@property (nonatomic, assign) NSInteger hasDatas;        // 1:当天有数据 0:当天没有数据

@end
