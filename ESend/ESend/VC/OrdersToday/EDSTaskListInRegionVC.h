//
//  EDSTaskListInRegionVC.h
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"
#import "SupermanOrderModel.h"

@interface EDSTaskListInRegionVC : BaseViewController

@property (nonatomic,copy) NSString * TLIR_Title;
@property (nonatomic,assign) OrderStatus selectedStatus;   // option view 标签

@property (nonatomic,assign) NSInteger businessid;
@property (nonatomic,assign) NSInteger regionid;

@end
