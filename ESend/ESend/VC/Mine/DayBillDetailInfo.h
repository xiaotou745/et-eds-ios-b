//
//  DayBillDetailInfo.h
//  ESend
//
//  Created by 台源洪 on 15/10/11.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

/// 日账单数据集元素
@interface DayBillDetailInfo : BaseModel

@property (nonatomic, assign) NSInteger recordId;
@property (nonatomic, copy) NSString * relationNo;
@property (nonatomic, assign) double amount;
@property (nonatomic, assign) NSInteger recordType;
@property (nonatomic, copy) NSString * operateTime;

@end
