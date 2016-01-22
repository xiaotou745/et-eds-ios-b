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
#import "UIAlertView+Blocks.h"
#import "CustomIOSAlertView.h"
#import "AppDelegate.h"
#import "SSMyOrdersVC.h"

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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ssPaySuccess:) name:AliPaySuccessNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ssPaySuccess:) name:WechatPaySuccessNotification object:nil];
    
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
    if (self.tipAmount > self.balancePrice) {
        _remainBalance.enable = NO;
    }else{
        _remainBalance.enable = YES;
    }
    NSArray * balanceArray = [NSArray arrayWithObjects:_remainBalance, nil];
    [_payMethodArray addObject:balanceArray];
    //
    _alipay = [[SSPayMethodModel alloc] init];
    _alipay.payType = SSPayMethodTypeAlipay;
    if (self.tipAmount > self.balancePrice) {
        _alipay.selected = YES;
    }else{
        _alipay.selected = NO;
    }
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
                [self showPaySuccessAlertWithCode:self.pickupcode];
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
        MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];//
        [SSHttpReqServer shanSongCreateFlashPay:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Tools hiddenProgress:HUD];
            NSInteger Status = [[responseObject objectForKey:@"Status"] integerValue];
            NSString * Message = [responseObject objectForKey:@"Message"];
            if (Status == 1) {
                NSDictionary * Result = [responseObject objectForKey:@"Result"];
                if (SSPayMethodTypeAlipay == [self selectedPayMethodType]) {
                    [AliPay payWithPrice:self.tipAmount orderNumber:[Result getStringWithKey:@"orderNo"] notifyURL:[Result getStringWithKey:@"notifyUrl"] productName:@"E代送发货端支付"];
                }else if (SSPayMethodTypeWechatpay == [self selectedPayMethodType]) {
                    [WechatPay wechatPayWithPrice:self.tipAmount orderNo:[Result getStringWithKey:@"orderNo"] notifyURL:[Result getStringWithKey:@"notifyUrl"] prepayId:[Result getStringWithKey:@"prepayId"]];
                }
            }else{
                [Tools showHUD:Message];
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

- (void)back{
    [UIAlertView showAlertViewWithTitle:nil message:@"订单还没有支付,确认返回吗?" cancelButtonTitle:@"确定" otherButtonTitles:@[@"继续支付"] onDismiss:^(NSInteger buttonIndex) {
    } onCancel:^{
        self.pickupcode = nil;
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - 支付回调
#pragma mark - 通知回调
- (void)ssPaySuccess:(NSNotification *)notify {
    //NSLog(@"%@",notify);
    [self showPaySuccessAlertWithCode:self.pickupcode];
}


#pragma mark - 支付成功弹出
- (void)showPaySuccessAlertWithCode:(NSString *)code{
    if (nil == code) {
        return;
    }
    CustomIOSAlertView * _alertView = [[CustomIOSAlertView alloc] init];
    [_alertView setContainerView:[self createShouHuoMaAlertWithMa:code]];
    [_alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"确定", @"我的订单", nil]];
    __block SSpayViewController * blockSelf = self;
    [_alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
        if (1 == buttonIndex) {// 我的订单
            AppDelegate * appdel = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UINavigationController * navc = (UINavigationController*)appdel.window.rootViewController;
            SSMyOrdersVC * umvc = [[SSMyOrdersVC alloc] initWithNibName:@"SSMyOrdersVC" bundle:nil];
            umvc.toSSMyOrderStatusUngrab = YES;
            NSMutableArray * navArray = [[NSMutableArray alloc] initWithCapacity:0];
            [navArray addObject:[navc.viewControllers firstObject]];
            [navArray addObject:umvc];
            [navc setViewControllers:navArray animated:YES];
        }else{
            [blockSelf.navigationController popViewControllerAnimated:YES];
        }
        [alertView close];
    }];
    [_alertView setUseMotionEffects:true];
    [_alertView show];
}


- (UIView *)createShouHuoMaAlertWithMa:(NSString *)code{
    // 40
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 240)];
    demoView.userInteractionEnabled = YES;
    UIImageView * gouImg = [[UIImageView alloc] initWithFrame:CGRectMake(290/2-15, 10, 30, 30)];
    gouImg.image = [UIImage imageNamed:@"ss_detail_completed"];
    [demoView addSubview:gouImg];
    
    UILabel * quhuoFix = [[UILabel alloc] initWithFrame:CGRectMake(10, 45, 290-20, 25)];
    quhuoFix.text = @"支付成功";
    quhuoFix.textAlignment = NSTextAlignmentCenter;
    quhuoFix.textColor = DeepGrey;
    quhuoFix.font = [UIFont systemFontOfSize:BigFontSize];
    [demoView addSubview:quhuoFix];
    
    UILabel * grayWarning = [[UILabel alloc] initWithFrame:CGRectMake(0, 75, 60, 25)];
    grayWarning.text = @"取货码:";
    grayWarning.textAlignment = NSTextAlignmentRight;
    grayWarning.font = [UIFont systemFontOfSize:14];
    grayWarning.textColor = DeepGrey;
    [demoView addSubview:grayWarning];
    
    UILabel * blueCode = [[UILabel alloc] initWithFrame:CGRectMake(65, 75, 150, 25)];
    blueCode.text = code;
    blueCode.font = [UIFont systemFontOfSize:14];
    blueCode.textColor = BlueColor;
    [demoView addSubview:blueCode];
    
    UILabel * grayNote = [[UILabel alloc] initWithFrame:CGRectMake(0, 105, 60, 25)];
    grayNote.text = @"提示:";
    grayNote.textAlignment = NSTextAlignmentRight;
    grayNote.font = [UIFont systemFontOfSize:14];
    grayNote.textColor = DeepGrey;
    [demoView addSubview:grayNote];
    
    UILabel * grayNote2 = [[UILabel alloc] initWithFrame:CGRectMake(65, 105, 220, 25)];
    grayNote2.text = @"进入我的订单也可以查看取货码";
    grayNote2.font = [UIFont systemFontOfSize:14];
    grayNote2.textColor = DeepGrey;
    [demoView addSubview:grayNote2];
    
    [demoView setFrame:CGRectMake(0, 0, 290, CGRectGetMaxY(grayNote.frame) + 10)];
    return demoView;
    
}

@end
