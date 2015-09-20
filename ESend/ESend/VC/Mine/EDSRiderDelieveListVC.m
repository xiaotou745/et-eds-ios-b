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

#define Rd_Cell_Id @"Rd_Cell_Id"


@interface EDSRiderDelieveListVC ()<UITableViewDataSource,UITableViewDelegate>

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
    
    self.Rd_Header.textColor = DeepGrey;
    self.Rd_Header.font = [UIFont systemFontOfSize:BigFontSize];
    self.Rd_Header.text = [NSString stringWithFormat:@"%@ %@ 骑士配送%@单",self.dateInfo,self.clienterName,self.orderCount];
    
    MBProgressHUD * waitingProcess = [Tools showProgressWithTitle:@""];
    
    NSDictionary *requstData = @{
                                 @"dateInfo" : self.dateInfo,
                                 @"clienterId": self.clienterId,
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
        
        [Tools hiddenProgress:waitingProcess];
        
        [_orderList removeAllObjects];
        for (NSDictionary *dic in result) {
            //SupermanOrderModel *order = [[SupermanOrderModel alloc] initWithDic:dic];
            SupermanOrderModel * order = [[SupermanOrderModel alloc] init];
            order.orderStatus = [[dic objectForKey:@"status"] integerValue];
            order.receivePhone = [dic objectForKey:@"recevicePhoneNo"];
            order.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
            order.orderNumber = [dic objectForKey:@"orderNo"];
            order.amount = [[dic objectForKey:@"amount"] floatValue];
            order.totalAmount = [[dic objectForKey:@"totalAmount"] floatValue];
            order.receiveAddress = [dic objectForKey:@"receviceAddress"];
            order.orderCount = [[dic objectForKey:@"orderCount"] integerValue];
            order.pubDate = [dic objectForKey:@"pubDate"];
            [_orderList addObject:order];
        }
        [self.Rd_ContentList reloadData];

    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
        [Tools hiddenProgress:waitingProcess];

    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
