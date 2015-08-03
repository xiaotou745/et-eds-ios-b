//
//  SupermanOrderModel.m
//  ESend
//
//  Created by 永来 付 on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "SupermanOrderModel.h"
#import "ChildOrderModel.h"

@implementation SupermanOrderModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        
        self.orderId = [dic getStringWithKey:@"OrderId"];
        self.orderNumber = [dic getStringWithKey:@"OrderNo"];
        
        [self loadData:dic];
    }
    return self;
}

- (void)loadData:(NSDictionary*)dic {
    
    
    self.supermenName = [dic getStringWithKey:@"ClienterName"];
    self.supermenPhone = [dic getStringWithKey:@"ClienterPhoneNo"];
    self.pickupName = [dic getStringWithKey:@"PickUpName"];
    self.pickupAddress = [dic getStringWithKey:@"PickUpAddress"];
    self.totalDeliverPrce = [dic getFloatWithKey:@"TotalDistribSubsidy"];
    self.amount = [dic getFloatWithKey:@"Amount"];
    self.totalAmount = [dic getFloatWithKey:@"TotalAmount"];
    self.receiveAddress = [dic getStringWithKey:@"ReceviceAddress"];
    self.receiveName = [dic getStringWithKey:@"ReceviceName"];
    self.receivePhone = [dic getStringWithKey:@"RecevicePhoneNo"];
    self.pubDate = [dic getStringWithKey:@"PubDate"];
    self.orderStatus = [dic getIntegerWithKey:@"Status"];
    self.remark = [[dic getStringWithKey:@"Remark"] isEqual:@""] ? @"无" : [dic getStringWithKey:@"Remark"] ;
    self.orderCount = [dic getIntegerWithKey:@"OrderCount"];
    
    self.isPay = [dic getIntegerWithKey:@"IsPay"];
    self.bussinessPhone = [dic getStringWithKey:@"businessPhone"];
    self.bussinessPhone2 = [dic getStringWithKey:@"businessPhone2"];
    self.childOrderList = [NSMutableArray array];
    for (NSDictionary *subDic in [dic getArrayWithKey:@"listOrderChild"]) {
        ChildOrderModel *childOrder = [[ChildOrderModel alloc] initWithDic:subDic];
        [self.childOrderList addObject:childOrder];
    }
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

@end
