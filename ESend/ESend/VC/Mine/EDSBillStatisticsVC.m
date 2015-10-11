//
//  EDSBillStatisticsVC.m
//  ESend
//
//  Created by 台源洪 on 15/9/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSBillStatisticsVC.h"
#import "KMMonthDateCalendarView.h"
#import "FHQNetWorkingAPI.h"
#import "KMNavigationTitleView.h"

#import "EDSBillStatisticsMonthCell.h"
#import "EDSBillStatisticsDayCell.h"

#import "Encryption.h"
#import "UserInfo.h"


#define BillStatisticsAPIHost @"http://10.8.7.253:7178/api-http/services/"

@interface EDSBillStatisticsVC ()<UITableViewDataSource,UITableViewDelegate>
{
    NSInteger _currentPage;
    
    double _inMoney;
    double _outMoney;
}
@property (strong, nonatomic) IBOutlet UIView *BS_OptionHeaderView;
@property (strong, nonatomic) IBOutlet UIView *BS_MidTitleBg;
@property (strong, nonatomic) IBOutlet UILabel *BS_MidTextV;
@property (strong, nonatomic) IBOutlet UITableView *BS_TableView;

@property (strong, nonatomic) KMNavigationTitleView * titleView;
@property (strong, nonatomic) KMMonthDateCalendarView * calendarView;

@property (assign, nonatomic) EDSBillStatisticsVCStyle style;

@property (strong, nonatomic) NSMutableArray * bills;

@end

@implementation EDSBillStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _currentPage = 1;
    _bills = [[NSMutableArray alloc] initWithCapacity:0];
    self.style = EDSBillStatisticsVCStyleDay;
    
    // titel view
    _titleView = [[KMNavigationTitleView alloc] initWithFrame:CGRectMake((ScreenWidth - 100)/2, 20, 100, 44)];
    _titleView.style = KMNavigationTitleViewStyleDay;
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
    
    UIButton * butn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 200, 44)];
    [self.BS_MidTitleBg addSubview:butn];
    [butn addTarget:self action:@selector(butnA:) forControlEvents:UIControlEventTouchUpInside];
    
    //
    [self getrecordtypeb];
}

- (void)butnA:(id)sender{
    if (_titleView.style == KMNavigationTitleViewStyleMonth) {
        _titleView.style = KMNavigationTitleViewStyleDay;

    }else{
        _titleView.style = KMNavigationTitleViewStyleMonth;

    }
}

- (KMMonthDateCalendarView *)calendarView{
    if (!_calendarView) {
        _calendarView = [[KMMonthDateCalendarView alloc] initWithFrame:CGRectMake(0, 50+64, ScreenWidth, KMMonthDateCalenderViewHeight)];
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
    NSString * urlstring = [NSString stringWithFormat:@"%@common/getrecordtypeb",BillStatisticsAPIHost];
    AFHTTPRequestOperation * operation = [[self _manager] POST:urlstring parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        // 系统错误 -1
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    return operation;
}

// 加密？
/// 1.1.2商户获取月账单(java必须大小写符合) // getbilllistb
- (AFHTTPRequestOperation *)getbilllistMonthbWithMonth:(NSString *)monthString{
    NSString * urlstring = [NSString stringWithFormat:@"%@accountbill/getbilllistb",BillStatisticsAPIHost];
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
    NSString * urlstring = [NSString stringWithFormat:@"%@accountbill/getbilllistdayb",BillStatisticsAPIHost];
    
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
    NSString * urlstring = [NSString stringWithFormat:@"%@accountbill/getbilldetailb",BillStatisticsAPIHost];
    
    NSDictionary * paraDict = @{
                                @"recordId":[NSNumber numberWithInteger:recordId],
                                @"businessId":[UserInfo getUserId],
                                };
    
    AFHTTPRequestOperation * operation = [[self _manager] POST:urlstring parameters:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    return operation;
}

@end
