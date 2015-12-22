//
//  SSMyOrderModel.h
//  ESend
//
//  Created by 台源洪 on 15/12/16.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface SSMyOrderModel : BaseModel

@property (nonatomic,copy) NSString * pickupCode;           //
@property (nonatomic,copy) NSString * pickUpAddress;        //
@property (nonatomic,assign) NSInteger orderId;
@property (nonatomic,assign) NSInteger platform;
@property (nonatomic,copy) NSString * pubDate;
@property (nonatomic,assign) BOOL isPay;
@property (nonatomic,copy) NSString * grabTime;
@property (nonatomic,copy) NSString *receviceAddress;
@property (nonatomic,assign) NSInteger status;
@property (nonatomic,assign) double orderCommission;
@property (nonatomic,copy) NSString * orderNo;
@property (nonatomic,copy) NSString * actualDoneDate;
@property (nonatomic,assign) double km;
@property (nonatomic,assign) double weight;

@property (nonatomic,assign) double balancePrice;

@property (nonatomic,assign)double totalAmount;

@end
