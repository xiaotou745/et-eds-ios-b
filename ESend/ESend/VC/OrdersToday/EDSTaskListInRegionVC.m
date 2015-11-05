//
//  EDSTaskListInRegionVC.m
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSTaskListInRegionVC.h"
#import "EDSTaskListInRegionCell.h"
#import "EDSHttpReqManager3.h"
#import "MJRefresh.h"
#import "UserInfo.h"
#import "EDSOrderDetailFor9CellsVC.h"

#define TLIR_HeadButtonTagTrans 1104
#define TLIR_Table_1st_cellId @"TLIR_Table_1st_cellId"
#define TLIR_Table_2nd_cellId @"TLIR_Table_2nd_cellId"
#define TLIR_Table_3rd_cellId @"TLIR_Table_3rd_cellId"

#define TLIR_NoDataS1 @"您目前没有待取货的订单!"
#define TLIR_NoDataS2 @"您目前没有配送中的订单!"
#define TLIR_NoDataS3 @"您目前没有已完成的订单!"

#define TLIR_Default_PageSize  1

@interface EDSTaskListInRegionVC ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
{
    AFHTTPRequestOperation *_operation;
    // 订单为空的=1
    UIImageView * _logoImgEmpty1;
    UIImageView * _logoImgEmpty2;
    UIImageView * _logoImgEmpty3;
    // 订单为空label s
    UILabel * _markedWordsLbl1;
    UILabel * _markedWordsLbl2;
    UILabel * _markedWordsLbl3;

    /// 分页
    NSInteger _currentPage1st;  //  取货 分页页码
    NSInteger _currentPage2nd;  //  配送 分页页码
    NSInteger _currentPage3rd;  //  已完成 分页页码
    
    // operation 上拉
    AFHTTPRequestOperation * _operationUntakeOrder1st;
    AFHTTPRequestOperation * _operationTaking2nd;
    AFHTTPRequestOperation * _operationDelieving3st;

}
// header option
@property (strong, nonatomic) IBOutlet UIView *TLIR_OptionBgView;

@property (strong, nonatomic) IBOutlet UIButton *TLIR_OptionFirstBtn;
@property (strong, nonatomic) IBOutlet UIButton *TLIR_OptionSecondBtn;
@property (strong, nonatomic) IBOutlet UIButton *TLIR_OptionThirdBtn;

@property (strong, nonatomic) IBOutlet UIImageView *TLIR_OptionSeparator1;
@property (strong, nonatomic) IBOutlet UIImageView *TLIR_OptionSeparator2;

@property (strong, nonatomic) IBOutlet UIImageView *TLIR_OptionIndicator;

// tables
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TLIR_TableScrollerWidth;
@property (strong, nonatomic) IBOutlet UIScrollView *TLIR_HorizonScroller;

@property (strong, nonatomic) IBOutlet UITableView *TLIR_TableFirst;
@property (strong, nonatomic) IBOutlet UITableView *TLIR_TableSecond;
@property (strong, nonatomic) IBOutlet UITableView *TLIR_TableThird;

// dataSource
@property (strong, nonatomic) NSMutableArray * TLIR_DataSourceFirst;
@property (strong, nonatomic) NSMutableArray * TLIR_DataSourceSecond;
@property (strong, nonatomic) NSMutableArray * TLIR_DataSourceThird;

@end

@implementation EDSTaskListInRegionVC


//[self addObserver:self forKeyPath:@"orderCount" options:NSKeyValueObservingOptionNew context:NULL];

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _TLIR_DataSourceFirst = [[NSMutableArray alloc] initWithCapacity:0];
    _TLIR_DataSourceSecond = [[NSMutableArray alloc] initWithCapacity:0];
    _TLIR_DataSourceThird = [[NSMutableArray alloc] initWithCapacity:0];
    _currentPage1st = 1;  //  取货 分页页码
    _currentPage2nd = 1;  //  配送 分页页码
    _currentPage3rd = 1;  //  已完成 分页页码
    
    [self configOptionView];
    [self _configOptionPullRefresh:self.TLIR_TableFirst];
    [self _configOptionPullRefresh:self.TLIR_TableSecond];
    [self _configOptionPullRefresh:self.TLIR_TableThird];
}

#pragma mark - Config Refresh Setting
- (void)_configOptionPullRefresh:(UITableView *)tabler
{
    // 添加动画图片的下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    if (tabler == self.TLIR_TableFirst) {
        [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(_refreshOptionAction)];
    }else if (tabler == self.TLIR_TableSecond) {
        [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(_refreshOptionAction)];
    }else if (tabler == self.TLIR_TableThird) {
        [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(_refreshOptionAction)];
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

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.TLIR_TableScrollerWidth.constant = ScreenWidth * 3;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    UIButton * abtn = (UIButton *)[self.view viewWithTag:[self selectedIndexWithOrderStatus:self.selectedStatus] + TLIR_HeadButtonTagTrans];
    [self optionButtonAction:abtn];
    
    if (self.selectedStatus == OrderStatusAccepted) {
        [self.TLIR_TableFirst.header beginRefreshing];
    }else if (self.selectedStatus == OrderStatusReceive){
        [self.TLIR_TableSecond.header beginRefreshing];
    }else if (self.selectedStatus == OrderStatusComplete){
        [self.TLIR_TableThird.header beginRefreshing];
    }
    
    self.titleLabel.text = self.TLIR_Title;
}

/// 订单状态对应 筛选标签
- (NSInteger)selectedIndexWithOrderStatus:(OrderStatus)status{
    switch (status) {
        case OrderStatusAccepted:
            return 1;
            break;
        case OrderStatusReceive:
            return 2;
            break;
        case OrderStatusComplete:
            return 3;
            break;
        default:
            return 1;
            break;
    }
}

- (void)configOptionView{
    self.TLIR_OptionSeparator1.backgroundColor =
    self.TLIR_OptionSeparator2.backgroundColor = BackgroundColor;
    
    // optionView  buttons
    self.TLIR_OptionFirstBtn.tag = 1 + TLIR_HeadButtonTagTrans;
    self.TLIR_OptionSecondBtn.tag = 2 + TLIR_HeadButtonTagTrans;
    self.TLIR_OptionThirdBtn.tag = 3 + TLIR_HeadButtonTagTrans;
    
    //self.TLIR_OptionFirstBtn.enabled = NO;
    
    [self setOptionButton:self.TLIR_OptionFirstBtn count:0];
    [self setOptionButton:self.TLIR_OptionSecondBtn count:0];
    [self setOptionButton:self.TLIR_OptionThirdBtn count:0];
    
    self.TLIR_OptionFirstBtn.titleLabel.font =
    self.TLIR_OptionSecondBtn.titleLabel.font =
    self.TLIR_OptionThirdBtn.titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    self.TLIR_OptionFirstBtn.backgroundColor =
    self.TLIR_OptionSecondBtn.backgroundColor =
    self.TLIR_OptionThirdBtn.backgroundColor = [UIColor whiteColor];
    
    self.TLIR_OptionIndicator.backgroundColor = BlueColor;
}

//- (void)configTableViews{
//    [self.TLIR_TableFirst registerClass:[EDSTaskListInRegionCell class] forCellReuseIdentifier:TLIR_Table_1st_cellId];
//    [self.TLIR_TableSecond registerClass:[EDSTaskListInRegionCell class] forCellReuseIdentifier:TLIR_Table_2nd_cellId];
//    [self.TLIR_TableThird registerClass:[EDSTaskListInRegionCell class] forCellReuseIdentifier:TLIR_Table_3rd_cellId];
//}

- (void)setOptionButton:(UIButton *)btn count:(long)count{
    NSString * tCount = (count>99)?[NSString stringWithFormat:@"99+"]:[NSString stringWithFormat:@"%ld",count];
    NSString * text = nil;
    if (btn.tag == 1 + TLIR_HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"取货中(%@)",tCount];
    }else if (btn.tag == 2 + TLIR_HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"配送中(%@)",tCount];
    }else if (btn.tag == 3 + TLIR_HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"已完成(%@)",tCount];
    }
    
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [AttributedString addAttribute:NSForegroundColorAttributeName value:DeepGrey range:NSMakeRange(0,AttributedString.length)];
    [btn setAttributedTitle:AttributedString forState:UIControlStateNormal];
    
    NSMutableAttributedString * hightedAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [hightedAttributedString addAttribute:NSForegroundColorAttributeName value:BlueColor range:NSMakeRange(0, hightedAttributedString.length)];
    [btn setAttributedTitle:hightedAttributedString forState:UIControlStateDisabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat delta = ScreenWidth/6;
    if (scrollView == self.TLIR_HorizonScroller) {
        CGFloat movCenterY = self.TLIR_OptionIndicator.center.y;
        CGFloat newCenterX = scrollView.contentOffset.x/3 + delta;
        self.TLIR_OptionIndicator.center = CGPointMake(newCenterX, movCenterY);
        [self _configScrollOffSetPropertys:scrollView.contentOffset.x];
    }
}

- (void)_configScrollOffSetPropertys:(CGFloat)x{
    self.TLIR_OptionFirstBtn.enabled = (x == 0)?NO:YES;
    self.TLIR_TableFirst.scrollsToTop = !self.TLIR_OptionFirstBtn.enabled;
    self.TLIR_OptionSecondBtn.enabled = (x == ScreenWidth)?NO:YES;
    self.TLIR_TableSecond.scrollsToTop = !self.TLIR_OptionSecondBtn.enabled;
    self.TLIR_OptionThirdBtn.enabled = (x == ScreenWidth * 2)?NO:YES;
    self.TLIR_TableThird.scrollsToTop = !self.TLIR_OptionThirdBtn.enabled;

    if (0 == x) {
        self.selectedStatus = OrderStatusAccepted;
        if (self.TLIR_TableFirst.header.state != MJRefreshHeaderStateRefreshing) {
            [self.TLIR_TableFirst.header beginRefreshing];
        }
    }else if (ScreenWidth == x){
        self.selectedStatus = OrderStatusReceive;
        if (self.TLIR_TableSecond.header.state != MJRefreshHeaderStateRefreshing) {
            [self.TLIR_TableSecond.header beginRefreshing];
        }
    }else if (ScreenWidth * 2 == x){
        self.selectedStatus = OrderStatusComplete;
        if (self.TLIR_TableThird.header.state != MJRefreshHeaderStateRefreshing) {
            [self.TLIR_TableThird.header beginRefreshing];
        }
    }
}

- (IBAction)optionButtonAction:(UIButton *)sender {
    [self _buttonEventWithSender:sender];
    
}

- (void)_enableHeadBtns{
    self.TLIR_OptionFirstBtn.enabled = YES;
    self.TLIR_OptionSecondBtn.enabled = YES;
    self.TLIR_OptionThirdBtn.enabled = YES;
}

- (void)_buttonEventWithSender:(UIButton *)sender{
    [self _enableHeadBtns];
    sender.enabled = NO;
    [self.TLIR_HorizonScroller setContentOffset:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds])*(sender.tag - 1 - TLIR_HeadButtonTagTrans), 0) animated:YES];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.TLIR_TableFirst) {
        return _TLIR_DataSourceFirst.count;
    }else if (tableView == self.TLIR_TableSecond) {
        return _TLIR_DataSourceSecond.count;
    }else if (tableView == self.TLIR_TableThird) {
        return _TLIR_DataSourceThird.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.TLIR_TableFirst) { // 待接单
        EDSTaskListInRegionCell *cell = [tableView dequeueReusableCellWithIdentifier:TLIR_Table_1st_cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EDSTaskListInRegionCell class]) owner:self options:nil] lastObject];
        }
        cell.dataSrouce = [_TLIR_DataSourceFirst objectAtIndex:indexPath.row];
        return cell;
    }else if (tableView == self.TLIR_TableSecond) {  // 待取货
        EDSTaskListInRegionCell *cell = [tableView dequeueReusableCellWithIdentifier:TLIR_Table_2nd_cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EDSTaskListInRegionCell class]) owner:self options:nil] lastObject];
        }
        //[cell loadData:_Hp_ContentLists2nd[indexPath.section]];
        return cell;
    }else if (tableView == self.TLIR_TableThird) {  // 配送中
        EDSTaskListInRegionCell *cell = [tableView dequeueReusableCellWithIdentifier:TLIR_Table_3rd_cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EDSTaskListInRegionCell class]) owner:self options:nil] lastObject];
        }
        //[cell loadData:_Hp_ContentLists2nd[indexPath.section]];
        return cell;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 118;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    EDSOrderDetailFor9CellsVC * odf9c = [[EDSOrderDetailFor9CellsVC alloc] initWithNibName:NSStringFromClass([EDSOrderDetailFor9CellsVC class]) bundle:nil];
    TaskInRegionModel * regionModel = nil;
    if (_selectedStatus == OrderStatusAccepted) {
        regionModel = [_TLIR_DataSourceFirst objectAtIndex:indexPath.row];
    }else if (_selectedStatus == OrderStatusReceive) {
        regionModel = [_TLIR_DataSourceSecond objectAtIndex:indexPath.row];
    }else if (_selectedStatus == OrderStatusComplete) {
        regionModel = [_TLIR_DataSourceThird objectAtIndex:indexPath.row];
    }
    odf9c.grabOrderId = regionModel.grabOrderId;
    [self.navigationController pushViewController:odf9c animated:YES];
}


#pragma mark - API - 下拉
- (void)_refreshOptionAction{
    if (_operation) {
        [_operation cancel];
        _operation = nil;
    }
    if (_selectedStatus == OrderStatusAccepted) {
        // 重置上拉加载的页码
        _currentPage1st = 1;
        [self.TLIR_TableSecond.header endRefreshing];
        [self.TLIR_TableThird.header endRefreshing];
    }else if (_selectedStatus == OrderStatusReceive) {
        _currentPage2nd = 1;
        [self.TLIR_TableFirst.header endRefreshing];
        [self.TLIR_TableThird.header endRefreshing];
    }else if (_selectedStatus == OrderStatusComplete) {
        _currentPage3rd = 1;
        [self.TLIR_TableFirst.header endRefreshing];
        [self.TLIR_TableSecond.header endRefreshing];
    }
    NSDictionary * paraData = @{
                                @"businessId":[NSNumber numberWithInt:260],//[UserInfo getUserId],
                                @"status":[NSString stringWithFormat:@"%ld",(long)_selectedStatus],
                                @"currentPage":[NSNumber numberWithInteger:1],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraData];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraData = @{@"data":aesString,};
    }
    _operation = [EDSHttpReqManager3 businessGetmyorderb:paraData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_selectedStatus == OrderStatusAccepted) {
            [self.TLIR_TableFirst.header endRefreshing];
        }else if (_selectedStatus == OrderStatusReceive) {
            [self.TLIR_TableSecond.header endRefreshing];
        }else if (_selectedStatus == OrderStatusComplete) {
            [self.TLIR_TableThird.header endRefreshing];
        }
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSDictionary * result = [responseObject objectForKey:@"result"];
            long quHuoOrderCountTotal = [[result objectForKey:@"quHuoOrderCountTotal"] longValue];
            long peiSongOrderCountTotal = [[result objectForKey:@"peiSongOrderCountTotal"] longValue];
            long yiWanChenOrderCountTotal = [[result objectForKey:@"yiWanChenOrderCountTotal"] longValue];
            [self setOptionButton:self.TLIR_OptionFirstBtn count:quHuoOrderCountTotal];
            [self setOptionButton:self.TLIR_OptionSecondBtn count:peiSongOrderCountTotal];
            [self setOptionButton:self.TLIR_OptionThirdBtn count:yiWanChenOrderCountTotal];
            NSArray * orderRespModel = [result objectForKey:@"orderRespModel"];
            
            if (_selectedStatus == OrderStatusAccepted) {
                [_TLIR_DataSourceFirst removeAllObjects];
                for (NSDictionary * aRespModel in orderRespModel) {
                    TaskInRegionModel * regioinModel = [[TaskInRegionModel alloc] initWithDic:aRespModel];
                    [_TLIR_DataSourceFirst addObject:regioinModel];
                }
                // empty
                if (_TLIR_DataSourceFirst.count == 0) {
                    [self _showTableEmpty:_TLIR_TableFirst];
                }else{
                    [self _hideTableEmpty:_TLIR_TableFirst];
                }
                [_TLIR_TableFirst reloadData];
                // footer refresh
                if (_TLIR_DataSourceFirst.count >= TLIR_Default_PageSize) {
                    if (self.TLIR_TableFirst.footer) {
                        [self.TLIR_TableFirst removeFooter];
                    }
                    [self.TLIR_TableFirst addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(tlir_tableViewFooterRefresh)];
                    self.TLIR_TableFirst.footer.state = MJRefreshFooterStateIdle;
                }

            }else if (_selectedStatus == OrderStatusReceive){
                [_TLIR_DataSourceSecond removeAllObjects];
                for (NSDictionary * aRespModel in orderRespModel) {
                    TaskInRegionModel * regioinModel = [[TaskInRegionModel alloc] initWithDic:aRespModel];
                    [_TLIR_DataSourceSecond addObject:regioinModel];
                }
                if (_TLIR_DataSourceSecond.count == 0) {
                    [self _showTableEmpty:_TLIR_TableSecond];
                }else{
                    [self _hideTableEmpty:_TLIR_TableSecond];
                }
                [_TLIR_TableSecond reloadData];
                if (_TLIR_DataSourceSecond.count >= TLIR_Default_PageSize) {
                    if (self.TLIR_TableSecond.footer) {
                        [self.TLIR_TableSecond removeFooter];
                    }
                    [self.TLIR_TableSecond addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(tlir_tableViewFooterRefresh)];
                    self.TLIR_TableSecond.footer.state = MJRefreshFooterStateIdle;
                }
            }else if (_selectedStatus == OrderStatusComplete){
                [_TLIR_DataSourceThird removeAllObjects];
                for (NSDictionary * aRespModel in orderRespModel) {
                    TaskInRegionModel * regioinModel = [[TaskInRegionModel alloc] initWithDic:aRespModel];
                    [_TLIR_DataSourceThird addObject:regioinModel];
                }
                if (_TLIR_DataSourceThird.count == 0) {
                    [self _showTableEmpty:_TLIR_TableThird];
                }else{
                    [self _hideTableEmpty:_TLIR_TableThird];
                }
                [_TLIR_TableThird reloadData];
                if (_TLIR_DataSourceThird.count >= TLIR_Default_PageSize) {
                    if (self.TLIR_TableThird.footer) {
                        [self.TLIR_TableThird removeFooter];
                    }
                    [self.TLIR_TableThird addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(tlir_tableViewFooterRefresh)];
                    self.TLIR_TableThird.footer.state = MJRefreshFooterStateIdle;
                }
            }
            
        }else{
            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_selectedStatus == OrderStatusAccepted) {
            [self.TLIR_TableFirst.header endRefreshing];
        }else if (_selectedStatus == OrderStatusReceive) {
            [self.TLIR_TableSecond.header endRefreshing];
        }else if (_selectedStatus == OrderStatusComplete) {
            [self.TLIR_TableThird.header endRefreshing];
        }
    }];
}



#pragma mark - 订单为空的情况
- (void)_showTableEmpty:(UITableView *)tableV{
    if (tableV == self.TLIR_TableFirst) {
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
        _markedWordsLbl1.text = TLIR_NoDataS1;
        [tableV addSubview:_markedWordsLbl1];
    }else if (tableV == self.TLIR_TableSecond){
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
        _markedWordsLbl2.text = TLIR_NoDataS2;
        [tableV addSubview:_markedWordsLbl2];
    }else if (tableV == self.TLIR_TableThird){
        if (!_logoImgEmpty3) {
            _logoImgEmpty3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
            _logoImgEmpty3.backgroundColor = [UIColor clearColor];
        }
        _logoImgEmpty3.image = [UIImage imageNamed:@"checkLogo"];
        _logoImgEmpty3.center = CGPointMake(ScreenWidth/2, (ScreenHeight-50-64)/3);
        [tableV addSubview:_logoImgEmpty3];
        if (!_markedWordsLbl3) {
            _markedWordsLbl3 = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgEmpty3) +Space_Big, ScreenWidth, 30)];
            _markedWordsLbl3.backgroundColor = [UIColor clearColor];
            _markedWordsLbl3.textAlignment = NSTextAlignmentCenter;
            _markedWordsLbl3.textColor     = DeepGrey;
            _markedWordsLbl3.font          = FONT_SIZE(BigFontSize);
        }
        _markedWordsLbl3.text = TLIR_NoDataS3;
        [tableV addSubview:_markedWordsLbl3];
    }
}

- (void)_hideTableEmpty:(UITableView *)tableV{
    if (tableV == self.TLIR_TableFirst) {
        if (_logoImgEmpty1) {
            [_logoImgEmpty1 removeFromSuperview];
        }
        if (_markedWordsLbl1) {
            [_markedWordsLbl1 removeFromSuperview];
        }
    }else if (tableV == self.TLIR_TableSecond){
        if (_logoImgEmpty2) {
            [_logoImgEmpty2 removeFromSuperview];
        }
        if (_markedWordsLbl2) {
            [_markedWordsLbl2 removeFromSuperview];
        }
    }else if (tableV == self.TLIR_TableThird){
        if (_logoImgEmpty3) {
            [_logoImgEmpty3 removeFromSuperview];
        }
        if (_markedWordsLbl3) {
            [_markedWordsLbl3 removeFromSuperview];
        }
    }
}

#pragma mark - API - 上拉
- (void)tlir_tableViewFooterRefresh{
    NSInteger currentPage = 1;
    if (_selectedStatus == OrderStatusAccepted) {
        currentPage = ++_currentPage1st;
    }else if (_selectedStatus == OrderStatusReceive) {
        currentPage = ++_currentPage2nd;
    }else if (_selectedStatus == OrderStatusComplete) {
        currentPage = ++_currentPage3rd;
    }
    NSDictionary * paraData = @{
                                @"businessId":[NSNumber numberWithInt:260],//[UserInfo getUserId],
                                @"status":[NSString stringWithFormat:@"%ld",(long)_selectedStatus],
                                @"currentPage":[NSNumber numberWithInteger:currentPage],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraData];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraData = @{@"data":aesString,};
    }
    
    [EDSHttpReqManager3 businessGetmyorderb:paraData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_selectedStatus == OrderStatusAccepted) {
            [self.TLIR_TableFirst.footer endRefreshing];
        }else if (_selectedStatus == OrderStatusReceive) {
            [self.TLIR_TableSecond.footer endRefreshing];
        }else if (_selectedStatus == OrderStatusComplete) {
            [self.TLIR_TableThird.footer endRefreshing];
        }
        
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSDictionary * result = [responseObject objectForKey:@"result"];
            long quHuoOrderCountTotal = [[result objectForKey:@"quHuoOrderCountTotal"] longValue];
            long peiSongOrderCountTotal = [[result objectForKey:@"peiSongOrderCountTotal"] longValue];
            long yiWanChenOrderCountTotal = [[result objectForKey:@"yiWanChenOrderCountTotal"] longValue];
            [self setOptionButton:self.TLIR_OptionFirstBtn count:quHuoOrderCountTotal];
            [self setOptionButton:self.TLIR_OptionSecondBtn count:peiSongOrderCountTotal];
            [self setOptionButton:self.TLIR_OptionThirdBtn count:yiWanChenOrderCountTotal];
            NSArray * orderRespModel = [result objectForKey:@"orderRespModel"];
            
            if (_selectedStatus == OrderStatusAccepted) {
                for (NSDictionary * aRespModel in orderRespModel) {
                    TaskInRegionModel * regioinModel = [[TaskInRegionModel alloc] initWithDic:aRespModel];
                    [_TLIR_DataSourceFirst addObject:regioinModel];
                }
                [_TLIR_TableFirst reloadData];
                if ([orderRespModel count] == 0){
                    _TLIR_TableFirst.footer.state = MJRefreshFooterStateNoMoreData;
                }
            }else if (_selectedStatus == OrderStatusReceive){
                for (NSDictionary * aRespModel in orderRespModel) {
                    TaskInRegionModel * regioinModel = [[TaskInRegionModel alloc] initWithDic:aRespModel];
                    [_TLIR_DataSourceSecond addObject:regioinModel];
                }
                [_TLIR_TableSecond reloadData];
                if ([orderRespModel count] == 0){
                    _TLIR_TableSecond.footer.state = MJRefreshFooterStateNoMoreData;
                }
            }else if (_selectedStatus == OrderStatusComplete){
                for (NSDictionary * aRespModel in orderRespModel) {
                    TaskInRegionModel * regioinModel = [[TaskInRegionModel alloc] initWithDic:aRespModel];
                    [_TLIR_DataSourceThird addObject:regioinModel];
                }
                [_TLIR_TableThird reloadData];
                if ([orderRespModel count] == 0){
                    _TLIR_TableThird.footer.state = MJRefreshFooterStateNoMoreData;
                }
            }
            
        }else{
            [Tools showHUD:message];
        }

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_selectedStatus == OrderStatusAccepted) {
            [self.TLIR_TableFirst.footer endRefreshing];
        }else if (_selectedStatus == OrderStatusReceive) {
            [self.TLIR_TableSecond.footer endRefreshing];
        }else if (_selectedStatus == OrderStatusComplete) {
            [self.TLIR_TableThird.footer endRefreshing];
        }
    }];
}

@end
