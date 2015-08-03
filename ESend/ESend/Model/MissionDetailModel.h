//
//  MissionDetailModel.h
//  ESend
//
//  Created by LiMingjie on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface MissionDetailModel : BaseModel

@property (nonatomic,copy)   NSString * orderNo;                 // 运单号
@property (nonatomic,copy)   NSString * time;                    // 发布时间

@property (nonatomic,assign) NSInteger  orderStatus;             // 订单状态 0 送货中 1 取货中 2 已完成
@property (nonatomic,assign) NSInteger  orderType;               // 订单类型 0 自发 1 第三方

@property (nonatomic,copy)   NSString * orderSource;             // 订单来源
@property (nonatomic,copy)   NSString * thirdPartyOrderNo;       // 第三方订单号


@property (nonatomic,copy)   NSString * senderName;              // 配送方名字
@property (nonatomic,copy)   NSString * senderPhoneNo;           // 配送方联系方式

@property (nonatomic,copy)   NSString * receiverName;            // 收货方名字
@property (nonatomic,copy)   NSString * receiverPhoneNo;         // 收货方联系方式

@property (nonatomic,strong) NSMutableArray * subOrderList;      // 子订单列表数据
@property (nonatomic,assign) CGFloat    totalDeliverPrce;        // 订单总额
@property (nonatomic,assign) BOOL       isPay;                   // 是否付款

@property (nonatomic,assign) CGFloat    shippingFee;             // 配送费

@property (nonatomic,copy)   NSString * invoiceName;             // 发票抬头

@property (nonatomic,copy)   NSString * notes;                   // 备注

@end
