//
//  OrderModel.h
//  ESend
//
//  Created by 永来 付 on 15/6/3.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"
#import "SubOrderModel.h"
#import "SupermanOrderModel.h"

//typedef NS_ENUM(NSInteger, OrderStatus) {
//    OrderStatusWaitingAccept = 1,       //待接单
//    OrderStatusPickup,                  //取货
//    OrderStatusDelivery,                //送货中
//};

@interface OrderModel : BaseModel

@property (nonatomic, copy) NSString *orderNumber;
@property (nonatomic, copy) NSString *orderAddress;
@property (nonatomic, copy) NSString *receivePhone;
@property (nonatomic, assign) NSInteger orderCount;
@property (nonatomic, assign) CGFloat orderTotal;
@property (nonatomic, copy) NSString *orderChannel;
@property (nonatomic, copy) NSString *orderTime;

@property (nonatomic, assign) OrderStatus orderStatus;
@property (nonatomic, copy) NSString *orderStatusStr;
@property (nonatomic, strong) UIColor *orderStatusColor;

@property (nonatomic, strong) NSMutableArray *addressList;
@property (nonatomic, strong) NSMutableArray *subOrderList;

@property (nonatomic, copy) NSString *remark;

@end
