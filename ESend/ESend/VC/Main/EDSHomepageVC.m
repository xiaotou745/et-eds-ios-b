//
//  EDSHomepageVC.m
//  ESend
//
//  Created by Maxwell on 15/9/18.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSHomepageVC.h"
#import "OrdersListTableVIewCell.h"
#import "MJRefresh.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"

#import "ReleseOrderViewController.h"

#define HPUserStatusInReviewMsg @"您目前没有通过验证，无法发单!"
#define HPBottomButtonTitleRelease @"发  布"
#define HPBottomButtonTilteInReview @"审核中"

@interface EDSHomepageVC ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate>
{
    // 第一个table,异常提示
    UIImageView * _logoImgViewS1;
    UILabel     * _markedWordsLabelS1;
    
    // 第二个table,异常提示
    UIImageView * _logoImgViewS2;
    UILabel     * _markedWordsLabelS2;
    
    // 第三个table,异常提示
    UIImageView * _logoImgViewS3;
    UILabel     * _markedWordsLabelS3;
}
@property (strong, nonatomic) IBOutlet UIView *Hp_MainBg;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Hp_MainBg_top;   // default 64

// option area
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Hp_OptionBgHeight;// default 50

@property (strong, nonatomic) IBOutlet UIButton *Hp_OptionBtn1st;           // 待接单 button
@property (strong, nonatomic) IBOutlet UIButton *Hp_OptionBtn2nd;           // 待取货 button
@property (strong, nonatomic) IBOutlet UIButton *Hp_Option3rd;              // 配送中 button

@property (strong, nonatomic) IBOutlet UIImageView *Hp_OptionSeparator11;   // 分割线11

@property (strong, nonatomic) IBOutlet UIImageView *Hp_OptionSeparator12;   // 分割线12
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Hp_OptionSeparatorHeight;    // default 30

@property (strong, nonatomic) IBOutlet UILabel *Hp_OptionIndicator;                 // 选择指示标志


// list area

@property (strong, nonatomic) IBOutlet UIScrollView *Hp_ListMainScroller;   // Horizonal scroller
@property (strong, nonatomic) IBOutlet UIView *Hp_ListMainScrollerContent;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Hp_ListMainScrollerContentWidth;     // 宽度，3倍

@property (strong, nonatomic) IBOutlet UITableView *Hp_ContentList1st;
@property (strong, nonatomic) IBOutlet UITableView *Hp_ContentList2nd;
@property (strong, nonatomic) IBOutlet UITableView *Hp_ContentList3rd;


// action  button

@property (strong, nonatomic) IBOutlet UIButton *Hp_BottomBtn;      // 底部button


// datasource
@property (strong, nonatomic) NSMutableArray * Hp_ContentLists1st;
@property (strong, nonatomic) NSMutableArray * Hp_ContentLists2nd;
@property (strong, nonatomic) NSMutableArray * Hp_ContentLists3rd;

@end

@implementation EDSHomepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:UserStatusChangeToReviewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseOrderSuccess) name:ReleseOrderNotification object:nil];
    
    _Hp_ContentLists1st = [[NSMutableArray alloc] initWithCapacity:0];
    _Hp_ContentLists2nd = [[NSMutableArray alloc] initWithCapacity:0];
    _Hp_ContentLists3rd = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self _configOptionPullRefresh:self.Hp_ContentList1st];
    [self _configOptionPullRefresh:self.Hp_ContentList2nd];
    [self _configOptionPullRefresh:self.Hp_ContentList3rd];
    
    /// table状态显示
    [self _configTableExceptionViews];
    
    [self.Hp_BottomBtn setTitle:HPBottomButtonTitleRelease forState:UIControlStateNormal];
    [self.Hp_BottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.Hp_BottomBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:@"blue_btn_noSelect"];
    [self.Hp_BottomBtn addTarget:self action:@selector(releseTask) forControlEvents:UIControlEventTouchUpInside];
    
    if ([UserInfo getStatus] != UserStatusComplete) {
        [self.Hp_BottomBtn setTitle:HPBottomButtonTilteInReview forState:UIControlStateNormal];
        self.Hp_BottomBtn.enabled = NO;
        
    }else{
        [self.Hp_BottomBtn setTitle:HPBottomButtonTitleRelease forState:UIControlStateNormal];
        self.Hp_BottomBtn.enabled = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    
    self.Hp_ListMainScrollerContentWidth.constant = MainWidth * 3;
}

#pragma mark - Config Refresh Setting
- (void)_configOptionPullRefresh:(UITableView *)tabler
{
    // 添加动画图片的下拉刷新
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadNewData方法）
    if (tabler == self.Hp_ContentList1st) {
        [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(_refreshOptionArea1st)];
    }else if (tabler == self.Hp_ContentList2nd) {
        [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(_refreshOptionArea2nd)];
    }else if (tabler == self.Hp_ContentList3rd) {
        [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(_refreshOptionArea3rd)];
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



- (void)_refreshOptionArea1st{
    
}

- (void)_refreshOptionArea2nd{
    
}

- (void)_refreshOptionArea3rd{
    
}

#pragma mark - Config Table Exception Views
- (void)_configTableExceptionViews{
    // 提示logo s1
    _logoImgViewS1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    _logoImgViewS1.backgroundColor = [UIColor clearColor];
    _logoImgViewS1.center          = CGPointMake(ScreenWidth/2, (ScreenHeight-self.Hp_OptionBgHeight.constant-64)/3);
    [self.Hp_ContentList1st addSubview:_logoImgViewS1];
    // 提示语 s1
    _markedWordsLabelS1 = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgViewS1) +Space_Big, ScreenWidth, 30)];
    _markedWordsLabelS1.backgroundColor = [UIColor clearColor];
    _markedWordsLabelS1.textAlignment = NSTextAlignmentCenter;
    _markedWordsLabelS1.textColor     = DeepGrey;
    _markedWordsLabelS1.font          = FONT_SIZE(BigFontSize);
    [self.Hp_ContentList1st addSubview:_markedWordsLabelS1];
    
    // 提示logo s2
    _logoImgViewS2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    _logoImgViewS2.backgroundColor = [UIColor clearColor];
    _logoImgViewS2.center          = CGPointMake(ScreenWidth/2, (ScreenHeight-self.Hp_OptionBgHeight.constant-64)/3);
    [self.Hp_ContentList2nd addSubview:_logoImgViewS2];
    // 提示语 s2
    _markedWordsLabelS2 = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgViewS2) +Space_Big, ScreenWidth, 30)];
    _markedWordsLabelS2.backgroundColor = [UIColor clearColor];
    _markedWordsLabelS2.textAlignment = NSTextAlignmentCenter;
    _markedWordsLabelS2.textColor     = DeepGrey;
    _markedWordsLabelS2.font          = FONT_SIZE(BigFontSize);
    [self.Hp_ContentList2nd addSubview:_markedWordsLabelS2];
    
    // 提示logo s3
    _logoImgViewS3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    _logoImgViewS3.backgroundColor = [UIColor clearColor];
    _logoImgViewS3.center          = CGPointMake(ScreenWidth/2, (ScreenHeight-self.Hp_OptionBgHeight.constant-64)/3);
    [self.Hp_ContentList3rd addSubview:_logoImgViewS3];
    // 提示语 s3
    _markedWordsLabelS3 = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_logoImgViewS3) +Space_Big, ScreenWidth, 30)];
    _markedWordsLabelS3.backgroundColor = [UIColor clearColor];
    _markedWordsLabelS3.textAlignment = NSTextAlignmentCenter;
    _markedWordsLabelS3.textColor     = DeepGrey;
    _markedWordsLabelS3.font          = FONT_SIZE(BigFontSize);
    [self.Hp_ContentList3rd addSubview:_markedWordsLabelS3];
    
    
    if ([UserInfo getStatus] != UserStatusComplete) {
        _logoImgViewS3.image =
        _logoImgViewS2.image =
        _logoImgViewS1.image = [UIImage imageNamed:@"checkLogo"];
        _markedWordsLabelS3.text =
        _markedWordsLabelS2.text =
        _markedWordsLabelS1.text = HPUserStatusInReviewMsg;
        
    }else if ([UserInfo isLogin]) {
        _logoImgViewS3.image =
        _logoImgViewS2.image =
        _logoImgViewS1.image = nil;
        _markedWordsLabelS3.text =
        _markedWordsLabelS2.text =
        _markedWordsLabelS1.text = @"";
        
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _ordersList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 20)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    OrdersListTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OrdersListTableVIewCell class]) forIndexPath:indexPath];
    [cell loadData:_ordersList[indexPath.section]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [OrdersListTableVIewCell calculateCellHeight:[_ordersList objectAtIndex:indexPath.section]];
}



#pragma mark - ButtonAction 
- (void)releseTask {
    ReleseOrderViewController *vc = [[ReleseOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
