//
//  WaitOrderListViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/5.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "WaitOrderListViewController.h"
#import "OrdersListTableViewController.h"

@interface WaitOrderListViewController ()
{
    OrdersListTableViewController *_ordersListVC;
}

@end

@implementation WaitOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bulidView {
    
    self.titleLabel.text = @"待确认订单";
    
    _ordersListVC = [[OrdersListTableViewController alloc] initWithStyle:UITableViewStylePlain];
    _ordersListVC.view.frame = CGRectMake(0, 64, MainWidth, ScreenHeight - 64);
    [self.view addSubview:_ordersListVC.view];
}


@end
