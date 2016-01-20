//
//  SSpayViewController.h
//  ESend
//
//  Created by 台源洪 on 15/12/5.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"

@interface SSpayViewController : BaseViewController

@property (nonatomic,copy) NSString * orderId;
@property (nonatomic,assign) NSInteger type;    // 1发单，2抢单之前，待支付订单列表
@property (nonatomic,assign) double tipAmount;  // 支付金额
@property (nonatomic,assign) double balancePrice;  // 账户余额

@property (nonatomic,copy) NSString * pickupcode;

@end
