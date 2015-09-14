//
//  MineViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/8.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MineViewController.h"
#import "MoreViewController.h"
#import "PayViewController.h"
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
#import "OrderStatisticsViewController.h"

typedef NS_ENUM(NSInteger, BottomType) {
    BottomTypeDetail = 1000,    //收支明细
    BottomTypeAccount,          //提款账户
    BottomTypeOrderetail        //订单统计
};

@interface MineViewController ()
{
    UIView *_topView;
    
    UILabel *_supplierNameLabel;
    UILabel *_balanceLabel;
    UILabel *_withdrawDeposit;
    
    NSDictionary *_business;
    BankModel *_bank;
    
    UIView *_newMessageIcon;
    UIButton *_userStatusBtn;
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
    
    NSString * jsonString2 = [requestData JSONString];
    
    NSString * aesString = [Security AesEncrypt:jsonString2];
    
    NSDictionary * requestData2 = @{
                                    @"data":aesString,
                                    @"Version":[Tools getApplicationVersion],
                                    };
    
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [FHQNetWorkingAPI getSupplierInfo:requestData2 successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        _business = result;
        
        //银行卡信息
        NSArray *bankList = [result objectForKey:@"listBFAcount"];
        if (bankList.count > 0) {
            _bank = [[BankModel alloc] initWithDic:bankList[0]];
            MineCell *mineCell = (MineCell*)[self.view viewWithTag:1001];
            mineCell.contentLabel.text = [NSString stringWithFormat:@"%@ ****%@",_bank.openBank,[_bank.bankCardNumber substringWithRange:NSMakeRange(_bank.bankCardNumber.length - 4, 4)]];
        }
        
        _supplierNameLabel.text = [_business getStringWithKey:@"Name"];
        
        _balanceLabel.text = [NSString stringWithFormat:@"余   额 ￥%.2f",[result getFloatWithKey:@"BalancePrice"]];
        _withdrawDeposit.text = [NSString stringWithFormat:@"可提现 ￥%.2f",[result getFloatWithKey:@"AllowWithdrawPrice"]];
        
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
            
            [_supplierNameLabel changeFrameWidth:MainWidth - 30 - 110];
            
            [_userStatusBtn setTitle:[UserInfo getStatusStr] forState:UIControlStateNormal];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangeToReviewNotification object:nil];
        } else {
            _userStatusBtn.hidden = YES;
            [_supplierNameLabel changeFrameWidth:MainWidth - 30 - 20];
        }
        
        [UserInfo setIsOneKeyPubOrder:@([_business getIntegerWithKey:@"OneKeyPubOrder"])];

        //商户名称
        [UserInfo saveBussinessName:[_business getStringWithKey:@"Name"]];
        
        [UserInfo saveDistribSubsidy:[_business getFloatWithKey:@"DistribSubsidy"]];
        
        [Tools hiddenProgress:HUD];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];
    
}

- (void)bulidView {
    
    self.titleLabel.text = @"商家中心";
    
    [self.rightBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickMore) forControlEvents:UIControlEventTouchUpInside];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(10, 15 + 64, MainWidth - 20, 100)];
    _topView.backgroundColor = [UIColor whiteColor];
    _topView.layer.cornerRadius = 5;
    [self.view addSubview:_topView];
    
    _supplierNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, MainWidth - 30 - 110, 50)];
    _supplierNameLabel.text = [UserInfo getBussinessName];
    _supplierNameLabel.textColor = DeepGrey;
    _supplierNameLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [_topView addSubview:_supplierNameLabel];
    
    UITapGestureRecognizer *tapUserInfo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
    _supplierNameLabel.userInteractionEnabled = YES;
    [_supplierNameLabel addGestureRecognizer:tapUserInfo];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth - 20 - 40, 0, 40, 50)];
    rightImageView.contentMode = UIViewContentModeCenter;
    rightImageView.image = [UIImage imageNamed:@"right_indicate"];
    rightImageView.userInteractionEnabled = YES;
    [_topView addSubview:rightImageView];
    
    UITapGestureRecognizer *tapName = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showUserInfo)];
    [rightImageView addGestureRecognizer:tapName];
    
    _userStatusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _userStatusBtn.enabled = NO;
    _userStatusBtn.frame = CGRectMake(MainWidth - 110 - 20, 25/2, 70, 25);
    [_userStatusBtn setBackgroundSmallImageNor:@"blue_border_btn_nor" smallImagePre:@"blue_border_btn_nor" smallImageDis:nil];
    [_userStatusBtn setTitleColor:BlueColor forState:UIControlStateNormal];
    [_userStatusBtn setTitle:@"审核中" forState:UIControlStateNormal];
    _userStatusBtn.hidden = YES;
    _userStatusBtn.titleLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    [_userStatusBtn addTarget:self action:@selector(showUserInfo) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_userStatusBtn];
    
    UIView *line = [Tools createLine];
    line.frame = CGRectMake(10, CGRectGetMaxY(_supplierNameLabel.frame), MainWidth - 20 - 20, 0.5);
    [_topView addSubview:line];
    
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame), MainWidth - 40, 40)];
    _balanceLabel.text = @"余 额  ￥0.00";
    _balanceLabel.textColor = DeepGrey;
    _balanceLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [_topView addSubview:_balanceLabel];
    
    _withdrawDeposit = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_balanceLabel.frame), MainWidth - 40, 40)];
    _withdrawDeposit.text = @"可提现 ￥0.00";
    _withdrawDeposit.textColor = DeepGrey;
    _withdrawDeposit.font = [UIFont systemFontOfSize:BigFontSize];
    [_topView addSubview:_withdrawDeposit];
    
    UIView *line1 = [Tools createLine];
    line1.frame = CGRectMake(10, CGRectGetMaxY(_withdrawDeposit.frame), MainWidth - 40, 0.5);
    [_topView addSubview:line1];
    
    UIButton *recharge = [UIButton buttonWithType:UIButtonTypeCustom];
    recharge.frame  = CGRectMake(FRAME_WIDTH(_topView)/2, CGRectGetMaxY(line1.frame), FRAME_WIDTH(_topView)/2, 50);
    [recharge setTitle:@"充值" forState:UIControlStateNormal];
    [recharge setImage:[UIImage imageNamed:@"recharge"] forState:UIControlStateNormal];
    [recharge setImage:[UIImage imageNamed:@"recharge"] forState:UIControlStateHighlighted];
    [recharge setTitleColor:BlueColor forState:UIControlStateNormal];
    recharge.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
    recharge.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
    [recharge addTarget:self action:@selector(clickRecharge) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:recharge];
    
//    UIView *vline = [[UIView alloc] initWithFrame:CGRectMake(FRAME_WIDTH(_topView)/2, CGRectGetMaxY(line1.frame), 0.5, 50)];
//    vline.backgroundColor = line1.backgroundColor;
//    [_topView addSubview:vline];
//    
//    UIButton *withdrew = [UIButton buttonWithType:UIButtonTypeCustom];
//    withdrew.frame  = CGRectMake(0, CGRectGetMaxY(line1.frame), FRAME_WIDTH(_topView)/2, 50);
//    [withdrew setTitle:@"电话提现" forState:UIControlStateNormal];
//    [withdrew setImage:[UIImage imageNamed:@"withdeposit"] forState:UIControlStateNormal];
//    [withdrew setImage:[UIImage imageNamed:@"withdeposit"] forState:UIControlStateHighlighted];
//    [withdrew setTitleColor:BlueColor forState:UIControlStateNormal];
//    withdrew.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
//    withdrew.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 10);
//    [withdrew addTarget:self action:@selector(clickWithdraw) forControlEvents:UIControlEventTouchUpInside];
//    [_topView addSubview:withdrew];
    
    [_topView changeFrameHeight:CGRectGetMaxY(recharge.frame)];
    
    _newMessageIcon = [[UIView alloc] initWithFrame:CGRectMake(130, 35/2, 10, 10)];
    _newMessageIcon.backgroundColor = RedDefault;
    _newMessageIcon.layer.cornerRadius = 5;
    _newMessageIcon.hidden = YES;
    
    
    NSArray *titles = @[@"收支明细", @"提款账户", @"订单统计", @"消息中心"];
    NSArray *icons = @[@"detail", @"account", @"order_detail", @"message_icon"];
    
    for (NSInteger i = 0; i < titles.count; i++) {
        NSString *contectStr = @"";
        
        MineCell *view = [[MineCell alloc] initWithTitle:titles[i] imageName:icons[i] content:contectStr];
        
        view.frame = CGRectMake(10, CGRectGetMaxY(_topView.frame) + 20 + i*45, MainWidth - 20, 45);
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
    

    
    if (tap.view.tag == 1002) {
        OrderStatisticsViewController *vc = [[OrderStatisticsViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (tap.view.tag == 1000) {
        ExpensesViewController *vc = [[ExpensesViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if ([UserInfo getStatus] != UserStatusComplete) {
        
        [Tools showHUD:@"暂时无法进行该操作！"];
        
        return;
    }
    
    if (tap.view.tag == 1001) {
        BankViewController *vc = [[BankViewController alloc] init];
        vc.bank = _bank;
        [self.navigationController pushViewController:vc animated:YES];
        return;
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
    vc.balancePrice = [_business getFloatWithKey:@"BalancePrice"];
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
