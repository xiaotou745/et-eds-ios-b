//
//  EDSBillStatisticsVC.m
//  ESend
//
//  Created by 台源洪 on 15/9/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSBillStatisticsVC.h"
#import "KMMonthDateCalendarView.h"
#import "UIColor+KMhexColor.h"
#import "FHQNetWorkingAPI.h"
#import "EDSBillStatisticsMonthCell.h"
#import "EDSBillStatisticsDayCell.h"
#import "Encryption.h"
#import "UserInfo.h"
#import "RecordTypeModel.h"
#import "UIImage+KmImg.h"
#import "BS_Header.h"
#import "NSDate+KMdate.h"
#import "ExpensesDetailVC.h"
#import "MJRefresh.h"
#import "NSString+KM_String.h"

#define BS_RightNavTitleChoose @"筛选"
#define BS_RightNavTitleDismiss @"收起"

#define BS_OptionTypeBtnTitleAll @"全部"
#define BS_OptionTypeBtnTitleOut @"出账"
#define BS_OptionTypeBtnTitleIn @"入账"

#define BS_BillTypeSwitchTitleMonth @"切换到天"
#define BS_BillTypeSwitchTitleDay @"切换到月"

#define BS_ColorGray @"666666"
#define BS_ColorBlue @"00bcd5"

#define BS_calloutTopPadding 15.0f
#define BS_calloutBottomPadding 15.0f
#define BS_calloutMargin 10.0f
#define BS_calloutContentHeight 30.0f

#define BS_calloutContentCountPerRow 3

#define BS_EmptyBillText @"暂无账单信息"


// #define BillStatisticsAPIHost @"http://10.8.7.253:7178/api-http/services/"

@interface EDSBillStatisticsVC ()<UITableViewDataSource,UITableViewDelegate,KMMonthDateCalendarViewDelegate>
{
    NSInteger _currentPage;
    
    double _inMoney;
    double _outMoney;
    
    // call out view
    UIView * _callOutBillTypeView;
    UIView * _maskView;
    
    // 订单为空的情况
    UIImageView * _emptyBillImg;
    UILabel * _emptyBillTextLbl;
    
    // viewDidAppear 次数， 第一次（==0）时，接口请求
    NSInteger _viewDidAppearTimes;
}
@property (strong, nonatomic) IBOutlet UIView *BS_OptionHeaderView;
@property (strong, nonatomic) IBOutlet UIView *BS_MidTitleBg;
@property (strong, nonatomic) IBOutlet UILabel *BS_MidTextV;
@property (strong, nonatomic) IBOutlet UITableView *BS_TableView;

// option buttons
@property (strong, nonatomic) IBOutlet UIButton *BS_allBillBtn;
@property (strong, nonatomic) IBOutlet UIButton *BS_outBillBtn;
@property (strong, nonatomic) IBOutlet UIButton *BS_inBillBtn;
@property (strong, nonatomic) IBOutlet UIImageView *BS_billTypeIndicator;

@property (strong, nonatomic) IBOutlet UIButton *BS_billTypeSwither;


@property (strong, nonatomic) KMMonthDateCalendarView * calendarView;
@property (strong, nonatomic) NSMutableArray * bills;           // table datasource
// typeDataSource
@property (strong, nonatomic) NSMutableArray * allBillTypes;    // all bill types
@property (strong, nonatomic) NSMutableArray * currentBillTypes;
@property (assign, nonatomic) EDSBillStatisticsVCStyle style;   // 日 or 月
/// 0,1,2 default 0
@property (nonatomic, assign) BS_RecordType currentType;        // 0,1,2 default 0
@property (nonatomic, assign) NSInteger currentTypeSub;         // default 0
@property (nonatomic, strong) NSDate * currentDate;             // 接口时间串

@end

@implementation EDSBillStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // data default value
    _currentPage = 1;
    _currentType = BS_RecordTypeAll;
    _currentTypeSub = 0;
    _bills = [[NSMutableArray alloc] initWithCapacity:0];
    _allBillTypes = [[NSMutableArray alloc] initWithCapacity:0];
    _currentBillTypes = [[NSMutableArray alloc] initWithCapacity:0];
    
#pragma mark - type
    self.style = EDSBillStatisticsVCStyleDay;
    
    [self _configViews];
    //
    [self getrecordtypeb];
    
    self.currentDate = [NSDate new];

    [self allBillTypeAction:self.BS_allBillBtn];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (0 == _viewDidAppearTimes) {
        // 日账单
        //[self allBillTypeAction:self.BS_allBillBtn];
    }
    _viewDidAppearTimes++;
}

/// build views
- (void)_configViews{
    // right nav button
    self.titleLabel.text = @"账单";
    [self.rightBtn setTitle:BS_RightNavTitleChoose forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(bsRightNavAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 全部，出账，入账
    [self.BS_allBillBtn setTitle:BS_OptionTypeBtnTitleAll forState:UIControlStateNormal];
    [self.BS_allBillBtn setTitleColor:[UIColor km_colorWithHexString:BS_ColorGray] forState:UIControlStateNormal];
    [self.BS_allBillBtn setTitleColor:[UIColor km_colorWithHexString:BS_ColorBlue] forState:UIControlStateDisabled];
    
    [self.BS_outBillBtn setTitle:BS_OptionTypeBtnTitleOut forState:UIControlStateNormal];
    [self.BS_outBillBtn setTitleColor:[UIColor km_colorWithHexString:BS_ColorGray] forState:UIControlStateNormal];
    [self.BS_outBillBtn setTitleColor:[UIColor km_colorWithHexString:BS_ColorBlue] forState:UIControlStateDisabled];
    
    [self.BS_inBillBtn setTitle:BS_OptionTypeBtnTitleIn forState:UIControlStateNormal];
    [self.BS_inBillBtn setTitleColor:[UIColor km_colorWithHexString:BS_ColorGray] forState:UIControlStateNormal];
    [self.BS_inBillBtn setTitleColor:[UIColor km_colorWithHexString:BS_ColorBlue] forState:UIControlStateDisabled];
    
    // 默认是天
    [self.BS_billTypeSwither setTitle:BS_BillTypeSwitchTitleDay forState:UIControlStateNormal];
    [self.BS_billTypeSwither setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.BS_billTypeSwither setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    
    // indicator
    self.BS_billTypeIndicator.backgroundColor = [UIColor km_colorWithHexString:BS_ColorBlue];
    
    // option view
    self.BS_OptionHeaderView.layer.masksToBounds = YES;
    self.BS_OptionHeaderView.layer.borderColor = [BackgroundColor CGColor];
    self.BS_OptionHeaderView.layer.borderWidth = 1.0f;
    // middle title
    self.BS_MidTitleBg.backgroundColor = BackgroundColor;
    self.BS_MidTextV.backgroundColor = [UIColor clearColor];
    self.BS_MidTextV.font = [UIFont systemFontOfSize:BigFontSize];
    [self.view addSubview:self.calendarView];
    
    // table view fresh
    [self.BS_TableView addLegendHeaderWithRefreshingTarget:self refreshingAction:@selector(bs_tableViewHeaderRefreshAction)];

}

- (void)bs_tableViewFooterRefresh{
    
    if (_style == EDSBillStatisticsVCStyleDay) {
        [self getbilllistDayb:[_currentDate dateToStringWithFormat:KMCalendarDatePrintFormat] billType:_currentType recordType:_currentTypeSub pullDown:NO];
    }else if (_style == EDSBillStatisticsVCStyleMonth){
        [self getbilllistMonthbWithMonth:[_currentDate dateToStringWithFormat:KMCalendarMonthPrintFormat] pullDown:NO];
    }
}

- (void)bs_tableViewHeaderRefreshAction{
    
    _currentPage = 1;
    
    if (_style == EDSBillStatisticsVCStyleDay) {
        [self getbilllistDayb:[_currentDate dateToStringWithFormat:KMCalendarDatePrintFormat] billType:_currentType recordType:_currentTypeSub pullDown:YES];
    }else if (_style == EDSBillStatisticsVCStyleMonth){
        [self getbilllistMonthbWithMonth:[_currentDate dateToStringWithFormat:KMCalendarMonthPrintFormat] pullDown:YES];
    }
    
}

- (KMMonthDateCalendarView *)calendarView{
    if (!_calendarView) {
        _calendarView = [[KMMonthDateCalendarView alloc] initWithFrame:CGRectMake(0, 50+64, ScreenWidth, KMMonthDateCalenderViewHeight)];
        _calendarView.delegate = self;
    }
    return _calendarView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Nav right button action
- (void)bsRightNavAction:(UIButton *)sender{
    if ([sender.currentTitle isEqualToString:BS_RightNavTitleChoose]) { // 弹出筛选项
        // disable sender
        sender.enabled = NO;
        // show
        if (!_maskView) {
            _maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
            _maskView.backgroundColor = BlackColor;
        }
        UITapGestureRecognizer * maskTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(masktapAction:)];
        [_maskView addGestureRecognizer:maskTap];
        _maskView.alpha = 0.0;
        [self.view addSubview:_maskView];

        if (!_callOutBillTypeView) {
            _callOutBillTypeView = [[UIView alloc] initWithFrame:CGRectMake(0, -200, ScreenWidth, 200)];
            _callOutBillTypeView.backgroundColor = [UIColor whiteColor];
            [self.view addSubview:_callOutBillTypeView];
        }
        [self.view bringSubviewToFront:_callOutBillTypeView];
        [self.view bringSubviewToFront:self.navBar];


        CGFloat buttonWidth = (ScreenWidth - (BS_calloutContentCountPerRow + 1) * BS_calloutMargin)/ BS_calloutContentCountPerRow;
        CGFloat billTypeViewHeight = 0;

        [_currentBillTypes removeAllObjects];
        [_currentBillTypes addObjectsFromArray:[self _BS_getBillTypesWithType:self.currentType]];
        for (int i = 0; i < _currentBillTypes.count; i++) {
            int row=i/BS_calloutContentCountPerRow;//行号
            int loc=i%BS_calloutContentCountPerRow;//列号
            CGFloat buttonX = BS_calloutMargin + loc*(BS_calloutMargin + buttonWidth);
            CGFloat buttonY = BS_calloutTopPadding + row*(BS_calloutMargin + BS_calloutContentHeight);

            RecordTypeModel * typeModel = [_currentBillTypes objectAtIndex:i];

            UIButton * typeButton = [[UIButton alloc] initWithFrame:CGRectMake(buttonX, buttonY, buttonWidth, BS_calloutContentHeight)];
            [typeButton setBackgroundImage:[UIImage KM_createImageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [typeButton setBackgroundImage:[UIImage KM_createImageWithColor:BlueColor] forState:UIControlStateSelected];
            typeButton.layer.masksToBounds = YES;
            typeButton.layer.borderColor = [SeparatorLineColor CGColor];
            typeButton.layer.borderWidth = 0.5f;
            [typeButton setTitle:typeModel.desc forState:UIControlStateNormal];
            [typeButton setTitleColor:DeepGrey forState:UIControlStateNormal];
            [typeButton setSelected:typeModel.selected];
            typeButton.tag = i;
            [typeButton addTarget:self action:@selector(typeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [_callOutBillTypeView addSubview:typeButton];

            billTypeViewHeight = CGRectGetMaxY(typeButton.frame);
        }
        billTypeViewHeight += BS_calloutBottomPadding;
        [_callOutBillTypeView setFrame:CGRectMake(0, -billTypeViewHeight, ScreenWidth, billTypeViewHeight)];
        
        [UIView animateWithDuration:0.5 animations:^{
            CGFloat height = CGRectGetHeight(_callOutBillTypeView.bounds);
            CGFloat width = CGRectGetWidth(_callOutBillTypeView.bounds);
            _callOutBillTypeView.frame = CGRectMake(0, 64, width, height);
            _maskView.alpha = 0.8f;
        } completion:^(BOOL finished) {
    //        view.imgIsUp
            [sender setTitle:BS_RightNavTitleDismiss forState:UIControlStateNormal];
            sender.enabled = YES;

        }];
    }else if ([sender.currentTitle isEqualToString:BS_RightNavTitleDismiss]){ // 收起筛选项
        if (_callOutBillTypeView) {
            sender.enabled = NO;
            [UIView animateWithDuration:0.5 animations:^{
                CGFloat height = CGRectGetHeight(_callOutBillTypeView.bounds);
                CGFloat width = CGRectGetWidth(_callOutBillTypeView.bounds);
                _callOutBillTypeView.frame = CGRectMake(0, -height, width, height);
                _maskView.alpha = 0.0;
            } completion:^(BOOL finished) {
                for (UIView * subview in _callOutBillTypeView.subviews) {
                    [subview removeFromSuperview];
                }
                [_maskView removeFromSuperview];
                _maskView = nil;
                [sender setTitle:BS_RightNavTitleChoose forState:UIControlStateNormal];
                sender.enabled = YES;
            }];
        }
    }
}

- (void)masktapAction:(UITapGestureRecognizer *)sender{
    [self bsRightNavAction:self.rightBtn];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _bills.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.style == EDSBillStatisticsVCStyleDay) {
        static NSString * dayBillStatisticsCellId = @"dayBillStatisticsCellId";
        EDSBillStatisticsDayCell * cell = [tableView dequeueReusableCellWithIdentifier:dayBillStatisticsCellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EDSBillStatisticsDayCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.billInfo = [_bills objectAtIndex:indexPath.row];
        return cell;
    }else if (self.style == EDSBillStatisticsVCStyleMonth){
        static NSString * monthBillStatisticsCellId = @"monthBillStatisticsCellId";
        EDSBillStatisticsMonthCell * cell = [tableView dequeueReusableCellWithIdentifier:monthBillStatisticsCellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EDSBillStatisticsMonthCell" owner:self options:nil] objectAtIndex:0];
        }
        cell.daybillInfo = [_bills objectAtIndex:indexPath.row];
        return cell;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.style == EDSBillStatisticsVCStyleDay) {
        return 50.0f;
    }else if (self.style == EDSBillStatisticsVCStyleMonth){
        return 50.0f;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (EDSBillStatisticsVCStyleDay == self.style) {
        DayBillDetailInfo * dayInfo = [_bills objectAtIndex:indexPath.row];
        [self getbilldetailbWithRecordId:dayInfo.recordId];
    }else if (EDSBillStatisticsVCStyleMonth == self.style){
        DayBillInfo * dayInfo = [_bills objectAtIndex:indexPath.row];
        if (1 == dayInfo.hasDatas) {
            
            NSString * dayString = dayInfo.dayInfo;
            // yyyy-MM-dd hh:mm:ss
            NSString * dayStringFormat = [NSString stringWithFormat:@"%@ 00:00:00",dayString];
            // 重置type, typeSub,timeInfo
            _currentType = BS_RecordTypeAll;
            _currentTypeSub = 0;
            _currentPage = 1;
            _currentDate = [dayStringFormat km_toDate];
            
            // 切换到日
            [self.BS_billTypeSwither setTitle:BS_BillTypeSwitchTitleDay forState:UIControlStateNormal];
            self.rightBtn.hidden = _BS_outBillBtn.hidden = _BS_inBillBtn.hidden = NO;
            self.style = EDSBillStatisticsVCStyleDay;
            [_calendarView setMonthDayStyle:EDSBillStatisticsVCStyleDay date:_currentDate];
            
            [self.BS_TableView removeFooter];
            [self.BS_TableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(bs_tableViewFooterRefresh)];
            
            // 调接口
            [self getbilllistDayb:[_currentDate dateToStringWithFormat:KMCalendarDatePrintFormat] billType:_currentType recordType:_currentTypeSub pullDown:YES];
        }
 
    }
}


#pragma mark - option button action

- (IBAction)allBillTypeAction:(UIButton *)sender {
    _currentType = BS_RecordTypeAll;
    _currentTypeSub = 0;
    _currentPage = 1;
    [self _BS_buttonEventWithSender:sender];
}

- (IBAction)outBillTypeAction:(UIButton *)sender {
    _currentType = BS_RecordTypeOut;
    _currentTypeSub = 0;
    _currentPage = 1;
    [self _BS_buttonEventWithSender:sender];
}

- (IBAction)inBillTypeAction:(UIButton *)sender {
    _currentType = BS_RecordTypeIn;
    _currentTypeSub = 0;
    _currentPage = 1;
    [self _BS_buttonEventWithSender:sender];
}

- (void)_enableAllOptionBtns{
    self.BS_allBillBtn.enabled = YES;
    self.BS_outBillBtn.enabled = YES;
    self.BS_inBillBtn.enabled = YES;
}

- (void)_BS_buttonEventWithSender:(UIButton *)sender{
    [self _enableAllOptionBtns];
    sender.enabled = NO;

    CGFloat movCenterY = self.BS_billTypeIndicator.center.y;
    CGFloat newCenterX = sender.center.x;
    [UIView animateWithDuration:0.3 animations:^{
        self.BS_billTypeIndicator.center = CGPointMake(newCenterX, movCenterY);
    } completion:^(BOOL finished) {
        // API 接口
        if (EDSBillStatisticsVCStyleDay == self.style) { // day
            [self getbilllistDayb:[self.currentDate dateToStringWithFormat:KMCalendarDatePrintFormat] billType:_currentType recordType:_currentTypeSub pullDown:YES];
        }else if (EDSBillStatisticsVCStyleMonth == self.style) { // month
            [self getbilllistMonthbWithMonth:[self.currentDate dateToStringWithFormat:KMCalendarMonthPrintFormat] pullDown:YES];
        }
    }];
}

/// 日月切换
- (IBAction)monthDaySwitchAction:(UIButton *)sender {
    // 重置type, typeSub,timeInfo
    _currentType = BS_RecordTypeAll;
    _currentTypeSub = 0;
    _currentDate = [NSDate new];
    _currentPage = 1;
    
    if ([sender.currentTitle isEqualToString:BS_BillTypeSwitchTitleMonth]) {    // 切换到日
        [sender setTitle:BS_BillTypeSwitchTitleDay forState:UIControlStateNormal];
        self.rightBtn.hidden = _BS_outBillBtn.hidden = _BS_inBillBtn.hidden = NO;
        self.style = EDSBillStatisticsVCStyleDay;
        [_calendarView setMonthDayStyle:EDSBillStatisticsVCStyleDay date:_currentDate];
        
        [self.BS_TableView removeFooter];
        [self.BS_TableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(bs_tableViewFooterRefresh)];

        // 调接口
        [self getbilllistDayb:[_currentDate dateToStringWithFormat:KMCalendarDatePrintFormat] billType:_currentType recordType:_currentTypeSub pullDown:YES];
        
    }else{  // 切换到月
        [sender setTitle:BS_BillTypeSwitchTitleMonth forState:UIControlStateNormal];
        self.rightBtn.hidden = _BS_outBillBtn.hidden = _BS_inBillBtn.hidden = YES;
        self.style = EDSBillStatisticsVCStyleMonth;
        [_calendarView setMonthDayStyle:EDSBillStatisticsVCStyleMonth date:_currentDate];
        
        [self.BS_TableView removeFooter];

        [self allBillTypeAction:_BS_allBillBtn];        // 重置type,typeSub；并调用接口请求
    }
}


#pragma mark - apis
- (AFHTTPRequestOperationManager *)_manager{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.requestSerializer.timeoutInterval = 30;
    NSDictionary * headerDict = [Encryption ESendB_Encryptioin];
    //NSLog(@"headerDicts:%@",headerDict);
    NSArray * keys = [headerDict allKeys];
    for (NSString * key in keys) {
        [manager.requestSerializer setValue:[headerDict objectForKey:key] forHTTPHeaderField:key];
    }
    return manager;
    
}

/// 1.1.8 B端商户点击账单按钮 获取所有的筛选条件类型
- (AFHTTPRequestOperation *)getrecordtypeb{
    MBProgressHUD * waitingProcess = [Tools showProgressWithTitle:@""];
    NSString * urlstring = [NSString stringWithFormat:@"%@common/getrecordtypeb",Java_API_SERVER];
    NSDictionary *requstData = @{
                                 @"Version":[Tools getApplicationVersion],
                                 };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:requstData];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        requstData = @{
                       @"data":aesString,
                       //@"Version":[Tools getApplicationVersion],
                       };
    }
    AFHTTPRequestOperation * operation = [[self _manager] POST:urlstring parameters:requstData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:waitingProcess];
        // 系统错误 -1
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString * message = responseObject[@"message"];
        NSArray * result = responseObject[@"result"];
        if (1 == status) {
            [_allBillTypes removeAllObjects];
            // 1 出账， 2 入账
            for (NSDictionary * typeDict in result) {
                RecordTypeModel * typeModel = [[RecordTypeModel alloc] initWithDic:typeDict];
                [_allBillTypes addObject:typeModel];
            }
        }else{
            NSLog(@"message:%@",message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:waitingProcess];
    }];
    return operation;
}

/// 1.1.2商户获取月账单(java必须大小写符合) pullDown是否下拉 // getbilllistb
- (AFHTTPRequestOperation *)getbilllistMonthbWithMonth:(NSString *)monthString pullDown:(BOOL)down{
    // 月账单接口无上拉，pulldown参数暂时闲置
    MBProgressHUD * waitingProcess = [Tools showProgressWithTitle:@""];

    NSString * urlstring = [NSString stringWithFormat:@"%@accountbill/getbilllistb",Java_API_SERVER];
    NSDictionary * paraDict = @{
                                @"monthInfo":monthString,
                                @"businessId":[UserInfo getUserId],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{
                       @"data":aesString,
                       //@"Version":[Tools getApplicationVersion],
                       };
    }

    
    AFHTTPRequestOperation * operation = [[self _manager] POST:urlstring parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:waitingProcess];
        
        if (self.BS_TableView.header.state == MJRefreshHeaderStateRefreshing) {
            [self.BS_TableView.header endRefreshing];
        }

        NSInteger status = [responseObject[@"status"] integerValue];
        NSString * message = responseObject[@"message"];
        NSDictionary * result = responseObject[@"result"];
        if (1 == status) {
            NSLog(@"%@",result);
            _inMoney = [result[@"inMoney"] doubleValue];
            _outMoney = [result[@"outMoney"] doubleValue];
            NSArray * listDays = result[@"listDays"];
            
            [self _removeBSEmptyBillView];
            if (listDays.count == 0) {
                [self _showBSEmptyBillView];
            }
            
            [_calendarView setOutBillAmount:_outMoney inAmount:_inMoney];
            [_bills removeAllObjects];
            for (NSDictionary * aRecords in listDays) {
                DayBillInfo * dayInfo = [[DayBillInfo alloc] initWithDic:aRecords];
                [_bills addObject:dayInfo];
            }
            [self.BS_TableView reloadData];
            
        }else{
            [_calendarView setOutBillAmount:0 inAmount:0];
            [Tools showHUD:message];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:waitingProcess];
        
        if (self.BS_TableView.header.state == MJRefreshHeaderStateRefreshing) {
            [self.BS_TableView.header endRefreshing];
        }


    }];
    return operation;
}

/// 1.1.3商户获取日账单(java必须大小写符合)
- (AFHTTPRequestOperation *)getbilllistDayb:(NSString *)dayString
                                   billType:(NSInteger)billType
                                 recordType:(NSInteger)recordType
                                   pullDown:(BOOL)down
{
    if (!down) {
        _currentPage ++;
    }
    
    MBProgressHUD * waitingProcess = [Tools showProgressWithTitle:@""];
    NSString * urlstring = [NSString stringWithFormat:@"%@accountbill/getbilllistdayb",Java_API_SERVER];
    NSDictionary * paraDict = @{
                                @"dayInfo":dayString,
                                
                                @"businessId":[UserInfo getUserId],//@"2007"
                                @"billType":[NSNumber numberWithInteger:billType],
                                @"recordType":[NSNumber numberWithInteger:recordType],
                                @"currentPage":[NSNumber numberWithInteger:_currentPage],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{
                     @"data":aesString,
                     //@"Version":[Tools getApplicationVersion],
                     };
    }
    
    AFHTTPRequestOperation * operation = [[self _manager] POST:urlstring parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:waitingProcess];
        if (self.BS_TableView.header.state == MJRefreshHeaderStateRefreshing) {
            [self.BS_TableView.header endRefreshing];
        }
        if (self.BS_TableView.footer.state == MJRefreshFooterStateRefreshing) {
            [self.BS_TableView.footer endRefreshing];
        }

        NSInteger status = [responseObject[@"status"] integerValue];
        NSString * message = responseObject[@"message"];
        NSDictionary * result = responseObject[@"result"];
        if (1 == status) {
             NSLog(@"%@",result);
            _inMoney = [result[@"inMoney"] doubleValue];
            _outMoney = [result[@"outMoney"] doubleValue];
            NSArray * listRecordS = result[@"listRecordS"];
            
            [self _removeBSEmptyBillView];
            if (down && listRecordS.count == 0) {
                [self _showBSEmptyBillView];
                [self.BS_TableView removeFooter]; // 无上拉加载
            }
            
            if (down && listRecordS.count > 0) {
                // table view footer fresh
                if (self.BS_TableView.footer) {
                    [self.BS_TableView removeFooter];
                }
                [self.BS_TableView addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(bs_tableViewFooterRefresh)];
                self.BS_TableView.footer.state = MJRefreshFooterStateIdle;
            }
            
            [_calendarView setOutBillAmount:_outMoney inAmount:_inMoney];
            if (down) {
                [_bills removeAllObjects];
            }
            for (NSDictionary * aRecords in listRecordS) {
                DayBillDetailInfo * dayInfo = [[DayBillDetailInfo alloc] initWithDic:aRecords];
                [_bills addObject:dayInfo];
            }
            [self.BS_TableView reloadData];
            
            if ([listRecordS count] == 0 && !down) {
                //_currentPage--;
                // [Tools showHUD:@"没有更多了"];
                self.BS_TableView.footer.state = MJRefreshFooterStateNoMoreData;

            }
            
        }else{
            [_calendarView setOutBillAmount:0 inAmount:0];
            [Tools showHUD:message];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:waitingProcess];
        
        if (self.BS_TableView.header.state == MJRefreshHeaderStateRefreshing) {
            [self.BS_TableView.header endRefreshing];
        }
        if (self.BS_TableView.footer.state == MJRefreshFooterStateRefreshing) {
            [self.BS_TableView.footer endRefreshing];
        }

    }];
    return operation;
}

/// 1.1.4商户获取账单详情(java必须大小写符合)//getbilldetailb
- (AFHTTPRequestOperation *)getbilldetailbWithRecordId:(NSInteger)recordId
{
    MBProgressHUD * waitingProcess = [Tools showProgressWithTitle:@""];
    NSString * urlstring = [NSString stringWithFormat:@"%@accountbill/getbilldetailb",Java_API_SERVER];
    NSDictionary * paraDict = @{
                                @"recordId":[NSNumber numberWithInteger:recordId],
                                @"businessId":[UserInfo getUserId],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{
                     @"data":aesString,
                     //@"Version":[Tools getApplicationVersion],
                     };
    }
    AFHTTPRequestOperation * operation = [[self _manager] POST:urlstring parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:waitingProcess];
        NSLog(@"%@",responseObject);
        NSInteger status = [responseObject[@"status"] integerValue];
        NSString * message = responseObject[@"message"];
        NSDictionary * result = responseObject[@"result"];
        if (1 == status) {
            if (isCanUseObj(result)) {
                ExpensesDetailVC * edvc = [[ExpensesDetailVC alloc] initWithNibName:@"ExpensesDetailVC" bundle:nil];
                edvc.detailInfo = result;
                [self.navigationController pushViewController:edvc animated:YES];
            }else{
                //
            }
        }else{
            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:waitingProcess];

    }];
    return operation;
}


#pragma mark - billTypeS
- (NSArray *)_BS_getBillTypesWithType:(BS_RecordType)type{
    if (_allBillTypes.count > 0) {
        NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
        RecordTypeModel * allTp = [[RecordTypeModel alloc] init];
        allTp.code = 0;
        allTp.desc = @"全部";
        allTp.type = type;
        allTp.selected = (0 == _currentTypeSub)?YES:NO;
        [array addObject:allTp];
        for (RecordTypeModel * atype in _allBillTypes) {
            atype.selected = (atype.code == _currentTypeSub)?YES:NO;
            if (BS_RecordTypeAll == type) {
                [array addObject:atype];
            }else if (BS_RecordTypeOut == type){
                if (atype.type == BS_RecordTypeOut) {
                    [array addObject:atype];
                }
            }else if (BS_RecordTypeIn == type){
                if (atype.type == BS_RecordTypeIn) {
                    [array addObject:atype];
                }
            }

        }
        return array;
    }else{
        return nil;
    }
}


#pragma mark - 筛选日账单搜索类型

- (void)typeButtonAction:(UIButton *)typeButton{
    //  必然是日账单了
    for (UIButton * subBtn in _callOutBillTypeView.subviews) {
        [subBtn setSelected:NO];
    }
    [typeButton setSelected:YES];
    NSInteger idx = typeButton.tag;
    RecordTypeModel * selectedType = [_currentBillTypes objectAtIndex:idx];
    //_currentType = selectedType.type;
    _currentTypeSub = selectedType.code;
    //
    [self getbilllistDayb:[self.currentDate dateToStringWithFormat:KMCalendarDatePrintFormat] billType:_currentType recordType:_currentTypeSub pullDown:YES];
    
    [self bsRightNavAction:self.rightBtn];

}



#pragma mark - KMMonthDateCalendarViewDelegate calendar
- (void)calendarView:(KMMonthDateCalendarView *)calendarView didStopChangeDate:(NSDate *)date dateString:(NSString *)dateString{
    _currentPage = 1;
    _currentDate = date;
    if (EDSBillStatisticsVCStyleDay == calendarView.style) {
        [self getbilllistDayb:dateString billType:_currentType recordType:_currentTypeSub pullDown:YES];
    }else if (EDSBillStatisticsVCStyleMonth == calendarView.style){
        [self getbilllistMonthbWithMonth:dateString pullDown:YES];
    }
}

- (void)calendarView:(KMMonthDateCalendarView *)calendarView SwitchToType:(EDSBillStatisticsVCStyle)style dateString:(NSString *)dateString{
    
}

- (void)calendarViewDidStartChangeDate:(KMMonthDateCalendarView *)calendarView{
    
}


#pragma mark - 空订单的情况
- (void)_showBSEmptyBillView{
    if (!_emptyBillImg) {
        // 61 * 61
        _emptyBillImg = [[UIImageView alloc] initWithFrame:CGRectZero];
        _emptyBillImg.image = [UIImage imageNamed:@"gray_icon"];
        _emptyBillImg.frame = CGRectMake(0, 0, 61, 61);
    }
    if (!_emptyBillTextLbl) {
        _emptyBillTextLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 20)];
        _emptyBillTextLbl.backgroundColor = [UIColor clearColor];
        _emptyBillTextLbl.text = BS_EmptyBillText;
        _emptyBillTextLbl.font = [UIFont systemFontOfSize:15];
        _emptyBillTextLbl.textAlignment = NSTextAlignmentCenter;
        _emptyBillTextLbl.textColor = LightGrey;
        
    }
    CGFloat tvHeight = ScreenHeight - 240;
    CGPoint imgCenter = CGPointMake(ScreenWidth/2, tvHeight/2);
    _emptyBillImg.center = imgCenter;
    [self.BS_TableView addSubview:_emptyBillImg];
    _emptyBillTextLbl.frame = CGRectMake(0, CGRectGetMaxY(_emptyBillImg.frame) + 10, ScreenWidth, 20) ;
    [self.BS_TableView addSubview:_emptyBillTextLbl];
    
}

- (void)_removeBSEmptyBillView{
    if (_emptyBillImg) {
        [_emptyBillImg removeFromSuperview];
        [_emptyBillTextLbl removeFromSuperview];
    }
}

@end
