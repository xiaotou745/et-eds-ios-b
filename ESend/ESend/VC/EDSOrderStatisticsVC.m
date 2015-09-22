//
//  EDSOrderStatisticsVC.m
//  ESend
//
//  Created by 台源洪 on 15/9/15.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "EDSOrderStatisticsVC.h"
#import "EDSAttachedRiderCell.h"
#import "UserInfo.h"
#import "FHQNetWorkingAPI.h"
#import "EDSStatisticsInfoModel.h"

#import "EDSRiderDelieveListVC.h"
#import "EDSMerchantReleaseTaskListVC.h"

#import "MNDatePicker.h"


#define OS_ORDER_CELL_HEADER_HEIGHT 50.0f
#define OS_ORDER_CELL_HEADER_CONTENT_HEIGHT 40.0f

#define OS_ORDER_CELL_HEIGHT 74.0f

@interface EDSOrderStatisticsVC ()<UITableViewDataSource,UITableViewDelegate,MNDatePicerDelegate>
{
    long _orderCount;                   // 订单数量
    double _totalAmount;                // 订单金额
    long _serviceClienterCount;         // 服务骑士数量

}
// header
@property (strong, nonatomic) IBOutlet UIView *OS_HeaderBg;
// date
@property (strong, nonatomic) IBOutlet UILabel *OS_Year;
@property (strong, nonatomic) IBOutlet UILabel *OS_Month;
@property (strong, nonatomic) IBOutlet UIImageView *OS_triangleIndicator;
@property (strong, nonatomic) IBOutlet UIButton *OS_YearMonthSelectBtn;

// order count
@property (strong, nonatomic) IBOutlet UILabel *OS_OrderCountFx;
@property (strong, nonatomic) IBOutlet UILabel *OS_OrderCount;

// order amount
@property (strong, nonatomic) IBOutlet UILabel *OS_OrderAmountFx;
@property (strong, nonatomic) IBOutlet UILabel *OS_OrderAmount;

// clienter count
@property (strong, nonatomic) IBOutlet UILabel *OS_ClienterCountFx;
@property (strong, nonatomic) IBOutlet UILabel *OS_ClienterCount;

@property (strong, nonatomic) MNDatePicker * datePicker;

// table
@property (strong, nonatomic) IBOutlet UITableView *OS_OrdersTable;

@property (strong, nonatomic) NSMutableArray * OS_OrdersData;

// ob
@property (nonatomic, copy) NSString * selectedYear;    // 选中年
@property (nonatomic, copy) NSString * selectedMonth;   // 选中月
@property (nonatomic, copy) NSString * selectedYearAndMonth;    // 选中年-月

@end

@implementation EDSOrderStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // datasource
    _OS_OrdersData = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self registerForKVO];
    
    self.titleLabel.text = @"订单统计";
    // header
    self.OS_Year.font =
    self.OS_OrderAmountFx.font =
    self.OS_OrderCountFx.font =
    self.OS_ClienterCountFx.font = [UIFont systemFontOfSize:BigFontSize];
    
    self.OS_Month.font =
    self.OS_OrderCount.font =
    self.OS_OrderAmount.font =
    self.OS_ClienterCount.font = [UIFont systemFontOfSize:BigFontSize];
    
    self.OS_Year.textColor =
    self.OS_Month.textColor =
    self.OS_OrderCountFx.textColor =
    self.OS_OrderAmountFx.textColor =
    self.OS_ClienterCountFx.textColor = DeepGrey;
    
    self.OS_OrderCount.textColor =
    self.OS_OrderAmount.textColor =
    self.OS_ClienterCount.textColor = TextColor6;
    
    // api
    [self getOrdersStatisticsWithTimeInfo:[self currentYearAndMonth]];
}

- (void)dealloc {
    [self unregisterFromKVO];
}


#pragma mark - register ob
- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"selectedYear", @"selectedMonth", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath{
    if ([keyPath isEqualToString:@"selectedYear"]) {
        self.OS_Year.text = [NSString stringWithFormat:@"%@年",self.selectedYear];
    }else if ([keyPath isEqualToString:@"selectedMonth"]){
        self.OS_Month.text = [NSString stringWithFormat:@"%@月",self.selectedMonth];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UITableViewDelegate,Datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    EDSStatisticsInfoModel * info = [_OS_OrdersData objectAtIndex:section];
    return info.serviceClienters.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _OS_OrdersData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * AR_TableCellIdentifier = @"AR_TableCellId";
    EDSAttachedRiderCell * cell = [tableView dequeueReusableCellWithIdentifier:AR_TableCellIdentifier];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"EDSAttachedRiderCell" owner:self options:nil] firstObject];
    }
    EDSStatisticsInfoModel * info = [_OS_OrdersData objectAtIndex:indexPath.section];
    cell.riderInfo = [info.serviceClienters objectAtIndex:indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return OS_ORDER_CELL_HEIGHT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return OS_ORDER_CELL_HEADER_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.OS_OrdersTable) { // section header
        
        EDSStatisticsInfoModel * info = [_OS_OrdersData objectAtIndex:section];
        
        UIView * header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, OS_ORDER_CELL_HEADER_HEIGHT)];
        header.backgroundColor = [UIColor whiteColor];
        
        UIView * headerTop = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
        headerTop.backgroundColor = BackgroundColor;
        [header addSubview:headerTop];
        
        UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 50, OS_ORDER_CELL_HEADER_CONTENT_HEIGHT)];
        name.backgroundColor = [UIColor clearColor];
        name.textAlignment = NSTextAlignmentLeft;
        name.textColor = DeepGrey;
        name.text = info.dateInfo;
        name.font = [UIFont systemFontOfSize:15.0f];
        [header addSubview:name];
        
        // 订单数量 80
        UILabel * orderCount = [[UILabel alloc] initWithFrame:CGRectMake(75, 10, 130, OS_ORDER_CELL_HEADER_CONTENT_HEIGHT)];
        NSString * infoCountString = nil;
        if (info.orderCount > 1000) {
            infoCountString = [NSString stringWithFormat:@"订单量 1000+"];
        }else {
            infoCountString = [NSString stringWithFormat:@"订单量 %ld",info.orderCount];
        }
        NSMutableAttributedString *content = [[NSMutableAttributedString alloc] initWithString:infoCountString];
        NSRange contentRange = {0, [content length]};
        if (info.orderCount > 0) {
            [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
        }
        [content addAttribute:NSForegroundColorAttributeName value:DeepGrey range:contentRange];
        [content addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15.0f] range:contentRange];
        orderCount.textAlignment = NSTextAlignmentLeft;
        //orderCount.textColor = DeepGrey;
        orderCount.attributedText = content;
        orderCount.backgroundColor = [UIColor clearColor];
        [header addSubview:orderCount];
        
        if (info.orderCount > 0) {
            UIButton * orderCountBtn = [[UIButton alloc] initWithFrame:CGRectMake(77, 10, 130, OS_ORDER_CELL_HEADER_CONTENT_HEIGHT)];
            [orderCountBtn setBackgroundColor:[UIColor clearColor]];
            orderCountBtn.tag = section;
            [orderCountBtn addTarget:self action:@selector(orderCountButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [header addSubview:orderCountBtn];
        }

        
        // 骑士数量 10
        float riderCountWidth = 80.0f;
        UILabel * riderCount = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 10 - riderCountWidth, 10, riderCountWidth, OS_ORDER_CELL_HEADER_CONTENT_HEIGHT)];
        riderCount.text = [NSString stringWithFormat:@"服务骑士 %ld",info.serviceClienterCount];
        riderCount.backgroundColor = [UIColor clearColor];
        riderCount.textAlignment = NSTextAlignmentRight;
        riderCount.textColor = DeepGrey;
        riderCount.font = [UIFont systemFontOfSize:15.0f];
        [header addSubview:riderCount];
        
        return header;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // monthDate
    EDSStatisticsInfoModel * info = [_OS_OrdersData objectAtIndex:indexPath.section];
    EDSRiderDelieveListVC * vc = [[EDSRiderDelieveListVC alloc] initWithNibName:@"EDSRiderDelieveListVC" bundle:nil];
    vc.dateInfo = info.monthDate;
    EDSStatisticsInfoClienterInfoModel * clienterInfo = [info.serviceClienters objectAtIndex:indexPath.row];
    vc.clienterId = [NSString stringWithFormat:@"%ld",clienterInfo.clienterId];
    vc.clienterName = clienterInfo.clienterName;
    vc.orderCount = [NSString stringWithFormat:@"%ld",clienterInfo.orderCount];
    [self.navigationController pushViewController:vc animated:YES];
}



#pragma mark - 订单量事件
- (void)orderCountButtonAction:(UIButton *)sender{
    
    NSLog(@"%ld",(long)sender.tag);
    EDSMerchantReleaseTaskListVC * vc = [[EDSMerchantReleaseTaskListVC alloc] initWithNibName:@"EDSMerchantReleaseTaskListVC" bundle:nil];
    EDSStatisticsInfoModel * info = [_OS_OrdersData objectAtIndex:sender.tag];
    vc.dateInfo = info.monthDate;
    vc.orderCount = [NSString stringWithFormat:@"%ld",info.orderCount];
    [self.navigationController pushViewController:vc animated:YES];


}


#pragma mark - API
- (void)getOrdersStatisticsWithTimeInfo:(NSString *)yearMonth{
    MBProgressHUD * waitingProcess = [Tools showProgressWithTitle:@""];
    
    NSDictionary *requstData = @{
                                 @"monthInfo" : yearMonth,
                                 @"businessId"  : [UserInfo getUserId],
                                 };
    
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:requstData];
        
        NSString * aesString = [Security AesEncrypt:jsonString2];
        
        requstData = @{
                     @"data":aesString,
                     //@"Version":[Tools getApplicationVersion],
                     };
    }
    [FHQNetWorkingAPI orderstatisticsb:requstData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        
        // NSLog(@"----=--=--===- %@",result);
        
        [Tools hiddenProgress:waitingProcess];
        _orderCount = [result getIntegerWithKey:@"orderCount"];
        _totalAmount = [[result objectForKey:@"totalAmount"] doubleValue];//amountFormatWithComma
        _serviceClienterCount = [result getIntegerWithKey:@"serviceClienterCount"];
        
        // arm it
        self.OS_OrderCount.text = [NSString stringWithFormat:@"%ld",_orderCount];
        NSString * amountString = [NSString stringWithFormat:@"%.2f",_totalAmount];
        self.OS_OrderAmount.text = [self amountFormatWithComma:amountString];
        self.OS_ClienterCount.text = [NSString stringWithFormat:@"%ld",_serviceClienterCount];
        
        [_OS_OrdersData removeAllObjects];
        
        NSArray * tempAry = [result getArrayWithKey:@"datas"];
        for (NSDictionary * tempDict in tempAry) {
            EDSStatisticsInfoModel * statistInfo = [[EDSStatisticsInfoModel alloc] initWithDic:tempDict];
//            if (statistInfo.orderCount > 0) {
//                [_OS_OrdersData addObject:statistInfo];
//            }
            [_OS_OrdersData addObject:statistInfo];

        }
        [self.OS_OrdersTable reloadData];
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:waitingProcess];

    }];

}

- (NSString *)currentYearAndMonth{
    NSDate * date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setDateFormat:@"yyyy"];
    NSString * year = [dateFormatter stringFromDate:localeDate];
    self.selectedYear = year;
    [dateFormatter setDateFormat:@"MM"];
    NSString * month = [dateFormatter stringFromDate:localeDate];
    self.selectedMonth = month;
    [dateFormatter setDateFormat:@"yyyy-MM"];
    return [dateFormatter stringFromDate:localeDate];
}

- (NSString *)amountFormatWithComma:(NSString *)amountString{
    
    if (amountString.length == 0) {
        return nil;
    }
    NSString * integerPart = [[amountString componentsSeparatedByString:@"."] objectAtIndex:0];
    NSString * floatPart = [[amountString componentsSeparatedByString:@"."] lastObject];
    NSUInteger integerLength = integerPart.length;
    if (integerLength <= 3) {
        return amountString;
    }
    
    int a = integerLength % 3;
    unsigned long b = integerLength / 3;
    NSString * head = [integerPart substringWithRange:NSMakeRange(0, a)];
    
    NSMutableString * resultString = [[NSMutableString alloc] init];
    [resultString appendString:head];
    for (int i = 0; i < b; i ++) {
        [resultString appendString:@","];
        NSRange range = NSMakeRange(a + i * 3, 3);
        [resultString appendString:[integerPart substringWithRange:range]];
    }
    [resultString appendString:@"."];
    [resultString appendString:floatPart];
    return resultString;
}

#pragma mark - button action
- (IBAction)yearMonthSelectAction:(UIButton *)sender {
    // self.OS_triangleIndicator.image = [UIImage imageNamed:@"triangle_up"];
    [self showDatePicker];
}

#pragma mark - datePicker
- (void)showDatePicker{
    [self dismissDatePicker];
    self.datePicker = [[MNDatePicker alloc] initWithDelegate:self year:_selectedYear month:_selectedMonth];
    [self.datePicker showInView:self.view];
}

- (void)dismissDatePicker{
    [self.datePicker cancelPicker];
    self.datePicker.delegate = nil;
    self.datePicker = nil;
}

- (void)MNDatePickerDidCancel:(MNDatePicker *)datePicker{
    self.OS_triangleIndicator.image = [UIImage imageNamed:@"triangle_down"];

}

- (void)MNDatePickerDidCompleteShowed:(MNDatePicker *)datePicker{
     self.OS_triangleIndicator.image = [UIImage imageNamed:@"triangle_up"];

}

- (void)MNDatePickerDidSelected:(MNDatePicker *)datePicker YearMonthString:(NSString *)yearMonth year:(NSString *)year month:(NSString *)month{
    NSLog(@"%@",yearMonth);
    self.selectedYear = year;
    self.selectedMonth = month;
    self.selectedYearAndMonth = yearMonth;
    
    [self getOrdersStatisticsWithTimeInfo:yearMonth];
    
//    NSLog(@"MNDatePickerDidSelected==%@",datePicker.datePicker.date);
//    NSString *dateString=[datePicker.datePicker.date description];
//    NSString *yearMonthDay=[[dateString componentsSeparatedByString:@" "]firstObject];
    
    // [self changeBirth:yearMonthDay];
    //    NSMutableArray *dateArr=(NSMutableArray *)[yearMonthDay componentsSeparatedByString:@"-"];
    //
    //    [dateArr insertObject:@"日" atIndex:dateArr.count];
    //    [dateArr insertObject:@"月" atIndex:dateArr.count-2];
    //    [dateArr insertObject:@"年" atIndex:dateArr.count-4];
    
}

@end
