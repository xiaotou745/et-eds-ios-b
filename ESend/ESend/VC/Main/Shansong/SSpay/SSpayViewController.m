//
//  SSpayViewController.m
//  ESend
//
//  Created by 台源洪 on 15/12/5.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSpayViewController.h"
#import "SSPayMethodCell.h"
#import "SSRemainingBalanceCell.h"

#define SSPayMethodTableCellHeight 45

@interface SSpayViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIView *payInfoBgView;
@property (weak, nonatomic) IBOutlet UILabel *payTotalLabel;
@property (weak, nonatomic) IBOutlet UITableView *payMethodTable;
@property (weak, nonatomic) IBOutlet UIButton *payActionBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *payMethodTableHeight;

@property (strong,nonatomic) NSMutableArray * payMethodArray;

@end

@implementation SSpayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.titleLabel.text = @"确认支付";
    [self customizeViews];
}

- (void)customizeViews{
    //data
    _payMethodArray = [[NSMutableArray alloc] initWithCapacity:0];
    SSRemainingBalanceModel * remainBalance = [[SSRemainingBalanceModel alloc] init];
    remainBalance.payType = SSPayMethodTypeRemainingBalance;
    remainBalance.selected = NO;
//    remainBalance.remainingBalance = 
    
    self.payInfoBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ss_pay_bg"]];
    self.payTotalLabel.textColor = RedDefault;
    self.payMethodTable.layer.borderColor = [SeparatorLineColor CGColor];
    self.payMethodTable.layer.borderWidth = 0.5;
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.payMethodTableHeight.constant = 3 * SSPayMethodTableCellHeight;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.payMethodArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[self.payMethodArray objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        static NSString * ssRemainBalanceCellID = @"ssRemainBalanceCellID";
        SSRemainingBalanceCell * cell = [tableView dequeueReusableCellWithIdentifier:ssRemainBalanceCellID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSRemainingBalanceCell class]) owner:self options:nil] lastObject];
        }
        return cell;
    }else if (indexPath.section == 1){
        static NSString * ssPayMethodCellID = @"ssPayMethodCellID";
        SSPayMethodCell * cell = [tableView dequeueReusableCellWithIdentifier:ssPayMethodCellID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSPayMethodCell class]) owner:self options:nil] lastObject];
        }
        return cell;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return SSPayMethodTableCellHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}
@end
