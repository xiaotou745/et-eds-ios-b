//
//  MDSubOrderModel.h
//  ESend
//
//  Created by LiMingjie on 15/6/26.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface MDSubOrderModel : BaseModel

@property (nonatomic,copy)   NSString * orderName;  // 子订单名称
@property (nonatomic,assign) CGFloat    price;      // 订单单价
@property (nonatomic,assign) NSInteger  count; // 数量

@end
