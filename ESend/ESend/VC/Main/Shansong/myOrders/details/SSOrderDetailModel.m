//
//  SSOrderDetailModel.m
//  ESend
//
//  Created by 台源洪 on 15/12/17.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSOrderDetailModel.h"

@implementation SSOrderDetailModel
//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    
//}

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.platform = [[dic objectForKey:@"platform"] integerValue];
        self.orderno = [dic objectForKey:@"orderno"];
        if (isCanUseObj([dic objectForKey:@"pickupaddress"])) {
            self.pickupaddress = [dic objectForKey:@"pickupaddress"];
        }
        self.recevicename = [dic objectForKey:@"recevicename"];
        self.recevicephoneno = [dic objectForKey:@"recevicephoneno"];
        self.receviceaddress = [dic objectForKey:@"receviceaddress"];
        self.ispay = [[dic objectForKey:@"ispay"] boolValue];
        self.amount = [[dic objectForKey:@"amount"] doubleValue];
        if (isCanUseObj([dic objectForKey:@"remark"])) {
            self.remark = [dic objectForKey:@"remark"];
        }else{
            self.remark = @"";
        }
        self.status = [[dic objectForKey:@"status"] integerValue];
        self.businessid = [[dic objectForKey:@"businessid"] integerValue];
        self.orderfrom = [[dic objectForKey:@"orderfrom"] integerValue];
        self.weight = [[dic objectForKey:@"weight"] doubleValue];
        self.km = [[dic objectForKey:@"km"] doubleValue];
        self.ordercount = [[dic objectForKey:@"ordercount"] integerValue];
        if (isCanUseObj([dic objectForKey:@"pickupcode"])) {
            self.pickupcode = [dic objectForKey:@"pickupcode"];
        }else{
            self.pickupcode = @"";
        }
        if (isCanUseObj([dic objectForKey:@"pubname"])) {
            self.pubname = [dic objectForKey:@"pubname"];
        }else{
            self.pubname = @"";
        }
        self.pubphoneno = [dic objectForKey:@"pubphoneno"];
        if (isCanUseObj([dic objectForKey:@"pubaddress"])) {
            self.pubaddress = [dic objectForKey:@"pubaddress"];
        }else{
            self.pubaddress = @"";
        }
        self.taketype = [[dic objectForKey:@"taketype"] integerValue];
        if (isCanUseObj([dic objectForKey:@"productname"])) {
            self.productname = [dic objectForKey:@"productname"];
        }else{
            self.productname = @"";
        }
        self.iscomplain = [[dic objectForKey:@"iscomplain"] integerValue];
        self.clienterName = [dic objectForKey:@"clienterName"];
        self.clienterid = [[dic objectForKey:@"clienterid"] integerValue];
        self.clienterPhoneNo = [dic objectForKey:@"clienterPhoneNo"];
        self.ordercommission = [[dic objectForKey:@"ordercommission"] doubleValue];
        self.cancelTime = [dic objectForKey:@"cancelTime"];
        if (isCanUseObj([dic objectForKey:@"otherCancelReason"])) {
            self.otherCancelReason = [dic objectForKey:@"otherCancelReason"];
        }else{
            self.otherCancelReason = @"";
        }
        if (isCanUseObj([dic objectForKey:@"actualdonedate"])) {
            self.actualdonedate = [dic objectForKey:@"actualdonedate"];
        }else{
            self.actualdonedate = @"";
        }
        if (isCanUseObj([dic objectForKey:@"pubdate"])) {
            self.pubdate = [dic objectForKey:@"pubdate"];
        }else{
            self.pubdate = @"";
        }
        if (isCanUseObj([dic objectForKey:@"grabtime"])) {
            self.grabtime = [dic objectForKey:@"grabtime"];
        }else{
            self.grabtime = @"";
        }
        if (isCanUseObj([dic objectForKey:@"taketime"])) {
            self.taketime = [dic objectForKey:@"taketime"];
        }else{
            self.taketime = @"";
        }
        if (isCanUseObj([dic objectForKey:@"expectedTakeTime"])) {
            self.expectedTakeTime = [dic objectForKey:@"expectedTakeTime"];
        }else{
            self.expectedTakeTime = @"";
        }
        self.orderId = [[dic objectForKey:@"id"] integerValue];
    }
    return self;
}

- (NSString *)orderStatusString{
    NSString * statusStr = @"";
    switch (self.status) {
        case SSMyOrderStatusUnpayed:
            statusStr = @"待支付";
            break;
        case SSMyOrderStatusUngrab:
            statusStr = @"待接单";
            break;
        case SSMyOrderStatusOntaking:
            statusStr = @"取货中";
            break;
        case SSMyOrderStatusOnDelivering:
            statusStr = @"配送中";
            break;
        case SSMyOrderStatusCompleted:
            statusStr = @"已完成";
            break;
        case SSMyOrderStatusCanceled:
            statusStr = @"已取消";
            break;
        default:
            break;
    }
    return statusStr;
}

- (NSString *)orderStatusImg{
    NSString * statusStr = nil;
    switch (self.status) {
        case SSMyOrderStatusUnpayed:
            statusStr = @"ss_detail_nopay";
            break;
        case SSMyOrderStatusUngrab:
            statusStr = @"ss_detail_nograb";
            break;
        case SSMyOrderStatusOntaking:
            statusStr = @"ss_detail_ontaking";
            break;
        case SSMyOrderStatusOnDelivering:
            statusStr = @"ss_detail_ondelivering";
            break;
        case SSMyOrderStatusCompleted:
            statusStr = @"ss_detail_completed";
            break;
        case SSMyOrderStatusCanceled:
            statusStr = @"ss_detail_cancel";
            break;
        default:
            break;
    }
    return statusStr;
}

- (NSString *)orderFromString{
    //订单来源，默认0表示E代送B端订单，1聚网客,2万达，3全时，4美团 5 回家吃饭 6首旅集团 99商家版后台
    NSString * result = nil;
    switch (self.orderfrom) {
        case 0:
            result = @"E代送B端订单";
            break;
        case 1:
            result = @"聚网客";
            break;
        case 2:
            result = @"万达";
            break;
        case 3:
            result = @"全时";
            break;
        case 4:
            result = @"美团";
            break;
        case 5:
            result = @"回家吃饭";
            break;
        case 6:
            result = @"首旅集团";
            break;
        case 99:
            result = @"商家版后台";
            break;
        default:
            break;
    }
    return result;
}

@end
