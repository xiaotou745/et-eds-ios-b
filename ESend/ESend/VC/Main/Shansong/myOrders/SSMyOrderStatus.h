//
//  SSMyOrderStatus.h
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#ifndef SSMyOrderStatus_h
#define SSMyOrderStatus_h

///0:待接单订单列表 2 待取货订单列表 4 配送中订单列表 50待支付 1已完成
typedef NS_ENUM(NSInteger, SSMyOrderStatus) {
    SSMyOrderStatusUnpayed = 50,
    SSMyOrderStatusUngrab = 0,
    SSMyOrderStatusOntaking = 2,
    SSMyOrderStatusOnDelivering = 4,
    SSMyOrderStatusCompleted = 1,
};

#endif /* SSMyOrderStatus_h */
