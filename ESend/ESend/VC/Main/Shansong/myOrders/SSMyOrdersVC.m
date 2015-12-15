//
//  SSMyOrdersVC.m
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSMyOrdersVC.h"
#import "SSOrderUnpayCell.h"
#import "SSMyOrderStatus.h"
#import "MJRefresh.h"
#import "UserInfo.h"
#import "SSOrderDetailVC.h"
/*
 typedef NS_ENUM(NSInteger, SSMyOrderStatus) {
 SSMyOrderStatusUnpayed = 50,
 SSMyOrderStatusUngrab = 0,
 SSMyOrderStatusOntaking = 2,
 SSMyOrderStatusOnDelivering = 4,
 SSMyOrderStatusCompleted = 1,
 };
 */

#define SS_ORDERS_BTN_TAG_BASE 628
#define SS_TABLE_UNPAY_CELLID           @"SS_TABLE_UNPAY_CELLID"
#define SS_TABLE_UNGRAB_CELLID          @"SS_TABLE_UNGRAB_CELLID"
#define SS_TABLE_ONTAKING_CELLID        @"SS_TABLE_ONTAKING_CELLID"
#define SS_TABLE_ONDELIVERING_CELLID    @"SS_TABLE_ONDELIVERING_CELLID"
#define SS_TABLE_COMPLETED_CELLID       @"SS_TABLE_COMPLETED_CELLID"

#define SS_NO_DATA_UNPAY        @"您目前没有待支付的订单!"
#define SS_NO_DATA_UNGRAB       @"您目前没有待接单的订单!"
#define SS_NO_DATA_ONTAKING     @"您目前没有待取货的订单!"
#define SS_NO_DATA_ONDELIVERING @"您目前没有配送中的订单!"
#define SS_NO_DATA_COMPLETED    @"您目前没有已完成的订单!"

#define SS_DEFALT_PAGE_SIZE  15

@interface SSMyOrdersVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    SSMyOrderStatus _orderListStatus;           // 当前订单状态
    
    AFHTTPRequestOperation *_operation;         // 下拉

    UIImageView * _logoImgEmptyUnpay;               // 订单为空的
    UIImageView * _logoImgEmptyUngrab;
    UIImageView * _logoImgEmptyOntaking;
    UIImageView * _logoImgEmptyOndelivering;
    UIImageView * _logoImgEmptyCompleted;
    
    UILabel * _markedWordsLblUnpay;                 // 订单为空label
    UILabel * _markedWordsLblUngrab;
    UILabel * _markedWordsLblOntaking;
    UILabel * _markedWordsLblOndelivering;
    UILabel * _markedWordsLblCompleted;
    
    NSInteger _currentPageUnpay;                    // 分页页码
    NSInteger _currentPageUngrab;
    NSInteger _currentPageOntaking;                    //
    NSInteger _currentPageOndelivering;
    NSInteger _currentPageCompleted;
    
    AFHTTPRequestOperation * _operationUpperUnpay;    // operation 上拉
    AFHTTPRequestOperation * _operationUpperUngrab;
    AFHTTPRequestOperation * _operationUpperOntaking;
    AFHTTPRequestOperation * _operationUpperOndelivering;
    AFHTTPRequestOperation * _operationUpperCompleted;
}

@property (strong, nonatomic) NSMutableArray * datasourceUnpay;
@property (strong, nonatomic) NSMutableArray * datasourceUngrab;
@property (strong, nonatomic) NSMutableArray * datasourceOntaking;
@property (strong, nonatomic) NSMutableArray * datasourceOndelivering;
@property (strong, nonatomic) NSMutableArray * datasourceCompleted;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionHeaderScrollerWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *optionHeaderScroller;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentScrollerWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroller;

@property (weak, nonatomic) IBOutlet UITableView *tableUnpay;
@property (weak, nonatomic) IBOutlet UITableView *tableUngrab;
@property (weak, nonatomic) IBOutlet UITableView *tableOntaking;
@property (weak, nonatomic) IBOutlet UITableView *tableOndelivering;
@property (weak, nonatomic) IBOutlet UITableView *tableCompleted;

@property (weak, nonatomic) IBOutlet UIButton *buttonUnpay;
@property (weak, nonatomic) IBOutlet UIButton *buttonUngrab;
@property (weak, nonatomic) IBOutlet UIButton *buttonOntaking;
@property (weak, nonatomic) IBOutlet UIButton *buttonOndelivering;
@property (weak, nonatomic) IBOutlet UIButton *buttonCompleted;

@property (weak, nonatomic) IBOutlet UIImageView *separator11;
@property (weak, nonatomic) IBOutlet UIImageView *separator12;
@property (weak, nonatomic) IBOutlet UIImageView *separator13;
@property (weak, nonatomic) IBOutlet UIImageView *separator14;

@end

@implementation SSMyOrdersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"我的订单";
    [self defaultValuesCustomize];
    [self viewsCustomize];
}

/// 初始化数据
- (void)defaultValuesCustomize{
    _datasourceCompleted = [[NSMutableArray alloc] initWithCapacity:0];
    _datasourceUnpay = [[NSMutableArray alloc] initWithCapacity:0];
    _datasourceUngrab = [[NSMutableArray alloc] initWithCapacity:0];
    _datasourceOntaking = [[NSMutableArray alloc] initWithCapacity:0];
    _datasourceOndelivering = [[NSMutableArray alloc] initWithCapacity:0];
    
    _currentPageUnpay = 1;                    // 分页页码
    _currentPageUngrab = 1;
    _currentPageOntaking = 1;
    _currentPageOndelivering = 1;
    _currentPageCompleted = 1;
    
    _orderListStatus = SSMyOrderStatusUnpayed;
}

/// 配置界面
- (void)viewsCustomize{
    [self optionViewsCustomize];
    [self _configOptionPullRefresh:self.tableCompleted];
    [self _configOptionPullRefresh:self.tableOndelivering];
    [self _configOptionPullRefresh:self.tableOntaking];
    [self _configOptionPullRefresh:self.tableUngrab];
    [self _configOptionPullRefresh:self.tableUnpay];
}
/// 配置头部选取区
- (void)optionViewsCustomize{
    self.separator11.backgroundColor =
    self.separator12.backgroundColor =
    self.separator13.backgroundColor =
    self.separator14.backgroundColor = BackgroundColor;
    
    // optionView  buttons
    self.buttonUnpay.tag = 1 + SS_ORDERS_BTN_TAG_BASE;
    self.buttonUngrab.tag = 2 + SS_ORDERS_BTN_TAG_BASE;
    self.buttonOntaking.tag = 3 + SS_ORDERS_BTN_TAG_BASE;
    self.buttonOndelivering.tag = 4 + SS_ORDERS_BTN_TAG_BASE;
    self.buttonCompleted.tag = 5 + SS_ORDERS_BTN_TAG_BASE;
    
    [self setOptionButton:self.buttonUnpay count:0];
    [self setOptionButton:self.buttonUngrab count:0];
    [self setOptionButton:self.buttonOntaking count:0];
    [self setOptionButton:self.buttonOndelivering count:0];
    [self setOptionButton:self.buttonCompleted count:0];

    self.buttonUnpay.titleLabel.font =
    self.buttonUngrab.titleLabel.font =
    self.buttonOntaking.titleLabel.font =
    self.buttonOndelivering.titleLabel.font =
    self.buttonCompleted.titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    self.buttonUnpay.backgroundColor =
    self.buttonUnpay.backgroundColor =
    self.buttonUnpay.backgroundColor =
    self.buttonUnpay.backgroundColor =
    self.buttonUnpay.backgroundColor = [UIColor whiteColor];
    
    // self.TLIR_OptionIndicator.backgroundColor = BlueColor;
}

#pragma mark - Config Refresh Setting
- (void)_configOptionPullRefresh:(UITableView *)tabler
{
    // 添加动画图片的下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(pullDownReqForList)];
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
    self.optionHeaderScrollerWidth.constant = 100 * 5;
    self.contentScrollerWidth.constant = ScreenWidth * 5;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self beginRefresh];
}

/// 界面开始下拉刷新
- (void)beginRefresh{
    switch (_orderListStatus) {
        case SSMyOrderStatusUnpayed:
            if (self.tableUnpay.header.state != MJRefreshHeaderStateRefreshing) {
                [self.tableUnpay.header beginRefreshing];
            }
            break;
        case SSMyOrderStatusUngrab:
            if (self.tableUngrab.header.state != MJRefreshHeaderStateRefreshing) {
                [self.tableUngrab.header beginRefreshing];
            }
            break;
        case SSMyOrderStatusOntaking:
            if (self.tableOntaking.header.state != MJRefreshHeaderStateRefreshing) {
                [self.tableOntaking.header beginRefreshing];
            }
            break;
        case SSMyOrderStatusOnDelivering:
            if (self.tableOndelivering.header.state != MJRefreshHeaderStateRefreshing) {
                [self.tableOndelivering.header beginRefreshing];
            }
            break;
        case SSMyOrderStatusCompleted:
            if (self.tableCompleted.header.state != MJRefreshHeaderStateRefreshing) {
                [self.tableCompleted.header beginRefreshing];
            }
            break;
        default:
            break;
    }
}

/// 设置标签按钮的数值
- (void)setOptionButton:(UIButton *)btn count:(long)count{
    NSString * tCount = (count>99)?[NSString stringWithFormat:@"99+"]:[NSString stringWithFormat:@"%ld",count];
    NSString * text = nil;
    if (btn.tag == 1 + SS_ORDERS_BTN_TAG_BASE) {
        text = [NSString stringWithFormat:@"待支付(%@)",tCount];
    }else if (btn.tag == 2 + SS_ORDERS_BTN_TAG_BASE) {
        text = [NSString stringWithFormat:@"待接单(%@)",tCount];
    }else if (btn.tag == 3 + SS_ORDERS_BTN_TAG_BASE) {
        text = [NSString stringWithFormat:@"取货中(%@)",tCount];
    }else if (btn.tag == 4 + SS_ORDERS_BTN_TAG_BASE) {
        text = [NSString stringWithFormat:@"配送中(%@)",tCount];
    }else if (btn.tag == 5 + SS_ORDERS_BTN_TAG_BASE) {
        text = [NSString stringWithFormat:@"已完成(%@)",tCount];
    }
    
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [AttributedString addAttribute:NSForegroundColorAttributeName value:DeepGrey range:NSMakeRange(0,AttributedString.length)];
    [btn setAttributedTitle:AttributedString forState:UIControlStateNormal];
    
    NSMutableAttributedString * hightedAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [hightedAttributedString addAttribute:NSForegroundColorAttributeName value:BlueColor range:NSMakeRange(0, hightedAttributedString.length)];
    [btn setAttributedTitle:hightedAttributedString forState:UIControlStateDisabled];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat delta = ScreenWidth/6;
    if (scrollView == self.contentScroller) {
//        CGFloat movCenterY = self.TLIR_OptionIndicator.center.y;
//        CGFloat newCenterX = scrollView.contentOffset.x/3 + delta;
//        self.TLIR_OptionIndicator.center = CGPointMake(newCenterX, movCenterY);
        [self _configScrollOffSetPropertys:scrollView.contentOffset.x];
    }
}

- (void)_configScrollOffSetPropertys:(CGFloat)x{
    self.buttonUnpay.enabled = (x == 0)?NO:YES;
    self.tableUnpay.scrollsToTop = !self.buttonUnpay.enabled;
    self.buttonUngrab.enabled = (x == ScreenWidth)?NO:YES;
    self.tableUngrab.scrollsToTop = !self.buttonUngrab.enabled;
    self.buttonOntaking.enabled = (x == ScreenWidth * 2)?NO:YES;
    self.tableOntaking.scrollsToTop = !self.buttonOntaking.enabled;
    self.buttonOndelivering.enabled = (x == ScreenWidth * 3)?NO:YES;
    self.tableOndelivering.scrollsToTop = !self.buttonOndelivering.enabled;
    self.buttonCompleted.enabled = (x == ScreenWidth * 4)?NO:YES;
    self.tableCompleted.scrollsToTop = !self.buttonCompleted.enabled;
    
    if (0 == x) {
        _orderListStatus = SSMyOrderStatusUnpayed;
    }else if (ScreenWidth == x){
        _orderListStatus = SSMyOrderStatusUngrab;
    }else if (ScreenWidth * 2 == x){
        _orderListStatus = SSMyOrderStatusOntaking;
    }else if (ScreenWidth * 3 == x){
        _orderListStatus = SSMyOrderStatusOnDelivering;
    }else if (ScreenWidth * 4 == x){
        _orderListStatus = SSMyOrderStatusCompleted;
    }else{
        return;
    }
    [self beginRefresh];
}


/// 按钮事件
- (IBAction)optionButtonAction:(UIButton *)sender {
    [self _buttonEventWithSender:sender];
    
}

- (void)_enableHeadBtns{
    self.buttonUnpay.enabled = YES;
    self.buttonUngrab.enabled = YES;
    self.buttonOntaking.enabled = YES;
    self.buttonOndelivering.enabled = YES;
    self.buttonCompleted.enabled = YES;
}

- (void)_buttonEventWithSender:(UIButton *)sender{
    [self _enableHeadBtns];
    sender.enabled = NO;
    [self.contentScroller setContentOffset:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds])*(sender.tag - 1 - SS_ORDERS_BTN_TAG_BASE), 0) animated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableUnpay) {
        return _datasourceUnpay.count;
    }else if (tableView == self.tableUngrab) {
        return _datasourceUngrab.count;
    }else if (tableView == self.tableOntaking) {
        return _datasourceOntaking.count;
    }else if (tableView == self.tableOndelivering) {
        return _datasourceOndelivering.count;
    }else if (tableView == self.tableCompleted) {
        return _datasourceCompleted.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableUnpay) {
        SSOrderUnpayCell * cell = [tableView dequeueReusableCellWithIdentifier:SS_TABLE_UNPAY_CELLID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSOrderUnpayCell class]) owner:self options:nil] lastObject];
        }
        return cell;
    }else if (tableView == self.tableUngrab) {
        SSOrderUnpayCell * cell = [tableView dequeueReusableCellWithIdentifier:SS_TABLE_UNPAY_CELLID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSOrderUnpayCell class]) owner:self options:nil] lastObject];
        }
        return cell;
    }else if (tableView == self.tableOntaking) {
        SSOrderUnpayCell * cell = [tableView dequeueReusableCellWithIdentifier:SS_TABLE_UNPAY_CELLID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSOrderUnpayCell class]) owner:self options:nil] lastObject];
        }
        return cell;
    }else if (tableView == self.tableOndelivering) {
        SSOrderUnpayCell * cell = [tableView dequeueReusableCellWithIdentifier:SS_TABLE_UNPAY_CELLID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSOrderUnpayCell class]) owner:self options:nil] lastObject];
        }
        return cell;
    }else if (tableView == self.tableCompleted) {
        SSOrderUnpayCell * cell = [tableView dequeueReusableCellWithIdentifier:SS_TABLE_UNPAY_CELLID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSOrderUnpayCell class]) owner:self options:nil] lastObject];
        }
        return cell;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 118;
    if (tableView == self.tableUnpay) {

    }else if (tableView == self.tableUngrab) {

    }else if (tableView == self.tableOntaking) {

    }else if (tableView == self.tableOndelivering) {

    }else if (tableView == self.tableCompleted) {

    }else{
        
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SSOrderDetailVC * odf9c = [[SSOrderDetailVC alloc] initWithNibName:NSStringFromClass([SSOrderDetailVC class]) bundle:nil];
    if (tableView == self.tableUnpay) {
        
    }else if (tableView == self.tableUngrab) {
        
    }else if (tableView == self.tableOntaking) {
        
    }else if (tableView == self.tableOndelivering) {
        
    }else if (tableView == self.tableCompleted) {
        
    }else{
        
    }
//    TaskInRegionModel * regionModel = nil;
//    if (_selectedStatus == OrderStatusAccepted) {
//        regionModel = [_TLIR_DataSourceFirst objectAtIndex:indexPath.row];
//    }else if (_selectedStatus == OrderStatusReceive) {
//        regionModel = [_TLIR_DataSourceSecond objectAtIndex:indexPath.row];
//    }else if (_selectedStatus == OrderStatusComplete) {
//        regionModel = [_TLIR_DataSourceThird objectAtIndex:indexPath.row];
//    }
//    odf9c.grabOrderId = regionModel.grabOrderId;
    [self.navigationController pushViewController:odf9c animated:YES];
}

#pragma mark - API
/// 订单列表，下拉
- (void)pullDownReqForList{
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
                                @"businessId":[NSNumber numberWithInteger:self.businessid],//[NSNumber numberWithInt:2125],//[UserInfo getUserId],
                                @"status":[NSString stringWithFormat:@"%ld",(long)_selectedStatus],
                                @"regionId":[NSNumber numberWithInteger:self.regionid],//[NSNumber numberWithInteger:1],
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
                                @"businessId":[NSNumber numberWithInteger:self.businessid],//[NSNumber numberWithInt:2125],//[UserInfo getUserId],
                                @"status":[NSString stringWithFormat:@"%ld",(long)_selectedStatus],
                                @"regionId":[NSNumber numberWithInteger:self.regionid],//[NSNumber numberWithInteger:1],
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
