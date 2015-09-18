//
//  OrdersListTableViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/3.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "OrdersListTableViewController.h"
#import "OrdersListTableVIewCell.h"
#import "MJRefresh.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"
#import "OrderDetailViewController.h"
#import "TakeOrderListViewController.h"
#import "SubOrderModel.h"
#import "WaitOrderListViewController.h"
#import "SupermanOrderModel.h"

@interface OrdersListTableViewController ()
{
    NSMutableArray *_ordersList;
    NSInteger _page;
    
    UIImageView * _logoImgView;
    UILabel     * _markedWordsLabel;
    
    AFHTTPRequestOperation *_operation;
}

@end

@implementation OrdersListTableViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:LogoutNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releseOrder) name:ReleseOrderNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOrder:) name:CancelOrderNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserStatusChange) name:UserStatusChangeToReviewNotification object:nil];
    
    [self initData];
    
    [self.tableView registerClass:[OrdersListTableVIewCell class] forCellReuseIdentifier:NSStringFromClass([OrdersListTableVIewCell class])];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 64)];
    
//    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(refreshData)];
//    [header setImages:@[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"]]
//             duration:0.2
//             forState:MJRefreshStateRefreshing];
//    [header setImages:@[[UIImage imageNamed:@"1"]]
//             duration:10
//             forState:MJRefreshStateIdle];
//    header.stateLabel.hidden = YES;
//    header.lastUpdatedTimeLabel.hidden = YES;
//    self.tableView.header = header;
//
//    MJRefreshBackGifFooter *footer = [MJRefreshBackGifFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
//    [footer setImages:@[[UIImage imageNamed:@"1"],[UIImage imageNamed:@"2"]]
//             duration:0.2
//             forState:MJRefreshStateRefreshing];
//    [footer setImages:@[[UIImage imageNamed:@"1"]]
//             duration:10
//             forState:MJRefreshStateIdle];
//    footer.stateLabel.hidden = YES;
//    self.tableView.footer = footer;
    
    
    // 提示logo
    _logoImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    _logoImgView.backgroundColor = [UIColor clearColor];
    _logoImgView.center          = CGPointMake(ScreenWidth/2, VIEW_HEIGHT(self.tableView)/3);
    [self.tableView addSubview:_logoImgView];
    
    // 提示语
    _markedWordsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgView) +Space_Big, ScreenWidth, 30)];
    _markedWordsLabel.backgroundColor = [UIColor clearColor];
    _markedWordsLabel.textAlignment = NSTextAlignmentCenter;
    _markedWordsLabel.textColor     = DeepGrey;
    _markedWordsLabel.font          = FONT_SIZE(BigFontSize);
    [self.tableView addSubview:_markedWordsLabel];
    

    if ([UserInfo getStatus] != UserStatusComplete) {
        _logoImgView.image = [UIImage imageNamed:@"checkLogo"];
        _markedWordsLabel.text = @"您目前没有通过验证，无法发单!";
        
    }else if ([UserInfo isLogin]) {
        
        _logoImgView.image     = nil;
        _markedWordsLabel.text = @"";
        
        [self.tableView.header beginRefreshing];
    }

}

- (void)refreshData {
    _page = 1 ;
    
    if (![UserInfo isLogin]) {
        [self.tableView.header endRefreshing];
        return;
    }
    
//    if ([UserInfo getStatus] != UserStatusComplete) {
//        [self.tableView.header endRefreshing];
//        return;
//        
//    }
    
    _page = 1 ;
    NSDictionary *requestData = @{@"userId"     : [UserInfo getUserId],
                                  @"Status"     : @(_orderStatus),
                                  @"pagedSize"  : @"100",
                                  @"pagedIndex" : @(_page),
                                  @"orderfrom"  : @"0",
                                  @"isCheckStatus" : @(true)};
    if (_operation) {
        [_operation cancel];
        _operation = nil;
    }
    
    _operation =  [FHQNetWorkingAPI getOrderList:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {

        if ([UserInfo getStatus] != UserStatusComplete) {
            [UserInfo saveStatus:UserStatusComplete];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangeToReviewNotification object:nil];
        }

        
        [_ordersList removeAllObjects];
        for (NSDictionary *dic in result) {
            SupermanOrderModel *order = [[SupermanOrderModel alloc] initWithDic:dic];
            [_ordersList addObject:order];
        }
        
        [self.tableView.header endRefreshing];
        
        [self checkIsNoData];

        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
         [self.tableView.header endRefreshing];
        
        if (error.code == -500) {
            NSLog(@"用户状态不对");
            
            [UserInfo saveStatus:UserStatusReviewing];
            [_ordersList removeAllObjects];
            [self.tableView reloadData];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangeToReviewNotification object:nil];
            
        } else {
            [self checkIsNoData];
            NSString *errorMessage = [error.userInfo getStringWithKey:@"Message"];
            if (isCanUseString(errorMessage)) {
                [Tools showHUD:errorMessage];
            } else {
                if ([AFNetworkReachabilityManager sharedManager].reachable) {
                    [Tools showHUD:@"请求失败"];
                }else{
                    
                }
            }

        }
        

        
    } isShowError:NO];

}

- (void)loadMoreData {
    _page++;
    NSDictionary *requestData = @{@"userId" : [UserInfo getUserId],
                                  @"Status" : @(_orderStatus),
                                  @"pagedSize" : @"100",
                                  @"pagedIndex" : @(_page),
                                  @"orderfrom" : @"0"};
    
    [FHQNetWorkingAPI getOrderList:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        
        for (NSDictionary *dic in result) {
            SupermanOrderModel *order = [[SupermanOrderModel alloc] initWithDic:dic];
            [_ordersList addObject:order];
        }
        
        if ([result count] == 0) {
            _page--;
        }

        [self.tableView.footer endRefreshing];
        [self.tableView reloadData];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [self.tableView.footer endRefreshing];
        _page--;
    } isShowError:YES];
}

- (void)checkIsNoData{
    if (_ordersList.count == 0) {
        _logoImgView.image = [UIImage imageNamed:@"orderLogo"];
        if (_orderStatus == OrderStatusUncomplete) {
            _markedWordsLabel.text = @"您目前没有未完成的订单!";
        }else if (_orderStatus == OrderStatusComplete){
            _markedWordsLabel.text = @"您目前没有已完成的订单!";
        }
    }else{
        _logoImgView.image     = nil;
        _markedWordsLabel.text = @"";
    }
    [self.tableView reloadData];
}
- (void)initData {
    _ordersList = [NSMutableArray array];
    
//    for (int i = 0; i < 10; i++) {
//        OrderModel *order = [[OrderModel alloc] init];
//        order.orderAddress = @"北京市朝阳区劲松桥东27号华腾北塘商务大厦2705室";
//        order.receivePhone = @"18600696720";
//        order.orderStatus = OrderStatusDelivery;
//        order.orderCount = 5;
//        order.orderTotal = 129.10;
//        order.orderTime = @"今天12:20";
//        order.orderChannel = @"美团网";
//        order.orderNumber = @"123123123123123";
//        order.remark = @"北京市朝阳区劲松桥东华腾北塘商务大厦2705室请送到这里面来";
//        
//        NSMutableArray *addressList = [NSMutableArray array];
//        [addressList setArray:@[@"北京市朝阳区劲松桥东华腾北塘商务大厦2705室", @"北京市朝阳区下甸甲八号院02b1"]];
//        order.addressList = addressList;
//        
//        NSMutableArray *subOrderList = [NSMutableArray array];
//        for (NSInteger i = 0; i < 10; i++) {
//            SubOrderModel *subOrder = [[SubOrderModel alloc] init];
//            subOrder.orderName = [NSString stringWithFormat:@"这是来自美团的订单%ld",(long)i];
//            subOrder.price = 123.2 + i;
//            [subOrderList addObject:subOrder];
//        }
//        
//        order.subOrderList = subOrderList;
//        
//        [_ordersList addObject:order];
//    }
//    

}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _ordersList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrdersListTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrdersListTableVIewCell class]) forIndexPath:indexPath];
    [cell loadData:_ordersList[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [OrdersListTableVIewCell calculateCellHeight:[_ordersList objectAtIndex:indexPath.section]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [self getOrderDetail:[_ordersList objectAtIndex:indexPath.section] ];
}

- (void)getOrderDetail:(SupermanOrderModel*)order  {
    NSDictionary *requestData = @{@"OrderId"    : order.orderId,
                                  @"BusinessId" : [UserInfo getUserId],
                                  @"version"    : @"1.0"};
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [FHQNetWorkingAPI getOrderDetail:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        
        [order loadData:result];
        
        OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
        vc.orderModel = order;
        UIViewController *nextVC = (UIViewController*)[self nextResponder];
        while (![nextVC isKindOfClass:[UIViewController class]] ) {
            nextVC = (UIViewController*)[nextVC nextResponder];
        }
        [nextVC.navigationController pushViewController:vc animated:YES];
        [Tools hiddenProgress:HUD];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];
}

- (void)userLoginSuccess {
    [_ordersList removeAllObjects];
    if ([UserInfo getStatus] != UserStatusComplete) {
        _logoImgView.image = [UIImage imageNamed:@"checkLogo"];
        _markedWordsLabel.text = @"您目前没有通过验证，无法发单!";
        
    }else{
        _logoImgView.image     = nil;
        _markedWordsLabel.text = @"";
        
        [self.tableView.header beginRefreshing];
    }
    
}

- (void)UserStatusChange {
    [self userLoginSuccess];
}

- (void)userLogout {
    [_ordersList removeAllObjects];
    [self.tableView reloadData];
}

- (void)releseOrder {
    [self.tableView.header beginRefreshing];
}

- (void)cancelOrder:(NSNotification*)notification {
    SupermanOrderModel *order = notification.object;

    if ([_ordersList containsObject:order]) {
        [_ordersList removeObject:order];
        [self.tableView reloadData];
    }

}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
