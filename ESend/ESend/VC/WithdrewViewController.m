//
//  WithdrewViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/26.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "WithdrewViewController.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"

@interface WithdrewViewController ()<UIScrollViewDelegate,UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    UIView *_topView;
    UIView *_bottomView;
    
    UILabel *_balanceTitleLabel;
    UILabel *_balanceLabel;
    
    UILabel *_rechargeTitleLabel;
    UITextField *_rechargeTF;
}

@end

@implementation WithdrewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)bulidView {
    self.titleLabel.text = @"提现";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainHeight, ScreenHeight - 64)];
    [self.view addSubview:_scrollView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainWidth, 110)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_topView];
    
    _balanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 90, 55)];
    _balanceTitleLabel.text = @"可提现余额";
    _balanceTitleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    _balanceTitleLabel.textColor = DeepGrey;
    [_topView addSubview:_balanceTitleLabel];
    
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_balanceTitleLabel.frame), 0, MainWidth - CGRectGetMaxX(_balanceTitleLabel.frame) - 10 , 55)];
    _balanceLabel.text = [NSString stringWithFormat:@"￥%.2f",_allowWithdrawPrice];
    _balanceLabel.font = [UIFont systemFontOfSize:BigFontSize];
    _balanceLabel.textColor = RedDefault;
    [_topView addSubview:_balanceLabel];
    
    UIView *line = [Tools createLine];
    line.frame = CGRectMake(0, CGRectGetMaxY(_balanceLabel.frame), MainWidth, 0.5);
    [_topView addSubview:line];
    
    _rechargeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame), 90, 55)];
    _rechargeTitleLabel.text = @"提现金额";
    _rechargeTitleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    _rechargeTitleLabel.textColor = DeepGrey;
    [_topView addSubview:_rechargeTitleLabel];
    
    _rechargeTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rechargeTitleLabel.frame), CGRectGetMaxY(line.frame), MainWidth - CGRectGetMaxX(_balanceTitleLabel.frame) - 10 , 55)];
    _rechargeTF.placeholder = @"输入金额";
    _rechargeTF.font = [UIFont systemFontOfSize:BigFontSize];
    _rechargeTF.textColor = DeepGrey;
    _rechargeTF.keyboardType = UIKeyboardTypeDecimalPad;
    _rechargeTF.returnKeyType = UIReturnKeyDone;
    _rechargeTF.delegate = self;
    [_topView addSubview:_rechargeTF];
    
    UILabel *alertLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame), MainWidth, 45)];
    alertLabel.text = @"提款少于500元需要支付2的元手续费";
    alertLabel.textColor = RedDefault;
    alertLabel.textAlignment = NSTextAlignmentCenter;
    alertLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    [_scrollView addSubview:alertLabel];
    
    
    UIView *bankView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(alertLabel.frame), MainWidth, 55)];
    bankView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:bankView];
    
    UIImageView *bankIconIV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 26, 55)];
    bankIconIV.contentMode = UIViewContentModeScaleAspectFit;
    bankIconIV.image = [UIImage imageNamed:@"account"];
    [bankView addSubview:bankIconIV];
    
    UILabel *bankTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(bankIconIV.frame) + 10, 0, 100, 55)];
    bankTitleLabel.text = @"收款账户";
    bankTitleLabel.textColor = DeepGrey;
    bankTitleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [bankView addSubview:bankTitleLabel];
    
    UILabel *bankLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, MainWidth - 10, 55)];
    bankLabel.text = [NSString stringWithFormat:@"%@ ****%@",_bank.openBank,[_bank.bankCardNumber substringWithRange:NSMakeRange(_bank.bankCardNumber.length - 4, 4)]];
    bankLabel.textColor = MiddleGrey;
    bankLabel.textAlignment = NSTextAlignmentRight;
    bankLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [bankView addSubview:bankLabel];
    
    
    UILabel *actionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(bankView.frame), MainWidth, 45)];
    actionLabel.text = @"申请提现后，在该笔提现到账前不可进行申请";
    actionLabel.textColor = MiddleGrey;
    actionLabel.textAlignment = NSTextAlignmentCenter;
    actionLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    [_scrollView addSubview:actionLabel];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:@""];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.frame = CGRectMake(10, CGRectGetMaxY(actionLabel.frame) + 30, MainWidth - 20, 50);
    [submitBtn setTitle:@"确    定" forState:UIControlStateNormal];
    [_scrollView addSubview:submitBtn];
}

- (void)submit {
    
    if ([_rechargeTF.text floatValue] == 0) {
        [Tools showHUD:@"提现金额不能为0元"];
        return;
    }
    
    NSDictionary *requestData = @{@"version"            : APIVersion,
                                  @"BusinessId"         : [UserInfo getUserId],
                                  @"WithdrawPrice"      : @([_rechargeTF.text floatValue]),
                                  @"FinanceAccountId"   : _bank.binkId};
    
    [FHQNetWorkingAPI withdrew:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
    
}

@end
