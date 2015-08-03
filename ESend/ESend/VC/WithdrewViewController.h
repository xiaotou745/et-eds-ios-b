//
//  WithdrewViewController.h
//  ESend
//
//  Created by 永来 付 on 15/6/26.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"
#import "BankModel.h"

@interface WithdrewViewController : BaseViewController

@property (nonatomic, strong) BankModel *bank;
@property (nonatomic, assign) CGFloat allowWithdrawPrice;

@end
