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
#import "UIAlertView+Blocks.h"
#import "EDSBusinessQRVC.h"
#import "CustomIOSAlertView.h"
#import "UserInfo.h"

#define MC_HeadButtonTagTrans 1105

#define MC_Table_1st_cellId @"MC_Table_1st_cellId"
#define MC_Table_2nd_cellId @"MC_Table_2nd_cellId"

#define MC_NoDataS1 @"您目前没有服务中的骑士!"
#define MC_NoDataS2 @"您目前没有申请中的骑士!"

#define MC_AddClienterTitle @"是否添加该骑士?"
#define MC_RejectClienterTitle @"是否拒绝添加该骑士?"

#define MC_CancelButtonTitle @"取消"
#define MC_ConfirmButtonTitle @"确定"

#define MC_Default_PageSize  15

#define MC_ReasonAlertMsg @"请输入5-100个字符"

@interface EDSMyClientersVC ()<UITableViewDataSource,UITableViewDelegate,EDSMyClienterCellDelegate,UITextViewDelegate>
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
    
    // textView
    UITextView * _remarkTextView;  // 解除绑定骑士输入框
    UILabel * _remarkPlaceholder;  // 解除原因placeholder
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
    
    [self _configNavButtons];
    [self mc_configOptionView];
    [self _configOptionPullRefresh:self.MC_Table1];
    [self _configOptionPullRefresh:self.MC_Table2];
}

- (void)_configNavButtons{
    // right
    [self.rightBtn setImage:[UIImage imageNamed:@"QR_CodeImg_Normal"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(myQRCodeBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)myQRCodeBtnAction{
    EDSBusinessQRVC * bqr = [[EDSBusinessQRVC alloc] initWithNibName:NSStringFromClass([EDSBusinessQRVC class]) bundle:nil];
    [self.navigationController pushViewController:bqr animated:YES];
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
        cell.buttonTitle = EDSMyClienterApplyingReject;
        cell.buttonTitle2 = EDSMyClienterApplyingAdd;
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
                                @"businessId":[UserInfo getUserId],
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
                if (_MC_TableDatasource1.count >= MC_Default_PageSize) {
                    if (self.MC_Table1.footer) {
                        [self.MC_Table1 removeFooter];
                    }
                    [self.MC_Table1 addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(mc_tableViewFooterRefresh)];
                    self.MC_Table1.footer.state = MJRefreshFooterStateIdle;
                }
                
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
                if (_MC_TableDatasource2.count >= MC_Default_PageSize) {
                    if (self.MC_Table2.footer) {
                        [self.MC_Table2 removeFooter];
                    }
                    [self.MC_Table2 addLegendFooterWithRefreshingTarget:self refreshingAction:@selector(mc_tableViewFooterRefresh)];
                    self.MC_Table2.footer.state = MJRefreshFooterStateIdle;
                }
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

/// 解除绑定骑士接口removerelation
- (void)removeClienterRelation:(NSInteger)clienterId remark:(NSString *)remark{
    NSDictionary * paraDict = @{
                                @"businessId":[UserInfo getUserId],
                                @"clienterId":[NSNumber numberWithInteger:clienterId],
                                @"remark":remark,
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{@"data":aesString,};
    }
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [EDSHttpReqManager3 removerelation:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            [Tools showHUD:@"解除成功"];
            [self.MC_Table1.header beginRefreshing];
        }else{
            NSLog(@"%@",message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
    }];
}

/// 添加骑士，拒绝骑士 auditStatus 1审核通过，2审核拒绝
- (void)optBindClienterWithRelationId:(NSInteger)relationId businessId:(NSInteger)businessId auditStatus:(NSInteger)auditStatus{
    NSDictionary * paraDict = @{
                                @"relationId":[NSNumber numberWithInteger:relationId],
                                @"businessId":[NSNumber numberWithInteger:businessId],
                                @"auditStatus":[NSNumber numberWithInteger:auditStatus],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{
                     @"data":aesString,
                     };
    }
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [EDSHttpReqManager3 optbindclienter:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            [Tools showHUD:(auditStatus == 1)?@"添加成功":@"拒绝成功"];
            [self.MC_Table2.header beginRefreshing];
        }else{
            NSLog(@"%@",message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
    }];
}

/// 上拉刷新
- (void)mc_tableViewFooterRefresh{
    NSInteger currentPage = 1;
    if (_selectedStatus == MyClienterStatusInService) {
        currentPage = ++_currentPage1st;
    }else if (_selectedStatus == MyClienterStatusApplying) {
        currentPage = ++_currentPage2nd;
    }
    NSDictionary * paraData = @{
                                @"businessId":[UserInfo getUserId],
                                @"auditStatus":[NSString stringWithFormat:@"%ld",(long)_selectedStatus],
                                @"currentPage":[NSNumber numberWithInteger:1],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraData];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraData = @{@"data":aesString,};
    }
    
    [EDSHttpReqManager3 getmyserviceclienters:paraData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (_selectedStatus == MyClienterStatusInService) {
            [self.MC_Table1.footer endRefreshing];
        }else if (_selectedStatus == MyClienterStatusApplying) {
            [self.MC_Table2.footer endRefreshing];
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
                for (NSDictionary * aRespModel in orderRespModel) {
                    EDSMyClienter * regioinModel = [[EDSMyClienter alloc] initWithDic:aRespModel];
                    [_MC_TableDatasource1 addObject:regioinModel];
                }
                [_MC_Table1 reloadData];
                if ([orderRespModel count] == 0){
                    _MC_Table1.footer.state = MJRefreshFooterStateNoMoreData;
                }
            }else if (_selectedStatus == MyClienterStatusApplying){
                for (NSDictionary * aRespModel in orderRespModel) {
                    EDSMyClienter * regioinModel = [[EDSMyClienter alloc] initWithDic:aRespModel];
                    [_MC_TableDatasource2 addObject:regioinModel];
                }
                [_MC_Table2 reloadData];
                if ([orderRespModel count] == 0){
                    _MC_Table2.footer.state = MJRefreshFooterStateNoMoreData;
                }
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
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        NSString * alertTitle = @"解除绑定骑士";
        [alertView setContainerView:[self mc_createAlertView:alertTitle content:userInfo]];
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        __block EDSMyClientersVC * blockSelf = self;
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            if (1 == buttonIndex) {
                if (_remarkTextView.text.length >= 5 && _remarkTextView.text.length <= 100) {
                    [alertView close];
                    [blockSelf removeClienterRelation:userInfo.clienterId remark:_remarkTextView.text];
                }else{
                    [Tools showHUD:MC_ReasonAlertMsg];
                }
            }else{
                [alertView close];
            }
        }];
        [alertView setUseMotionEffects:true];
        [alertView show];
    }else if ([title compare:EDSMyClienterApplyingAdd] == NSOrderedSame){ // 添加
        [UIAlertView showAlertViewWithTitle:MC_AddClienterTitle message:nil cancelButtonTitle:MC_CancelButtonTitle otherButtonTitles:@[MC_ConfirmButtonTitle] onDismiss:^(NSInteger buttonIndex) {
            [self optBindClienterWithRelationId:userInfo.relationId businessId:[[UserInfo getUserId] integerValue] auditStatus:1];
        } onCancel:^{
            
        }];
    }else if ([title compare:EDSMyClienterApplyingReject] == NSOrderedSame){ // 拒绝
        [UIAlertView showAlertViewWithTitle:MC_RejectClienterTitle message:nil cancelButtonTitle:MC_CancelButtonTitle otherButtonTitles:@[MC_ConfirmButtonTitle] onDismiss:^(NSInteger buttonIndex) {
            [self optBindClienterWithRelationId:userInfo.relationId businessId:[[UserInfo getUserId] integerValue] auditStatus:2];
        } onCancel:^{
            
        }];
    }
}

- (UIView *)mc_createAlertView:(NSString *)alertTitle content:(EDSMyClienter *)cInfo{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(demoView.frame), 50)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = DeepGrey;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:15];
    titleLabel.text = alertTitle;
    [demoView addSubview:titleLabel];
    
    UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame) + 1, CGRectGetWidth(demoView.frame), 0.5f)];
    line.backgroundColor = [UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f];
    [demoView addSubview:line];
    
    CGFloat labelLeftMargin = 20;
    CGFloat labelWidth = 60;
    CGFloat labelHeight = 22;
    CGFloat padding = 5;
    UILabel * nameFix = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftMargin, CGRectGetMaxY(line.frame)+padding, labelWidth, labelHeight)];
    [self _alertViewLabel:nameFix];
    nameFix.text = @"骑士姓名:";
    [demoView addSubview:nameFix];
    UILabel * phoneFix = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftMargin, CGRectGetMaxY(nameFix.frame) + padding, labelWidth, labelHeight)];
    [self _alertViewLabel:phoneFix];
    phoneFix.text = @"骑士电话:";
    [demoView addSubview:phoneFix];
    UILabel * remarkFix = [[UILabel alloc] initWithFrame:CGRectMake(labelLeftMargin, CGRectGetMaxY(phoneFix.frame) + padding * 2, labelWidth, labelHeight)];
    [self _alertViewLabel:remarkFix];
    remarkFix.text = @"解除原因:";
    [demoView addSubview:remarkFix];
    
    UILabel * name = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(nameFix.frame), nameFix.frame.origin.y, CGRectGetWidth(demoView.frame) - CGRectGetWidth(nameFix.frame), labelHeight)];
    [self _alertViewLabel:name];
    name.text = cInfo.trueName;
    [demoView addSubview:name];
    
    UILabel * phone = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(phoneFix.frame), phoneFix.frame.origin.y, CGRectGetWidth(demoView.frame) - CGRectGetWidth(phoneFix.frame), labelHeight)];
    [self _alertViewLabel:phone];
    phone.text = cInfo.phoneNo;
    [demoView addSubview:phone];
    
    if (!_remarkPlaceholder) {
        _remarkPlaceholder = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(remarkFix.frame) + padding, remarkFix.frame.origin.y, CGRectGetWidth(demoView.frame) - CGRectGetWidth(remarkFix.frame) - labelLeftMargin*2, labelHeight)];
        _remarkPlaceholder.font = [UIFont systemFontOfSize:13];
        _remarkPlaceholder.textAlignment = NSTextAlignmentLeft;
        _remarkPlaceholder.textColor = TextColor9;
    }
    _remarkPlaceholder.text = MC_ReasonAlertMsg;
    [demoView addSubview:_remarkPlaceholder];
    
    if (!_remarkTextView) {
        _remarkTextView = [[UITextView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(remarkFix.frame), remarkFix.frame.origin.y - padding, CGRectGetWidth(demoView.frame) - CGRectGetWidth(remarkFix.frame) - labelLeftMargin*2, 60)];
        _remarkTextView.font = [UIFont systemFontOfSize:13];
        _remarkTextView.textColor = TextColor6;
        _remarkTextView.layer.borderColor = [[UIColor colorWithRed:198.0/255.0 green:198.0/255.0 blue:198.0/255.0 alpha:1.0f] CGColor];
        _remarkTextView.layer.borderWidth = 0.5f;
        _remarkTextView.layer.cornerRadius = 2.0f;
        _remarkTextView.delegate = self;
        _remarkTextView.backgroundColor = [UIColor clearColor];
    }
    _remarkTextView.text = @"";
//    _remarkTextView.text = @"请输入一百个字八九十请输入一百个字八九十请输入一百个字八九十请输入一百个字八九十请输入一百个字八九十请输入一百个字八九十请输入一百个字八九十请输入一百个字八九十请输入一百个字八九十请输入一百个字八九十";
    [demoView addSubview:_remarkTextView];
    
    [demoView setFrame:CGRectMake(0, 0, 290, CGRectGetMaxY(_remarkTextView.frame) + padding)];
    
    return demoView;
}
- (void)_alertViewLabel:(UILabel *)label{
    label.backgroundColor = [UIColor clearColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = TextColor6;
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (_remarkTextView == textView) {
        if ([toBeString length] > 100 ) {
            textView.text = [toBeString substringToIndex:100];
            [Tools showHUD:MC_ReasonAlertMsg];
            return NO;
        }
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _remarkPlaceholder.text = MC_ReasonAlertMsg;
    }else{
        _remarkPlaceholder.text = @"";
    }
}

@end
