//
//  EDSRiderDelieveListVC.m
//  ESend
//
//  Created by 台源洪 on 15/9/15.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "EDSRiderDelieveListVC.h"
#import "OrdersListTableVIewCell.h"
#import "FHQNetWorkingAPI.h"

#import "UserInfo.h"
#import "MJRefresh.h"

#define Rd_Cell_Id @"Rd_Cell_Id"


@interface EDSRiderDelieveListVC ()<UITableViewDataSource,UITableViewDelegate>
{
    int _currentPage;// refresh page
    BOOL _addedLoadMore;    // add load more
}

@property (strong, nonatomic) IBOutlet UILabel *Rd_Header;
@property (nonatomic, strong) IBOutlet UITableView * Rd_ContentList;

// 数据源
@property (nonatomic, strong) NSMutableArray * orderList;

@end

@implementation EDSRiderDelieveListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"配送列表";
    
    _orderList = [[NSMutableArray alloc] initWithCapacity:0];
    [self.Rd_ContentList registerClass:[OrdersListTableVIewCell class] forCellReuseIdentifier:Rd_Cell_Id];
    
    [self.Rd_ContentList addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(refreshPullDataList)];
    
    self.Rd_Header.textColor = DeepGrey;
    self.Rd_Header.font = [UIFont systemFontOfSize:BigFontSize];
    self.Rd_Header.text = [NSString stringWithFormat:@"%@ %@ 骑士配送%@单",self.dateInfo,self.clienterName,self.orderCount];
    
    [self.Rd_ContentList.header beginRefreshing];
    

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API

- (void)refreshPullDataList{
    _currentPage = 1;
    NSDictionary *requstData = @{
                                 @"dateInfo" : self.dateInfo,
                                 @"clienterId": self.clienterId,
                                 @"businessId"  : [UserInfo getUserId],
                                 @"currentPage":[NSNumber numberWithInt:_currentPage],
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
        
        [self.Rd_ContentList.header endRefreshing];
        
        [_orderList removeAllObjects];
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
            [_orderList addObject:order];
        }
        [self.Rd_ContentList reloadData];
        
        if (_orderList.count > 4 && !_addedLoadMore) {
            [self.Rd_ContentList addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
            _addedLoadMore = YES;
        }
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
        [self.Rd_ContentList.header endRefreshing];
        
    }];
}

- (void)loadMoreData{
    
    _currentPage ++;
    NSDictionary *requstData = @{
                                 @"dateInfo" : self.dateInfo,
                                 @"clienterId": self.clienterId,
                                 @"businessId"  : [UserInfo getUserId],
                                 @"currentPage":[NSNumber numberWithInt:_currentPage],
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
            [_orderList addObject:order];
        }
        [self.Rd_ContentList reloadData];
        
        if ([result count] == 0) {
            _currentPage--;
        }
        
        [self.Rd_ContentList.footer endRefreshing];
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        _currentPage--;
        [self.Rd_ContentList.footer endRefreshing];
        
    }];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OrdersListTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:Rd_Cell_Id forIndexPath:indexPath];
    [cell loadData:_orderList[indexPath.section]];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [OrdersListTableVIewCell calculateCellHeight:[_orderList objectAtIndex:indexPath.section]];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _orderList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}



@end
