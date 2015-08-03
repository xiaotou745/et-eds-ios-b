//
//  OrderStatisticsViewController.m
//  ESend
//
//  Created by LiMingjie on 15/6/27.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "OrderStatisticsViewController.h"

#import "UserInfo.h"
#import "FHQNetWorkingAPI.h"

@interface OrderStatisticsViewController ()
{
    UIView * topBgView;
    
    
    UILabel * _todayOrderCount;
    UILabel * _todayPayCount;
    
    UILabel * _todayFinishedOrderCount;
    UILabel * _todayFinishedPayCount;
    
    
    UILabel * _monthOrderCount;
    UILabel * _monthPayCount;
    
    UILabel * _monthFinishedOrderCount;
    UILabel * _monthFinishedPayCount;
}
@end

@implementation OrderStatisticsViewController

- (void)initializeData{
    
    MBProgressHUD * waitingProcess = [Tools showProgressWithTitle:@""];
    
    NSDictionary *requstData = @{@"version" : APIVersion,
                                 @"userId"  : [UserInfo getUserId]};
    
    [FHQNetWorkingAPI getOrderCount:requstData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        
        [self createViews];
        
        [self setDataWithTodayOC:[result getIntegerWithKey:@"todayPublish"]
                         todayPC:[result getFloatWithKey:@"todayPublishAmount"]
                        todayFOC:[result getIntegerWithKey:@"todayDone"]
                        todayFPC:[result getFloatWithKey:@"todayDoneAmount"]
                         monthOC:[result getIntegerWithKey:@"monthPublish"]
                         monthPC:[result getFloatWithKey:@"monthPublishAmount"]
                        monthFOC:[result getIntegerWithKey:@"monthDone"]
                        monthFPC:[result getFloatWithKey:@"monthDoneAmount"]];
        
        [Tools hiddenProgress:waitingProcess];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:waitingProcess];
    }];
}

- (void)bulidView{
    
    self.titleLabel.text = @"订单统计";
}

- (void)createViews{
    [self createTodayListView];
    [self creteMonthListView];
}

- (void)createTodayListView{
    // 蓝色背景
    topBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 63, ScreenWidth, 190)];
    topBgView.backgroundColor = RGBCOLOR(32, 188, 211);
    [self.view addSubview:topBgView];
    
    
    
    // ‘今日已发布订单’
    UILabel * mark1 = [self createLabel1WithFrame:CGRectMake(Space_Big + Space_Normal, Space_Big, ScreenWidth, 30) Title:@"今日已发布订单" textColor:[UIColor whiteColor] superView:topBgView];
    
    
    
    // 订单icon
    UIImageView * icon1 = [self createMarkIconWithFrame:CGRectMake(VIEW_X(mark1), VIEW_Y_Bottom(mark1) +Space_Normal, 20, 20) imgName:@"order_icon"];
    // 订单数
    _todayOrderCount = [self createLabel2WithFrame:CGRectMake(VIEW_X_Right(icon1) +Space_Small, VIEW_Y(icon1), 70, VIEW_HEIGHT(icon1)) title:@"-- 单" textColor:[UIColor whiteColor] superView:topBgView];
    
    
    // 金额icon
    UIImageView * icon2 = [self createMarkIconWithFrame:CGRectMake(VIEW_X_Right(_todayOrderCount), VIEW_Y(_todayOrderCount), 20, 20) imgName:@"count_icon"];
    // 金额数
    _todayPayCount = [self createLabel2WithFrame:CGRectMake(VIEW_X_Right(icon2) +Space_Small, VIEW_Y(icon2), 200, VIEW_HEIGHT(icon2)) title:@"订单金额：--.-- 元" textColor:[UIColor whiteColor] superView:topBgView];
    
    
    // 分割线
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(VIEW_X(mark1), VIEW_Y_Bottom(icon1) +Space_Big, ScreenWidth - VIEW_X(mark1) *2, 0.5f)];
    line.backgroundColor = LightGrey;
    [topBgView addSubview:line];
    
    
    
    
    // ‘今日已完成订单’
    UILabel * mark2 = [self createLabel1WithFrame:CGRectMake(VIEW_X(mark1), VIEW_Y_Bottom(line) +Space_Big, ScreenWidth, 30) Title:@"今日已完成订单" textColor:[UIColor whiteColor] superView:topBgView];
    
    
    
    // 订单icon
    UIImageView * icon3 = [self createMarkIconWithFrame:CGRectMake(VIEW_X(mark2), VIEW_Y_Bottom(mark2) +Space_Normal, 20, 20) imgName:@"order_icon"];
    // 订单数
    _todayFinishedOrderCount = [self createLabel2WithFrame:CGRectMake(VIEW_X_Right(icon3) +Space_Small, VIEW_Y(icon3), 70, VIEW_HEIGHT(icon3)) title:@"-- 单" textColor:[UIColor whiteColor] superView:topBgView];
    
    
    // 金额icon
    UIImageView * icon4 = [self createMarkIconWithFrame:CGRectMake(VIEW_X_Right(_todayFinishedOrderCount), VIEW_Y(_todayFinishedOrderCount), 20, 20) imgName:@"count_icon"];
    // 金额数
    _todayFinishedPayCount = [self createLabel2WithFrame:CGRectMake(VIEW_X_Right(icon4) +Space_Small, VIEW_Y(icon4), 200, VIEW_HEIGHT(icon4)) title:@"订单金额：--.-- 元" textColor:[UIColor whiteColor] superView:topBgView];
}

- (void)creteMonthListView{
    
    // 圆角白背景
    UIView * bottomBgView = [[UIView alloc] initWithFrame:CGRectMake(Space_Big, VIEW_Y_Bottom(topBgView) +Space_Large, ScreenWidth - Space_Big *2, 190)];
    bottomBgView.backgroundColor = [UIColor whiteColor];
    bottomBgView.layer.cornerRadius = 3.f;
    bottomBgView.layer.borderColor  = LightGrey.CGColor;
    bottomBgView.layer.borderWidth  = 0.5f;
    [self.view addSubview:bottomBgView];
    
    
    
    // ‘本月已发布订单’
    UILabel * mark3 = [self createLabel1WithFrame:CGRectMake(Space_Normal, Space_Big, ScreenWidth, 30) Title:@"本月已发布订单" textColor:[UIColor blackColor] superView:bottomBgView];
    
    
    // 订单数
    _monthOrderCount = [self createLabel2WithFrame:CGRectMake(VIEW_X(mark3), VIEW_Y_Bottom(mark3) +Space_Normal, 70, 20) title:@"-- 单" textColor:[UIColor blackColor] superView:bottomBgView];
    // 金额数
    _monthPayCount = [self createLabel2WithFrame:CGRectMake(VIEW_X_Right(_monthOrderCount), VIEW_Y(_monthOrderCount), 200, VIEW_HEIGHT(_monthOrderCount)) title:@"订单金额：--.-- 元" textColor:[UIColor blackColor] superView:bottomBgView];
    
    
    
    
    
    // 分割线
    UIView * line2 = [[UIView alloc] initWithFrame:CGRectMake(VIEW_X(mark3), VIEW_Y_Bottom(_monthOrderCount) +Space_Big, VIEW_WIDTH(bottomBgView) - VIEW_X(mark3) *2, 0.5f)];
    line2.backgroundColor = LightGrey;
    [bottomBgView addSubview:line2];
    
    
    
    
    // ‘本月已完成订单’
    UILabel * mark4 = [self createLabel1WithFrame:CGRectMake(VIEW_X(mark3), VIEW_Y_Bottom(line2) +Space_Big, ScreenWidth, 30) Title:@"本月已完成订单" textColor:[UIColor blackColor] superView:bottomBgView];
    
    
    // 订单数
    _monthFinishedOrderCount = [self createLabel2WithFrame:CGRectMake(VIEW_X(mark4), VIEW_Y_Bottom(mark4) +Space_Normal, 70, 20) title:@"-- 单" textColor:[UIColor blackColor] superView:bottomBgView];
    // 金额数
    _monthFinishedPayCount = [self createLabel2WithFrame:CGRectMake(VIEW_X_Right(_monthFinishedOrderCount), VIEW_Y(_monthFinishedOrderCount), 200, VIEW_HEIGHT(_monthFinishedOrderCount)) title:@"订单金额：--.-- 元" textColor:[UIColor blackColor] superView:bottomBgView];
}

#pragma mark - Methods
// 设置数据
- (void)setDataWithTodayOC:(NSInteger)todayOC todayPC:(CGFloat)todayPC todayFOC:(NSInteger)todayFOC todayFPC:(CGFloat)todayFPC monthOC:(NSInteger)monthOC monthPC:(CGFloat)monthPC monthFOC:(NSInteger)monthFOC monthFPC:(CGFloat)monthFPC{
    
    _todayOrderCount.text         = [NSString stringWithFormat:@"%ld单",(long)todayOC];
    _todayPayCount.text           = [NSString stringWithFormat:@"订单金额：%0.2f元",todayPC];
    
    _todayFinishedOrderCount.text = [NSString stringWithFormat:@"%ld单",(long)todayFOC];
    _todayFinishedPayCount.text   = [NSString stringWithFormat:@"订单金额：%0.2f元",todayFPC];
    
    
    _monthOrderCount.text           = [NSString stringWithFormat:@"%ld单",(long)monthOC];
    _monthPayCount.attributedText   = [self changColorOfString:[NSString stringWithFormat:@"订单金额：%0.2f元",monthPC]];
    
    _monthFinishedOrderCount.text           = [NSString stringWithFormat:@"%ld单",(long)monthFOC];
    _monthFinishedPayCount.attributedText   = [self changColorOfString:[NSString stringWithFormat:@"订单金额：%0.2f元",monthFPC]];
}

- (NSMutableAttributedString *)changColorOfString:(NSString *)str{
    
    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:str];

    [attributeString setAttributes:@{NSForegroundColorAttributeName : [UIColor redColor],   NSFontAttributeName : [UIFont systemFontOfSize:NormalFontSize]} range:NSMakeRange(5, str.length -6)];
    
    return attributeString;
}


#pragma mark - Controls Methods
- (UILabel *)createLabel1WithFrame:(CGRect)frame Title:(NSString *)title textColor:(UIColor *)color superView:(UIView *)superView{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text      = title;
    label.textColor = color;
    label.font      = FONT_BOLD_SIZE(LagerFontSize);
    [superView addSubview:label];
    
    return label;
}

- (UILabel *)createLabel2WithFrame:(CGRect)frame title:(NSString *)title textColor:(UIColor *)color superView:(UIView *)superView{
    UILabel * label = [[UILabel alloc] initWithFrame:frame];
    label.text      = title;
    label.textColor = color;
    label.font      = FONT_SIZE(NormalFontSize);
    [superView addSubview:label];
    
    return label;
}

- (UIImageView *)createMarkIconWithFrame:(CGRect)frame imgName:(NSString *)imgName{
    UIImageView * imgView = [[UIImageView alloc] initWithFrame:frame];
    imgView.image         = [UIImage imageNamed:imgName];
    [topBgView addSubview:imgView];
    
    return imgView;
}

@end
