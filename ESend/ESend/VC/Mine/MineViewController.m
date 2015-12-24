//
//  MineViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/8.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MineViewController.h"
#import "MoreViewController.h"
#import "EDSFullfillMoneyVC.h"
#import "BankViewController.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"
#import "BankModel.h"
#import "MessagesViewController.h"
#import "MineCell.h"
#import "WithdrewViewController.h"
#import "ExpensesViewController.h"
#import "PrefectInfoViewController.h"
#import "EDSOrderStatisticsVC.h"

#import "EDSBusinessShouldKnow.h"
#import "EDSBillStatisticsVC.h"


#define BusinessInfoMsg @"商铺信息管理"

typedef NS_ENUM(NSInteger, BottomType) {
    BottomTypeDetail = 1000,    //收支明细
    BottomTypeAccount,          //提款账户
    BottomTypeOrderetail        //订单统计
};

@interface MineViewController ()
{
    UIView *_topView;
    
    UILabel *_supplierNameLabel;        // 名称
    UILabel *_supplierPhoneLbl;         // 手机号
    UILabel *_balanceLabel;
    UILabel *_withdrawDeposit;
    
    NSDictionary *_business;
    BankModel *_bank;
    
    UIView *_newMessageIcon;
    UIButton *_userStatusBtn;
    UILabel * _businessFixNote;
}

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configMineUIViews];
}

//- (void)viewWillAppear:(BOOL)animated {
//    [super viewWillAppear:animated];
//    _newMessageIcon.hidden = YES;
//    [self loadData];
//
//}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _newMessageIcon.hidden = YES;
    [self reqloadData];
}

- (void)reqloadData {
    
    NSDictionary *requestData = @{@"BussinessId" : [UserInfo getUserId],
                                  @"version" : @"1.0"};
    
    NSString * jsonString2 = [Security JsonStringWithDictionary:requestData];
    
    NSString * aesString = [Security AesEncrypt:jsonString2];
    
    NSDictionary * requestData2 = @{
                                    @"data":aesString,
                                    @"Version":[Tools getApplicationVersion],
                                    };
    
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [FHQNetWorkingAPI getSupplierInfo:requestData2 successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"返回结果 %@",result);
        _business = (NSDictionary *)result;

        _supplierNameLabel.text = [_business getStringWithKey:@"PhoneNo"];
        double amountRemain = [result getDoubleWithKey:@"BalancePrice"];
        _balanceLabel.text = [NSString stringWithFormat:@"￥%.2f",amountRemain];
        //是否有新的消息
        if ([result getIntegerWithKey:@"HasMessage"]) {
            _newMessageIcon.hidden = NO;
        } else {
            _newMessageIcon.hidden = YES;
        }
        
        //商户名称
        [UserInfo saveBussinessName:[_business getStringWithKey:@"Name"]];
        [UserInfo setbussinessPhone:[_business getStringWithKey:@"PhoneNo"]];
        
        NSLog(@"%@",[_business getStringWithKey:@"PhoneNo"]);
        _supplierPhoneLbl.text = [UserInfo getbussinessPhone];

        [UserInfo saveDistribSubsidy:[_business getFloatWithKey:@"DistribSubsidy"]];
        
        [Tools hiddenProgress:HUD];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];
    
}

- (void)configMineUIViews {
    
    // 导航条
    self.titleLabel.text = @"个人中心";
    
    [self.rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    
    
    // topView
    _topView = [[UIView alloc] initWithFrame:CGRectMake(10, 15 + 64, MainWidth - 20, 100)];
    _topView.backgroundColor = [UIColor whiteColor];
    _topView.layer.cornerRadius = 5;
    [self.view addSubview:_topView];
    
    // 账号
    UILabel * accountFix = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 40, 25)];
    accountFix.text = @"账号";
    accountFix.textColor = LightGrey;
    accountFix.font = [UIFont systemFontOfSize:BigFontSize];
    [_topView addSubview:accountFix];

    // 店铺名称
    _supplierNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 20, MainWidth - 30 - 60, 25)];
    _supplierNameLabel.text = [UserInfo getbussinessPhone];//setbussinessPhone
    _supplierNameLabel.textColor = DeepGrey;
    _supplierNameLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [_topView addSubview:_supplierNameLabel];
    
    UIView *line = [Tools createLine];
    line.frame = CGRectMake(10, CGRectGetMaxY(_supplierNameLabel.frame) + 10, MainWidth - 20 - 20, 0.5);
    [_topView addSubview:line];
    
    /// 余额数值
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame), MainWidth/2 - 20, 30)];
    _balanceLabel.text = @"";
    _balanceLabel.textAlignment = NSTextAlignmentCenter;
    _balanceLabel.textColor = RedDefault;
    _balanceLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [_topView addSubview:_balanceLabel];
    
    // 余额fix
    _withdrawDeposit = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_balanceLabel.frame), MainWidth/2 - 20, 30)];
    _withdrawDeposit.text = @"余额";
    _withdrawDeposit.textAlignment = NSTextAlignmentCenter;
    _withdrawDeposit.textColor = DeepGrey;
    _withdrawDeposit.font = [UIFont systemFontOfSize:BigFontSize];
    [_topView addSubview:_withdrawDeposit];
    
    UIView *line1 = [Tools createLine];
    line1.frame = CGRectMake(FRAME_WIDTH(_topView)/2, CGRectGetMaxY(line.frame), 0.5, 60);
    [_topView addSubview:line1];
    
    //
    UIImageView * rechargeImage = [[UIImageView alloc] initWithFrame:CGRectMake(FRAME_WIDTH(_topView)*3/4 - 13, CGRectGetMaxY(line.frame) + 5, 26, 26)];
    rechargeImage.image = [UIImage imageNamed:@"recharge"];
    [_topView addSubview:rechargeImage];
    
    //
    UILabel * rechargeLbl = [[UILabel alloc] initWithFrame:CGRectMake(FRAME_WIDTH(_topView)/2,CGRectGetMaxY(_balanceLabel.frame) +2 , FRAME_WIDTH(_topView)/2, 25)];
    rechargeLbl.text = @"充值";
    rechargeLbl.textAlignment = NSTextAlignmentCenter;
    rechargeLbl.textColor = BlueColor;
    rechargeLbl.font = [UIFont systemFontOfSize:BigFontSize];
    [_topView addSubview:rechargeLbl];
    
    UIButton *recharge = [UIButton buttonWithType:UIButtonTypeCustom];
    recharge.frame  = CGRectMake(FRAME_WIDTH(_topView)/2, CGRectGetMaxY(line.frame), FRAME_WIDTH(_topView)/2, 50);
    [recharge setBackgroundColor:[UIColor clearColor]];
    [recharge addTarget:self action:@selector(clickRecharge) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:recharge];
    
    
    ///
    [_topView changeFrameHeight:CGRectGetMaxY(line1.frame)];
    
    _newMessageIcon = [[UIView alloc] initWithFrame:CGRectMake(130, 35/2, 10, 10)];
    _newMessageIcon.backgroundColor = RedDefault;
    _newMessageIcon.layer.cornerRadius = 5;
    _newMessageIcon.hidden = YES;
    
    
    NSArray *titles = @[@"账单",  @"订单统计", @"价格表",@"消息中心"];
    NSArray *icons = @[@"detail",  @"order_detail", @"ss_user_jiagebiao",@"message_icon"];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *contectStr = @"";
        
        MineCell *view = [[MineCell alloc] initWithTitle:titles[i] imageName:icons[i] content:contectStr];
        
        view.frame = CGRectMake(10, CGRectGetMaxY(_topView.frame) + 20 + i*45 + ((i>2)?20:0), MainWidth - 20, 45);
        [self.view addSubview:view];
        view.tag = 1000+i;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [view addGestureRecognizer:tap];
        
        if (i == 3) {
            [view addSubview:_newMessageIcon];

        }
        
    }

}

- (void)tapView:(UITapGestureRecognizer*)tap {
    
    if (tap.view.tag == 1003) {
        MessagesViewController *vc = [[MessagesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    

    
    if (tap.view.tag == 1001) { // 订单统计
        EDSOrderStatisticsVC *vc = [[EDSOrderStatisticsVC alloc] initWithNibName:@"EDSOrderStatisticsVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (tap.view.tag == 1000) { // 账单统计
        // v1.2.1的订单统计
        EDSBillStatisticsVC * vc = [[EDSBillStatisticsVC alloc] initWithNibName:@"EDSBillStatisticsVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        return;
        
    }
    
    if (tap.view.tag == 1002) {
        // 价格表
        EDSBusinessShouldKnow * bskVC = [[EDSBusinessShouldKnow alloc] initWithNibName:@"EDSBusinessShouldKnow" bundle:nil];
        [self.navigationController pushViewController:bskVC animated:YES];
    }
}

- (void)clickMore {
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)clickRecharge {
    
    EDSFullfillMoneyVC *vc = [[EDSFullfillMoneyVC alloc] init];
    vc.balancePrice = [[_business objectForKey:@"BalancePrice"] doubleValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickWithdraw {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4006380177"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    return;
    
}

- (void)showUserInfo {
    PrefectInfoViewController *vc = [[PrefectInfoViewController alloc] init];
    vc.bussiness = _business;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
