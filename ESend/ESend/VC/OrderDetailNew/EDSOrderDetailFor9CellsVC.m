//
//  EDSOrderDetailFor9CellsVC.m
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSOrderDetailFor9CellsVC.h"
#import "EDSHttpReqManager3.h"
#import "TaskInRegionModel.h"
#import "SupermanOrderModel.h"

@interface EDSOrderDetailFor9CellsVC ()
{
    TaskInRegionModel * _detailModel;
}
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *ScrollerContentHeight;
// view1
@property (strong, nonatomic) IBOutlet UIView *SectionView1;
@property (strong, nonatomic) IBOutlet UILabel *OrderCountFix;
@property (strong, nonatomic) IBOutlet UILabel *OrderStatus;
@property (strong, nonatomic) IBOutlet UILabel *OrderCount;
// view2
@property (strong, nonatomic) IBOutlet UIView *SectionView2;
@property (strong, nonatomic) IBOutlet UILabel *OrderGrabTimeFix;
@property (strong, nonatomic) IBOutlet UILabel *OrderGrabTime;
// view3
@property (strong, nonatomic) IBOutlet UIView *SectionView3;
@property (strong, nonatomic) IBOutlet UILabel *ClienterFix;
@property (strong, nonatomic) IBOutlet UILabel *ClienterName;
@property (strong, nonatomic) IBOutlet UILabel *ClienterPhoneNo;
@property (strong, nonatomic) IBOutlet UILabel *ClienterDestinationFix;
@property (strong, nonatomic) IBOutlet UILabel *ClienterDestination;
@property (strong, nonatomic) IBOutlet UIImageView *ClienterSeparatorLine;
// view4
@property (strong, nonatomic) IBOutlet UIView *SectionView4;
@property (strong, nonatomic) IBOutlet UILabel *statusQiang;
@property (strong, nonatomic) IBOutlet UILabel *statusQu;
@property (strong, nonatomic) IBOutlet UILabel *statusDa;
@property (strong, nonatomic) IBOutlet UILabel *statusQiangTime;
@property (strong, nonatomic) IBOutlet UILabel *statusQuTime;
@property (strong, nonatomic) IBOutlet UILabel *statusDaTime;
@property (strong, nonatomic) IBOutlet UIImageView *statusLine1;
@property (strong, nonatomic) IBOutlet UIImageView *statusLine2;

@end

@implementation EDSOrderDetailFor9CellsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"任务详情";
    [self configODF9CViews];
    [self businessGetMyOrderDetailBWithId:self.grabOrderId];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.ScrollerContentHeight.constant = ScreenHeight - 63;
}

- (void)configODF9CViews{
    // view1
    self.SectionView1.layer.borderColor = [SeparatorLineColor CGColor];
    self.SectionView1.layer.borderWidth = 1.0f;
    self.OrderCountFix.textColor = TextColor6;
    self.OrderCount.textColor =
    self.OrderStatus.textColor = BlueColor;
    // view2
    self.SectionView2.layer.borderColor = [SeparatorLineColor CGColor];
    self.SectionView2.layer.borderWidth = 1.0f;
    self.OrderGrabTimeFix.textColor =
    self.OrderGrabTime.textColor = TextColor6;
    //view3
    self.SectionView3.layer.borderColor = [SeparatorLineColor CGColor];
    self.SectionView3.layer.borderWidth = 1.0f;
    self.ClienterFix.textColor =
    self.ClienterName.textColor =
    self.ClienterPhoneNo.textColor =
    self.ClienterDestinationFix.textColor =
    self.ClienterDestination.textColor = TextColor6;
    self.ClienterSeparatorLine.backgroundColor = SeparatorLineColor;
    // view4  half 13
    self.SectionView4.layer.borderColor = [SeparatorLineColor CGColor];
    self.SectionView4.layer.borderWidth = 1.0f;
    self.statusQiang.textColor =
    self.statusQu.textColor =
    self.statusDa.textColor = [UIColor whiteColor];
    self.statusQiang.backgroundColor =
    self.statusLine1.backgroundColor =
    self.statusQu.backgroundColor =
    self.statusLine2.backgroundColor =
    self.statusDa.backgroundColor = BackgroundColor;
    self.statusQiangTime.textColor =
    self.statusQuTime.textColor =
    self.statusDaTime.textColor = TextColor6;
    
    self.statusQiang.layer.cornerRadius =
    self.statusQu.layer.cornerRadius =
    self.statusDa.layer.cornerRadius = 13.0f;
    self.statusQiang.layer.masksToBounds =
    self.statusQu.layer.masksToBounds =
    self.statusDa.layer.masksToBounds = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - API
- (void)businessGetMyOrderDetailBWithId:(NSInteger)grabOrderId{
    NSDictionary * paraDict = @{@"grabOrderId":[NSNumber numberWithInteger:grabOrderId],};
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{@"data":aesString,};
    }
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [EDSHttpReqManager3 businessGetmyorderdetailb:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            /// regionModel
            _detailModel = [[TaskInRegionModel alloc] initWithDic:[responseObject objectForKey:@"result"]];
            [self armedViewsWithDataSource:_detailModel];
        }else{
            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
    }];
}

- (void)armedViewsWithDataSource:(TaskInRegionModel *)datasource{
    self.OrderStatus.text = [self orderStatusStrWithStatus:datasource.status];
    self.OrderCount.text = [NSString stringWithFormat:@"%ld份",datasource.orderCount];
    self.OrderGrabTime.text = [self grabTimeWithStr:datasource.grabTime];
    self.ClienterName.text = datasource.clienterName;
    self.ClienterPhoneNo.text = datasource.clienterPhoneNo;
    self.ClienterDestination.text = [NSString stringWithFormat:@"%@ %@",datasource.orderRegionOneName,datasource.orderRegionTwoName];
    [self statusLinesWithStatusCode:datasource.status];
    self.statusQiangTime.text = [self nodeTimeWithStr:datasource.grabTime];
    self.statusQuTime.text = [self nodeTimeWithStr:datasource.pickUpTime];
    self.statusDaTime.text = [self nodeTimeWithStr:datasource.actualDoneDate];
}


- (IBAction)callClienterPhone:(UIButton *)sender {
    [Tools call:_detailModel.clienterPhoneNo atView:self.view];
}

- (NSString*)orderStatusStrWithStatus:(OrderStatus)status {
    switch (status) {
        case OrderStatusNewOrder:
            return @"待接单";
        case OrderStatusComplete:
            return @"已完成";
        case OrderStatusAccepted:
            return @"取货中";
        case OrderStatusCancel:
            return @"已取消";
        case OrderStatusWaitingAccept:
            return @"待接入订单";
        case OrderStatusReceive:
            return @"送货中";
        default:
            return @"";
            break;
    }
    return @"";
}

- (NSString *)grabTimeWithStr:(NSString *)str{
    NSAssert(nil != str, @"str is nil");
    NSArray * components = [str componentsSeparatedByString:@":"];
    return [NSString stringWithFormat:@"%@:%@",[components firstObject],[components objectAtIndex:1]];
}

- (NSString *)getTimeWithData:(TaskInRegionModel *)dataSrouce{
    NSString * timeStr = nil;
    switch (dataSrouce.status) {
        case 2:
            timeStr = dataSrouce.grabTime;
            self.OrderGrabTimeFix.text = @"抢单时间:";
            break;
        case 4:
            timeStr = dataSrouce.pickUpTime;
            self.OrderGrabTimeFix.text = @"取货时间:";
            break;
        case 1:
            timeStr = dataSrouce.actualDoneDate;
            self.OrderGrabTimeFix.text = @"完成时间:";
            break;
        default:
            break;
    }
    if (timeStr == nil) {
        return nil;
    }
    if (timeStr.length < 16) {
        return [NSString stringWithFormat:@"%@",timeStr];
    }
    NSArray * components = [timeStr componentsSeparatedByString:@":"];
    return [NSString stringWithFormat:@"%@:%@",[components firstObject],[components objectAtIndex:1]];
}

- (void)statusLinesWithStatusCode:(OrderStatus)status{
    if (status == OrderStatusAccepted) { // 抢了
        self.statusQiang.backgroundColor = BlueColor;
        self.statusQiangTime.hidden = NO;
    }else if (status == OrderStatusReceive){ // 取了
        self.statusQiang.backgroundColor =
        self.statusLine1.backgroundColor =
        self.statusQu.backgroundColor = BlueColor;
        
        self.statusQiangTime.hidden = NO;
        self.statusQuTime.hidden = NO;
    }else if (status == OrderStatusComplete){ // 达了
        self.statusQiang.backgroundColor =
        self.statusLine1.backgroundColor =
        self.statusQu.backgroundColor =
        self.statusLine2.backgroundColor =
        self.statusDa.backgroundColor = BlueColor;
        
        self.statusQiangTime.hidden = NO;
        self.statusQuTime.hidden = NO;
        self.statusDaTime.hidden = NO;
    }
}

- (NSString *)nodeTimeWithStr:(NSString *)string{
    NSAssert(nil != string, @"string is nil");
    if (string.length < 18) {
        return string;
    }else{
        return [string substringWithRange:NSMakeRange(5, 11)];
    }
}

@end
