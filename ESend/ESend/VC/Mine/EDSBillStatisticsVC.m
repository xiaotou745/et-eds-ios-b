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
#import "KMNavigationTitleView.h"
#import "EDSBillStatisticsMonthCell.h"
#import "EDSBillStatisticsDayCell.h"
#import "Encryption.h"
#import "UserInfo.h"
#import "RecordTypeModel.h"

#define BS_OptionTypeBtnTitleAll @"全部"
#define BS_OptionTypeBtnTitleOut @"出账"
#define BS_OptionTypeBtnTitleIn @"入账"

#define BS_BillTypeSwitchTitleMonth @"切换到日"
#define BS_BillTypeSwitchTitleDay @"切换到月"

#define BS_ColorGray @"666666"
#define BS_ColorBlue @"00bcd5"


// #define BillStatisticsAPIHost @"http://10.8.7.253:7178/api-http/services/"

@interface EDSBillStatisticsVC ()<UITableViewDataSource,UITableViewDelegate,KMNavigationTitleViewDelegate,KMMonthDateCalendarViewDelegate>
{
    NSInteger _currentPage;
    
    double _inMoney;
    double _outMoney;
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

@property (strong, nonatomic) KMNavigationTitleView * titleView;
@property (strong, nonatomic) KMMonthDateCalendarView * calendarView;

@property (assign, nonatomic) EDSBillStatisticsVCStyle style;

@property (strong, nonatomic) NSMutableArray * bills;

// typeDataSource
@property (strong, nonatomic) NSMutableArray * allBillTypes;
@property (strong, nonatomic) NSMutableArray * outBillTypes;
@property (strong, nonatomic) NSMutableArray * inBillTypes;

@end

@implementation EDSBillStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // data alloc
    _currentPage = 1;
    _bills = [[NSMutableArray alloc] initWithCapacity:0];
    _allBillTypes = [[NSMutableArray alloc] initWithCapacity:0];
    _outBillTypes = [[NSMutableArray alloc] initWithCapacity:0];
    _inBillTypes = [[NSMutableArray alloc] initWithCapacity:0];
    
#pragma mark - type
    self.style = EDSBillStatisticsVCStyleDay;
    
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
    
    [self.BS_billTypeSwither setTitle:BS_BillTypeSwitchTitleMonth forState:UIControlStateNormal];
    [self.BS_billTypeSwither setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.BS_billTypeSwither setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];

    // indicator
    self.BS_billTypeIndicator.backgroundColor = [UIColor km_colorWithHexString:BS_ColorBlue];
    
    // titel view
    _titleView = [[KMNavigationTitleView alloc] initWithFrame:CGRectMake((ScreenWidth - 100)/2, 20, 100, 44)];
    _titleView.style = KMNavigationTitleViewStyleDay;
    _titleView.delegate = self;
    [self.navBar addSubview:_titleView];
    
    // option view
    self.BS_OptionHeaderView.layer.masksToBounds = YES;
    self.BS_OptionHeaderView.layer.borderColor = [BackgroundColor CGColor];
    self.BS_OptionHeaderView.layer.borderWidth = 1.0f;
    // middle title
    self.BS_MidTitleBg.backgroundColor = BackgroundColor;
    self.BS_MidTextV.backgroundColor = [UIColor clearColor];
    self.BS_MidTextV.font = [UIFont systemFontOfSize:BigFontSize];
    [self.view addSubview:self.calendarView];
    //
    [self getrecordtypeb];
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


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _bills.count;
//    if (self.style == EDSBillStatisticsVCStyleDay) {
//        return _dayBills.count;
//    }else if (self.style == EDSBillStatisticsVCStyleMonth){
//        return _monthBills.count;
//    }else{
//        return 0;
//    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.style == EDSBillStatisticsVCStyleDay) {
        static NSString * dayBillStatisticsCellId = @"dayBillStatisticsCellId";
        EDSBillStatisticsDayCell * cell = [tableView dequeueReusableCellWithIdentifier:dayBillStatisticsCellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EDSBillStatisticsDayCell" owner:self options:nil] objectAtIndex:0];
        }
        return cell;
    }else if (self.style == EDSBillStatisticsVCStyleMonth){
        static NSString * monthBillStatisticsCellId = @"monthBillStatisticsCellId";
        EDSBillStatisticsMonthCell * cell = [tableView dequeueReusableCellWithIdentifier:monthBillStatisticsCellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"EDSBillStatisticsMonthCell" owner:self options:nil] objectAtIndex:0];
        }
        return cell;
    }else{
        return nil;
    }
}


#pragma mark - option button action

- (IBAction)allBillTypeAction:(UIButton *)sender {
    [self _BS_buttonEventWithSender:sender];
}

- (IBAction)outBillTypeAction:(UIButton *)sender {
    [self _BS_buttonEventWithSender:sender];

}

- (IBAction)inBillTypeAction:(UIButton *)sender {
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
//    [self.Hp_ListMainScroller setContentOffset:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds])*(sender.tag - 1 - HeadButtonTagTrans), 0) animated:YES];
    CGFloat movCenterY = self.BS_billTypeIndicator.center.y;
    CGFloat newCenterX = sender.center.x;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.BS_billTypeIndicator.center = CGPointMake(newCenterX, movCenterY);

    } completion:^(BOOL finished) {
        
    }];
}

- (IBAction)monthDaySwitchAction:(UIButton *)sender {
    if ([sender.currentTitle isEqualToString:BS_BillTypeSwitchTitleMonth]) {    // 切换到日
        [sender setTitle:BS_BillTypeSwitchTitleDay forState:UIControlStateNormal];
        _calendarView.style = KMMonthDateCalendarViewStyleDate;
    }else{  // 切换到月
        [sender setTitle:BS_BillTypeSwitchTitleMonth forState:UIControlStateNormal];
        _calendarView.style = KMMonthDateCalendarViewStyleMonth;
    }
    
    if (_titleView.style == KMNavigationTitleViewStyleMonth) {
        _titleView.style = KMNavigationTitleViewStyleDay;
    }else{
        _titleView.style = KMNavigationTitleViewStyleMonth;
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

// 加密？
/// 1.1.2商户获取月账单(java必须大小写符合) // getbilllistb
- (AFHTTPRequestOperation *)getbilllistMonthbWithMonth:(NSString *)monthString{
    NSString * urlstring = [NSString stringWithFormat:@"%@accountbill/getbilllistb",Java_API_SERVER];
    NSDictionary * paraDict = @{
                                @"monthInfo":monthString,
                                @"businessId":[UserInfo getUserId],
                                    };
    
    AFHTTPRequestOperation * operation = [[self _manager] POST:urlstring parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    return operation;
}

/// 1.1.3商户获取日账单(java必须大小写符合)
- (AFHTTPRequestOperation *)getbilllistDayb:(NSString *)dayString
                                   billType:(NSInteger)billType
                                 recordType:(NSInteger)recordType
{
    NSString * urlstring = [NSString stringWithFormat:@"%@accountbill/getbilllistdayb",Java_API_SERVER];
    
    NSDictionary * paraDict = @{
                                @"dayInfo":dayString,
                                @"businessId":[UserInfo getUserId],
                                @"billType":[NSNumber numberWithInteger:billType],
                                @"recordType":[NSNumber numberWithInteger:recordType],
                                @"currentPage":[NSNumber numberWithInteger:_currentPage],
                                };
    
    AFHTTPRequestOperation * operation = [[self _manager] POST:urlstring parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    return operation;
}

/// 1.1.4商户获取账单详情(java必须大小写符合)//getbilldetailb
- (AFHTTPRequestOperation *)getbilldetailbWithRecordId:(NSInteger)recordId
{
    NSString * urlstring = [NSString stringWithFormat:@"%@accountbill/getbilldetailb",Java_API_SERVER];
    
    NSDictionary * paraDict = @{
                                @"recordId":[NSNumber numberWithInteger:recordId],
                                @"businessId":[UserInfo getUserId],
                                };
    
    AFHTTPRequestOperation * operation = [[self _manager] POST:urlstring parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    return operation;
}


#pragma mark - billTypeS
- (NSArray *)_BS_getAllBillTypes{
    if (_allBillTypes.count > 0) {
        NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
        RecordTypeModel * allTp = [[RecordTypeModel alloc] init];
        allTp.code = 0;
        allTp.desc = @"全部";
        allTp.type = BS_RecordTypeAll;
        allTp.selected = YES;
        [array addObject:allTp];
        for (RecordTypeModel * atype in _allBillTypes) {
            atype.selected = NO;
            [array addObject:atype];
        }
        return array;
    }else{
        return nil;
    }
}

/// 获得所有出账类型
- (NSArray *)_BS_getOutBillTypes{
    if (_allBillTypes.count > 0) {
        NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
        RecordTypeModel * allTp = [[RecordTypeModel alloc] init];
        allTp.code = 0;
        allTp.desc = @"全部";
        allTp.type = BS_RecordTypeOut;
        allTp.selected = YES;
        [array addObject:allTp];
        for (RecordTypeModel * atype in _allBillTypes) {
            if (atype.type == BS_RecordTypeOut) {
                atype.selected = NO;
                [array addObject:atype];
            }
        }
        return array;
    }else{
        return nil;
    }
}

/// 获得所有入账类型
- (NSArray *)_BS_getInBillTypes{
    if (_allBillTypes.count > 0) {
        NSMutableArray * array = [[NSMutableArray alloc] initWithCapacity:0];
        RecordTypeModel * allTp = [[RecordTypeModel alloc] init];
        allTp.code = 0;
        allTp.desc = @"全部";
        allTp.type = BS_RecordTypeIn;
        allTp.selected = YES;
        [array addObject:allTp];
        for (RecordTypeModel * atype in _allBillTypes) {
            if (atype.type == BS_RecordTypeIn) {
                atype.selected = NO;
                [array addObject:atype];
            }
        }
        return array;
    }else{
        return nil;
    }
}

#pragma mark - KMNavigationTitleViewDelegate   title回调
- (void)KMNavigationTitleView:(KMNavigationTitleView *)view shouldHideContentView:(KMNavigationTitleViewOptionType)optionType typeId:(NSInteger)typeId{
    
}

- (void)KMNavigationTitleView:(KMNavigationTitleView *)view shouldShowContentView:(KMNavigationTitleViewOptionType)ot typeId:(NSInteger)tid{
    // show
}





#pragma mark - KMMonthDateCalendarViewDelegate calendar
- (void)calendarView:(KMMonthDateCalendarView *)calendarView didStopChangeDate:(NSDate *)date dateString:(NSString *)dateString{
    NSLog(@"ds:%@",dateString);
}

- (void)calendarView:(KMMonthDateCalendarView *)calendarView SwitchToType:(KMMonthDateCalendarViewStyle)style dateString:(NSString *)dateString{
    NSLog(@"dss:%@",dateString);
}

- (void)calendarViewDidStartChangeDate:(KMMonthDateCalendarView *)calendarView{
    // non
}

@end
