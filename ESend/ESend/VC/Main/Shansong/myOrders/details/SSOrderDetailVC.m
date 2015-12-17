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

@interface SSOrderDetailVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerBottomToBound;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OrderHeaderToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderContentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderFaAddrHeight; // default 25;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderShouAddrHeight;  // default 25;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderNameToAddrBottomDistance;  // default 35;有配送信息， 否则 5
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderRemarkHeight;
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
@property (weak, nonatomic) IBOutlet UILabel *orderFaPhone;
// 收货信息
@property (weak, nonatomic) IBOutlet UILabel *orderShouAddr;
@property (weak, nonatomic) IBOutlet UILabel *orderShouName;
@property (weak, nonatomic) IBOutlet UILabel *orderShouPhone;
// 配送信息
@property (weak, nonatomic) IBOutlet UILabel *orderDeliveryName;
@property (weak, nonatomic) IBOutlet UILabel *orderDeliveryPhone;
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
// 取消订单
@property (weak, nonatomic) IBOutlet UIView *orderCancelBg;
@property (weak, nonatomic) IBOutlet UILabel *orderCancelTime;
@property (weak, nonatomic) IBOutlet UILabel *orderCancelReason;
// 底部按钮
@property (weak,nonatomic) UIButton * orderCancelButton;
@property (weak,nonatomic) UIButton * orderPayButton;

@end

@implementation SSOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"订单详情";
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
        SSOrderDetailModel * orderDetailModel = [[SSOrderDetailModel alloc] init];
        [orderDetailModel setValuesForKeysWithDictionary:[responseObject objectForKey:@"result"]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
    }];
}

@end
