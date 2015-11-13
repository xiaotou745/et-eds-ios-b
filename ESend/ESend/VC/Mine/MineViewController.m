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

#import "EDSMyClientersVC.h"


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
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _newMessageIcon.hidden = YES;
    [self loadData];

}

- (void)loadData {
    
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
        NSLog(@"%@",result);
        _business = result;
        
//        //银行卡信息
//        NSArray *bankList = [result objectForKey:@"listBFAcount"];
//        if (bankList.count > 0) {
//            _bank = [[BankModel alloc] initWithDic:bankList[0]];
//            MineCell *mineCell = (MineCell*)[self.view viewWithTag:1001];
//            mineCell.contentLabel.text = [NSString stringWithFormat:@"%@ ****%@",_bank.openBank,[_bank.bankCardNumber substringWithRange:NSMakeRange(_bank.bankCardNumber.length - 4, 4)]];
//        }
        
        _supplierNameLabel.text = [self businessNameWithStr:[_business getStringWithKey:@"Name"]];//;
        
        double amountRemain = [[result objectForKey:@"BalancePrice"] doubleValue];
        //double amountCanGet = [[result objectForKey:@"AllowWithdrawPrice"] doubleValue];
        
        _balanceLabel.text = [NSString stringWithFormat:@"￥%.2f",amountRemain];
        //_withdrawDeposit.text = [NSString stringWithFormat:@"￥%.2f",amountCanGet];
        
        //是否有新的消息
        if ([result getIntegerWithKey:@"HasMessage"]) {
            _newMessageIcon.hidden = NO;
        } else {
            _newMessageIcon.hidden = YES;
        }
        
        //用户状态
        [UserInfo saveStatus:[result getIntegerWithKey:@"Status"]];
        if ([UserInfo getStatus] != UserStatusComplete) {
            _userStatusBtn.hidden = NO;
            _businessFixNote.hidden = YES;
            [_supplierNameLabel changeFrameWidth:MainWidth - 30 - 110];
            
            [_userStatusBtn setTitle:[UserInfo getStatusStr] forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangeToReviewNotification object:nil];
        } else {
            _userStatusBtn.hidden = YES;
            _businessFixNote.hidden = NO;
            [_supplierNameLabel changeFrameWidth:MainWidth - 30 - 20];
        }
        
        [UserInfo setIsOneKeyPubOrder:@([_business getIntegerWithKey:@"OneKeyPubOrder"])];

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

- (NSString *)businessNameWithStr:(NSString *)str{
    NSString * result = nil;
    if (str.length > 10) {
        result = [NSString stringWithFormat:@"%@...",[str substringToIndex:10]];
    }else{
        result = str;
    }
    return result;
}

- (void)bulidView {
    
    // 导航条
    self.titleLabel.text = @"商家中心";
    
    [self.rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    
    
    // topView
    _topView = [[UIView alloc] initWithFrame:CGRectMake(10, 15 + 64, MainWidth - 20, 100)];
    _topView.backgroundColor = [UIColor whiteColor];
    _topView.layer.cornerRadius = 5;
    [self.view addSubview:_topView];
    
    // 店铺名称
    _supplierNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainWidth - 30 - 110, 25)];
    _supplierNameLabel.text = [self businessNameWithStr:[UserInfo getBussinessName]];//
    _supplierNameLabel.textColor = DeepGrey;
    _supplierNameLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [_topView addSubview:_supplierNameLabel];
    
    UITapGestureRecognizer *tapUserInfo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
    _supplierNameLabel.userInteractionEnabled = YES;
    [_supplierNameLabel addGestureRecognizer:tapUserInfo];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth - 20 - 40, 10, 40, 50)];
    rightImageView.contentMode = UIViewContentModeCenter;
    rightImageView.image = [UIImage imageNamed:@"right_indicate"];
    rightImageView.userInteractionEnabled = YES;
    [_topView addSubview:rightImageView];
    
    UITapGestureRecognizer *tapName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
    [rightImageView addGestureRecognizer:tapName];
    
    // msg
    _businessFixNote = [[UILabel alloc] init];
    _businessFixNote.frame = CGRectMake(MainWidth - 90 - 60, 25/2 + 10, 90, 25);
    _businessFixNote.text = BusinessInfoMsg;
    _businessFixNote.textAlignment = NSTextAlignmentRight;
    _businessFixNote.textColor = LightGrey;
    _businessFixNote.font = [UIFont systemFontOfSize:NormalFontSize];
    _businessFixNote.backgroundColor = [UIColor clearColor];
    _businessFixNote.hidden = NO;
    [_topView addSubview:_businessFixNote];
    
    ///
    _userStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _userStatusBtn.enabled = NO;
    _userStatusBtn.frame = CGRectMake(MainWidth - 110 - 20, 25/2 + 10, 70, 25);
    [_userStatusBtn setBackgroundSmallImageNor:@"blue_border_btn_nor" smallImagePre:@"blue_border_btn_nor" smallImageDis:nil];
    [_userStatusBtn setTitleColor:BlueColor forState:UIControlStateNormal];
    [_userStatusBtn setTitle:@"审核中" forState:UIControlStateNormal];
    _userStatusBtn.hidden = YES;
    _userStatusBtn.titleLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    [_userStatusBtn addTarget:self action:@selector(showUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_userStatusBtn];
    
    // 手机号
    _supplierPhoneLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_supplierNameLabel.frame) + 5, MainWidth - 30 - 110, 25)];
    _supplierPhoneLbl.text = [UserInfo getbussinessPhone];
    _supplierPhoneLbl.textColor = DeepGrey;
    _supplierPhoneLbl.font = [UIFont systemFontOfSize:NormalFontSize];
    [_topView addSubview:_supplierPhoneLbl];
    
    
    UIView *line = [Tools createLine];
    line.frame = CGRectMake(10, CGRectGetMaxY(_supplierPhoneLbl.frame) + 10, MainWidth - 20 - 20, 0.5);
    [_topView addSubview:line];
    
    /// 余额数值
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame), MainWidth/2 - 20, 30)];
    _balanceLabel.text = @"";
    _balanceLabel.textAlignment = NSTextAlignmentCenter;
    _balanceLabel.textColor = DeepGrey;
    _balanceLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [_topView addSubview:_balanceLabel];
    
    // 余额fix
    _withdrawDeposit = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_balanceLabel.frame), MainWidth/2 - 20, 30)];
    _withdrawDeposit.text = @"余额";
    _withdrawDeposit.textAlignment = NSTextAlignmentCenter;
    _withdrawDeposit.textColor = LightGrey;
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
//    [recharge setTitle:@"充值" forState:UIControlStateNormal];
//    [recharge setImage:[UIImage imageNamed:@"recharge"] forState:UIControlStateNormal];
//    [recharge setImage:[UIImage imageNamed:@"recharge"] forState:UIControlStateHighlighted];
//    [recharge setTitleColor:BlueColor forState:UIControlStateNormal];
//    recharge.titleEdgeInsets = UIEdgeInsetsMake(20, 0, 0, 0);
//    recharge.imageEdgeInsets = UIEdgeInsetsMake(0, FRAME_WIDTH(_topView)/2 - 13, 26, FRAME_WIDTH(_topView)/2 - 13);
    [recharge addTarget:self action:@selector(clickRecharge) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:recharge];
    
    
    ///
    [_topView changeFrameHeight:CGRectGetMaxY(line1.frame)];
    
    _newMessageIcon = [[UIView alloc] initWithFrame:CGRectMake(130, 35/2, 10, 10)];
    _newMessageIcon.backgroundColor = RedDefault;
    _newMessageIcon.layer.cornerRadius = 5;
    _newMessageIcon.hidden = YES;
    
    
    NSArray *titles = @[@"账单",@"订单统计",@"我的骑士",@"消息中心",@"商家须知"];
    NSArray *icons = @[@"detail",@"order_detail",@"my_clienters",@"message_icon",@"business_note"];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *contectStr = @"";
        
        MineCell *view = [[MineCell alloc] initWithTitle:titles[i] imageName:icons[i] content:contectStr];
        
        view.frame = CGRectMake(10, CGRectGetMaxY(_topView.frame) + 20 + i*45 + ((i>=3)?20:0) + ((i==4)?20:0), MainWidth - 20, 45);
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
    
    if (tap.view.tag == 1003) { // 消息中心
        MessagesViewController *vc = [[MessagesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (tap.view.tag == 1002) { // 我的骑士
        EDSMyClientersVC * vc = [[EDSMyClientersVC alloc] initWithNibName:NSStringFromClass([EDSMyClientersVC class]) bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (tap.view.tag == 1001) { // 订单统计
        if ([UserInfo getStatus] != UserStatusComplete) {
            [Tools showHUD:@"您尚未审核通过"];
            return;
        }
        EDSOrderStatisticsVC *vc = [[EDSOrderStatisticsVC alloc] initWithNibName:@"EDSOrderStatisticsVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (tap.view.tag == 1000) { // 账单统计
        // v1.2.1之前的订单统计
//        ExpensesViewController *vc = [[ExpensesViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
        
        // v1.2.1的订单统计
        EDSBillStatisticsVC * vc = [[EDSBillStatisticsVC alloc] initWithNibName:@"EDSBillStatisticsVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        return;
        
    }
    
    if (tap.view.tag == 1004) { // 商家须知
        //NSLog(@"1003");
        // http://m.edaisong.com/htmls/rule.html
        EDSBusinessShouldKnow * bskVC = [[EDSBusinessShouldKnow alloc] initWithNibName:@"EDSBusinessShouldKnow" bundle:nil];
        [self.navigationController pushViewController:bskVC animated:YES];
    }
}

- (void)clickMore {
    MoreViewController *moreVC = [[MoreViewController alloc] init];
    [self.navigationController pushViewController:moreVC animated:YES];
}

- (void)clickRecharge {
    
//    if ([UserInfo getStatus] != UserStatusComplete) {
//        
//        [Tools showHUD:@"暂时无法进行该操作！"];
//        
//        return;
//    }
    
    EDSFullfillMoneyVC *vc = [[EDSFullfillMoneyVC alloc] init];
    vc.balancePrice = [[_business objectForKey:@"BalancePrice"] doubleValue];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)clickWithdraw {
    
    if ([UserInfo getStatus] != UserStatusComplete) {
        
        [Tools showHUD:@"暂时无法进行该操作！"];
        
        return;
    }
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4006380177"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    return;
    
//    WithdrewViewController *withdrewVC = [[WithdrewViewController alloc] init];
//    withdrewVC.bank = _bank;
//    withdrewVC.allowWithdrawPrice = [_business getFloatWithKey:@"AllowWithdrawPrice"];
//    [self.navigationController pushViewController:withdrewVC animated:YES];
}

- (void)showUserInfo {
    PrefectInfoViewController *vc = [[PrefectInfoViewController alloc] init];
    vc.bussiness = _business;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
