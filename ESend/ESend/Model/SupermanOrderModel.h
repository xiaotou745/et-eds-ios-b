//
//  SupermanOrderModel.h
//  ESend
//
//  Created by 永来 付 on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"
#import "ChildOrderModel.h"


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
    OrderChannelEsend = 0,       //b端
    OrderChannelJuwangke =1,    //聚网客
    OrderChannelWanda = 2,      //万达
    OrderChannelQuanshi = 3,    //全时
    OrderChannelMeituan = 4,     //美团
    OrderChannelB_Web = 99,         // 商户web版
};

#warning 历史原因加之java接口.net接口，设计面较宽,不要使用 initWithDic: 和 loadData: 方法

@interface SupermanOrderModel : BaseModel

/// 超人电话
@property (nonatomic, copy) NSString *supermenPhone;
/// 超人姓名
@property (nonatomic, copy) NSString *supermenName;
//收货人姓名
@property (nonatomic, copy) NSString *pickupName;
//收货人电话
@property (nonatomic, copy) NSString *pickupPhone;
/// 取货地址
@property (nonatomic, copy) NSString *pickupAddress;
///  订单id
@property (nonatomic, copy) NSString *orderId;
/// 订单号
@property (nonatomic, copy) NSString *orderNumber;

//送餐费
@property (nonatomic, assign) double totalDeliverPrce;
@property (nonatomic, assign) double amount;

/// 订单金额（含外送费，骑士端用）
@property (nonatomic, assign) double totalAmount;

/// 收货人姓名
@property (nonatomic, copy) NSString *receiveName;
/// 收货地址
@property (nonatomic, copy) NSString *receiveAddress;
/// 收货电话
@property (nonatomic, copy) NSString *receivePhone;
/// 收获城市
@property (nonatomic, copy) NSString *receviceCity;

/// 发布时间
@property (nonatomic, copy) NSString *pubDate;
/// 订单数量
@property (nonatomic, assign) NSInteger orderCount;
/// 备注
@property (nonatomic, copy) NSString *remark;

/// 订单状态码
@property (nonatomic, assign) OrderStatus orderStatus;
@property (nonatomic, copy) NSString *orderStatusStr;
@property (nonatomic, strong) UIColor *orderStatusColor;
@property (nonatomic, copy) NSString *orderStatusImageName;


/// from
@property (nonatomic, assign) NSInteger orderChannel;
@property (nonatomic, copy) NSString *orderChannelStr;

/// 是否已支付
@property (nonatomic, assign) BOOL isPay;
/// 子订单集合
@property (nonatomic, strong) NSMutableArray *childOrderList;

/// 商家座机
@property (nonatomic, copy) NSString * Landline;
/// 商家电话
@property (nonatomic, copy) NSString *bussinessPhone;
/// 商家电话2
@property (nonatomic, copy) NSString *bussinessPhone2;


// 2015-08-18
// 骑士id
@property (nonatomic, assign) long ClienterId;
// 商户id
@property (nonatomic, assign) long businessId;
// 是否被投诉  1,已经投诉；0，没有投诉
@property (nonatomic, assign) long IsComplain;


// 2015-10-21
/// 骑士距离门店距离用来排序 只有在骑士查询我的任务 ——待取货的任务时有效
@property (nonatomic, assign) NSInteger distance_OrderBy;
/// 结算方式 （之前B端有用）
@property (nonatomic, assign) NSInteger mealsSettleMode;
/// 骑士收入，弃用，移动端不删除该字段，防止出错暂时留着  ==
@property (nonatomic, assign) NSInteger income;
/// 发货人（商家) businessName
@property (nonatomic, copy) NSString * businessName;
/// 已经无实际意义，与app同步，不能删，以前只有骑士端未完成该字段有用 ==
@property (nonatomic, assign) NSInteger needPickupCode;
/// 订单来源（第三方来源）
@property (nonatomic, assign) NSInteger orderFrom;
/// 订单来源名称
@property (nonatomic, copy) NSString * orderFromName;
/// 骑士距离门店距离 只有在骑士查询我的任务 ——待取货的任务时有效 ==
@property (nonatomic, copy) NSString * distance;
///  第三方订单号 ==
@property (nonatomic, copy) NSString * originalOrderNo;
///  取货城市（商家城市）
@property (nonatomic, copy) NSString * pickUpCity;
/// 集团id（已经无实际意义） ==
@property (nonatomic, assign) NSInteger groupId;
/// 订单完成时间  ==
@property (nonatomic, copy) NSString * actualDoneDate;
/// 默认– 商家距顾客距离，改字段无实际意义 ==
@property (nonatomic,copy) NSString * distanceB2R;
/// 骑士收入 ==
@property (nonatomic, assign) NSInteger orderCommission;
/// 已经上传的小票数量 ==
@property (nonatomic, assign) NSInteger hadUploadCount;


// 12.24 增加，订单来源
@property (nonatomic,copy) NSString * PlatformStr;

// 弃用之
// - (void)loadData:(NSDictionary*)dic;


@end
