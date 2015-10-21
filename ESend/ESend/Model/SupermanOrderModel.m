//
//  SupermanOrderModel.m
//  ESend
//
//  Created by 永来 付 on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "SupermanOrderModel.h"

@implementation SupermanOrderModel




- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        self.orderId = [dic getStringWithKey:@"orderId"];                   // 订单id
        self.orderNumber = [dic getStringWithKey:@"orderNo"];               // 订单号
        
        [self loadData:dic];
    }
    return self;
}


- (void)loadData:(NSDictionary*)dic {
    
    
    self.supermenName = [dic getStringWithKey:@"superManName"];             // 骑士姓名
    self.supermenPhone = [dic getStringWithKey:@"superManPhone"];           // 骑士电话
    self.pickupName = [dic getStringWithKey:@"PickUpName"];
    self.pickupAddress = [dic getStringWithKey:@"pickUpAddress"];           // 取货地址.
    self.totalDeliverPrce = [dic getFloatWithKey:@"TotalDistribSubsidy"];
    self.amount = [dic getDoubleWithKey:@"amount"];                          // 订单金额（不含外送费，商家端用）
    self.totalAmount = [dic getDoubleWithKey:@"totalAmount"];                // 订单金额（含外送费，骑士端用）
    self.receiveAddress = [dic getStringWithKey:@"receviceAddress"];        // 收获地址
    self.receiveName = [dic getStringWithKey:@"receviceName"];              // 收获人姓名
    self.receviceCity = [dic getStringWithKey:@"receviceCity"];             // 收货城市
    self.receivePhone = [dic getStringWithKey:@"recevicePhoneNo"];          // recevicePhoneNo
    self.pubDate = [dic getStringWithKey:@"pubDate"];                       // 发布时间
    self.orderStatus = [dic getIntegerWithKey:@"status"];                   // 订单状态码
    self.remark = [[dic getStringWithKey:@"remark"] isEqual:@""] ? @"无" : [dic getStringWithKey:@"remark"] ;
    self.orderCount = [dic getIntegerWithKey:@"orderCount"];                // 订单数量
    
    self.isPay = [dic getIntegerWithKey:@"isPay"];                          // 是否已经支付
    self.bussinessPhone = [dic getStringWithKey:@"businessPhone"];          // 商家电话
    self.bussinessPhone2 = [dic getStringWithKey:@"businessPhone2"];        // 商家电话2
    self.childOrderList = [NSMutableArray array];
    for (NSDictionary *subDic in [dic getArrayWithKey:@"listOrderChild"]) {
        ChildOrderModel *childOrder = [[ChildOrderModel alloc] initWithDic:subDic];
        [self.childOrderList addObject:childOrder];
    }
    
    self.ClienterId = [dic getIntegerWithKey:@"ClienterId"];
    self.businessId = [dic getIntegerWithKey:@"businessId"];
    self.IsComplain = [dic getIntegerWithKey:@"IsComplain"];
    
    // 2015-10-21
    self.distance_OrderBy = [dic getIntegerWithKey:@"distance_OrderBy"];
    self.mealsSettleMode = [dic getIntegerWithKey:@"mealsSettleMode"];
    self.businessName = [dic getStringWithKey:@"businessName"];
    self.orderFrom = [dic getIntegerWithKey:@"orderFrom"];
    self.orderFromName = [dic getStringWithKey:@"orderFromName"];
    self.pickUpCity = [dic getStringWithKey:@"pickUpCity"];
}

- (NSString*)orderStatusStr {
    switch (_orderStatus) {
        case OrderStatusNewOrder:
            return @"待接单";
        case OrderStatusComplete:
            return @"已完成";
        case OrderStatusAccepted:
            return @"取货中";
        case OrderStatusCancel:
            return @"已取消";
        case OrderStatusWaitingAccept:
            return @"待接入订单";
        case OrderStatusReceive:
            return @"送货中";
        default:
            return @"";
            break;
    }
    return @"";
}

- (UIColor*)orderStatusColor {
    switch (_orderStatus) {
        case OrderStatusNewOrder:
            return [UIColor colorWithHexString:@"00bcd5"];
        case OrderStatusAccepted:
            return [UIColor colorWithHexString:@"f7585d"];
        case OrderStatusReceive:
            return [UIColor colorWithHexString:@"00bc87"];
        default:
            break;
    }
    return DeepGrey;
}

- (NSString*)orderChannelStr {
    switch (_orderChannel) {
        case OrderChannelEsend:
            return @"E代送";
        case OrderChannelJuwangke:
            return @"聚网客";
        case OrderChannelQuanshi:
            return @"全时";
        case OrderChannelWanda:
            return @"万达";
        case OrderChannelMeituan:
            return @"美团";
        default:
            break;
    }
    return @"";
}

- (NSString*)orderStatusImageName {
    switch (_orderStatus) {
        case OrderStatusComplete:
            return @"compeleted_icon";
        case OrderStatusNewOrder:
            return @"order_wait_accept";
        case OrderStatusAccepted:
            return @"receive_icon";
        case OrderStatusReceive:
            return @"sending_icon";
        default:
            break;
    }
    return @"receive_icon";
}

- (NSString *)orderFromName{
    switch (_orderFrom) {
        case OrderChannelEsend:
            return @"B端";
        case OrderChannelJuwangke:
            return @"聚网客";
        case OrderChannelQuanshi:
            return @"全时";
        case OrderChannelWanda:
            return @"万达";
        case OrderChannelMeituan:
            return @"美团";
        case OrderChannelB_Web:
            return @"商户web版";
        default:
            break;
    }
    return @"";
}


@end
