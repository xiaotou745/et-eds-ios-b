//
//  PayViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/2.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "PayViewController.h"
#import "QRadioButton.h"
#import "AliPay.h"
#import "FHQNetWorkingAPI.h"

@interface PayViewController ()<UITextFieldDelegate>
{
    UIScrollView *_scrollView;
    UIView *_topView;
    UIView *_bottomView;
    
    UILabel *_balanceTitleLabel;
    UILabel *_balanceLabel;
    
    UILabel *_rechargeTitleLabel;
    UITextField *_rechargeTF;
    
    QRadioButton *_alipayBtn;
    QRadioButton *_wechatBtn;

    
}
@end

@implementation PayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paySuccess) name:AliPaySuccessNotification object:nil];
    
}


- (void)bulidView {
    
    self.titleLabel.text = @"充值";
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64, MainHeight, ScreenHeight - 64)];
    [self.view addSubview:_scrollView];
    
    _topView = [[UIView alloc] initWithFrame:CGRectMake(0, 10, MainWidth, 110)];
    _topView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_topView];
    
    _balanceTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 55)];
    _balanceTitleLabel.text = @"余     额";
    _balanceTitleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    _balanceTitleLabel.textColor = DeepGrey;
    [_topView addSubview:_balanceTitleLabel];
    
    _balanceLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_balanceTitleLabel.frame), 0, MainWidth - CGRectGetMaxX(_balanceTitleLabel.frame) - 10 , 55)];
    _balanceLabel.text = [NSString stringWithFormat:@"￥%.2f",_balancePrice];
    _balanceLabel.font = [UIFont systemFontOfSize:BigFontSize];
    _balanceLabel.textColor = RedDefault;
    [_topView addSubview:_balanceLabel];
    
    UIView *line = [Tools createLine];
    line.frame = CGRectMake(0, CGRectGetMaxY(_balanceLabel.frame), MainWidth, 0.5);
    [_topView addSubview:line];
    
    _rechargeTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame), 80, 55)];
    _rechargeTitleLabel.text = @"充值金额";
    _rechargeTitleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    _rechargeTitleLabel.textColor = DeepGrey;
    [_topView addSubview:_rechargeTitleLabel];
    
    _rechargeTF = [[UITextField alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_rechargeTitleLabel.frame), CGRectGetMaxY(line.frame), MainWidth - CGRectGetMaxX(_balanceTitleLabel.frame) - 10 , 55)];
    _rechargeTF.placeholder = @"充值金额";
    _rechargeTF.font = [UIFont systemFontOfSize:BigFontSize];
    _rechargeTF.textColor = DeepGrey;
    _rechargeTF.keyboardType = UIKeyboardTypeDecimalPad;
    _rechargeTF.returnKeyType = UIReturnKeyDone;
    _rechargeTF.delegate = self;
    [_rechargeTF becomeFirstResponder];
    [_topView addSubview:_rechargeTF];
    
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_topView.frame) + 20, MainWidth, 55)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_bottomView];
    
    UIImageView *aliPay = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 20, 55)];
    aliPay.contentMode = UIViewContentModeCenter;
    aliPay.image = [UIImage imageNamed:@"alipay_icon"];
    [_bottomView addSubview:aliPay];
    
    UILabel *aliPayLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(aliPay.frame) + 20, 0, MainWidth, 55)];
    aliPayLabel.text = @"支付宝支付";
    aliPayLabel.font = [UIFont systemFontOfSize:BigFontSize];
    aliPayLabel.textColor = DeepGrey;
    [_bottomView addSubview:aliPayLabel];
    
    UIView *line1 = [Tools createLine];
    line1.frame = CGRectMake(0, CGRectGetMaxY(aliPay.frame), MainWidth, 0.5);
    [_bottomView addSubview:line1];
    
    UIImageView *wecharIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(aliPay.frame), 20, 55)];
    wecharIcon.contentMode = UIViewContentModeCenter;
    wecharIcon.image = [UIImage imageNamed:@"wechar_icon"];
    [_bottomView addSubview:wecharIcon];
    
    UILabel *wecharLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(wecharIcon.frame) + 20, CGRectGetMaxY(line1.frame), MainWidth, 55)];
    wecharLabel.text = @"微信支付";
    wecharLabel.font = [UIFont systemFontOfSize:BigFontSize];
    wecharLabel.textColor = DeepGrey;
    [_bottomView addSubview:wecharLabel];
    
    _alipayBtn = [[QRadioButton alloc] initWithDelegate:self groupId:@"payment"];
    _alipayBtn.frame = CGRectMake(MainWidth - 45, 0, 45, 55);
    _alipayBtn.checked = YES;
    [_bottomView addSubview:_alipayBtn];
    
    _wechatBtn = [[QRadioButton alloc] initWithDelegate:self groupId:@"payment"];
    _wechatBtn.frame = CGRectMake(MainWidth - 45, CGRectGetMaxY(aliPayLabel.frame), 45, 55);
    [_bottomView addSubview:_wechatBtn];
    
    UIView *alipayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 55)];
    alipayView.userInteractionEnabled = YES;
    alipayView.tag = 1000;
    [_bottomView addSubview:alipayView];
    UITapGestureRecognizer *tapAlipay = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPay:)];
    [alipayView addGestureRecognizer:tapAlipay];
    
    UIView *wechatView = [[UIView alloc] initWithFrame:CGRectMake(0, 55, MainWidth, 55)];
    wechatView.userInteractionEnabled = YES;
    [_bottomView addSubview:wechatView];
    UITapGestureRecognizer *tapWechat = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickPay:)];
    [wechatView addGestureRecognizer:tapWechat];
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [submitBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:@""];
    [submitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.frame = CGRectMake(10, CGRectGetMaxY(_bottomView.frame) + 30 + 55, MainWidth - 20, 50);
    [submitBtn setTitle:@"确    定" forState:UIControlStateNormal];
    [_scrollView addSubview:submitBtn];
}

- (void)clickPay:(UITapGestureRecognizer*)tap {
    if (tap.view.tag == 1000) {
        _alipayBtn.checked = YES;
    } else {
        _wechatBtn.checked = YES;
    }
}

- (void)submit {
    
    NSString * asb = _rechargeTF.text;
    float asbF = [asb floatValue];
    //NSLog(@"%@,%f",asb,asbF);
    
    if (asbF < 0.01f) {
        [Tools showHUD:@"充值金额不能少于0.01元"];
        return;
    }
    
    CGFloat price = [_rechargeTF.text floatValue] * 100;
    NSLog(@"%f",price);
    price = ceilf(price)/100.f;
    NSLog(@"%f",price);
    if (price < 0.01f) {
        [Tools showHUD:@"充值金额不能少于0.01元"];
        return;
    }
    
    if (price > 100000) {
        [Tools showHUD:@"充值金额不能大于100000元"];
        return;
    }
    
    [Tools hiddenKeyboard];
    
    NSDictionary *requsetData = @{@"version"    : APIVersion,
                                  @"PayType"    : @(1),
                                  @"payAmount"  : [NSNumber numberWithFloat:price]
                                  };
    [FHQNetWorkingAPI getPayInfo:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        [AliPay payWithPrice:price orderNumber:[result getStringWithKey:@"orderNo"] notifyURL:[result getStringWithKey:@"notifyUrl"] productName:@"充值"];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
    
    
}

- (void)paySuccess {
    [Tools showHUD:@"充值成功"];
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

@end
