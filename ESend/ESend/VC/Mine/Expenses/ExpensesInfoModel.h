//
//  ExpensesInfoModel.h
//  ESend
//
//  Created by LiMingjie on 15/6/27.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface ExpensesInfoModel : BaseModel

@property (nonatomic,copy)   NSString * infoType;  // 支出类型
@property (nonatomic,assign) CGFloat    amount;    // 金额
@property (nonatomic,copy)   NSString * time;      // 时间
@property (nonatomic,copy)   NSString * state;     // 状态

@end
