//
//  EDSFullfillMoneyVC.m
//  ESend
//
//  Created by 台源洪 on 15/9/11.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "EDSFullfillMoneyVC.h"
#import "EDSFullfillOptionCell.h"
#import "FHQNetWorkingAPI.h"
#import "AliPay.h"
#import "WechatPay.h"

#define FFM_CellHeight 55.0f

@interface EDSFullfillMoneyVC ()<UITableViewDataSource,UITableViewDelegate>
{
    EDSPaymentType _PayType;
}
@property (strong, nonatomic) IBOutlet UIScrollView *FFM_Scroller;
@property (strong, nonatomic) IBOutlet UIView *FFM_ScrollerContent;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *FFM_ScrollerContentHeight;

@property (strong, nonatomic) IBOutlet UIView *FFM_TitleBlock;
@property (strong, nonatomic) IBOutlet UIImageView *FFM_SeparatorLine;
@property (strong, nonatomic) IBOutlet UILabel *FFM_AmoutRemainFix;
@property (strong, nonatomic) IBOutlet UILabel *FFM_AmoutRemain;
@property (strong, nonatomic) IBOutlet UILabel *FFM_AmoutToRechargeFix;
@property (strong, nonatomic) IBOutlet UITextField *FFM_AmoutToRecharge;

@property (strong, nonatomic) IBOutlet UITableView *FFM_PaymentOptionTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *FFM_PaymentOptionTableHeight;

@property (strong, nonatomic) IBOutlet UIButton *FFM_PaymentSubmitBtn;


// datasource
@property (strong, nonatomic) NSMutableArray * FFM_Payments;


@end

@implementation EDSFullfillMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"充值";
    
    //接口中： 支付宝-paytype-1；微信支付-paytype-2;
    _FFM_Payments = [[NSMutableArray alloc] initWithCapacity:0];
    EDSPaymentTypeModel * aliPay = [[EDSPaymentTypeModel alloc] init];
    aliPay.paymentType = EDSPaymentTypeAlipay;
    aliPay.paymentName = @"支付宝支付";
    aliPay.selected = YES;
    [_FFM_Payments addObject:aliPay];
    
    EDSPaymentTypeModel * wechatPay = [[EDSPaymentTypeModel alloc] init];
    wechatPay.paymentType = EDSPaymentTypeWechatPay;
    wechatPay.paymentName = @"微信支付";
    wechatPay.selected = NO;
    [_FFM_Payments addObject:wechatPay];

    // ui
    self.FFM_AmoutToRechargeFix.font =
    self.FFM_AmoutRemainFix.font =
    self.FFM_AmoutToRecharge.font = [UIFont systemFontOfSize:BigFontSize];
    
    self.FFM_AmoutToRechargeFix.textColor =
    self.FFM_AmoutRemainFix.textColor =
    self.FFM_AmoutToRecharge.textColor = DeepGrey;
    
    self.FFM_AmoutToRecharge.keyboardType = UIKeyboardTypeDecimalPad;
    self.FFM_AmoutToRecharge.returnKeyType = UIReturnKeyDone;
    
    self.FFM_AmoutRemain.text = [NSString stringWithFormat:@"￥%.2f",_balancePrice];
    self.FFM_AmoutRemain.font = [UIFont systemFontOfSize:BigFontSize];
    self.FFM_AmoutRemain.textColor = RedDefault;
    
    self.FFM_SeparatorLine.backgroundColor = SeparatorLineColor;
    self.FFM_PaymentOptionTable.scrollEnabled = NO;
    
    self.FFM_PaymentOptionTableHeight.constant = FFM_CellHeight * self.FFM_Payments.count;
    
    [self.FFM_PaymentSubmitBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:@""];
    [self.FFM_PaymentSubmitBtn addTarget:self action:@selector(submit) forControlEvents:UIControlEventTouchUpInside];
    [self.FFM_PaymentSubmitBtn setTitle:@"确    定" forState:UIControlStateNormal];
}

- (void)submit{
    
    NSString * asb = _FFM_AmoutToRecharge.text;
    float asbF = [asb floatValue];
    //NSLog(@"%@,%f",asb,asbF);
    
    if (asbF < 0.01f) {
        [Tools showHUD:@"充值金额不能少于0.01元"];
        return;
    }
    
    CGFloat price = [_FFM_AmoutToRecharge.text floatValue] * 100;
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
    
    //
    _PayType = [self _selectedPaymentType];
    
    NSDictionary *requsetData = @{@"version"    : APIVersion,
                                  @"PayType"    : @(_PayType),
                                  @"payAmount"  : [NSNumber numberWithFloat:price]
                                  };
    
    [FHQNetWorkingAPI getPayInfo:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        // NSLog(@"%@",result);
        if (EDSPaymentTypeAlipay == _PayType) {
            [AliPay payWithPrice:price orderNumber:[result getStringWithKey:@"orderNo"] notifyURL:[result getStringWithKey:@"notifyUrl"]];
        }else if (EDSPaymentTypeWechatPay == _PayType) {
            [WechatPay wechatPayWithPrice:price orderNo:[result getStringWithKey:@"orderNo"] notifyURL:[result getStringWithKey:@"notifyUrl"] prepayId:[result getStringWithKey:@"prepayId"]];
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.FFM_ScrollerContentHeight.constant = ScreenHeight - 64 + 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.FFM_Payments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * FFM_PaymentCellIdentify = @"FFM_PaymentCellIdentify";
    EDSFullfillOptionCell * cell = [tableView dequeueReusableCellWithIdentifier:FFM_PaymentCellIdentify];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EDSFullfillOptionCell" owner:self options:nil] firstObject];
    }
    cell.paymentModel = [_FFM_Payments objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.FFM_AmoutToRecharge resignFirstResponder];
    [self _selectPaymentWithIdx:indexPath.row];
    [self.FFM_PaymentOptionTable reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return FFM_CellHeight;
}

/// table data source all deselected
- (void)_selectPaymentWithIdx:(NSInteger)idx{

    for (int i= 0 ; i < _FFM_Payments.count; i++) {
        EDSPaymentTypeModel * aPayment = [_FFM_Payments objectAtIndex:i];
        if (i == idx) {
            aPayment.selected = YES;
        }else{
            aPayment.selected = NO;
        }
    }
    
}

- (EDSPaymentType)_selectedPaymentType{
    EDSPaymentType selectedType;
    for (int i = 0; i < _FFM_Payments.count; i++) {
        EDSPaymentTypeModel * aPayment = [_FFM_Payments objectAtIndex:i];
        if (aPayment.selected) {
            selectedType = aPayment.paymentType;
            break;
        }
    }
    return selectedType;
}

@end
