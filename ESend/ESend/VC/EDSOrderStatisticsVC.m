//
//  EDSOrderStatisticsVC.m
//  ESend
//
//  Created by 台源洪 on 15/9/15.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "EDSOrderStatisticsVC.h"
#import "EDSAttachedRiderCell.h"

#import "MNUnderLineButton.h"

#define OS_ORDER_CELL_HEADER_HEIGHT 40.0f
#define OS_ORDER_CELL_HEIGHT 74.0f

@interface EDSOrderStatisticsVC ()<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIView *OS_HeaderBg;

@property (strong, nonatomic) IBOutlet UITableView *OS_OrdersTable;

@property (strong, nonatomic) NSMutableArray * OS_OrdersData;

@end

@implementation EDSOrderStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // datasource
    _OS_OrdersData = [[NSMutableArray alloc] initWithCapacity:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate,Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * AR_TableCellIdentifier = @"AR_TableCellId";
    EDSAttachedRiderCell * cell = [tableView dequeueReusableCellWithIdentifier:AR_TableCellIdentifier];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EDSAttachedRiderCell" owner:self options:nil] firstObject];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return OS_ORDER_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return OS_ORDER_CELL_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.OS_OrdersTable) { // section header
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, OS_ORDER_CELL_HEADER_HEIGHT)];
        header.backgroundColor = [UIColor colorWithHexString:@"fafafa"];
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 50, OS_ORDER_CELL_HEADER_HEIGHT)];
        name.backgroundColor = [UIColor clearColor];
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = [UIColor colorWithHexString:@"999999"];
        //name.text = ((ETSDishCagegory *)self.foodCagegories[section]).cagegory_name;
        name.font = [UIFont systemFontOfSize:13.0f];
        [header addSubview:name];
        
        // 订单数量 80
        MNUnderLineButton * orderCountBtn = [[MNUnderLineButton alloc] initWithFrame:CGRectMake(80, 0, 70, OS_ORDER_CELL_HEADER_HEIGHT)];
        [orderCountBtn setTitle:[NSString stringWithFormat:@"完成订单量 10"] forState:UIControlStateNormal];
        [orderCountBtn setTitleColor:DeepGrey forState:UIControlStateNormal];
        orderCountBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        orderCountBtn.tag = section;
        [orderCountBtn addTarget:self action:@selector(orderCountButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [header addSubview:orderCountBtn];
        
        // 骑士数量 10
        float riderCountWidth = 80.0f;
        UILabel * riderCount = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - riderCountWidth, 0, riderCountWidth, OS_ORDER_CELL_HEADER_HEIGHT)];
        riderCount.backgroundColor = [UIColor clearColor];
        riderCount.textAlignment = NSTextAlignmentRight;
        riderCount.textColor = [UIColor colorWithHexString:@"999999"];
        riderCount.font = [UIFont systemFontOfSize:13.0f];
        [header addSubview:riderCount];
        
        return header;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



#pragma mark - 订单量事件
- (void)orderCountButtonAction:(MNUnderLineButton *)sender{
    NSLog(@"%ld",(long)sender.tag);
}

@end
