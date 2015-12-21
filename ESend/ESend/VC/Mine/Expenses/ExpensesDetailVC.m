//
//  ExpensesDetailVC.m
//  ESend
//
//  Created by Maxwell on 15/8/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ExpensesDetailVC.h"
#import "UserInfo.h"
#import "FHQNetWorkingAPI.h"
#import "OrderDetailViewController.h"
#import "SSOrderDetailVC.h"

@interface ExpensesDetailVC ()
{
    NSInteger _withwardId;
    NSInteger _platform;
}
@property (strong, nonatomic) IBOutlet UIView *FirstBlock;
@property (strong, nonatomic) IBOutlet UILabel *expenseStatus;
@property (strong, nonatomic) IBOutlet UILabel *RMBFlag;
@property (strong, nonatomic) IBOutlet UILabel *expenseAmount;
@property (strong, nonatomic) IBOutlet UIImageView *FirstBlockSeperator;
@property (strong, nonatomic) IBOutlet UILabel *expenseOperationName;
@property (strong, nonatomic) IBOutlet UIImageView *rightIndicatorImg;

@property (strong, nonatomic) IBOutlet UIView *expenseBgView;

@property (strong, nonatomic) IBOutlet UIView *SecondBlock;
@property (strong, nonatomic) IBOutlet UIImageView *secondBlockSeperator;
@property (strong, nonatomic) IBOutlet UILabel *detailFix;
@property (strong, nonatomic) IBOutlet UILabel *expenseDetail;
@property (strong, nonatomic) IBOutlet UILabel *timeFix;
@property (strong, nonatomic) IBOutlet UILabel *expenseTime;
@property (strong, nonatomic) IBOutlet UIImageView *secondBlockSeperator2;
@property (strong, nonatomic) IBOutlet UILabel *thirdFix;
@property (strong, nonatomic) IBOutlet UILabel *thirdLabel;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollerHeight;  // scrollerView高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *SecondBlockHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *expenseDetailHeight;

@end

@implementation ExpensesDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.titleLabel.text = @"账单详情";
    
    self.FirstBlock.backgroundColor =
    self.SecondBlock.backgroundColor = [UIColor whiteColor];
    
    self.expenseStatus.textColor = TextColor6;
    self.expenseStatus.font = [UIFont systemFontOfSize:14];
    
    self.RMBFlag.font = [UIFont boldSystemFontOfSize:27.5];
    self.expenseAmount.textColor =
    self.RMBFlag.textColor = RedDefault;
    
    self.expenseAmount.font = [UIFont boldSystemFontOfSize:37.5];
    
    self.secondBlockSeperator2.backgroundColor =
    self.secondBlockSeperator.backgroundColor =
    self.FirstBlockSeperator.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    
    self.expenseOperationName.font = [UIFont systemFontOfSize:14];
    self.expenseOperationName.textColor = DeepGrey;
    
    self.detailFix.font =
    self.timeFix.font =
    self.thirdFix.font =
    self.thirdLabel.font =
    self.expenseDetail.font =
    self.expenseTime.font = [UIFont systemFontOfSize:16];
    
    self.detailFix.textColor =
    self.timeFix.textColor =
    self.thirdFix.textColor = DeepGrey;
    
    self.thirdLabel.textColor =
    self.expenseDetail.textColor =
    self.expenseTime.textColor = TextColor6;
    
    self.expenseDetail.numberOfLines = 0;
    

    
    // data
    
    double amount = [_detailInfo[@"amount"] doubleValue];
    NSString * status = _detailInfo[@"status"];
    _withwardId = [_detailInfo[@"withwardId"] integerValue];
    NSString * relationNo = _detailInfo[@"relationNo"];
    NSString * recordType = _detailInfo[@"recordType"];
    NSString * operateTime = _detailInfo[@"operateTime"];
    NSString * remark = _detailInfo[@"remark"];
    NSString * noDesc = _detailInfo[@"noDesc"];
    NSInteger isOrder = [_detailInfo[@"isOrder"] integerValue];
    _platform = [_detailInfo[@"platform"] integerValue];
    
    if (!isCanUseString(relationNo)) {
        relationNo = @"--";
    }
    if ([relationNo isEqualToString:@"<null>"]) {
        relationNo = @"--";
    }
    
    self.expenseStatus.text = status;
    self.expenseAmount.text = [NSString stringWithFormat:@"%.2f",amount];
    self.expenseOperationName.text = [NSString stringWithFormat:@"%@: %@",noDesc,relationNo];
    //1
    self.expenseDetail.text = recordType;
    //2
    self.expenseTime.text = remark;
    //3
    self.thirdLabel.text = operateTime;
    
    if (1 == isOrder) {
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(EdTapAction:)];
        self.expenseOperationName.userInteractionEnabled = YES;
        //[self.expenseOperationName addGestureRecognizer:tap];
        self.rightIndicatorImg.userInteractionEnabled = YES;
        //[self.rightIndicatorImg addGestureRecognizer:tap];
        self.expenseBgView.userInteractionEnabled = YES;
        
        [self.expenseBgView addGestureRecognizer:tap];
        
    }else if (0 == isOrder){
        self.rightIndicatorImg.hidden = YES;
    }

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)EdTapAction:(UITapGestureRecognizer *)sender{
    if (_platform == 3) {
        //
        SSOrderDetailVC * odvc = [[SSOrderDetailVC alloc] initWithNibName:@"SSOrderDetailVC" bundle:nil];
        odvc.orderId = [NSString stringWithFormat:@"%ld",_withwardId];
        [self.navigationController pushViewController:odvc animated:YES];
        
    }else{
        NSDictionary *requestData = @{@"OrderId"    : [NSNumber numberWithInteger:_withwardId],
                                      @"BusinessId" : [UserInfo getUserId],
                                      @"version"    : @"1.0"};
        MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
        [FHQNetWorkingAPI getOrderDetail:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {
            
            // NSDictionary * dic = (NSDictionary *)result;
            SupermanOrderModel * order = [[SupermanOrderModel alloc] init];
            //
            order.remark = [[result getStringWithKey:@"Remark"] isEqual:@""] ? @"无" : [result getStringWithKey:@"Remark"] ;
            //order.remark = [result getStringWithKey:@"Remark"];
            order.isPay = [[result objectForKey:@"IsPay"] boolValue];
            order.Landline = [result getStringWithKey:@"Landline"];
            order.totalAmount = [result getDoubleWithKey:@"TotalAmount"];
            order.pubDate = [result getStringWithKey:@"PubDate"];
            order.orderFrom = [result getIntegerWithKey:@"OrderFrom"];
            order.receviceCity = [result getStringWithKey:@"receviceCity"];
            order.orderCount = [result getIntegerWithKey:@"OrderCount"];
            // NeedUploadCount 无用
            // order.mealsSettleMode 无用
            // 经纬度 无用
            order.businessId = [result getIntegerWithKey:@"businessId"];
            // distance_OrderBy 无用
            order.receiveAddress = [result getStringWithKey:@"ReceviceAddress"];
            // OneKeyPubOrder 一键发单 - 没有用到
            // order.originalOrderNo 第三方订单号
            order.businessName = [result getStringWithKey:@"businessName"];
            // Payment 无用
            order.IsComplain = [result getIntegerWithKey:@"IsComplain"];
            // order.distance
            order.ClienterId = [result getIntegerWithKey:@"ClienterId"];
            order.orderStatus = [result getIntegerWithKey:@"Status"];
            // IsExistsUnFinish
            order.bussinessPhone = [result getStringWithKey:@"businessPhone"];
            // ClienterPhoneNo
            order.bussinessPhone2 = [result getStringWithKey:@"businessPhone2"];
            order.orderNumber = [result getStringWithKey:@"OrderNo"];
            // GrabTime
            order.receivePhone = [result getStringWithKey:@"RecevicePhoneNo"];
            // GroupId
            // OrderCommission
            // Invoice
            // pickUpCity
            //
            order.pickupAddress = [result getStringWithKey:@"PickUpAddress"];
            order.totalDeliverPrce = [result getDoubleWithKey:@"TotalDistribSubsidy"];
            // ClienterName
            [order.childOrderList removeAllObjects];
            for (NSDictionary *subDic in [result getArrayWithKey:@"listOrderChild"]) {
                ChildOrderModel *childOrder = [[ChildOrderModel alloc] initWithDic:subDic];
                [order.childOrderList addObject:childOrder];
            }
            // IsAllowCashPay
            // IsModifyTicket
            // distanceB2R
            // BusinessAddress
            order.amount = [result getDoubleWithKey:@"Amount"];
            order.orderId = [NSString stringWithFormat:@"%ld",[result getIntegerWithKey:@"Id"]];
            // PickupCode
            // HadUploadCount
            order.receiveName = [result getStringWithKey:@"ReceviceName"];
            
            //
            OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
            vc.orderModel = order;
            [self.navigationController pushViewController:vc animated:YES];
            [Tools hiddenProgress:HUD];
        } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
            [Tools hiddenProgress:HUD];
        }];
    }


}

@end
