//
//  SupermanOrderModel.h
//  ESend
//
//  Created by 永来 付 on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

typedef NS_ENUM(NSInteger, OrderStatus) {
    OrderStatusNewOrder = 0,                        //待接单
    OrderStatusComplete = 1,                        //订单已完成
    OrderStatusAccepted = 2,                        //取货中
    OrderStatusCancel = 3,                          //订单已取消
    OrderStatusReceive = 4,                         //已到店取餐
    OrderStatusWaitingAccept = 30,                  //待接入订单
    OrderStatusUncomplete = 100,                    //未完成订单
};

typedef NS_ENUM(NSInteger, OrderChannel) {
    OrderChannelEsend = 0,       //e代送
    OrderChannelJuwangke =1,    //聚网客
    OrderChannelWanda = 2,      //万达
    OrderChannelQuanshi = 3,    //全时
    OrderChannelMeituan = 4     //美团
};

@interface SupermanOrderModel : BaseModel

//超人电话
@property (nonatomic, copy) NSString *supermenPhone;
//超人姓名
@property (nonatomic, copy) NSString *supermenName;
//收货人姓名
@property (nonatomic, copy) NSString *pickupName;
//收货人电话
@property (nonatomic, copy) NSString *pickupPhone;
@property (nonatomic, copy) NSString *pickupAddress;
//
@property (nonatomic, copy) NSString *orderId;
@property (nonatomic, copy) NSString *orderNumber;

//送餐费
@property (nonatomic, assign) CGFloat totalDeliverPrce;
@property (nonatomic, assign) CGFloat amount;
@property (nonatomic, assign) CGFloat totalAmount;

@property (nonatomic, copy) NSString *receiveName;
@property (nonatomic, copy) NSString *receiveAddress;
@property (nonatomic, copy) NSString *receivePhone;

@property (nonatomic, copy) NSString *pubDate;

@property (nonatomic, assign) NSInteger orderCount;

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, assign) OrderStatus orderStatus;
@property (nonatomic, copy) NSString *orderStatusStr;
@property (nonatomic, strong) UIColor *orderStatusColor;
@property (nonatomic, copy) NSString *orderStatusImageName;

@property (nonatomic, assign) NSInteger orderChannel;
@property (nonatomic, copy) NSString *orderChannelStr;

@property (nonatomic, assign) BOOL isPay;
@property (nonatomic, strong) NSMutableArray *childOrderList;
@property (nonatomic, copy) NSString *bussinessPhone;
@property (nonatomic, copy) NSString *bussinessPhone2;


// 2015-08-18
// 骑士id
@property (nonatomic, assign) long ClienterId;
// 商户id
@property (nonatomic, assign) long businessId;
// 是否被投诉  1,已经投诉；0，没有投诉
@property (nonatomic, assign) long IsComplain;

- (void)loadData:(NSDictionary*)dic;

@end
