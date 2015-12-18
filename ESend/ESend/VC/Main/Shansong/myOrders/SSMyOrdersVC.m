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
#import "SSHttpReqServer.h"
#import "SSMyOrderModel.h"
#import "SSOrderUngrabCell.h"
#import "SSOrderOnDeliveryingCell.h"

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
#define SS_TABLE_CANCELED_CELLID       @"SS_TABLE_CANCELED_CELLID"

#define SS_NO_DATA_UNPAY        @"您目前没有待支付的订单!"
#define SS_NO_DATA_UNGRAB       @"您目前没有待接单的订单!"
#define SS_NO_DATA_ONTAKING     @"您目前没有待取货的订单!"
#define SS_NO_DATA_ONDELIVERING @"您目前没有配送中的订单!"
#define SS_NO_DATA_COMPLETED    @"您目前没有已完成的订单!"
#define SS_NO_DATA_CANCELED    @"您目前没有已取消的订单!"

#define SS_DEFALT_PAGE_SIZE  15

@interface SSMyOrdersVC ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,SSOrderUnpayCellDelegate,SSOrderUngrabCellDelegate>
{
    SSMyOrderStatus _orderListStatus;           // 当前订单状态
    
    AFHTTPRequestOperation *_operation;         // 下拉

    UIImageView * _logoImgEmptyUnpay;               // 订单为空的
    UIImageView * _logoImgEmptyUngrab;
    UIImageView * _logoImgEmptyOntaking;
    UIImageView * _logoImgEmptyOndelivering;
    UIImageView * _logoImgEmptyCompleted;
    UIImageView * _logoImgEmptyCanceled;
    
    UILabel * _markedWordsLblUnpay;                 // 订单为空label
    UILabel * _markedWordsLblUngrab;
    UILabel * _markedWordsLblOntaking;
    UILabel * _markedWordsLblOndelivering;
    UILabel * _markedWordsLblCompleted;
    UILabel * _markedwordsLblCanceled;
    
    NSInteger _currentPageUnpay;                    // 分页页码
    NSInteger _currentPageUngrab;
    NSInteger _currentPageOntaking;                    //
    NSInteger _currentPageOndelivering;
    NSInteger _currentPageCompleted;
    NSInteger _currentPageCanceled;
    
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
@property (strong, nonatomic) NSMutableArray * datasourceCanceled;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *optionHeaderScrollerWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *optionHeaderScroller;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentScrollerWidth;
@property (weak, nonatomic) IBOutlet UIScrollView *contentScroller;

@property (weak, nonatomic) IBOutlet UITableView *tableUnpay;
@property (weak, nonatomic) IBOutlet UITableView *tableUngrab;
@property (weak, nonatomic) IBOutlet UITableView *tableOntaking;
@property (weak, nonatomic) IBOutlet UITableView *tableOndelivering;
@property (weak, nonatomic) IBOutlet UITableView *tableCompleted;
@property (weak, nonatomic) IBOutlet UITableView *tableCanceled;

@property (weak, nonatomic) IBOutlet UIButton *buttonUnpay;
@property (weak, nonatomic) IBOutlet UIButton *buttonUngrab;
@property (weak, nonatomic) IBOutlet UIButton *buttonOntaking;
@property (weak, nonatomic) IBOutlet UIButton *buttonOndelivering;
@property (weak, nonatomic) IBOutlet UIButton *buttonCompleted;
@property (weak, nonatomic) IBOutlet UIButton *buttonCanceled;

@property (weak, nonatomic) IBOutlet UIImageView *separator11;
@property (weak, nonatomic) IBOutlet UIImageView *separator12;
@property (weak, nonatomic) IBOutlet UIImageView *separator13;
@property (weak, nonatomic) IBOutlet UIImageView *separator14;
@property (weak, nonatomic) IBOutlet UIImageView *separator15;

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
    _datasourceCanceled = [[NSMutableArray alloc] initWithCapacity:0];
    
    _currentPageUnpay = 1;                    // 分页页码
    _currentPageUngrab = 1;
    _currentPageOntaking = 1;
    _currentPageOndelivering = 1;
    _currentPageCompleted = 1;
    _currentPageCanceled = 1;
    
    _orderListStatus = SSMyOrderStatusUnpayed;
}

/// 配置界面
- (void)viewsCustomize{
    [self optionViewsCustomize];
    [self _configOptionPullRefresh:self.tableCanceled];
    [self _configOptionPullRefresh:self.tableCompleted];
    [self _configOptionPullRefresh:self.tableOndelivering];
    [self _configOptionPullRefresh:self.tableOntaking];
    [self _configOptionPullRefresh:self.tableUngrab];
    [self _configOptionPullRefresh:self.tableUnpay];
}
/// 配置头部选取区
- (void)optionViewsCustomize{
    self.optionHeaderScroller.layer.borderColor = [SeparatorLineColor CGColor];
    self.optionHeaderScroller.layer.borderWidth = 0.5f;
    
    self.separator11.backgroundColor =
    self.separator12.backgroundColor =
    self.separator13.backgroundColor =
    self.separator15.backgroundColor =
    self.separator14.backgroundColor = BackgroundColor;
    
    // optionView  buttons
    self.buttonUnpay.tag = 1 + SS_ORDERS_BTN_TAG_BASE;
    self.buttonUngrab.tag = 2 + SS_ORDERS_BTN_TAG_BASE;
    self.buttonOntaking.tag = 3 + SS_ORDERS_BTN_TAG_BASE;
    self.buttonOndelivering.tag = 4 + SS_ORDERS_BTN_TAG_BASE;
    self.buttonCompleted.tag = 5 + SS_ORDERS_BTN_TAG_BASE;
    self.buttonCanceled.tag = 6 + SS_ORDERS_BTN_TAG_BASE;
    
    [self setOptionButton:self.buttonUnpay count:0];
    [self setOptionButton:self.buttonUngrab count:0];
    [self setOptionButton:self.buttonOntaking count:0];
    [self setOptionButton:self.buttonOndelivering count:0];
    [self setOptionButton:self.buttonCompleted count:0];
    [self setOptionButton:self.buttonCanceled count:0];

    self.buttonUnpay.titleLabel.font =
    self.buttonUngrab.titleLabel.font =
    self.buttonOntaking.titleLabel.font =
    self.buttonOndelivering.titleLabel.font =
    self.buttonCanceled.titleLabel.font =
    self.buttonCompleted.titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    self.buttonUnpay.backgroundColor =
    self.buttonUngrab.backgroundColor =
    self.buttonOntaking.backgroundColor =
    self.buttonOndelivering.backgroundColor =
    self.buttonCanceled.backgroundColor =
    self.buttonCompleted.backgroundColor = [UIColor whiteColor];
    
    self.buttonUnpay.enabled = NO;
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
    self.optionHeaderScrollerWidth.constant = 100 * 6;
    self.contentScrollerWidth.constant = ScreenWidth * 6;
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
        case SSMyOrderStatusCanceled:
            if (self.tableCanceled.header.state != MJRefreshHeaderStateRefreshing) {
                [self.tableCanceled.header beginRefreshing];
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
    }else if (btn.tag == 6 + SS_ORDERS_BTN_TAG_BASE) {
        text = [NSString stringWithFormat:@"已取消(%@)",tCount];
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
    self.buttonCanceled.enabled = (x == ScreenWidth * 5)?NO:YES;
    self.tableCanceled.scrollsToTop = !self.buttonCompleted.enabled;
    
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
    }else if (ScreenWidth * 5 == x){
        _orderListStatus = SSMyOrderStatusCanceled;
    }else{
        return;
    }
    [self beginRefresh];
    [self performSelectorOnMainThread:@selector(adjustOptionScrollerWithX:) withObject:[NSNumber numberWithFloat:x/ScreenWidth] waitUntilDone:YES];
}

- (void)adjustOptionScrollerWithX:(NSNumber *)NumX{
    CGFloat wholeWidth = self.optionHeaderScrollerWidth.constant;
    CGFloat buttonWidth = wholeWidth/6;
    CGFloat buttonHeight = 50;
    CGRect targetRect = CGRectMake(buttonWidth * [NumX floatValue], 0, buttonWidth, buttonHeight);
    [self.optionHeaderScroller scrollRectToVisible:targetRect animated:YES];
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
    self.buttonCanceled.enabled = YES;
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
    }else if (tableView == self.tableCanceled){
        return _datasourceCanceled.count;
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
        cell.datasource = [_datasourceUnpay objectAtIndex:indexPath.row];
        cell.delegate = self;
        return cell;
    }else if (tableView == self.tableUngrab) {
        SSOrderUngrabCell * cell = [tableView dequeueReusableCellWithIdentifier:SS_TABLE_UNGRAB_CELLID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSOrderUngrabCell class]) owner:self options:nil] lastObject];
        }
        cell.datasource = [_datasourceUngrab objectAtIndex:indexPath.row];
        cell.delegate = self;
        return cell;
    }else if (tableView == self.tableOntaking) {
        SSOrderUngrabCell * cell = [tableView dequeueReusableCellWithIdentifier:SS_TABLE_ONTAKING_CELLID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSOrderUngrabCell class]) owner:self options:nil] lastObject];
        }
        cell.datasource = [_datasourceOntaking objectAtIndex:indexPath.row];
        return cell;
    }else if (tableView == self.tableOndelivering) {
        SSOrderOnDeliveryingCell * cell = [tableView dequeueReusableCellWithIdentifier:SS_TABLE_ONDELIVERING_CELLID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSOrderOnDeliveryingCell class]) owner:self options:nil] lastObject];
        }
        cell.datasource = [_datasourceOndelivering objectAtIndex:indexPath.row];
        return cell;
    }else if (tableView == self.tableCompleted) {
        SSOrderOnDeliveryingCell * cell = [tableView dequeueReusableCellWithIdentifier:SS_TABLE_COMPLETED_CELLID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSOrderOnDeliveryingCell class]) owner:self options:nil] lastObject];
        }
        cell.datasource = [_datasourceCompleted objectAtIndex:indexPath.row];
        return cell;
    }else if (tableView == self.tableCanceled) {
        SSOrderOnDeliveryingCell * cell = [tableView dequeueReusableCellWithIdentifier:SS_TABLE_CANCELED_CELLID];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSOrderOnDeliveryingCell class]) owner:self options:nil] lastObject];
        }
        cell.datasource = [_datasourceCanceled objectAtIndex:indexPath.row];
        return cell;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableUnpay) {
        return 152;
    }else if (tableView == self.tableUngrab) {
        return 198;
    }else if (tableView == self.tableOntaking) {
        return 198;
    }else if (tableView == self.tableOndelivering) {
        return 153;
    }else if (tableView == self.tableCompleted) {
        return 153;
    }else if (tableView == self.tableCanceled){
        return 153;
    }else{
        return 0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SSOrderDetailVC * odf9c = [[SSOrderDetailVC alloc] initWithNibName:NSStringFromClass([SSOrderDetailVC class]) bundle:nil];
    NSInteger orderId;
    if (tableView == self.tableUnpay) {
        SSMyOrderModel * orderModel = [_datasourceUnpay objectAtIndex:indexPath.row];
        orderId = orderModel.orderId;
    }else if (tableView == self.tableUngrab) {
        SSMyOrderModel * orderModel = [_datasourceUngrab objectAtIndex:indexPath.row];
        orderId = orderModel.orderId;
    }else if (tableView == self.tableOntaking) {
        SSMyOrderModel * orderModel = [_datasourceOntaking objectAtIndex:indexPath.row];
        orderId = orderModel.orderId;
    }else if (tableView == self.tableOndelivering) {
        SSMyOrderModel * orderModel = [_datasourceOndelivering objectAtIndex:indexPath.row];
        orderId = orderModel.orderId;
    }else if (tableView == self.tableCompleted) {
        SSMyOrderModel * orderModel = [_datasourceCompleted objectAtIndex:indexPath.row];
        orderId = orderModel.orderId;
    }else if (tableView == self.tableCanceled) {
        SSMyOrderModel * orderModel = [_datasourceCanceled objectAtIndex:indexPath.row];
        orderId = orderModel.orderId;
    }else{
        
    }
    odf9c.orderId = [NSString stringWithFormat:@"%ld",orderId];
    [self.navigationController pushViewController:odf9c animated:YES];
}

#pragma mark - API

- (void)endTheRefreshingWithStatus:(SSMyOrderStatus)status{
    if (status == SSMyOrderStatusUnpayed) {
        [self.tableUnpay.header endRefreshing];
    }else if (status == SSMyOrderStatusUngrab){
        [self.tableUngrab.header endRefreshing];
    }else if (status == SSMyOrderStatusOntaking){
        [self.tableOntaking.header endRefreshing];
    }else if (status == SSMyOrderStatusOnDelivering){
        [self.tableOndelivering.header endRefreshing];
    }else if (status == SSMyOrderStatusCompleted){
        [self.tableCompleted.header endRefreshing];
    }else if (status == SSMyOrderStatusCanceled){
        [self.tableCanceled.header endRefreshing];
    }
}

- (void)endOtherRefreshingWithStatus:(SSMyOrderStatus)status{
    if (status == SSMyOrderStatusUnpayed) {
        _currentPageUnpay = 1;
        [self.tableUngrab.header endRefreshing];
        [self.tableOntaking.header endRefreshing];
        [self.tableOndelivering.header endRefreshing];
        [self.tableCompleted.header endRefreshing];
        [self.tableCanceled.header endRefreshing];
    }else if (status == SSMyOrderStatusUngrab){
        _currentPageUngrab = 1;
        [self.tableUnpay.header endRefreshing];
        [self.tableOntaking.header endRefreshing];
        [self.tableOndelivering.header endRefreshing];
        [self.tableCompleted.header endRefreshing];
        [self.tableCanceled.header endRefreshing];
    }else if (status == SSMyOrderStatusOntaking){
        _currentPageOntaking = 1;
        [self.tableUnpay.header endRefreshing];
        [self.tableUngrab.header endRefreshing];
        [self.tableOndelivering.header endRefreshing];
        [self.tableCompleted.header endRefreshing];
        [self.tableCanceled.header endRefreshing];
    }else if (status == SSMyOrderStatusOnDelivering){
        _currentPageOndelivering = 1;
        [self.tableUnpay.header endRefreshing];
        [self.tableUngrab.header endRefreshing];
        [self.tableOntaking.header endRefreshing];
        [self.tableCompleted.header endRefreshing];
        [self.tableCanceled.header endRefreshing];
    }else if (status == SSMyOrderStatusCompleted){
        _currentPageCompleted = 1;
        [self.tableUnpay.header endRefreshing];
        [self.tableUngrab.header endRefreshing];
        [self.tableOntaking.header endRefreshing];
        [self.tableOndelivering.header endRefreshing];
        [self.tableCanceled.header endRefreshing];
    }else if (status == SSMyOrderStatusCanceled){
        _currentPageCanceled = 1;
        [self.tableUnpay.header endRefreshing];
        [self.tableUngrab.header endRefreshing];
        [self.tableOntaking.header endRefreshing];
        [self.tableOndelivering.header endRefreshing];
        [self.tableCompleted.header endRefreshing];
    }
}

- (void)endTheFooterRefreshingWithStatus:(SSMyOrderStatus)status{
    if (status == SSMyOrderStatusUnpayed) {
        [self.tableUnpay.footer endRefreshing];
    }else if (status == SSMyOrderStatusUngrab){
        [self.tableUngrab.footer endRefreshing];
    }else if (status == SSMyOrderStatusOntaking){
        [self.tableOntaking.footer endRefreshing];
    }else if (status == SSMyOrderStatusOnDelivering){
        [self.tableOndelivering.footer endRefreshing];
    }else if (status == SSMyOrderStatusCompleted){
        [self.tableCompleted.footer endRefreshing];
    }else if (status == SSMyOrderStatusCanceled){
        [self.tableCanceled.footer endRefreshing];
    }
}

/// 订单列表，下拉
- (void)pullDownReqForList{
    if (_operation) {
        [_operation cancel];
        _operation = nil;
    }
    [self endOtherRefreshingWithStatus:_orderListStatus];
    NSDictionary * paraData = @{
                                @"businessId":[UserInfo getUserId],//[NSNumber numberWithInt:2125],//[UserInfo getUserId],
                                @"status":[NSString stringWithFormat:@"%ld",(long)_orderListStatus],
                                @"platform":@"1,3",//[NSNumber numberWithInteger:1],
                                @"currentPage":[NSNumber numberWithInteger:1],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraData];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraData = @{@"data":aesString,};
    }
    __block SSMyOrdersVC * blockSelf = self;
    _operation = [SSHttpReqServer shanSongQueryOrderB:paraData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [blockSelf endTheRefreshingWithStatus:_orderListStatus];
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSDictionary * result = [responseObject objectForKey:@"result"];
            long unpayCount = [[result objectForKey:@"waitPayCount"] longValue];
            long ungrabCount = [[result objectForKey:@"newCount"] longValue];
            long onTakingCount = [[result objectForKey:@"deliveryCount"] longValue];
            long onDeliveryingCount = [[result objectForKey:@"takingCount"] longValue];
            long completedCount = [[result objectForKey:@"hadCompleteCount"] longValue];
            long completedCount22 = [[result objectForKey:@"hadCompleteCount"] longValue];

            [self setOptionButton:self.buttonUnpay count:unpayCount];
            [self setOptionButton:self.buttonUngrab count:ungrabCount];
            [self setOptionButton:self.buttonOntaking count:onTakingCount];
            [self setOptionButton:self.buttonOndelivering count:onDeliveryingCount];
            [self setOptionButton:self.buttonCompleted count:completedCount];
            [self setOptionButton:self.buttonCanceled count:completedCount22];
            
            NSArray * orderRespModel = [result objectForKey:@"orders"];
            
            if (_orderListStatus == SSMyOrderStatusUnpayed) {
                [_datasourceUnpay removeAllObjects];
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * orderModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceUnpay addObject:orderModel];
                }
                // empty
                if (_datasourceUnpay.count == 0) {
                    [self _showTableEmpty:_tableUnpay];
                }else{
                    [self _hideTableEmpty:_tableUnpay];
                }
                [_tableUnpay reloadData];
                // footer refresh
                if (_datasourceUnpay.count >= SS_DEFALT_PAGE_SIZE) {
                    if (_tableUnpay.footer) {
                        [_tableUnpay removeFooter];
                    }
                    [_tableUnpay addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(tlir_tableViewFooterRefresh)];
                    _tableUnpay.footer.state = MJRefreshFooterStateIdle;
                }
                
            }else if (_orderListStatus == SSMyOrderStatusUngrab){
                [_datasourceUngrab removeAllObjects];
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * regioinModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceUngrab addObject:regioinModel];
                }
                if (_datasourceUngrab.count == 0) {
                    [self _showTableEmpty:_tableUngrab];
                }else{
                    [self _hideTableEmpty:_tableUngrab];
                }
                [_tableUngrab reloadData];
                if (_datasourceUngrab.count >= SS_DEFALT_PAGE_SIZE) {
                    if (_tableUngrab.footer) {
                        [_tableUngrab removeFooter];
                    }
                    [_tableUngrab addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(tlir_tableViewFooterRefresh)];
                    _tableUngrab.footer.state = MJRefreshFooterStateIdle;
                }
            }else if (_orderListStatus == SSMyOrderStatusOntaking){
                [_datasourceOntaking removeAllObjects];
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * regioinModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceOntaking addObject:regioinModel];
                }
                if (_datasourceOntaking.count == 0) {
                    [self _showTableEmpty:_tableOntaking];
                }else{
                    [self _hideTableEmpty:_tableOntaking];
                }
                [_tableOntaking reloadData];
                if (_datasourceOntaking.count >= SS_DEFALT_PAGE_SIZE) {
                    if (_tableOntaking.footer) {
                        [_tableOntaking removeFooter];
                    }
                    [_tableOntaking addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(tlir_tableViewFooterRefresh)];
                    _tableOntaking.footer.state = MJRefreshFooterStateIdle;
                }
            }else if (_orderListStatus == SSMyOrderStatusOnDelivering){
                [_datasourceOndelivering removeAllObjects];
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * regioinModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceOndelivering addObject:regioinModel];
                }
                if (_datasourceOndelivering.count == 0) {
                    [self _showTableEmpty:_tableOndelivering];
                }else{
                    [self _hideTableEmpty:_tableOndelivering];
                }
                [_tableOndelivering reloadData];
                if (_datasourceOndelivering.count >= SS_DEFALT_PAGE_SIZE) {
                    if (_tableOndelivering.footer) {
                        [_tableOndelivering removeFooter];
                    }
                    [_tableOndelivering addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(tlir_tableViewFooterRefresh)];
                    _tableOndelivering.footer.state = MJRefreshFooterStateIdle;
                }
            }else if (_orderListStatus == SSMyOrderStatusCompleted){
                [_datasourceCompleted removeAllObjects];
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * regioinModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceCompleted addObject:regioinModel];
                }
                if (_datasourceCompleted.count == 0) {
                    [self _showTableEmpty:_tableCompleted];
                }else{
                    [self _hideTableEmpty:_tableCompleted];
                }
                [_tableCompleted reloadData];
                if (_datasourceCompleted.count >= SS_DEFALT_PAGE_SIZE) {
                    if (_tableCompleted.footer) {
                        [_tableCompleted removeFooter];
                    }
                    [_tableCompleted addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(tlir_tableViewFooterRefresh)];
                    _tableCompleted.footer.state = MJRefreshFooterStateIdle;
                }
            }else if (_orderListStatus == SSMyOrderStatusCanceled){
                [_datasourceCanceled removeAllObjects];
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * regioinModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceCanceled addObject:regioinModel];
                }
                if (_datasourceCanceled.count == 0) {
                    [self _showTableEmpty:_tableCanceled];
                }else{
                    [self _hideTableEmpty:_tableCanceled];
                }
                [_tableCanceled reloadData];
                if (_datasourceCanceled.count >= SS_DEFALT_PAGE_SIZE) {
                    if (_tableCanceled.footer) {
                        [_tableCanceled removeFooter];
                    }
                    [_tableCanceled addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(tlir_tableViewFooterRefresh)];
                    _tableCanceled.footer.state = MJRefreshFooterStateIdle;
                }
            }
            
        }else{
            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [blockSelf endTheRefreshingWithStatus:_orderListStatus];
    }];

}




#pragma mark - 订单为空的情况
- (void)_showTableEmpty:(UITableView *)tableV{
    if (tableV == self.tableUnpay) {
        if (!_logoImgEmptyUnpay) {
            _logoImgEmptyUnpay = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
            _logoImgEmptyUnpay.backgroundColor = [UIColor clearColor];
        }
        _logoImgEmptyUnpay.image = [UIImage imageNamed:@"checkLogo"];
        _logoImgEmptyUnpay.center = CGPointMake(ScreenWidth/2, (ScreenHeight-50-64)/3);
        [tableV addSubview:_logoImgEmptyUnpay];
        if (!_markedWordsLblUnpay) {
            _markedWordsLblUnpay = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgEmptyUnpay) +Space_Big, ScreenWidth, 30)];
            _markedWordsLblUnpay.backgroundColor = [UIColor clearColor];
            _markedWordsLblUnpay.textAlignment = NSTextAlignmentCenter;
            _markedWordsLblUnpay.textColor     = DeepGrey;
            _markedWordsLblUnpay.font          = FONT_SIZE(BigFontSize);
        }
        _markedWordsLblUnpay.text = SS_NO_DATA_UNPAY;
        [tableV addSubview:_markedWordsLblUnpay];
    }else if (tableV == self.tableUngrab){
        if (!_logoImgEmptyUngrab) {
            _logoImgEmptyUngrab = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
            _logoImgEmptyUngrab.backgroundColor = [UIColor clearColor];
        }
        _logoImgEmptyUngrab.image = [UIImage imageNamed:@"checkLogo"];
        _logoImgEmptyUngrab.center = CGPointMake(ScreenWidth/2, (ScreenHeight-50-64)/3);
        [tableV addSubview:_logoImgEmptyUngrab];
        if (!_markedWordsLblUngrab) {
            _markedWordsLblUngrab = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgEmptyUngrab) +Space_Big, ScreenWidth, 30)];
            _markedWordsLblUngrab.backgroundColor = [UIColor clearColor];
            _markedWordsLblUngrab.textAlignment = NSTextAlignmentCenter;
            _markedWordsLblUngrab.textColor     = DeepGrey;
            _markedWordsLblUngrab.font          = FONT_SIZE(BigFontSize);
        }
        _markedWordsLblUngrab.text = SS_NO_DATA_UNGRAB;
        [tableV addSubview:_markedWordsLblUngrab];
    }else if (tableV == self.tableOntaking){
        if (!_logoImgEmptyOntaking) {
            _logoImgEmptyOntaking = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
            _logoImgEmptyOntaking.backgroundColor = [UIColor clearColor];
        }
        _logoImgEmptyOntaking.image = [UIImage imageNamed:@"checkLogo"];
        _logoImgEmptyOntaking.center = CGPointMake(ScreenWidth/2, (ScreenHeight-50-64)/3);
        [tableV addSubview:_logoImgEmptyOntaking];
        if (!_markedWordsLblOntaking) {
            _markedWordsLblOntaking = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgEmptyOntaking) +Space_Big, ScreenWidth, 30)];
            _markedWordsLblOntaking.backgroundColor = [UIColor clearColor];
            _markedWordsLblOntaking.textAlignment = NSTextAlignmentCenter;
            _markedWordsLblOntaking.textColor     = DeepGrey;
            _markedWordsLblOntaking.font          = FONT_SIZE(BigFontSize);
        }
        _markedWordsLblOntaking.text = SS_NO_DATA_ONTAKING;
        [tableV addSubview:_markedWordsLblOntaking];
    }else if (tableV == self.tableOndelivering){
        if (!_logoImgEmptyOndelivering) {
            _logoImgEmptyOndelivering = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
            _logoImgEmptyOndelivering.backgroundColor = [UIColor clearColor];
        }
        _logoImgEmptyOndelivering.image = [UIImage imageNamed:@"checkLogo"];
        _logoImgEmptyOndelivering.center = CGPointMake(ScreenWidth/2, (ScreenHeight-50-64)/3);
        [tableV addSubview:_logoImgEmptyOndelivering];
        if (!_markedWordsLblOndelivering) {
            _markedWordsLblOndelivering = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgEmptyOndelivering) +Space_Big, ScreenWidth, 30)];
            _markedWordsLblOndelivering.backgroundColor = [UIColor clearColor];
            _markedWordsLblOndelivering.textAlignment = NSTextAlignmentCenter;
            _markedWordsLblOndelivering.textColor     = DeepGrey;
            _markedWordsLblOndelivering.font          = FONT_SIZE(BigFontSize);
        }
        _markedWordsLblOndelivering.text = SS_NO_DATA_ONDELIVERING;
        [tableV addSubview:_markedWordsLblOndelivering];
    }else if (tableV == self.tableCompleted){
        if (!_logoImgEmptyCompleted) {
            _logoImgEmptyCompleted = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
            _logoImgEmptyCompleted.backgroundColor = [UIColor clearColor];
        }
        _logoImgEmptyCompleted.image = [UIImage imageNamed:@"checkLogo"];
        _logoImgEmptyCompleted.center = CGPointMake(ScreenWidth/2, (ScreenHeight-50-64)/3);
        [tableV addSubview:_logoImgEmptyCompleted];
        if (!_markedWordsLblCompleted) {
            _markedWordsLblCompleted = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgEmptyCompleted) +Space_Big, ScreenWidth, 30)];
            _markedWordsLblCompleted.backgroundColor = [UIColor clearColor];
            _markedWordsLblCompleted.textAlignment = NSTextAlignmentCenter;
            _markedWordsLblCompleted.textColor     = DeepGrey;
            _markedWordsLblCompleted.font          = FONT_SIZE(BigFontSize);
        }
        _markedWordsLblCompleted.text = SS_NO_DATA_COMPLETED;
        [tableV addSubview:_markedWordsLblCompleted];
    }else if (tableV == self.tableCanceled){
        if (!_logoImgEmptyCanceled) {
            _logoImgEmptyCanceled = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
            _logoImgEmptyCanceled.backgroundColor = [UIColor clearColor];
        }
        _logoImgEmptyCanceled.image = [UIImage imageNamed:@"checkLogo"];
        _logoImgEmptyCanceled.center = CGPointMake(ScreenWidth/2, (ScreenHeight-50-64)/3);
        [tableV addSubview:_logoImgEmptyCanceled];
        if (!_markedwordsLblCanceled) {
            _markedwordsLblCanceled = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgEmptyCanceled) +Space_Big, ScreenWidth, 30)];
            _markedwordsLblCanceled.backgroundColor = [UIColor clearColor];
            _markedwordsLblCanceled.textAlignment = NSTextAlignmentCenter;
            _markedwordsLblCanceled.textColor     = DeepGrey;
            _markedwordsLblCanceled.font          = FONT_SIZE(BigFontSize);
        }
        _markedwordsLblCanceled.text = SS_NO_DATA_CANCELED;
        [tableV addSubview:_markedwordsLblCanceled];
    }
}

- (void)_hideTableEmpty:(UITableView *)tableV{
    if (tableV == self.tableUnpay) {
        if (_logoImgEmptyUnpay) {
            [_logoImgEmptyUnpay removeFromSuperview];
        }
        if (_markedWordsLblUnpay) {
            [_markedWordsLblUnpay removeFromSuperview];
        }
    }else if (tableV == self.tableUngrab){
        if (_logoImgEmptyUngrab) {
            [_logoImgEmptyUngrab removeFromSuperview];
        }
        if (_markedWordsLblUngrab) {
            [_markedWordsLblUngrab removeFromSuperview];
        }
    }else if (tableV == self.tableOntaking){
        if (_logoImgEmptyOntaking) {
            [_logoImgEmptyOntaking removeFromSuperview];
        }
        if (_markedWordsLblOntaking) {
            [_markedWordsLblOntaking removeFromSuperview];
        }
    }else if (tableV == self.tableOndelivering){
        if (_logoImgEmptyOndelivering) {
            [_logoImgEmptyOndelivering removeFromSuperview];
        }
        if (_markedWordsLblOndelivering) {
            [_markedWordsLblOndelivering removeFromSuperview];
        }
    }else if (tableV == self.tableCompleted){
        if (_logoImgEmptyCompleted) {
            [_logoImgEmptyCompleted removeFromSuperview];
        }
        if (_markedWordsLblCompleted) {
            [_markedWordsLblCompleted removeFromSuperview];
        }
    }else if (tableV == self.tableCanceled){
        if (_logoImgEmptyCanceled) {
            [_logoImgEmptyCanceled removeFromSuperview];
        }
        if (_markedwordsLblCanceled) {
            [_markedwordsLblCanceled removeFromSuperview];
        }
    }
}



#pragma mark - API - 上拉
- (void)tlir_tableViewFooterRefresh{
    NSInteger currentPage = 1;
    if (_orderListStatus == SSMyOrderStatusUnpayed) {
        currentPage = ++_currentPageUnpay;
    }else if (_orderListStatus == SSMyOrderStatusUngrab) {
        currentPage = ++_currentPageUngrab;
    }else if (_orderListStatus == SSMyOrderStatusOntaking) {
        currentPage = ++_currentPageOntaking;
    }else if (_orderListStatus == SSMyOrderStatusOnDelivering) {
        currentPage = ++_currentPageOndelivering;
    }else if (_orderListStatus == SSMyOrderStatusCompleted) {
        currentPage = ++_currentPageCompleted;
    }else if (_orderListStatus == SSMyOrderStatusCanceled) {
        currentPage = ++_currentPageCanceled;
    }
    NSDictionary * paraData = @{
                                @"businessId":[UserInfo getUserId],//[NSNumber numberWithInt:2125],//[UserInfo getUserId],
                                @"status":[NSString stringWithFormat:@"%ld",(long)_orderListStatus],
                                @"platform":@"1,3",//[NSNumber numberWithInteger:1],
                                @"currentPage":[NSNumber numberWithInteger:currentPage],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraData];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraData = @{@"data":aesString,};
    }
    __block SSMyOrdersVC * blockSelf = self;
    _operation = [SSHttpReqServer shanSongQueryOrderB:paraData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [blockSelf endTheFooterRefreshingWithStatus:_orderListStatus];
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSDictionary * result = [responseObject objectForKey:@"result"];
            long unpayCount = [[result objectForKey:@"waitPayCount"] longValue];
            long ungrabCount = [[result objectForKey:@"newCount"] longValue];
            long onTakingCount = [[result objectForKey:@"deliveryCount"] longValue];
            long onDeliveryingCount = [[result objectForKey:@"takingCount"] longValue];
            long completedCount = [[result objectForKey:@"hadCompleteCount"] longValue];
            long completedCount22 = [[result objectForKey:@"hadCompleteCount"] longValue];

            [self setOptionButton:self.buttonUnpay count:unpayCount];
            [self setOptionButton:self.buttonUngrab count:ungrabCount];
            [self setOptionButton:self.buttonOntaking count:onTakingCount];
            [self setOptionButton:self.buttonOndelivering count:onDeliveryingCount];
            [self setOptionButton:self.buttonCompleted count:completedCount];
            [self setOptionButton:self.buttonCanceled count:completedCount22];
            NSArray * orderRespModel = [result objectForKey:@"orders"];
            
            if (_orderListStatus == SSMyOrderStatusUnpayed) {
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * orderModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceUnpay addObject:orderModel];
                }
                [_tableUnpay reloadData];
                if ([orderRespModel count] == 0){
                    _tableUnpay.footer.state = MJRefreshFooterStateNoMoreData;
                }
            }else if (_orderListStatus == SSMyOrderStatusUngrab){
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * regioinModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceUngrab addObject:regioinModel];
                }
                [_tableUngrab reloadData];
                if ([orderRespModel count] == 0){
                    _tableUngrab.footer.state = MJRefreshFooterStateNoMoreData;
                }
            }else if (_orderListStatus == SSMyOrderStatusOntaking){
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * regioinModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceOntaking addObject:regioinModel];
                }
                [_tableOntaking reloadData];
                if ([orderRespModel count] == 0){
                    _tableOntaking.footer.state = MJRefreshFooterStateNoMoreData;
                }
            }else if (_orderListStatus == SSMyOrderStatusOnDelivering){
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * regioinModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceOndelivering addObject:regioinModel];
                }
                [_tableOndelivering reloadData];
                if ([orderRespModel count] == 0){
                    _tableOndelivering.footer.state = MJRefreshFooterStateNoMoreData;
                }
            }else if (_orderListStatus == SSMyOrderStatusCompleted){
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * regioinModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceCompleted addObject:regioinModel];
                }
                [_tableCompleted reloadData];
                if ([orderRespModel count] == 0){
                    _tableCompleted.footer.state = MJRefreshFooterStateNoMoreData;
                }
            }else if (_orderListStatus == SSMyOrderStatusCanceled){
                for (NSDictionary * aRespModel in orderRespModel) {
                    SSMyOrderModel * regioinModel = [[SSMyOrderModel alloc] initWithDic:aRespModel];
                    [_datasourceCanceled addObject:regioinModel];
                }
                [_tableCanceled reloadData];
                if ([orderRespModel count] == 0){
                    _tableCanceled.footer.state = MJRefreshFooterStateNoMoreData;
                }
            }
            
        }else{
            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [blockSelf endTheFooterRefreshingWithStatus:_orderListStatus];
    }];

}

#pragma mark - 支付未支付的代理
- (void)orderUnpayCell:(SSOrderUnpayCell *)cell payWithId:(NSString *)orderId{
    
}

#pragma mark - 加小费
- (void)orderUngrabCell:(SSOrderUngrabCell *)cell payXiaoFeeWithId:(NSString *)orderId{
    
}


@end
