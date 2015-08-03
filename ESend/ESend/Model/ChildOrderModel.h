//
//  ChildOrderModel.h
//  ESend
//
//  Created by 永来 付 on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface ChildOrderModel : BaseModel

@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, assign) CGFloat goodPrice;
@property (nonatomic, assign) CGFloat deliverPrice;
@property (nonatomic, assign) CGFloat totalPrice;

@end
