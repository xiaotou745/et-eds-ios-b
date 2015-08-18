//
//  OrdersListTableViewController.h
//  ESend
//
//  Created by 永来 付 on 15/6/3.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

/// 订单列表
@interface OrdersListTableViewController : UITableViewController

@property (nonatomic, assign) OrderStatus orderStatus;

@end
