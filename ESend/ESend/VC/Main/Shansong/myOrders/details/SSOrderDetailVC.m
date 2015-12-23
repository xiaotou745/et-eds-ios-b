//
//  SSOrderDetailVC.m
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSOrderDetailVC.h"
#import "SSOrderDetailModel.h"
#import "SSHttpReqServer.h"
#import "UserInfo.h"
#import "NSString+SSDateFormat.h"
#import "FHQNetWorkingAPI.h"
#import "SSpayViewController.h"
#import "Tools.h"
#import "UIAlertView+Blocks.h"
#import "ComplaintViewController.h"

#define SSOrderDetailVCCancelTitle @"取消任务"
#define SSOrderDetailVCGoPayTitle @"去支付"

#define SSOrderLabelDefaultHeight 25
#define SSOrderLabelDefaultFontSize 14

@interface SSOrderDetailVC ()
{
    UIButton * _cancelOrder;
    UIButton * _gotoPay;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerBottomToBound;         // default == 0, 否则 49; 底部操作区 44

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OrderHeaderToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderContentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderFaAddrHeight; // default 25;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderShouAddrHeight;  // default 25;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderNameToAddrBottomDistance;  // default 35;有配送信息， 否则 5  ,减30
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderRemarkHeight;     // default 25
// 视图
@property (weak, nonatomic) IBOutlet UIScrollView *orderMainScroller;
// 取货码，订单号，订单来源
@property (weak, nonatomic) IBOutlet UIView *orderTakeCodeBg;
@property (weak, nonatomic) IBOutlet UILabel *orderTakecode;
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusImg;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusText;
@property (weak, nonatomic) IBOutlet UILabel *orderNo;
@property (weak, nonatomic) IBOutlet UILabel *orderFrom;
// 配送费，距离，重量
@property (weak, nonatomic) IBOutlet UILabel *orderDeliveryFee;
@property (weak, nonatomic) IBOutlet UILabel *orderKm;
@property (weak, nonatomic) IBOutlet UILabel *orderWeight;

// 发货信息
@property (weak, nonatomic) IBOutlet UILabel *orderFaAddr;
@property (weak, nonatomic) IBOutlet UILabel *orderFaName;
@property (weak, nonatomic) IBOutlet UIButton *orderFaPhone;
// 收货信息
@property (weak, nonatomic) IBOutlet UILabel *orderShouAddr;
@property (weak, nonatomic) IBOutlet UILabel *orderShouName;
@property (weak, nonatomic) IBOutlet UIButton *orderShouPhone;
// 配送信息
@property (weak, nonatomic) IBOutlet UILabel *orderDeliveryInfoFix;
@property (weak, nonatomic) IBOutlet UILabel *orderDeliveryName;
@property (weak, nonatomic) IBOutlet UIButton *orderDeliveryPhone;
// 物品名称,取货时间，备注
@property (weak, nonatomic) IBOutlet UILabel *orderProductName;
@property (weak, nonatomic) IBOutlet UILabel *orderTakeTime;
@property (weak, nonatomic) IBOutlet UILabel *orderRemark;
// 订单状态，--
@property (weak, nonatomic) IBOutlet UIView *orderStatusBg;
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusPubImg;
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusGrabImg;
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusTakeImg;
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusCompleteImg;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusPubText;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusGrabText;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusTakeText;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusCompleteText;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusPubTime;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusGrabTime;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusTakeTime;
@property (weak, nonatomic) IBOutlet UILabel *orderStatusCompleteTime;
@property (weak, nonatomic) IBOutlet UIImageView *separator41;
@property (weak, nonatomic) IBOutlet UIImageView *separator42;
@property (weak, nonatomic) IBOutlet UIImageView *separator43;

// 取消订单
@property (weak, nonatomic) IBOutlet UIView *orderCancelBg;
@property (weak, nonatomic) IBOutlet UILabel *orderCancelTime;
@property (weak, nonatomic) IBOutlet UILabel *orderCancelReason;
// 底部按钮
@property (weak,nonatomic) UIButton * orderCancelButton;
@property (weak,nonatomic) UIButton * orderPayButton;

@property (strong,nonatomic) SSOrderDetailModel *orderInfo;

@end

@implementation SSOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"订单详情";
    
    [self.rightBtn addTarget:self action:@selector(clickComplaint) forControlEvents:UIControlEventTouchUpInside];
    //[self.rightBtn setFrame:CGRectMake(MainWidth - 12 - 75, OffsetBarHeight + 6, 75, 32)];
    [self.rightBtn setTitle:@"投诉" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"已投诉" forState:UIControlStateDisabled];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
    self.rightBtn.hidden = NO;
    
    _orderMainScroller.hidden = YES;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getORderDetail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API
- (void)getORderDetail{
    NSDictionary * paraDict = @{
                                @"businessId":[UserInfo getUserId],
                                @"orderId":self.orderId,
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{@"data":aesString,};
    }
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [SSHttpReqServer shanSongGetOrderDetails:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSDictionary * result = [responseObject objectForKey:@"result"];
            SSOrderDetailModel * orderDetailModel = [[SSOrderDetailModel alloc] initWithDic:result];
        [self layoutViewsWithData:orderDetailModel];
        }else{
            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
    }];
}

#pragma mark - 取消订单
- (void)cancelOrder{
    //
    [UIAlertView showAlertViewWithTitle:nil message:@"确认要取消订单吗" cancelButtonTitle:@"取消" otherButtonTitles:@[@"确定"] onDismiss:^(NSInteger buttonIndex) {
        MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
        NSDictionary *paraDict = @{
                                   @"OptUserName"  : [UserInfo getUserId],
                                   @"OptLog"       : @"闪送APP取消订单",
                                   @"orderId"      : [NSString stringWithFormat:@"%ld",(long)_orderInfo.orderId],
                                   @"Remark"       : @"闪送APP取消订单",
                                   @"Platform"     : @"5",
                                   };
        if (AES_Security) {
            NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
            NSString * aesString = [Security AesEncrypt:jsonString2];
            paraDict = @{@"data":aesString,};
        }
        [SSHttpReqServer shanSongSSCancelOrder:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [Tools hiddenProgress:HUD];
            NSInteger status = [[responseObject objectForKey:@"Status"] integerValue];
            NSString * message = [responseObject objectForKey:@"Message"];
            if (1 == status) {
                [Tools showHUD:@"任务已取消"];
                [self.navigationController popViewControllerAnimated:YES];
            }else{
                [Tools showHUD:message];
            }
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Tools hiddenProgress:HUD];

        }];
        
    } onCancel:^{
        
    }];
}

#pragma mark - gotopay
- (void)gotoPay{
    SSpayViewController * svc = [[SSpayViewController alloc] initWithNibName:NSStringFromClass([SSpayViewController class]) bundle:nil];
    svc.orderId = [NSString stringWithFormat:@"%ld",(long)_orderInfo.orderId];
    svc.balancePrice = _orderInfo.balancePrice;
    svc.type = 2;
    svc.tipAmount = _orderInfo.amount;
    [self.navigationController pushViewController:svc animated:YES];
}

#pragma mark - layoutViews
- (void)layoutViewsWithData:(SSOrderDetailModel *)orderInfo{
    
    [_cancelOrder removeFromSuperview]; _cancelOrder = nil;
    [_gotoPay removeFromSuperview]; _gotoPay = nil;
    
    CGFloat scrollerContentHeight = 0;
    CGFloat padding = 10; // padding
    _orderInfo = orderInfo;
    NSLog(@"%@",orderInfo);
    _orderMainScroller.hidden = NO;
    // 导航条
    if (1 == orderInfo.iscomplain) {
        self.rightBtn.enabled = NO;
    }else{
        self.rightBtn.enabled = YES;
    }
    // 取货码
    if (orderInfo.status == SSMyOrderStatusUngrab || orderInfo.status == SSMyOrderStatusOntaking) {
        self.orderTakecode.text = [NSString stringWithFormat:@"取货码: %@",orderInfo.pickupcode]; //30
        scrollerContentHeight += 30 + padding;
    }else{
        self.orderTakeCodeBg.hidden = YES;
        self.OrderHeaderToTop.constant = 0;
    }
    // 订单号
    self.orderNo.text = orderInfo.orderno;
    self.orderFrom.text = orderInfo.platformstr;
    self.orderStatusImg.image = [UIImage imageNamed:orderInfo.orderStatusImg];
    self.orderStatusText.text = orderInfo.orderStatusString;
    
    scrollerContentHeight += 70 + padding;
    
    CGFloat labelWidth = ScreenWidth - 90;
    // content 涉及到高度变化
    self.orderDeliveryFee.text = [NSString stringWithFormat:@"¥%.2f",orderInfo.ordercommission];
    self.orderDeliveryFee.textColor = RedDefault;
    self.orderKm.text = [NSString stringWithFormat:@"%.2fkm",orderInfo.km];
    self.orderWeight.text = [NSString stringWithFormat:@"%.2f公斤",orderInfo.weight];
    NSString * faAddrStr = isCanUseObj(orderInfo.pickupaddress)?orderInfo.pickupaddress:@"";
    CGFloat faAddrStrHeight = [Tools stringHeight:faAddrStr fontSize:SSOrderLabelDefaultFontSize width:labelWidth].height;
    self.orderFaAddrHeight.constant = MAX(faAddrStrHeight, SSOrderLabelDefaultHeight);
    self.orderFaAddr.text = faAddrStr;       // 高度
    
    self.orderFaName.text = orderInfo.pubname;
    [self.orderFaPhone setTitle:orderInfo.pubphoneno forState:UIControlStateNormal];
    
    NSString * shouAddrStr = isCanUseObj(orderInfo.receviceaddress)?orderInfo.receviceaddress:@"";
    self.orderShouAddr.text = shouAddrStr;    // 高度
    CGFloat shouAddrStrHeight = [Tools stringHeight:shouAddrStr fontSize:SSOrderLabelDefaultFontSize width:labelWidth].height;
    self.orderShouAddrHeight.constant = MAX(shouAddrStrHeight, SSOrderLabelDefaultHeight);
    
    self.orderShouName.text = orderInfo.recevicename;
    [self.orderShouPhone setTitle:orderInfo.recevicephoneno forState:UIControlStateNormal];
    // 配送信息... 取货中，配送中，已送达有
    if (orderInfo.status == SSMyOrderStatusOntaking || orderInfo.status == SSMyOrderStatusOnDelivering || orderInfo.status == SSMyOrderStatusCompleted) {
        self.orderDeliveryName.text = orderInfo.clienterName;
        [self.orderDeliveryPhone setTitle:orderInfo.clienterPhoneNo forState:UIControlStateNormal];
    }else{
        self.orderDeliveryName.hidden =
        self.orderDeliveryPhone.hidden =
        self.orderDeliveryInfoFix.hidden = YES;
        self.orderNameToAddrBottomDistance.constant = 5;
    }
    self.orderProductName.text = orderInfo.productname;
    self.orderTakeTime.text = (orderInfo.taketype == 0)?@"立即取货":[NSString stringWithFormat:@"预约取货/%@",orderInfo.expectedTakeTime];
    // 备注
    NSString * remarkStr = isCanUseObj(orderInfo.remark)?orderInfo.remark:@"";
    self.orderRemark.text = remarkStr;    // 高度
    CGFloat remarkStrHeight = [Tools stringHeight:remarkStr fontSize:SSOrderLabelDefaultFontSize width:labelWidth].height + 10;
    self.orderRemarkHeight.constant = MAX(remarkStrHeight, SSOrderLabelDefaultHeight);
    
    if (remarkStrHeight>SSOrderLabelDefaultHeight) {
        self.orderContentHeight.constant += remarkStrHeight - SSOrderLabelDefaultHeight;
    }
    if (shouAddrStrHeight>SSOrderLabelDefaultHeight) {
        self.orderContentHeight.constant += shouAddrStrHeight - SSOrderLabelDefaultHeight;
    }
    if (faAddrStrHeight>SSOrderLabelDefaultHeight) {
        self.orderContentHeight.constant += faAddrStrHeight - SSOrderLabelDefaultHeight;
    }
    scrollerContentHeight += self.orderContentHeight.constant + padding;// default 321;
    
    // 订单状态 待支付没有，其他均有, 高度~~
    if (orderInfo.status == SSMyOrderStatusUnpayed) {
        self.orderStatusBg.hidden = YES;
    }else{
        [self layoutStatusViewsWithData:orderInfo];
        scrollerContentHeight += 85 + padding;
    }
    // 取消时间，原因 , 涉及高度
    if (orderInfo.status == SSMyOrderStatusCanceled) {
        self.orderCancelTime.text = orderInfo.cancelTime;
        self.orderCancelReason.text = orderInfo.otherCancelReason;
        scrollerContentHeight += 85 + padding;
    }else{
        self.orderCancelBg.hidden = YES;
    }
    self.scrollerContentHeight.constant = scrollerContentHeight;
    
    // 底部去取消任务，去支付,
    if (orderInfo.status == SSMyOrderStatusUnpayed || orderInfo.status == SSMyOrderStatusUngrab) {
        if (orderInfo.status == SSMyOrderStatusUnpayed) { // 取消任务，去支付
            self.scrollerBottomToBound.constant = 60;
            _cancelOrder = [[UIButton alloc] initWithFrame:CGRectMake(10, ScreenHeight - 54, (ScreenWidth - 30)/2, 44)];
            [_cancelOrder setTitle:SSOrderDetailVCCancelTitle forState:UIControlStateNormal];
            [_cancelOrder setTitleColor:BlueColor forState:UIControlStateNormal];
            [_cancelOrder setBackgroundColor:[UIColor whiteColor]];
            _cancelOrder.layer.masksToBounds = YES;
            _cancelOrder.layer.borderColor = [BlueColor CGColor];
            _cancelOrder.layer.borderWidth = 1;
            _cancelOrder.layer.cornerRadius = 3;
            [_cancelOrder addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_cancelOrder];
            
            _gotoPay = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - (ScreenWidth - 30)/2, ScreenHeight - 54, (ScreenWidth - 30)/2, 44)];
            [_gotoPay setTitle:SSOrderDetailVCGoPayTitle forState:UIControlStateNormal];
            [_gotoPay setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            _gotoPay.layer.masksToBounds = YES;
            _gotoPay.layer.cornerRadius = 3;
            [_gotoPay setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
            [_gotoPay addTarget:self action:@selector(gotoPay) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_gotoPay];
        }else{ // 取消任务
            self.scrollerBottomToBound.constant = 49;
            _cancelOrder = [[UIButton alloc] initWithFrame:CGRectMake(0, ScreenHeight - 44, ScreenWidth, 44)];
            [_cancelOrder setTitle:SSOrderDetailVCCancelTitle forState:UIControlStateNormal];
            [_cancelOrder setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            //[cancelOrder setBackgroundColor:BlueColor];
            [_cancelOrder setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
            [_cancelOrder addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:_cancelOrder];
        }
    }
    
    // scrollerContentHeight
}


- (void)layoutStatusViewsWithData:(SSOrderDetailModel *)orderInfo{
    if (orderInfo.status == SSMyOrderStatusCanceled) {
        self.orderStatusPubTime.text = [orderInfo.pubdate MMDDHHmmString];
        return;
    }
    self.orderStatusPubTime.text = [orderInfo.pubdate MMDDHHmmString];
    self.orderStatusPubTime.textColor =
    self.orderStatusPubText.textColor = BlueColor;
    self.orderStatusPubImg.image = [UIImage imageNamed:@"ss_status_bar_fabu_green"];
    if (orderInfo.status == SSMyOrderStatusUngrab) {
        return;
    }
    self.separator41.backgroundColor = BlueColor;
    self.orderStatusGrabTime.text = [orderInfo.grabtime MMDDHHmmString];
    self.orderStatusGrabTime.textColor =
    self.orderStatusGrabText.textColor = BlueColor;
    self.orderStatusGrabImg.image = [UIImage imageNamed:@"ss_status_bar_jiedan_green"];
    if (orderInfo.status == SSMyOrderStatusOntaking) {
        return;
    }
    self.separator42.backgroundColor = BlueColor;
    self.orderStatusTakeTime.text = [orderInfo.taketime MMDDHHmmString];
    self.orderStatusTakeTime.textColor =
    self.orderStatusTakeText.textColor = BlueColor;
    self.orderStatusTakeImg.image = [UIImage imageNamed:@"ss_status_bar_quhuo_green"];
    if (orderInfo.status == SSMyOrderStatusOnDelivering) {
        return;
    }
    self.separator43.backgroundColor = BlueColor;
    self.orderStatusCompleteTime.text = [orderInfo.actualdonedate MMDDHHmmString];
    self.orderStatusCompleteTime.textColor =
    self.orderStatusCompleteText.textColor = BlueColor;
    self.orderStatusCompleteImg.image = [UIImage imageNamed:@"ss_status_bar_daoda_green"];
}

- (IBAction)callThePhone:(UIButton *)sender {
    if (sender.currentTitle && sender.currentTitle.length > 0) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",sender.currentTitle];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    }
}


#pragma mark - 投诉界面
- (void)clickComplaint{
    ComplaintViewController *vc = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
    vc.orderModel = self.orderInfo;
    vc.callBackBlock = ^{
        self.rightBtn.enabled = NO;
    };
    [self.navigationController pushViewController:vc animated:YES];
}


@end
