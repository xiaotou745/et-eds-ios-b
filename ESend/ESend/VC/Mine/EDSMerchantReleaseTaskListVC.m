//
//  EDSMerchantReleaseTaskListVC.m
//  ESend
//
//  Created by 台源洪 on 15/9/16.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "EDSMerchantReleaseTaskListVC.h"
#import "OrdersListTableVIewCell.h"
#import "FHQNetWorkingAPI.h"

#import "UserInfo.h"
#import "MJRefresh.h"

#import "OrderDetailViewController.h"

#define MRTL_Cell_Id @"MRTL_Cell_Id"

@interface EDSMerchantReleaseTaskListVC ()<UITableViewDataSource,UITableViewDelegate>
{
     int       _currentPage;
    BOOL _addedLoadMore;

}
@property (strong, nonatomic) IBOutlet UILabel *MRTL_Header;
@property (strong, nonatomic) IBOutlet UITableView *MRTL_OrderListTable;

// 数据源
@property (nonatomic, strong) NSMutableArray * MRTLorderList;

@end

@implementation EDSMerchantReleaseTaskListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"任务列表";
    
    _MRTLorderList = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self.MRTL_OrderListTable registerClass:[OrdersListTableVIewCell class] forCellReuseIdentifier:MRTL_Cell_Id];
    [self.MRTL_OrderListTable addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(downpullToRefreshDataList)];
    [self.MRTL_OrderListTable.header beginRefreshing];
    
    self.MRTL_Header.textColor = DeepGrey;
    self.MRTL_Header.font = [UIFont systemFontOfSize:BigFontSize];
    self.MRTL_Header.text = [NSString stringWithFormat:@"%@       订单量 %@",self.dateInfo,self.orderCount];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - API

- (void)downpullToRefreshDataList{
    _currentPage = 1;
    
    NSDictionary *requstData = @{
                                 @"dateInfo" : self.dateInfo,
                                 @"businessId"  : [UserInfo getUserId],
                                 };
    
    
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:requstData];
        
        NSString * aesString = [Security AesEncrypt:jsonString2];
        
        requstData = @{
                       @"data":aesString,
                       //@"Version":[Tools getApplicationVersion],
                       };
    }
    
    [FHQNetWorkingAPI getcompliteorderb:requstData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        
        NSLog(@"%@",result);
        
        [self.MRTL_OrderListTable.header endRefreshing];
        
        [_MRTLorderList removeAllObjects];
        for (NSDictionary *dic in result) {
            //SupermanOrderModel *order = [[SupermanOrderModel alloc] initWithDic:dic];
            SupermanOrderModel * order = [[SupermanOrderModel alloc] init];
            order.orderStatus = [[dic objectForKey:@"status"] integerValue];
            order.receivePhone = [dic getStringWithKey:@"recevicePhoneNo"];
            order.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
            order.orderNumber = [dic objectForKey:@"orderNo"];
            order.amount = [[dic objectForKey:@"amount"] floatValue];
            order.totalAmount = [[dic objectForKey:@"totalAmount"] floatValue];
            order.receiveAddress = [dic getStringWithKey:@"receviceAddress"];
            order.orderCount = [[dic objectForKey:@"orderCount"] integerValue];
            order.pubDate = [dic objectForKey:@"pubDate"];
            [_MRTLorderList addObject:order];
        }
        [self.MRTL_OrderListTable reloadData];
        
        if (_MRTLorderList.count > 4 && !_addedLoadMore) {
            [self.MRTL_OrderListTable addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            _addedLoadMore = YES;
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [self.MRTL_OrderListTable.header endRefreshing];

        
    }];
}

- (void)loadMoreData{
    _currentPage ++;
    NSDictionary *requstData = @{
                                 @"dateInfo" : self.dateInfo,
                                 @"businessId"  : [UserInfo getUserId],
                                 };
    
    
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:requstData];
        
        NSString * aesString = [Security AesEncrypt:jsonString2];
        
        requstData = @{
                       @"data":aesString,
                       //@"Version":[Tools getApplicationVersion],
                       };
    }
    
    [FHQNetWorkingAPI getcompliteorderb:requstData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        
        NSLog(@"%@",result);
        
        for (NSDictionary *dic in result) {
            //SupermanOrderModel *order = [[SupermanOrderModel alloc] initWithDic:dic];
            SupermanOrderModel * order = [[SupermanOrderModel alloc] init];
            order.orderStatus = [[dic objectForKey:@"status"] integerValue];
            order.receivePhone = [dic getStringWithKey:@"recevicePhoneNo"];
            order.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
            order.orderNumber = [dic objectForKey:@"orderNo"];
            order.amount = [[dic objectForKey:@"amount"] floatValue];
            order.totalAmount = [[dic objectForKey:@"totalAmount"] floatValue];
            order.receiveAddress = [dic getStringWithKey:@"receviceAddress"];
            order.orderCount = [[dic objectForKey:@"orderCount"] integerValue];
            order.pubDate = [dic objectForKey:@"pubDate"];
            [_MRTLorderList addObject:order];
        }
        [self.MRTL_OrderListTable reloadData];
        if ([result count] == 0) {
            _currentPage--;
        }
        
        [self.MRTL_OrderListTable.footer endRefreshing];
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        _currentPage -- ;
        [self.MRTL_OrderListTable.footer endRefreshing];
        
        
    }];
}



#pragma mark - UITableViewDataSource,UITableViewDelegate
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrdersListTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:MRTL_Cell_Id forIndexPath:indexPath];
    [cell loadData:_MRTLorderList[indexPath.section]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [OrdersListTableVIewCell calculateCellHeight:[_MRTLorderList objectAtIndex:indexPath.section]];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _MRTLorderList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self getOrderDetail:[_MRTLorderList objectAtIndex:indexPath.section] ];
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
        [self.navigationController pushViewController:vc animated:YES];
        [Tools hiddenProgress:HUD];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];
}

@end
