//
//  SubOrderModel.h
//  ESend
//
//  Created by 永来 付 on 15/6/5.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface SubOrderModel : BaseModel

@property (nonatomic, copy) NSString *subOrderId;
@property (nonatomic, copy) NSString *orderName;
@property (nonatomic, assign) CGFloat price;

@end
