//
//  SSOrderDetailModel.h
//  ESend
//
//  Created by 台源洪 on 15/12/17.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"
#import "SSMyOrderStatus.h"


@interface SSOrderDetailModel : BaseModel

@property (nonatomic,assign) NSInteger platform;
@property (nonatomic,copy) NSString * orderno;
@property (nonatomic,copy) NSString * pickupaddress;// 取货地址

@property (nonatomic,copy) NSString * recevicename;// 收货人名称
@property (nonatomic,copy) NSString * recevicephoneno;// 收货人电话
@property (nonatomic,copy) NSString * receviceaddress;// 收货人地址
@property (nonatomic,assign) BOOL ispay;// 是否付款
@property (nonatomic,assign) double amount;// 金额
@property (nonatomic,copy) NSString * remark;// 备注;
@property (nonatomic,assign) SSMyOrderStatus status;// 状态
@property (nonatomic,assign) NSInteger businessid;// 商户id
@property (nonatomic,assign) NSInteger orderfrom;// 订单来源
@property (nonatomic,assign) double weight;// 订单总重量
@property (nonatomic,assign) double km;// 距离
@property (nonatomic,assign) NSInteger ordercount;// 订单数量
@property (nonatomic,copy) NSString * pickupcode;// 取货码
@property (nonatomic,copy) NSString * pubname;// 发货人
@property (nonatomic,copy) NSString * pubphoneno;// 发货人手机号
@property (nonatomic,copy) NSString * pubaddress;// 发货人地址

@property (nonatomic,assign) NSInteger taketype;// 取货状态默认0立即，1 预约
@property (nonatomic,copy) NSString * productname;// 物品名称;
@property (nonatomic,assign) NSInteger iscomplain;// 是否显示投诉
@property (nonatomic,copy) NSString * clienterName;// 骑士姓名
@property (nonatomic,assign) NSInteger clienterid;// 骑士id
@property (nonatomic,copy) NSString * clienterPhoneNo;// 骑士电话;
@property (nonatomic,assign) double ordercommission;// 配送费
@property (nonatomic,copy) NSString * cancelTime;// 取消时间
@property (nonatomic,copy) NSString * otherCancelReason;// 取消原因

@property (nonatomic,copy) NSString * actualdonedate;// 完成时间
@property (nonatomic,copy) NSString * pubdate;// 发单时间
@property (nonatomic,copy) NSString * grabtime;// 抢单时间
@property (nonatomic,copy) NSString * taketime;// 取货时间
@property (nonatomic,copy) NSString * expectedTakeTime;// 期望那取货时间
@property (nonatomic,assign) NSInteger orderId;// id

@property (nonatomic,assign) double balancePrice;   // 账户余额
@property (nonatomic,copy) NSString * platformstr;  // 订单来源

@property (nonatomic,copy) NSString * paymentstr;   //支付方式str

@property (nonatomic,assign) double amountAndTip;   // 总额，带小费

// readonly
@property (nonatomic,copy,readonly) NSString * orderStatusString;   // 订单状态中文
@property (nonatomic,copy,readonly) NSString * orderStatusImg;      // 订单状态图片地址
@property (nonatomic,copy,readonly) NSString * orderFromString;     // 订单来源

@end
