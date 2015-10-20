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
#import "MineViewController.h"
#import "OrderDetailViewController.h"

#import "SCMessageView.h"
#import "MessageDetailViewController.h"

#define HPUserStatusInReviewMsg @"您目前没有通过验证，无法发单!"
#define HPBottomButtonTitleRelease @"发  布"
#define HPBottomButtonTilteInReview @"审核中"

#define HPNoDataS1 @"您目前没有待接单的订单!"
#define HPNoDataS2 @"您目前没有待取货的订单!"
#define HPNoDataS3 @"您目前没有配送中的订单!"

#define Hp_Cell_1st_Id @"Hp_ContentList1stCellId"
#define Hp_Cell_2nd_Id @"Hp_ContentList2ndCellId"
#define Hp_Cell_3rd_Id @"Hp_ContentList3rdCellId"

#define HeadButtonTagTrans 918



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
    
    ///
    OrderStatus _orderListStatus;  //0,2,4
    
    /// operation
    AFHTTPRequestOperation *_operation;
    
    // 第一次滚动到右边时刷新，0次，2次以及多次不自动刷新
    // 滚动到section的次数
    int _timesScrollToMiddle;
    int _timesScrollToRight;

    // 首页公告
    NSString *_newMessageTEXT;
    NSString *_newMessageID;
    SCMessageView * _scMsgView;
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
    
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    // notifications
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:UserStatusChangeToReviewNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLogout) name:LogoutNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releseOrderSuccessfully:) name:ReleseOrderNotification object:nil];
    // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelOrder:) name:CancelOrderNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userStatusChanged) name:UserStatusChangeToReviewNotification object:nil];
    
    _Hp_ContentLists1st = [[NSMutableArray alloc] initWithCapacity:0];
    _Hp_ContentLists2nd = [[NSMutableArray alloc] initWithCapacity:0];
    _Hp_ContentLists3rd = [[NSMutableArray alloc] initWithCapacity:0];
    
    _orderListStatus = OrderStatusNewOrder;
    
    self.titleLabel.text = @"呼叫配送员";
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18]}];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth/2 - titleSize.width/2 - 20 - 5, 20 + (44 - titleSize.height)/2, 20, 20)];
    iconView.image = [UIImage imageNamed:@"icon_80"];
    iconView.layer.cornerRadius = 5;
    iconView.layer.masksToBounds = YES;
    [self.navBar addSubview:iconView];
    
    self.leftBtn.hidden = YES;
    
    [self.rightBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickUser) forControlEvents:UIControlEventTouchUpInside];
    
    // separators config
    self.Hp_OptionSeparator11.backgroundColor =
    self.Hp_OptionSeparator12.backgroundColor = LightGrey;
    
    // optionView  buttons
    self.Hp_OptionBtn1st.tag = 1 + HeadButtonTagTrans;
    self.Hp_OptionBtn2nd.tag = 2 + HeadButtonTagTrans;
    self.Hp_Option3rd.tag = 3 + HeadButtonTagTrans;
    
    self.Hp_OptionBtn1st.enabled = NO;
    
    [self setOptionButton:self.Hp_OptionBtn1st count:0];
    [self setOptionButton:self.Hp_OptionBtn2nd count:0];
    [self setOptionButton:self.Hp_Option3rd count:0];
    
    self.Hp_OptionIndicator.backgroundColor = BlueColor;
    
    self.Hp_Option3rd.titleLabel.font =
    self.Hp_OptionBtn2nd.titleLabel.font =
    self.Hp_OptionBtn1st.titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    self.Hp_Option3rd.backgroundColor =
    self.Hp_OptionBtn2nd.backgroundColor =
    self.Hp_OptionBtn1st.backgroundColor = [UIColor whiteColor];
    [self.Hp_Option3rd setTitleColor:DeepGrey forState:UIControlStateNormal];
    [self.Hp_OptionBtn2nd setTitleColor:DeepGrey forState:UIControlStateNormal];
    [self.Hp_OptionBtn1st setTitleColor:DeepGrey forState:UIControlStateNormal];
    
    // table refresh
    
    [self _configOptionPullRefresh:self.Hp_ContentList1st];
    [self _configOptionPullRefresh:self.Hp_ContentList2nd];
    [self _configOptionPullRefresh:self.Hp_ContentList3rd];
    
    /// table状态显示
    [self _configTableExceptionViews];
    /// 设置tables
    [self _configTablesProperty];
    
    /// 底部button
    [self.Hp_BottomBtn setTitle:HPBottomButtonTitleRelease forState:UIControlStateNormal];
    [self.Hp_BottomBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.Hp_BottomBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:@"blue_btn_noSelect"];
    [self.Hp_BottomBtn addTarget:self action:@selector(releseTask) forControlEvents:UIControlEventTouchUpInside];
    
    [self userLoginSuccess];
//    if ([UserInfo getStatus] != UserStatusComplete) {
//        [self.Hp_BottomBtn setTitle:HPBottomButtonTilteInReview forState:UIControlStateNormal];
//        self.Hp_BottomBtn.enabled = NO;
//        
//    }else{
//        [self.Hp_BottomBtn setTitle:HPBottomButtonTitleRelease forState:UIControlStateNormal];
//        self.Hp_BottomBtn.enabled = YES;
//    }
    
    // 滚动到section的次数
    _timesScrollToMiddle = 0;
    _timesScrollToRight = 0;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_scMsgView) {
        [_scMsgView removeFromSuperview];
        _scMsgView = nil;
        self.Hp_MainBg_top.constant = 64;

    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //
    if (_orderListStatus == OrderStatusNewOrder) {
        [self.Hp_ContentList1st.header beginRefreshing];
    }else if (_orderListStatus == OrderStatusAccepted) {
        [self.Hp_ContentList2nd.header beginRefreshing];
    }else if (_orderListStatus == OrderStatusReceive){
        [self.Hp_ContentList3rd.header beginRefreshing];
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
        [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(_refreshOptionAreaAction)];
    }else if (tabler == self.Hp_ContentList2nd) {
        [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(_refreshOptionAreaAction)];
    }else if (tabler == self.Hp_ContentList3rd) {
        [tabler addGifHeaderWithRefreshingTarget:self refreshingAction:@selector(_refreshOptionAreaAction)];
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


- (void)_refreshOptionAreaAction{
    
    if ([UserInfo isLogin]) {
        // 商家端是否有新公告消息
        [self newMessagesB];
    }
    
    if (![UserInfo isLogin]) {
        if (_orderListStatus == OrderStatusNewOrder) {
            [self.Hp_ContentList1st.header endRefreshing];
        }else if (_orderListStatus == OrderStatusAccepted) {
            [self.Hp_ContentList2nd.header endRefreshing];
        }else if (_orderListStatus == OrderStatusReceive) {
            [self.Hp_ContentList3rd.header endRefreshing];
        }
        return;
    }
    
    if (_operation) {
        [_operation cancel];
        _operation = nil;
        if (_orderListStatus == OrderStatusNewOrder) {
            [self.Hp_ContentList1st.header endRefreshing];
        }else if (_orderListStatus == OrderStatusAccepted) {
            [self.Hp_ContentList2nd.header endRefreshing];
        }else if (_orderListStatus == OrderStatusReceive) {
            [self.Hp_ContentList3rd.header endRefreshing];
        }
    }
    
    
    NSDictionary * paraData = @{
                                @"businessId":[UserInfo getUserId],
                                @"status":[NSString stringWithFormat:@"%ld",(long)_orderListStatus],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraData];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraData = @{
                     @"data":aesString,
                     //@"Version":[Tools getApplicationVersion],
                     };
    }
    
    _operation = [FHQNetWorkingAPI queryorderb:paraData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"111111 result %@",result);
        
        if ([UserInfo getStatus] != UserStatusComplete) {
            [UserInfo saveStatus:UserStatusComplete];
            [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangeToReviewNotification object:nil];
        }
        
        //java
        long newCount = [[result objectForKey:@"newCount"] longValue];
        long takingCount = [[result objectForKey:@"takingCount"] longValue];     // 配送中
        long deliveryCount = [[result objectForKey:@"deliveryCount"] longValue]; // 待取货
        
        [self setOptionButton:self.Hp_OptionBtn1st count:newCount];
        [self setOptionButton:self.Hp_OptionBtn2nd count:deliveryCount];
        [self setOptionButton:self.Hp_Option3rd count:takingCount];
        
        NSArray * orders = [result objectForKey:@"orders"];

        //
        
        if (_orderListStatus == OrderStatusNewOrder) {
            [self.Hp_ContentList1st.header endRefreshing];
            
            [_Hp_ContentLists1st removeAllObjects];
            for (NSDictionary *dic in orders) {
                //SupermanOrderModel *order = [[SupermanOrderModel alloc] initWithDic:dic];
                SupermanOrderModel * order = [[SupermanOrderModel alloc] init];
                order.orderStatus = [[dic objectForKey:@"status"] integerValue];
                order.receivePhone = [dic getStringWithKey:@"recevicePhoneNo"];
                order.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                order.orderNumber = [dic objectForKey:@"orderNo"];
                order.amount = [[dic objectForKey:@"amount"] floatValue];
                order.totalAmount = [[dic objectForKey:@"totalAmount"] floatValue];
                order.receiveAddress = [dic getStringWithKey:@"receviceAddress"];
                order.orderCount = [[dic objectForKey:@"orderCount"] integerValue];
                order.pubDate = [dic objectForKey:@"pubDate"];
                [_Hp_ContentLists1st addObject:order];
            }
            
        }else if (_orderListStatus == OrderStatusAccepted) {
            [self.Hp_ContentList2nd.header endRefreshing];
            
            [_Hp_ContentLists2nd removeAllObjects];
            for (NSDictionary *dic in orders) {
                //SupermanOrderModel *order = [[SupermanOrderModel alloc] initWithDic:dic];
                SupermanOrderModel * order = [[SupermanOrderModel alloc] init];
                order.orderStatus = [[dic objectForKey:@"status"] integerValue];
                order.receivePhone = [dic getStringWithKey:@"recevicePhoneNo"];
                order.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                order.orderNumber = [dic objectForKey:@"orderNo"];
                order.amount = [[dic objectForKey:@"amount"] floatValue];
                order.totalAmount = [[dic objectForKey:@"totalAmount"] floatValue];
                order.receiveAddress = [dic getStringWithKey:@"receviceAddress"];
                order.orderCount = [[dic objectForKey:@"orderCount"] integerValue];
                order.pubDate = [dic objectForKey:@"pubDate"];

                [_Hp_ContentLists2nd addObject:order];
            }
            
        }else if (_orderListStatus == OrderStatusReceive) {
            [self.Hp_ContentList3rd.header endRefreshing];
            
            [_Hp_ContentLists3rd removeAllObjects];
            for (NSDictionary *dic in orders) {
                // SupermanOrderModel *order = [[SupermanOrderModel alloc] initWithDic:dic];
                SupermanOrderModel * order = [[SupermanOrderModel alloc] init];
                order.orderStatus = [[dic objectForKey:@"status"] integerValue];
                order.receivePhone = [dic getStringWithKey:@"recevicePhoneNo"];
                order.orderId = [NSString stringWithFormat:@"%@",[dic objectForKey:@"orderId"]];
                order.orderNumber = [dic objectForKey:@"orderNo"];
                order.amount = [[dic objectForKey:@"amount"] floatValue];
                order.totalAmount = [[dic objectForKey:@"totalAmount"] floatValue];
                order.receiveAddress = [dic getStringWithKey:@"receviceAddress"];
                order.orderCount = [[dic objectForKey:@"orderCount"] integerValue];
                order.pubDate = [dic objectForKey:@"pubDate"];

                [_Hp_ContentLists3rd addObject:order];
            }
        }
        
        [self checkIsNoData];
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
         // NSLog(@"222222 error %@",error.userInfo);
        
        if (_orderListStatus == OrderStatusNewOrder) {
            [self.Hp_ContentList1st.header endRefreshing];
        }else if (_orderListStatus == OrderStatusAccepted) {
            [self.Hp_ContentList2nd.header endRefreshing];
        }else if (_orderListStatus == OrderStatusReceive) {
            [self.Hp_ContentList3rd.header endRefreshing];
        }
        
        if (error.code == -500) {
            // NSLog(@"用户状态不对");
            
            [UserInfo saveStatus:UserStatusReviewing];
            [_Hp_ContentLists1st removeAllObjects];
            [self.Hp_ContentList1st reloadData];
            
            [_Hp_ContentLists2nd removeAllObjects];
            [self.Hp_ContentList2nd reloadData];
            
            [_Hp_ContentLists3rd removeAllObjects];
            [self.Hp_ContentList3rd reloadData];
            
            [self setOptionButton:self.Hp_OptionBtn1st count:0];
            [self setOptionButton:self.Hp_OptionBtn2nd count:0];
            [self setOptionButton:self.Hp_Option3rd count:0];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:UserStatusChangeToReviewNotification object:nil];
            
        } else {
            [self checkIsNoData];
            NSString *errorMessage = [error.userInfo getStringWithKey:@"Message"];
            if (isCanUseString(errorMessage)) {
                [Tools showHUD:errorMessage];
            } else {
                if ([AFNetworkReachabilityManager sharedManager].reachable) {
                    [Tools showHUD:@"请求失败"];
                }else{
                    
                }
            }
            
        }
        
    }];
}

- (void)checkIsNoData{
    if (_orderListStatus == OrderStatusNewOrder) {
        if (_Hp_ContentLists1st.count == 0) {
            _logoImgViewS1.image = [UIImage imageNamed:@"orderLogo"];
            _markedWordsLabelS1.text = HPNoDataS1;
        }else{
            _logoImgViewS1.image     = nil;
            _markedWordsLabelS1.text = @"";
        }
        [self.Hp_ContentList1st reloadData];
        
    }else if (_orderListStatus == OrderStatusAccepted) {
        if (_Hp_ContentLists2nd.count == 0) {
            _logoImgViewS2.image = [UIImage imageNamed:@"orderLogo"];
            _markedWordsLabelS2.text = HPNoDataS2;
        }else{
            _logoImgViewS2.image     = nil;
            _markedWordsLabelS2.text = @"";
        }
        [self.Hp_ContentList2nd reloadData];
        
    }else if (_orderListStatus == OrderStatusReceive){
        if (_Hp_ContentLists3rd.count == 0) {
            _logoImgViewS3.image = [UIImage imageNamed:@"orderLogo"];
            _markedWordsLabelS3.text = HPNoDataS3;
        }else{
            _logoImgViewS3.image     = nil;
            _markedWordsLabelS3.text = @"";
        }
        [self.Hp_ContentList3rd reloadData];
    }

}

- (void)setOptionButton:(UIButton *)btn count:(long)count{
    NSString * tCount = (count>99)?[NSString stringWithFormat:@"99+"]:[NSString stringWithFormat:@"%ld",count];
    NSString * text = nil;
    if (btn.tag == 1 + HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"待接单(%@)",tCount];
    }else if (btn.tag == 2 + HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"取货中(%@)",tCount];
    }else if (btn.tag == 3 + HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"配送中(%@)",tCount];
    }
    
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [AttributedString addAttribute:NSForegroundColorAttributeName value:DeepGrey range:NSMakeRange(0,AttributedString.length)];
    [btn setAttributedTitle:AttributedString forState:UIControlStateNormal];
    
    NSMutableAttributedString * hightedAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [hightedAttributedString addAttribute:NSForegroundColorAttributeName value:BlueColor range:NSMakeRange(0, hightedAttributedString.length)];
//    [hightedAttributedString addAttribute:NSForegroundColorAttributeName value:BlueColor range:NSMakeRange(0, 4)];
//    [hightedAttributedString addAttribute:NSForegroundColorAttributeName value:BlueColor range:NSMakeRange(AttributedString.length - 1, 1)];

    [btn setAttributedTitle:hightedAttributedString forState:UIControlStateDisabled];
    
//    if (selected)   [AttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(4,AttributedString.length-4-1)];
//    
//    else           [AttributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:SCColorText3] range:NSMakeRange(0,AttributedString.length)];
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


- (void)_configTablesProperty{
    
    [self.Hp_ContentList1st registerClass:[OrdersListTableVIewCell class] forCellReuseIdentifier:Hp_Cell_1st_Id];
    [self.Hp_ContentList2nd registerClass:[OrdersListTableVIewCell class] forCellReuseIdentifier:Hp_Cell_2nd_Id];
    [self.Hp_ContentList3rd registerClass:[OrdersListTableVIewCell class] forCellReuseIdentifier:Hp_Cell_3rd_Id];
    
    self.Hp_ContentList3rd.backgroundColor =
    self.Hp_ContentList2nd.backgroundColor =
    self.Hp_ContentList1st.backgroundColor = [UIColor clearColor];
    self.Hp_ContentList3rd.separatorStyle =
    self.Hp_ContentList2nd.separatorStyle =
    self.Hp_ContentList1st.separatorStyle = UITableViewCellSeparatorStyleNone;
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.Hp_ContentList1st) {
        return _Hp_ContentLists1st.count;
    }else if (tableView == self.Hp_ContentList2nd) {
        return _Hp_ContentLists2nd.count;
    }else if (tableView == self.Hp_ContentList3rd) {
        return _Hp_ContentLists3rd.count;
    }else{
        return 0;
    }
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
    
    if (tableView == self.Hp_ContentList1st) { // 待接单
        OrdersListTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:Hp_Cell_1st_Id forIndexPath:indexPath];
        [cell loadData:_Hp_ContentLists1st[indexPath.section]];
        return cell;
    }else if (tableView == self.Hp_ContentList2nd) {  // 待取货
        OrdersListTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:Hp_Cell_2nd_Id forIndexPath:indexPath];
        [cell loadData:_Hp_ContentLists2nd[indexPath.section]];
        return cell;
    }else if (tableView == self.Hp_ContentList3rd) {  // 配送中
        OrdersListTableVIewCell *cell = [tableView dequeueReusableCellWithIdentifier:Hp_Cell_3rd_Id forIndexPath:indexPath];
        [cell loadData:_Hp_ContentLists3rd[indexPath.section]];
        return cell;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (tableView == self.Hp_ContentList1st) { // 待接单
        return [OrdersListTableVIewCell calculateCellHeight:[_Hp_ContentLists1st objectAtIndex:indexPath.section]];
    }else if (tableView == self.Hp_ContentList2nd) {  // 待取货
        return [OrdersListTableVIewCell calculateCellHeight:[_Hp_ContentLists2nd objectAtIndex:indexPath.section]];
    }else if (tableView == self.Hp_ContentList3rd) {  // 配送中
        return [OrdersListTableVIewCell calculateCellHeight:[_Hp_ContentLists3rd objectAtIndex:indexPath.section]];
    }else{
        return 0.0f;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.Hp_ContentList1st) { // 待接单
        [self getOrderDetail:[_Hp_ContentLists1st objectAtIndex:indexPath.section] ];
    }else if (tableView == self.Hp_ContentList2nd) {  // 待取货
        [self getOrderDetail:[_Hp_ContentLists2nd objectAtIndex:indexPath.section] ];
    }else if (tableView == self.Hp_ContentList3rd) {  // 配送中
        [self getOrderDetail:[_Hp_ContentLists3rd objectAtIndex:indexPath.section] ];
    }else{
    }
}

- (void)getOrderDetail:(SupermanOrderModel*)order  {
    NSDictionary *requestData = @{@"OrderId"    : order.orderId,
                                  @"BusinessId" : [UserInfo getUserId],
                                  @"version"    : @"1.0"};
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [FHQNetWorkingAPI getOrderDetail:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        
        [order loadData:result];
        
        OrderDetailViewController *vc = [[OrderDetailViewController alloc] init];
        vc.orderModel = order;
        [self.navigationController pushViewController:vc animated:YES];
        [Tools hiddenProgress:HUD];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];
}



#pragma mark - ButtonAction 
- (void)releseTask {
    ReleseOrderViewController *vc = [[ReleseOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)clickUser{
    MineViewController *vc = [[MineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)s1ButtonAction:(UIButton *)sender {
    [self _buttonEventWithSender:sender];

}
- (IBAction)s2ButtonAction:(UIButton *)sender {
    [self _buttonEventWithSender:sender];

}
- (IBAction)s3ButtonAction:(UIButton *)sender {
    [self _buttonEventWithSender:sender];

}

- (void)_enableHeadBtns{
    self.Hp_OptionBtn1st.enabled = YES;
    self.Hp_OptionBtn2nd.enabled = YES;
    self.Hp_Option3rd.enabled = YES;
}

- (void)_buttonEventWithSender:(UIButton *)sender{
    [self _enableHeadBtns];
    sender.enabled = NO;
    [self.Hp_ListMainScroller setContentOffset:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds])*(sender.tag - 1 - HeadButtonTagTrans), 0) animated:YES];
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


#pragma mark - Scroller
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat delta = ScreenWidth/6;
    if (scrollView == self.Hp_ListMainScroller) {
        CGFloat movCenterY = self.Hp_OptionIndicator.center.y;
        CGFloat newCenterX = scrollView.contentOffset.x/3 + delta;
        self.Hp_OptionIndicator.center = CGPointMake(newCenterX, movCenterY);
        if (scrollView.contentOffset.x == 0) {// 待接单
            self.Hp_OptionBtn1st.enabled = NO;
            self.Hp_OptionBtn2nd.enabled = YES;
            self.Hp_Option3rd.enabled = YES;
            self.Hp_ContentList1st.scrollsToTop = YES;
            self.Hp_ContentList2nd.scrollsToTop = NO;
            self.Hp_ContentList3rd.scrollsToTop = NO;
            _orderListStatus = OrderStatusNewOrder;
            
            //[self switchToTakingBTN:NO];
            
        }
        if (scrollView.contentOffset.x == ScreenWidth) { // 待取货
            self.Hp_OptionBtn1st.enabled = YES;
            self.Hp_OptionBtn2nd.enabled = NO;
            self.Hp_Option3rd.enabled = YES;
            self.Hp_ContentList1st.scrollsToTop = NO;
            self.Hp_ContentList2nd.scrollsToTop = YES;
            self.Hp_ContentList3rd.scrollsToTop = NO;
            _orderListStatus = OrderStatusAccepted;
            
//            [self switchToTakingBTN:YES];
            
            _timesScrollToMiddle ++;
            if (_timesScrollToMiddle == 1) {
                [self.Hp_ContentList2nd.header beginRefreshing];
            }
            
        }
        
        if (scrollView.contentOffset.x == ScreenWidth * 2) { // 配送中
            self.Hp_OptionBtn1st.enabled = YES;
            self.Hp_OptionBtn2nd.enabled = YES;
            self.Hp_Option3rd.enabled = NO;
            self.Hp_ContentList1st.scrollsToTop = NO;
            self.Hp_ContentList2nd.scrollsToTop = NO;
            self.Hp_ContentList3rd.scrollsToTop = YES;
            _orderListStatus = OrderStatusReceive;
            
            //            [self switchToTakingBTN:YES];

            _timesScrollToRight ++;
            if (_timesScrollToRight == 1) {
                [self.Hp_ContentList3rd.header beginRefreshing];
            }
            
        }
    }
}


#pragma mark - API

#pragma mark - API
- (void)newMessagesB{
    
    NSDictionary * paraData = @{
                                @"businessId":[NSString stringWithFormat:@"%@",[UserInfo getUserId]],
                                };
    
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraData];
        
        NSString * aesString = [Security AesEncrypt:jsonString2];
        
        paraData = @{
                     @"data":aesString,
                     //@"Version":[Tools getApplicationVersion],
                     };
    }
    
    [FHQNetWorkingAPI newMessageB:paraData successBlock:^(id result, AFHTTPRequestOperation *operation){
        _newMessageTEXT=result[@"content"];
        _newMessageID=[NSString stringWithFormat:@"%@",result[@"id"]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            self.Hp_MainBg_top.constant = 64 + kSCMessageView_Vheight + 5;
            
            /// 先释放
            if (_scMsgView) {
                [_scMsgView removeFromSuperview];
                _scMsgView = nil;
                self.Hp_MainBg_top.constant = 64;
                
            }
            
            _scMsgView=[[SCMessageView alloc]initWithWithTitle:_newMessageTEXT   AddToView:self.view onTap:^(){
                //goto  msgDetail
                MessageDetailViewController *vc=[[MessageDetailViewController alloc]init];
                //            vc.titleDic=tilteDic;
                vc.messageId=_newMessageID;
                [self.navigationController pushViewController:vc animated:YES];

                [_scMsgView removeFromSuperview];
                _scMsgView = nil;
                self.Hp_MainBg_top.constant = 64;

                
            }];
            
        });

        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {

    }];
}


#pragma mark - NotificationCenterNotify
- (void)userLoginSuccess {
    if ([UserInfo getStatus] != UserStatusComplete) {
        [self.Hp_BottomBtn setTitle:HPBottomButtonTilteInReview forState:UIControlStateNormal];
        self.Hp_BottomBtn.enabled = NO;
        
    }else{
        [self.Hp_BottomBtn setTitle:HPBottomButtonTitleRelease forState:UIControlStateNormal];
        self.Hp_BottomBtn.enabled = YES;
    }
}



- (void)userStatusChanged {
    
    [_Hp_ContentLists1st removeAllObjects];
    [_Hp_ContentLists2nd removeAllObjects];
    [_Hp_ContentLists3rd removeAllObjects];
    [self.Hp_ContentList1st reloadData];
    [self.Hp_ContentList2nd reloadData];
    [self.Hp_ContentList3rd reloadData];
    
    if ([UserInfo isLogin]) {
        _logoImgViewS3.image =
        _logoImgViewS2.image =
        _logoImgViewS1.image = nil;
        _markedWordsLabelS3.text =
        _markedWordsLabelS2.text =
        _markedWordsLabelS1.text = @"";
        
    }else if ([UserInfo getStatus] != UserStatusComplete){
        _logoImgViewS3.image =
        _logoImgViewS2.image =
        _logoImgViewS1.image = [UIImage imageNamed:@"checkLogo"];
        _markedWordsLabelS3.text =
        _markedWordsLabelS2.text =
        _markedWordsLabelS1.text = HPUserStatusInReviewMsg;
    }
    
}

- (void)userLogout{
   // [self userStatusChanged];
    [_Hp_ContentLists1st removeAllObjects];
    [_Hp_ContentLists2nd removeAllObjects];
    [_Hp_ContentLists3rd removeAllObjects];
    [self.Hp_ContentList1st reloadData];
    [self.Hp_ContentList2nd reloadData];
    [self.Hp_ContentList3rd reloadData];
    
    _logoImgViewS3.image =
    _logoImgViewS2.image =
    _logoImgViewS1.image = nil;
    _markedWordsLabelS3.text =
    _markedWordsLabelS2.text =
    _markedWordsLabelS1.text = @"";
    
    [self setOptionButton:self.Hp_OptionBtn1st count:0];
    [self setOptionButton:self.Hp_OptionBtn2nd count:0];
    [self setOptionButton:self.Hp_Option3rd count:0];
    
    _timesScrollToMiddle = 0;
    _timesScrollToRight = 0;
}

- (void)releseOrderSuccessfully:(NSNotification *)notify{
    [self s1ButtonAction:self.Hp_OptionBtn1st];
}


@end
