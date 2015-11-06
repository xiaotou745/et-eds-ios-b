//
//  EDSMyClientersVC.m
//  ESend
//
//  Created by 台源洪 on 15/11/5.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSMyClientersVC.h"
#import "EDSMyClienterCell.h"
#import "MJRefresh.h"
#import "EDSHttpReqManager3.h"

#define MC_HeadButtonTagTrans 1105

#define MC_Table_1st_cellId @"MC_Table_1st_cellId"
#define MC_Table_2nd_cellId @"MC_Table_2nd_cellId"

#define MC_NoDataS1 @"您目前没有服务中的骑士!"
#define MC_NoDataS2 @"您目前没有申请中的骑士!"

@interface EDSMyClientersVC ()<UITableViewDataSource,UITableViewDelegate,EDSMyClienterCellDelegate>
{
    MyClienterStatus _selectedStatus;
    
    AFHTTPRequestOperation *_operation;
    // 订单为空的=1
    UIImageView * _logoImgEmpty1;
    UIImageView * _logoImgEmpty2;
    // 订单为空label s
    UILabel * _markedWordsLbl1;
    UILabel * _markedWordsLbl2;
    
    /// 分页
    NSInteger _currentPage1st;  //  服务中 分页页码
    NSInteger _currentPage2nd;  //  申请中 分页页码
}
// optionView
@property (strong, nonatomic) IBOutlet UIView *MC_OptionBg;
@property (strong, nonatomic) IBOutlet UIButton *MC_OptionBtn1;
@property (strong, nonatomic) IBOutlet UIButton *MC_OptionBtn2;
@property (strong, nonatomic) IBOutlet UIImageView *MC_OptionSeparator;
@property (strong, nonatomic) IBOutlet UIImageView *MC_OptionIndicator;
// tables
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *MC_HorizonScrollWidth;
@property (strong, nonatomic) IBOutlet UITableView *MC_Table1;
@property (strong, nonatomic) IBOutlet UITableView *MC_Table2;
@property (strong, nonatomic) IBOutlet UIScrollView *MC_HorizonScroller;
// dataSource
@property (nonatomic, strong) NSMutableArray * MC_TableDatasource1;
@property (nonatomic, strong) NSMutableArray * MC_TableDatasource2;

@end

@implementation EDSMyClientersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"我的骑士";
    // default data
    _selectedStatus = MyClienterStatusInService;
    _MC_TableDatasource1 = [[NSMutableArray alloc] initWithCapacity:0];
    _MC_TableDatasource2 = [[NSMutableArray alloc] initWithCapacity:0];
    _currentPage1st = 1;
    _currentPage2nd = 1;
    
    [self mc_configOptionView];
    [self _configOptionPullRefresh:self.MC_Table1];
    [self _configOptionPullRefresh:self.MC_Table2];
}

#pragma mark - Config Refresh Setting
- (void)_configOptionPullRefresh:(UITableView *)tabler
{
    // 添加动画图片的下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    if (tabler == self.MC_Table1) {
        [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(_refreshOptionActionMC)];
    }else if (tabler == self.MC_Table2) {
        [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(_refreshOptionActionMC)];
    }
    // 隐藏时间
    tabler.header.updatedTimeHidden = YES;
    // 隐藏状态
    tabler.header.stateHidden = YES;
    // 设置普通状态的动画图片
    NSMutableArray *idleImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
        [idleImages addObject:image];
    }
    [tabler.gifHeader setImages:idleImages forState:MJRefreshHeaderStateIdle];
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=2; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%lu", (unsigned long)i]];
        [refreshingImages addObject:image];
    }
    [tabler.gifHeader setImages:refreshingImages forState:MJRefreshHeaderStateRefreshing];
}

- (void)mc_configOptionView{
    self.MC_OptionSeparator.backgroundColor = BackgroundColor;
    
    // optionView  buttons
    self.MC_OptionBtn1.tag = 1 + MC_HeadButtonTagTrans;
    self.MC_OptionBtn2.tag = 0 + MC_HeadButtonTagTrans;
    
    [self setOptionButton:self.MC_OptionBtn1 count:0];
    [self setOptionButton:self.MC_OptionBtn2 count:0];
    
    self.MC_OptionBtn1.titleLabel.font =
    self.MC_OptionBtn2.titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    self.MC_OptionBtn1.backgroundColor =
    self.MC_OptionBtn2.backgroundColor = [UIColor whiteColor];
    
    self.MC_OptionIndicator.backgroundColor = BlueColor;
}
- (void)setOptionButton:(UIButton *)btn count:(long)count{
    NSString * tCount = (count>99)?[NSString stringWithFormat:@"99+"]:[NSString stringWithFormat:@"%ld",count];
    NSString * text = nil;
    if (btn.tag == 1 + MC_HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"服务中(%@)",tCount];
    }else if (btn.tag == 0 + MC_HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"申请中(%@)",tCount];
    }
    
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [AttributedString addAttribute:NSForegroundColorAttributeName value:DeepGrey range:NSMakeRange(0,AttributedString.length)];
    [btn setAttributedTitle:AttributedString forState:UIControlStateNormal];
    
    NSMutableAttributedString * hightedAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [hightedAttributedString addAttribute:NSForegroundColorAttributeName value:BlueColor range:NSMakeRange(0, hightedAttributedString.length)];
    [btn setAttributedTitle:hightedAttributedString forState:UIControlStateDisabled];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIButton * abtn = (UIButton *)[self.view viewWithTag:_selectedStatus + MC_HeadButtonTagTrans];
    [self optionButtonAction:abtn];
    
    if (_selectedStatus == MyClienterStatusInService) {
        [self.MC_Table1.header beginRefreshing];
    }else if (_selectedStatus == MyClienterStatusApplying){
        [self.MC_Table2.header beginRefreshing];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.MC_HorizonScrollWidth.constant = ScreenWidth * 2;
}


#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat delta = ScreenWidth/4;
    if (scrollView == self.MC_HorizonScroller) {
        CGFloat movCenterY = self.MC_OptionIndicator.center.y;
        CGFloat newCenterX = scrollView.contentOffset.x/2 + delta;
        self.MC_OptionIndicator.center = CGPointMake(newCenterX, movCenterY);
        [self _configScrollOffSetPropertys:scrollView.contentOffset.x];
    }
}

- (void)_configScrollOffSetPropertys:(CGFloat)x{
    self.MC_OptionBtn1.enabled = (x == 0)?NO:YES;
    self.MC_Table1.scrollsToTop = !self.MC_OptionBtn1.enabled;
    self.MC_OptionBtn2.enabled = (x == ScreenWidth)?NO:YES;
    self.MC_Table2.scrollsToTop = !self.MC_OptionBtn2.enabled;
    
    if (0 == x) {
        _selectedStatus = MyClienterStatusInService;
        if (self.MC_Table1.header.state != MJRefreshHeaderStateRefreshing) {
            [self.MC_Table1.header beginRefreshing];
        }
    }else if (ScreenWidth == x){
        _selectedStatus = MyClienterStatusApplying;
        if (self.MC_Table2.header.state != MJRefreshHeaderStateRefreshing) {
            [self.MC_Table2.header beginRefreshing];
        }
    }
}

- (IBAction)optionButtonAction:(UIButton *)sender {
    [self _buttonEventWithSender:sender];
}

- (void)_enableHeadBtns{
    self.MC_OptionBtn1.enabled = YES;
    self.MC_OptionBtn2.enabled = YES;
}

- (void)_buttonEventWithSender:(UIButton *)sender{
    [self _enableHeadBtns];
    sender.enabled = NO;
    // 1-0;  0-1;
    [self.MC_HorizonScroller setContentOffset:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds])*(((sender.tag - 1 - MC_HeadButtonTagTrans)==0)?0:1), 0) animated:YES];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.MC_Table1) {
        return _MC_TableDatasource1.count;
    }else if (tableView == self.MC_Table2) {
        return _MC_TableDatasource2.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.MC_Table1) { // 服务中.
        EDSMyClienterCell *cell = [tableView dequeueReusableCellWithIdentifier:MC_Table_1st_cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EDSMyClienterCell class]) owner:self options:nil] lastObject];
        }
        cell.datasource = [_MC_TableDatasource1 objectAtIndex:indexPath.row];
        cell.buttonTitle = EDSMyClienterInService;
        cell.delegate = self;
        return cell;
    }else if (tableView == self.MC_Table2) {  // 申请中..
        EDSMyClienterCell *cell = [tableView dequeueReusableCellWithIdentifier:MC_Table_2nd_cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EDSMyClienterCell class]) owner:self options:nil] lastObject];
        }
        cell.datasource = [_MC_TableDatasource2 objectAtIndex:indexPath.row];
        cell.buttonTitle = EDSMyClienterApplyingAdd;
        cell.buttonTitle2 = EDSMyClienterApplyingReject;
        cell.delegate = self;
        return cell;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


#pragma mark - API 
/// 下拉
- (void)_refreshOptionActionMC{
    if (_operation) {
        [_operation cancel];
        _operation = nil;
    }
    if (_selectedStatus == MyClienterStatusInService) {
        // 重置上拉加载的页码
        _currentPage1st = 1;
        [self.MC_Table2.header endRefreshing];
    }else if (_selectedStatus == MyClienterStatusApplying) {
        _currentPage2nd = 1;
        [self.MC_Table1.header endRefreshing];
    }
    NSDictionary * paraData = @{
                                @"businessId":[NSNumber numberWithInt:260],//[UserInfo getUserId],
                                @"auditStatus":[NSString stringWithFormat:@"%ld",(long)_selectedStatus],
                                @"currentPage":[NSNumber numberWithInteger:1],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraData];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraData = @{@"data":aesString,};
    }
    _operation = [EDSHttpReqManager3 getmyserviceclienters:paraData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_selectedStatus == MyClienterStatusInService) {
            [self.MC_Table1.header endRefreshing];
        }else if (_selectedStatus == MyClienterStatusApplying) {
            [self.MC_Table2.header endRefreshing];
        }
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSDictionary * result = [responseObject objectForKey:@"result"];
            long serviceCount = [[result objectForKey:@"serviceCount"] longValue];
            long waitAduitCount = [[result objectForKey:@"waitAduitCount"] longValue];
            [self setOptionButton:self.MC_OptionBtn1 count:serviceCount];
            [self setOptionButton:self.MC_OptionBtn2 count:waitAduitCount];
            NSArray * orderRespModel = [result objectForKey:@"list"];
            
            if (_selectedStatus == MyClienterStatusInService) {
                [_MC_TableDatasource1 removeAllObjects];
                for (NSDictionary * aRespModel in orderRespModel) {
                    EDSMyClienter * regioinModel = [[EDSMyClienter alloc] initWithDic:aRespModel];
                    [_MC_TableDatasource1 addObject:regioinModel];
                }
                // empty
                if (_MC_TableDatasource1.count == 0) {
                    [self _showTableEmpty:_MC_Table1];
                }else{
                    [self _hideTableEmpty:_MC_Table1];
                }
                [_MC_Table1 reloadData];
                // footer refresh
//                if (_TLIR_DataSourceFirst.count >= TLIR_Default_PageSize) {
//                    if (self.TLIR_TableFirst.footer) {
//                        [self.TLIR_TableFirst removeFooter];
//                    }
//                    [self.TLIR_TableFirst addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(tlir_tableViewFooterRefresh)];
//                    self.TLIR_TableFirst.footer.state = MJRefreshFooterStateIdle;
//                }
                
            }else if (_selectedStatus == MyClienterStatusApplying){
                [_MC_TableDatasource2 removeAllObjects];
                for (NSDictionary * aRespModel in orderRespModel) {
                    EDSMyClienter * regioinModel = [[EDSMyClienter alloc] initWithDic:aRespModel];
                    [_MC_TableDatasource2 addObject:regioinModel];
                }
                if (_MC_TableDatasource2.count == 0) {
                    [self _showTableEmpty:_MC_Table2];
                }else{
                    [self _hideTableEmpty:_MC_Table2];
                }
                [_MC_Table2 reloadData];
//                if (_TLIR_DataSourceSecond.count >= TLIR_Default_PageSize) {
//                    if (self.TLIR_TableSecond.footer) {
//                        [self.TLIR_TableSecond removeFooter];
//                    }
//                    [self.TLIR_TableSecond addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(tlir_tableViewFooterRefresh)];
//                    self.TLIR_TableSecond.footer.state = MJRefreshFooterStateIdle;
//                }
            }
        }else{
            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_selectedStatus == MyClienterStatusInService) {
            [self.MC_Table1.header endRefreshing];
        }else if (_selectedStatus == MyClienterStatusApplying) {
            [self.MC_Table2.header endRefreshing];
        }
    }];
}

#pragma mark - 订单为空的情况
- (void)_showTableEmpty:(UITableView *)tableV{
    if (tableV == self.MC_Table1) {
        if (!_logoImgEmpty1) {
            _logoImgEmpty1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
            _logoImgEmpty1.backgroundColor = [UIColor clearColor];
        }
        _logoImgEmpty1.image = [UIImage imageNamed:@"checkLogo"];
        _logoImgEmpty1.center = CGPointMake(ScreenWidth/2, (ScreenHeight-50-64)/3);
        [tableV addSubview:_logoImgEmpty1];
        if (!_markedWordsLbl1) {
            _markedWordsLbl1 = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgEmpty1) +Space_Big, ScreenWidth, 30)];
            _markedWordsLbl1.backgroundColor = [UIColor clearColor];
            _markedWordsLbl1.textAlignment = NSTextAlignmentCenter;
            _markedWordsLbl1.textColor     = DeepGrey;
            _markedWordsLbl1.font          = FONT_SIZE(BigFontSize);
        }
        _markedWordsLbl1.text = MC_NoDataS1;
        [tableV addSubview:_markedWordsLbl1];
    }else if (tableV == self.MC_Table2){
        if (!_logoImgEmpty2) {
            _logoImgEmpty2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
            _logoImgEmpty2.backgroundColor = [UIColor clearColor];
        }
        _logoImgEmpty2.image = [UIImage imageNamed:@"checkLogo"];
        _logoImgEmpty2.center = CGPointMake(ScreenWidth/2, (ScreenHeight-50-64)/3);
        [tableV addSubview:_logoImgEmpty2];
        if (!_markedWordsLbl2) {
            _markedWordsLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgEmpty2) +Space_Big, ScreenWidth, 30)];
            _markedWordsLbl2.backgroundColor = [UIColor clearColor];
            _markedWordsLbl2.textAlignment = NSTextAlignmentCenter;
            _markedWordsLbl2.textColor     = DeepGrey;
            _markedWordsLbl2.font          = FONT_SIZE(BigFontSize);
        }
        _markedWordsLbl2.text = MC_NoDataS2;
        [tableV addSubview:_markedWordsLbl2];
    }
}

- (void)_hideTableEmpty:(UITableView *)tableV{
    if (tableV == self.MC_Table1) {
        if (_logoImgEmpty1) {
            [_logoImgEmpty1 removeFromSuperview];
        }
        if (_markedWordsLbl1) {
            [_markedWordsLbl1 removeFromSuperview];
        }
    }else if (tableV == self.MC_Table2){
        if (_logoImgEmpty2) {
            [_logoImgEmpty2 removeFromSuperview];
        }
        if (_markedWordsLbl2) {
            [_markedWordsLbl2 removeFromSuperview];
        }
    }
}


#pragma mark - EDSMyClienterCellDelegate
- (void)clienterCell:(EDSMyClienterCell *)cell didClickTitle:(NSString *)title cellInfo:(EDSMyClienter *)userInfo{
    if ([title compare:EDSMyClienterInService] == NSOrderedSame) { // 解绑
        
    }else if ([title compare:EDSMyClienterApplyingAdd] == NSOrderedSame){ // 添加
        
    }else if ([title compare:EDSMyClienterApplyingReject] == NSOrderedSame){ // 拒绝
        
    }
}
@end
