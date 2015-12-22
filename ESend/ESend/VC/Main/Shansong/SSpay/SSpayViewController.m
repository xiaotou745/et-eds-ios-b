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
#import "SSHttpReqServer.h"
#import "UserInfo.h"
#import "AliPay.h"
#import "WechatPay.h"

#define SSPayMethodTableCellHeight 45

@interface SSpayViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    SSRemainingBalanceModel * _remainBalance;
    SSPayMethodModel * _alipay;
    SSPayMethodModel * _wechatPay;
}
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ssPaySuccess) name:AliPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ssPaySuccess) name:WechatPaySuccessNotification object:nil];
    
    [self customizeViews];
}

- (void)customizeViews{
    self.payTotalLabel.text = [NSString stringWithFormat:@"¥%.2f",self.tipAmount];
    self.payTotalLabel.textColor = RedDefault;
    //data
    _payMethodArray = [[NSMutableArray alloc] initWithCapacity:0];
    _remainBalance = [[SSRemainingBalanceModel alloc] init];
    _remainBalance.payType = SSPayMethodTypeRemainingBalance;
    _remainBalance.selected = YES;
    _remainBalance.remainingBalance = self.balancePrice;
    NSArray * balanceArray = [NSArray arrayWithObjects:_remainBalance, nil];
    [_payMethodArray addObject:balanceArray];
    //
    _alipay = [[SSPayMethodModel alloc] init];
    _alipay.payType = SSPayMethodTypeAlipay;
    _alipay.selected = NO;
    _wechatPay = [[SSPayMethodModel alloc] init];
    _wechatPay.payType = SSPayMethodTypeWechatpay;
    _wechatPay.selected = NO;
    NSArray * onlinePayArray = [NSArray arrayWithObjects:_alipay,_wechatPay, nil];
    [_payMethodArray addObject:onlinePayArray];
    
    self.payInfoBgView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"ss_pay_bg"]];
    self.payTotalLabel.textColor = RedDefault;
    self.payMethodTable.layer.borderColor = [SeparatorLineColor CGColor];
    self.payMethodTable.layer.borderWidth = 0.5;
    //
    [self.payActionBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
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
        cell.dataSource = [[_payMethodArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        return cell;
    }else if (indexPath.section == 1){
        static NSString * ssPayMethodCellID = @"ssPayMethodCellID";
        SSPayMethodCell * cell = [tableView dequeueReusableCellWithIdentifier:ssPayMethodCellID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSPayMethodCell class]) owner:self options:nil] lastObject];
        }
        cell.datasource = [[_payMethodArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
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
    [self selectTheOnlyType:indexPath];
    [tableView reloadData];
}

- (IBAction)buybuybuy:(UIButton *)sender {
    if ([self selectedPayMethodType] == SSPayMethodTypeRemainingBalance) {
        NSDictionary * paraDict = @{
                                    @"businessId":[UserInfo getUserId],
                                    @"orderId":self.orderId,
                                    @"type":[NSNumber numberWithInteger:self.type],
                                    @"tipamount":[NSNumber numberWithDouble:self.tipAmount],
                                    };
        if (AES_Security) {
            NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
            NSString * aesString = [Security AesEncrypt:jsonString2];
            paraDict = @{@"data":aesString,};
        }
        MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];//
        [SSHttpReqServer shanSongOrderBalancePay:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Tools hiddenProgress:HUD];
            NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
            NSString * message = [responseObject objectForKey:@"message"];
            if (status == 1) {
                [Tools showHUD:@"支付成功"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [Tools showHUD:message];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Tools hiddenProgress:HUD];
        }];
    }else{
        NSDictionary * paraDict = @{
                                    @"payStyle":@"0",
                                    @"orderId":self.orderId,
                                    @"payType":[NSNumber numberWithInteger:[self selectedPayMethodType]],
                                    @"tipAmount":[NSNumber numberWithDouble:self.tipAmount],
                                    };
        if (AES_Security) {
            NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
            NSString * aesString = [Security AesEncrypt:jsonString2];
            paraDict = @{@"data":aesString,};
        }
        MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];//
        [SSHttpReqServer shanSongCreateFlashPay:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Tools hiddenProgress:HUD];
            NSDictionary * Result = [responseObject objectForKey:@"Result"];
            if (SSPayMethodTypeAlipay == [self selectedPayMethodType]) {
                [AliPay payWithPrice:self.tipAmount orderNumber:[Result getStringWithKey:@"orderNo"] notifyURL:[Result getStringWithKey:@"notifyUrl"] productName:@"E代送发货端支付"];
            }else if (SSPayMethodTypeWechatpay == [self selectedPayMethodType]) {
                [WechatPay wechatPayWithPrice:self.tipAmount orderNo:[Result getStringWithKey:@"orderNo"] notifyURL:[Result getStringWithKey:@"notifyUrl"] prepayId:[Result getStringWithKey:@"prepayId"]];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Tools hiddenProgress:HUD];
        }];
    }
}

- (void)selectTheOnlyType:(NSIndexPath *)indexPath{
    _remainBalance.selected = NO;
    _alipay.selected = NO;
    _wechatPay.selected = NO;
    if (indexPath.section == 0) {
        _remainBalance.selected = YES;
    }else{
        if (indexPath.row == 0) {
            _alipay.selected = YES;
        }else{
            _wechatPay.selected = YES;
        }
    }
}

- (SSPayMethodType)selectedPayMethodType{
    NSInteger theType = -1;
    for (SSRemainingBalanceModel * model in _payMethodArray[0]) {
        if (model.selected) {
            theType = model.payType;
            break;
        }
    }
    if (theType > 0) {
        return theType;
    }
    for (SSPayMethodModel * model in _payMethodArray[1]) {
        if (model.selected) {
            theType = model.payType;
            break;
        }
    }
    return theType;
}

#pragma mark - 支付回调
#pragma mark - 通知回调
- (void)ssPaySuccess {
    [Tools showHUD:@"支付成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
