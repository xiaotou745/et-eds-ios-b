//
//  ComplaintViewController.h
//  ESend
//
//  Created by Maxwell on 15/8/18.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"
#import "SSOrderDetailModel.h"

@interface ComplaintViewController : BaseViewController

@property (nonatomic, strong) SSOrderDetailModel *orderModel;

@property (nonatomic,copy) void (^callBackBlock)(void);


@end
