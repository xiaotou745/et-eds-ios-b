//
//  ThirdOrderListViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/24.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ThirdOrderListViewController.h"
#import "ThirdOrderTableViewCell.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"
#import "SupermanOrderModel.h"
#import "MJRefresh.h"

@interface ThirdOrderListViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_ordersList;
}

@end

@implementation ThirdOrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bulidView {
    
    self.titleLabel.text = @"待确认订单";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView registerClass:[ThirdOrderTableViewCell class] forCellReuseIdentifier:NSStringFromClass([ThirdOrderTableViewCell class])];
    [self.view addSubview:_tableView];
    
//    _tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
}

- (void)refreshData {
    
    NSDictionary *requestData = @{@"userId" : [UserInfo getUserId],
                                  @"Status" : @(OrderStatusWaitingAccept),
                                  @"pagedSize" : @"100",
                                  @"pagedIndex" : @"0",
                                  @"orderfrom" : @"0"};
    
    [FHQNetWorkingAPI getOrderList:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        
        [_ordersList removeAllObjects];
        for (NSDictionary *dic in result) {
            SupermanOrderModel *order = [[SupermanOrderModel alloc] initWithDic:dic];
            [_ordersList addObject:order];
        }
        
        [_tableView.header endRefreshing];
        [_tableView reloadData];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [_tableView.header endRefreshing];
    } isShowError:YES];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 95;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 10;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ThirdOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ThirdOrderTableViewCell class])];
    [cell loadData:nil];
    return cell;
}
@end
