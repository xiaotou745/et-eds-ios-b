//
//  SSMyOrdersVC.m
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSMyOrdersVC.h"
#import "SSOrderUnpayCell.h"
#import "SSMyOrderStatus.h"

@interface SSMyOrdersVC ()<UITableViewDataSource,UITableViewDelegate>
{
    SSMyOrderStatus _orderListStatus;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionHeaderScrollerWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentScrollerWidth;
@end

@implementation SSMyOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"我的订单";
}


- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.optionHeaderScrollerWidth.constant = 100 * 5;
    self.contentScrollerWidth.constant = ScreenWidth * 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    // 待支付
    static NSString * ssOrderVCUnpayCellId = @"ssOrderVCUnpayCellId";
    SSOrderUnpayCell * cell = [tableView dequeueReusableCellWithIdentifier:ssOrderVCUnpayCellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSOrderUnpayCell class]) owner:self options:nil] lastObject];
    }
    return cell;
}

#pragma mark - API
/// 订单列表，下拉

@end
