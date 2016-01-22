//
//  SSMyOrdersVC.h
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"
#import "SSMyOrderStatus.h"

@interface SSMyOrdersVC : BaseViewController
@property (nonatomic,assign) SSMyOrderStatus orderListStatus;   // 当前订单状态
//
@property (nonatomic,assign) BOOL toSSMyOrderStatusUngrab;      // 显示待解订单项
@end
