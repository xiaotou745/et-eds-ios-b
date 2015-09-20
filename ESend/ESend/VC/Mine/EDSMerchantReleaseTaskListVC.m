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

#define MRTL_Cell_Id @"MRTL_Cell_Id"

@interface EDSMerchantReleaseTaskListVC ()<UITableViewDataSource,UITableViewDelegate>
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
    
    self.MRTL_Header.textColor = DeepGrey;
    self.MRTL_Header.font = [UIFont systemFontOfSize:BigFontSize];
    self.MRTL_Header.text = [NSString stringWithFormat:@"%@       订单量 %@",self.dateInfo,self.orderCount];
    
    
    MBProgressHUD * waitingProcess = [Tools showProgressWithTitle:@""];
    
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
        
        [Tools hiddenProgress:waitingProcess];
        
        [_MRTLorderList removeAllObjects];
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
            [_MRTLorderList addObject:order];
        }
        [self.MRTL_OrderListTable reloadData];
        
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

@end
