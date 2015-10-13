//
//  ExpensesDetailVC.h
//  ESend
//
//  Created by Maxwell on 15/8/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"

#import "ExpensesInfoModel.h"

/// 收支详情 2015-08-25
/// 新增字段，2015-10-13
@interface ExpensesDetailVC : BaseViewController
@property (nonatomic, strong) ExpensesInfoModel * expenseInfoModel;

/// 新版字段，2015-10-13
@property (nonatomic, strong) NSDictionary * detailInfo;

@end
