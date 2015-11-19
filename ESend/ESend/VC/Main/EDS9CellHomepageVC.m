//
//  EDS9CellHomepageVC.m
//  ESend
//
//  Created by 台源洪 on 15/10/29.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDS9CellHomepageVC.h"
#import "MineViewController.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"
#import "Hp9ItemCell.h"
#import "EDSTodaysOrdersVC.h"
#import "EDSHttpReqManager3.h"
#import "Hp9CellRegionModel.h"
#import "EDS9cell2ndRegionView.h"
#import "CustomIOSAlertView.h"

#define HpMaxMoney 15000

#define HpTaskMoneyWithin @"任务金额需在0-15000之间"
#define HpOrderCountErrorMsg @"订单数量不能为0"
#define HpBeyondMaxMoneyErrString @"最大金额15000"

#define Hp9ItemCellId @"Hp9cellItemCellId"

@interface EDS9CellHomepageVC ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UINavigationControllerDelegate,Hp9ItemCellDelegate>
{
    // 其他情况的
    UIView * _otherSituationView;           // bg
    UIImageView * _otherSituationImgView;   // img
    UILabel * _otherSituationTextLabel;     // label
    /// 正在显示状态不对的情况
    BOOL _otherSituationShowing;            // flag
    
    UIView * _otherSituation9CellView;              // 9 cell shortage bg
    UIImageView * _otherSituationImg;               // 9 cell shortage img
    UILabel * _otherSituation9CellShortageTitle;    // 9 cell shortage title
    UILabel * _otherSituation9CellShortageContent;  // 9 cell shortage content
    /// 正在显示不足九宫格的情况
    BOOL _otherSitua9CellShortageShowing;           // flag
    
    // 是否配置过 config9Cells
    BOOL _9cellsHasConfiged;
//    // 是否需要输入金额 getAllowInputMoney
//    NSInteger _allowInputMoney;
    
    /// 订单总数量
    NSInteger _totalCount;
}
@property (strong, nonatomic) IBOutlet UIScrollView *Hp_Scroller;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *Hp_ScrollerHeight;
@property (strong, nonatomic) IBOutlet UICollectionView *Hp_9cells;

// 通知提醒栏
@property (strong, nonatomic) IBOutlet UIView *Hp_View1;
@property (strong, nonatomic) IBOutlet UILabel *Hp_View1_note;

// 任务金额，任务数量栏
@property (strong, nonatomic) IBOutlet UIView *Hp_view2;
@property (strong, nonatomic) IBOutlet UIImageView *Hp_view2_seperator;
@property (strong, nonatomic) IBOutlet UILabel *Hp_view2_totalFix;
@property (strong, nonatomic) IBOutlet UILabel *Hp_view2_total_count;
@property (strong, nonatomic) IBOutlet UITextField *Hp_view2_textfield;
@property (strong, nonatomic) IBOutlet UIImageView *Hp_view2_xiahua;
@property (strong, nonatomic) IBOutlet UILabel *Hp_view2_yuan;

// 发布任务按钮
@property (strong, nonatomic) IBOutlet UIButton *releaseButton;
@property (strong, nonatomic) NSMutableArray * Hp_RegionArray;

@property (strong, nonatomic) IBOutlet UICollectionViewFlowLayout *Hp_Collection_Flowlayout;
@end

@implementation EDS9CellHomepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    _Hp_RegionArray = [[NSMutableArray alloc] initWithCapacity:0];
    _9cellsHasConfiged = NO;    // 默认未配置colletionView
    // _allowInputMoney = 0;       // 默认需要输入金额
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderCountsWithNotification:) name:Hp9CellSecondaryRegionOrderCountChangedNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hpUserLogout) name:LogoutNotifaction object:nil];

    
    // 九宫格订单数量变动之后的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrderTotalCount) name:Hp9cellOrderCountChangedNotification object:nil];
    
    [self configNavTitle];
    [self _configNibViews];
    
    self.Hp_Scroller.hidden = YES;
    self.releaseButton.hidden = YES;
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];


}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [Tools hiddenKeyboard];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 只有登录了才能到这个界面。
    if ([UserInfo isLogin]) {
        // 用户状态
        [self synchronizeTheBusinessStatus];
    }

}



- (void)updateViewConstraints{
    [super updateViewConstraints];
    //self.Hp_ScrollerHeight.constant = 244 + 30 + 80;
    self.Hp_ScrollerHeight.constant = ScreenHeight - (10 + 40 + 15 + 64) + 1;
}

/// 配置导航条
- (void)configNavTitle{
    self.titleLabel.text = @"发布任务";
    // left mineBtnAction
    [self.leftBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(mineBtnAction) forControlEvents:UIControlEventTouchUpInside];
    // right
    [self.rightBtn setImage:[UIImage imageNamed:@"9cell_order"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(todaysOrdersBtnAction) forControlEvents:UIControlEventTouchUpInside];
   // self.rightBtn.hidden = YES;
}

- (void)_configNibViews{
    self.Hp_9cells.layer.borderColor = [SeparatorColorC CGColor];
    self.Hp_9cells.layer.borderWidth = 0.5f;
    self.Hp_View1_note.textColor = TextColor9;
    
    self.Hp_view2.layer.borderColor = [SeparatorColorC CGColor];
    self.Hp_view2.layer.borderWidth = 0.5f;
    self.Hp_view2_seperator.backgroundColor = SeparatorColorC;
    self.Hp_view2_totalFix.textColor =
    self.Hp_view2_yuan.textColor =
    self.Hp_view2_textfield.textColor =
    self.Hp_view2_total_count.textColor = DeepGrey;
    self.Hp_view2_xiahua.backgroundColor = DeepGrey;
    
    [self.releaseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.releaseButton setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:@"blue_btn_noSelect"];
}

- (void)config9Cells{
    if (_9cellsHasConfiged) {
        return;
    }
    //Hp9ItemCell
    UINib *cellNib = [UINib nibWithNibName:NSStringFromClass([Hp9ItemCell class]) bundle:nil];
    [self.Hp_9cells registerNib:cellNib forCellWithReuseIdentifier:Hp9ItemCellId];
    self.Hp_9cells.dataSource = self;
    self.Hp_9cells.delegate = self;
    _9cellsHasConfiged = YES;
}

- (void)mineBtnAction{
    MineViewController *vc = [[MineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)todaysOrdersBtnAction{
    EDSTodaysOrdersVC * tovc = [[EDSTodaysOrdersVC alloc] initWithNibName:NSStringFromClass([EDSTodaysOrdersVC class]) bundle:nil];
    [self.navigationController pushViewController:tovc animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 9 cell UI delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _Hp_RegionArray.count;
}

// The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    Hp9ItemCell * cell = (Hp9ItemCell *)[collectionView dequeueReusableCellWithReuseIdentifier:Hp9ItemCellId forIndexPath:indexPath];
    cell.dataModel = [_Hp_RegionArray objectAtIndex:indexPath.row];
    cell.delegate = self;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Hp9ItemCell * cell = (Hp9ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.dataModel.twoOrderRegionList.count > 0) {
        // secondary
        NSLog(@"有二级区域");
        EDS9cell2ndRegionView * ndRegionView = [[EDS9cell2ndRegionView alloc] initWithDelegate:nil dataSource:cell.dataModel.twoOrderRegionList regionName:cell.dataModel.regionName];
        [ndRegionView show];
    }else{
        cell.dataModel.orderCount ++;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake(86, 68);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    if (iPhone6plus) {
        return 40;
    }else{
        return 10;
    }
}


#pragma mark - API
/// 获取商户用户当前状态
- (void)synchronizeTheBusinessStatus{
    // 8436
    NSDictionary *requestData = @{
                                  @"userId" :[UserInfo getUserId],
                                  @"version":APIVersion,
                                  };
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [EDSHttpReqManager3 getUserStatusData:requestData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        [self _removeOtherSituationViews];
        NSInteger Status = [[responseObject objectForKey:@"Status"] integerValue];
        NSString * Message = [responseObject objectForKey:@"Message"];
        if (0 == Status) {
            // 状态:0未审核，1已通过，2未审核且未添加地址，3审核中，4审核被拒绝
            NSInteger userStatus = [[[responseObject objectForKey:@"Result"] objectForKey:@"status"] integerValue];
            //
            if (1 == userStatus) { // 审核通过
                if (_otherSituationShowing) {
                    [self _removeOtherSituationViews];
                }
                [self synchronizeBusiness9CellRegionInfo];
            }else{
                if (!_otherSituationShowing) {
                    [self _showOtherSituationViewWithStatus:userStatus];
                }
            }
        }else{
            [Tools showHUD:Message];
            
            if (!_otherSitua9CellShortageShowing) { // 没显示
                [self _showOtherSituationView9CellShortage];
            }
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
        
        if (!_otherSitua9CellShortageShowing) { // 没显示
            [self _showOtherSituationView9CellShortage];
        }
    }];
    
}

/// 获取商户用户的9个区域信息
- (void)synchronizeBusiness9CellRegionInfo{
    NSDictionary * paraDict = @{
                                @"businessId":[UserInfo getUserId],//[UserInfo getUserId],
                                @"status":[NSNumber numberWithInt:1],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{@"data":aesString,};
    }
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [EDSHttpReqManager3 getorderregion:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSArray * regionArray = [responseObject objectForKey:@"result"];
            [_Hp_RegionArray removeAllObjects];
            for (NSDictionary * aregionDict in regionArray) {
                Hp9CellRegionModel * aRegion = [[Hp9CellRegionModel alloc] initWithDic:aregionDict];
                [_Hp_RegionArray addObject:aRegion];
            }
            [self config9Cells];
            [_Hp_9cells reloadData];
            // [self getAllowInputMoney];
            if (9 == regionArray.count) {   // 九宫格
                if (_otherSitua9CellShortageShowing) {  // 显示不足九个，则去除
                    [self _removeOtherSituation9cellViews];
                }
                //
                self.Hp_Scroller.hidden = NO;
                self.releaseButton.hidden = NO;

            }else{ // 显示不足九个的情况
                if (!_otherSitua9CellShortageShowing) { // 没显示
                    [self _showOtherSituationView9CellShortage];
                }
            }
        }else{
            // [Tools showHUD:message];
            if (!_otherSitua9CellShortageShowing) { // 没显示
                [self _showOtherSituationView9CellShortage];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
        if (!_otherSitua9CellShortageShowing) { // 没显示
            [self _showOtherSituationView9CellShortage];
        }
    }];
    
}

/// 是否需要输入金额
//- (void)getAllowInputMoney{
//    /// 是否需要输入金额
//    NSDictionary * paraDict = @{
//                                @"businessId":[UserInfo getUserId],
//                                };
//    if (AES_Security) {
//        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
//        NSString * aesString = [Security AesEncrypt:jsonString2];
//        paraDict = @{
//                     @"data":aesString,
//                     };
//    }
//    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
//    [EDSHttpReqManager3 getisallowinputmoney:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        [Tools hiddenProgress:HUD];
//        NSString * message = [responseObject objectForKey:@"message"];
//        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
//        if (1 == status) {
//            NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
//            // NSLog(@"%ld",result);
//            // 0 普通模式 需要;    1 （快单模式）不需要
//            _allowInputMoney = result;
//        }else{
//            NSLog(@"getAllowInputMoney %@",message);
//        }
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [Tools hiddenProgress:HUD];
//    }];
//}

- (NSDictionary *)dictWithorderRegionOneId:(NSInteger)orderRegionOneId orderRegionTwoId:(NSInteger)orderRegionTwoId orderCount:(NSInteger)orderCount{
    return  @{
              @"orderCount":[NSNumber numberWithInteger:orderCount],
              @"orderRegionTwoId":[NSNumber numberWithInteger:orderRegionTwoId],
              @"orderRegionOneId":[NSNumber numberWithInteger:orderRegionOneId],
              };
}

/// 发布订单接口
- (void)pushOrder{
    NSMutableArray * apiOrderList = [[NSMutableArray alloc] initWithCapacity:0];
    for (Hp9CellRegionModel * firstRegion in _Hp_RegionArray) {
        if (firstRegion.orderCount > 0) { // 该一级区域有订单
            if (firstRegion.twoOrderRegionList.count > 0) { // 有二级区域
                for (Hp9cellSecondaryRegion * secondRegion in firstRegion.twoOrderRegionList) {
                    if (secondRegion.orderCount > 0) {
                        NSDictionary * adict = [self dictWithorderRegionOneId:firstRegion.regionId orderRegionTwoId:secondRegion.regionId orderCount:secondRegion.orderCount];
                        [apiOrderList addObject:adict];
                    }
                }
            }else{  // 无二级区域
                NSDictionary * adict = [self dictWithorderRegionOneId:firstRegion.regionId orderRegionTwoId:0 orderCount:firstRegion.orderCount];
                [apiOrderList addObject:adict];
            }

        }
    }
    
    NSString * apiOrderListString = [Security JsonStringWithDictionary:apiOrderList];
    NSDictionary * paraDict = @{
                                @"businessid":[UserInfo getUserId],
                                @"ordercount":[NSNumber numberWithInteger:_totalCount],
                                @"amount":[NSNumber numberWithInteger:[self.Hp_view2_textfield.text integerValue]],
                                @"orderfrom":[NSNumber numberWithInteger:0],
                                @"ispay":@"true",
                                @"listOrderRegionStr":apiOrderListString,
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{
                     @"data":aesString,
                     };
    }
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [EDSHttpReqManager3 pushOrderData:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            //1成功-7获取商户信息失败-9您已被取消发单资格-10订单已经存在
            [Tools showHUD:@"发布成功"];
            //
            //[_Hp_RegionArray removeAllObjects];
            /// 清空所有的ordercount
            [self clearAllRegionArrayOrderCount];
            //
            _Hp_view2_textfield.text = @"";
            _Hp_view2_total_count.text = @"订单数量: 0单";
            
        }else{
            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];

    }];

}

- (void)clearAllRegionArrayOrderCount{
    // _Hp_RegionArray
    for (Hp9CellRegionModel * firstRegion in _Hp_RegionArray) {
        firstRegion.orderCount = 0;
        if (firstRegion.twoOrderRegionList.count > 0) {
            for (Hp9cellSecondaryRegion * secondRegion in firstRegion.twoOrderRegionList) {
                secondRegion.orderCount = 0;
            }
        }
    }
    
}

/// 请求送餐费
- (void)reqForDistribSubsidyTask {
    [Tools hiddenKeyboard];
    NSDictionary *requsetData = @{@"BussinessId" : [UserInfo getUserId],
                                  @"Version" : APIVersion,
                                  @"Amount" : [NSNumber numberWithInteger:[self.Hp_view2_textfield.text integerValue]],
                                  @"OrderCount" : [NSNumber numberWithInteger:_totalCount]};
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [FHQNetWorkingAPI getDistribSubsidy:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
        double DistribSubsidy = [result getDoubleWithKey:@"DistribSubsidy"];//外送费
        double RemainBalance = [result getDoubleWithKey:@"RemainBalance"]; // 剩余余额(商家余额 –当前任务结算金额)
        //double GroupBusinessAmount = [result getDoubleWithKey:@"GroupBusinessAmount"];
        double OrderBalance = [result getDoubleWithKey:@"OrderBalance"]; // 当前任务结算金额(每个商家设定的结算比例)
        
        // Here we need to pass a full frame
        CustomIOSAlertView *alertView = [[CustomIOSAlertView alloc] init];
        NSString * alertTitle = @"确定要发布订单吗?";
        [alertView setContainerView:[self createHpReleaseAlertView:alertTitle orderAmout:[self.Hp_view2_textfield.text doubleValue] orderCount:_totalCount DistribSubsidy:DistribSubsidy OrderBalance:OrderBalance RemainBalance:RemainBalance]];
        [alertView setButtonTitles:[NSMutableArray arrayWithObjects:@"取消", @"确定", nil]];
        __block EDS9CellHomepageVC * blockSelf = self;
        [alertView setOnButtonTouchUpInside:^(CustomIOSAlertView *alertView, int buttonIndex) {
            if (1 == buttonIndex) {
                [blockSelf pushOrder];
            }
            [alertView close];
        }];
        [alertView setUseMotionEffects:true];
        [alertView show];
        
        [Tools hiddenProgress:HUD];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        [Tools hiddenProgress:HUD];
    }];
}

#pragma mark - 审核未通过的其他情况
/// 审核未通过的其他情况
- (void)_showOtherSituationViewWithStatus:(NSInteger)statusCode{
    if (_otherSituationShowing) {
        return;
    }
    if (!_otherSituationView) {
        _otherSituationView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
        _otherSituationView.backgroundColor = [UIColor whiteColor];
    }
    // 提示logo
    if (!_otherSituationImgView) {
        _otherSituationImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
        _otherSituationImgView.backgroundColor = [UIColor clearColor];
        _otherSituationImgView.image = [UIImage imageNamed:@"checkLogo"];
        _otherSituationImgView.center          = CGPointMake(ScreenWidth/2, (ScreenHeight-64)/3);
    }
    [_otherSituationView addSubview:_otherSituationImgView];
    // 提示语
    if (!_otherSituationTextLabel) {
        _otherSituationTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_otherSituationImgView) +Space_Big, ScreenWidth, 30)];
        _otherSituationTextLabel.backgroundColor = [UIColor clearColor];
        _otherSituationTextLabel.textAlignment = NSTextAlignmentCenter;
        _otherSituationTextLabel.textColor     = DeepGrey;
        _otherSituationTextLabel.font          = FONT_SIZE(BigFontSize);
    }
    _otherSituationTextLabel.text = (0 == statusCode)?@"您目前没有提交审核资料，无法发单!":@"您提交的资料正在审核中，无法发单!";
    [_otherSituationView addSubview:_otherSituationTextLabel];
    [self.view addSubview:_otherSituationView];
    
    _otherSituationShowing = YES;
}

/// 清空-- 状态不对的
- (void)_removeOtherSituationViews{
    if (_otherSituationView) {
        for (UIView * aview in _otherSituationView.subviews) {
            [aview removeFromSuperview];
        }
        [_otherSituationView removeFromSuperview];
    }
    _otherSituationShowing = NO;
}

/// 清空不足九宫格的情况
- (void)_removeOtherSituation9cellViews{
    if (_otherSitua9CellShortageShowing) {
        for (UIView * aview in _otherSituation9CellView.subviews) {
            [aview removeFromSuperview];
        }
        [_otherSituation9CellView removeFromSuperview];
    }
    self.titleLabel.text = @"发布任务";
    _otherSitua9CellShortageShowing = NO;
}

/// 九宫格不满九个格子的情况
- (void)_showOtherSituationView9CellShortage{
    
    if (_otherSitua9CellShortageShowing) {
        return;
    }
    if (!_otherSituation9CellView) {
        _otherSituation9CellView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
        _otherSituation9CellView.backgroundColor = BackgroundColor;
    }
    if (!_otherSituationImg) {
        _otherSituationImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75, 100)];
        _otherSituationImg.backgroundColor = [UIColor clearColor];
    }
    _otherSituationImg.image = [UIImage imageNamed:@"9cell_shortage_img"];
    _otherSituationImg.center = CGPointMake(ScreenWidth/2, (ScreenHeight-64)/3);
    [_otherSituation9CellView addSubview:_otherSituationImg];
    
    if (!_otherSituation9CellShortageTitle) {
        _otherSituation9CellShortageTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_otherSituationImg) + Space_Normal, ScreenWidth, 30)];
        _otherSituation9CellShortageTitle.text = @"请在电脑版商户中心设置配送区域！";
        _otherSituation9CellShortageTitle.backgroundColor = [UIColor clearColor];
        _otherSituation9CellShortageTitle.textAlignment = NSTextAlignmentCenter;
        _otherSituation9CellShortageTitle.textColor = DeepGrey;
        _otherSituation9CellShortageTitle.font = FONT_SIZE(BigFontSize);
    }
    [_otherSituation9CellView addSubview:_otherSituation9CellShortageTitle];
    
    if (!_otherSituation9CellShortageContent) {
        _otherSituation9CellShortageContent = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_otherSituation9CellShortageTitle) +Space_Normal, ScreenWidth, 20)];
        _otherSituation9CellShortageContent.text = @"网址:http://sh.edaisong.com";
        _otherSituation9CellShortageContent.backgroundColor = [UIColor clearColor];
        _otherSituation9CellShortageContent.textAlignment = NSTextAlignmentCenter;
        _otherSituation9CellShortageContent.textColor = DeepGrey;
        _otherSituation9CellShortageContent.font = FONT_SIZE(NormalFontSize);
    }
    [_otherSituation9CellView addSubview:_otherSituation9CellShortageContent];
    [self.view addSubview:_otherSituation9CellView];
    
    self.titleLabel.text = @"E代送商户";
    _otherSitua9CellShortageShowing = YES;
}

#pragma mark - 发布任务Action:
- (IBAction)hpReleaseBtnAction:(UIButton *)sender {
    
//    // 0 普通模式 需要;    1 （快单模式）不需要
//    if (_allowInputMoney == 0) {
//        if (self.Hp_view2_textfield.text.length == 0 || [self.Hp_view2_textfield.text integerValue] < 0) {
//            [Tools showHUD:HpTaskMoneyWithin];
//            return;
//        }
//    }
    
    if (_totalCount <= 0) {
        [Tools showHUD:HpOrderCountErrorMsg];
        return;
    }
    
    [self reqForDistribSubsidyTask];
}

/// alert
- (UIView *)createHpReleaseAlertView:(NSString *)title
                          orderAmout:(double)orderAmout
                          orderCount:(NSInteger)orderCount
                      DistribSubsidy:(double)DistribSubsidy
                        OrderBalance:(double)OrderBalance
                       RemainBalance:(double)RemainBalance
{
    UIView *demoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 290, 200)];
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(demoView.frame), 40)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = DeepGrey;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = [UIFont systemFontOfSize:16];
    titleLabel.text = title;
    [demoView addSubview:titleLabel];
    
    UIImageView * aLine = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleLabel.frame), CGRectGetWidth(demoView.frame), 0.5f)];
    aLine.backgroundColor = SeparatorColorC;
    [demoView addSubview:aLine];
    
    CGFloat leftMargin = 15;
    CGFloat lblHeight = 22;
    CGFloat y = CGRectGetMaxY(aLine.frame) + 10;
    // 订单总金额
    double totalAmount = orderAmout + orderCount * DistribSubsidy;
    if (totalAmount > 0) {
        UILabel * orderAmoutLbl = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, y, CGRectGetWidth(demoView.frame)-leftMargin, lblHeight)];
        orderAmoutLbl.font = [UIFont systemFontOfSize:15];
        orderAmoutLbl.textColor = TextColor6;
        orderAmoutLbl.backgroundColor = [UIColor clearColor];
        orderAmoutLbl.textAlignment = NSTextAlignmentLeft;
        orderAmoutLbl.text = [NSString stringWithFormat:@"总金额: %.2f元",totalAmount];
        [demoView addSubview:orderAmoutLbl];
        
        y = CGRectGetMaxY(orderAmoutLbl.frame);
    }
    
    // 订单金额
    if (orderAmout > 0) {
        UILabel * amoutLbl = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, y, CGRectGetWidth(demoView.frame)-leftMargin, lblHeight)];
        amoutLbl.font = [UIFont systemFontOfSize:15];
        amoutLbl.textColor = TextColor6;
        amoutLbl.backgroundColor = [UIColor clearColor];
        amoutLbl.textAlignment = NSTextAlignmentLeft;
        amoutLbl.text = [NSString stringWithFormat:@"订单金额: %.2f元",orderAmout];
        [demoView addSubview:amoutLbl];
        
        y = CGRectGetMaxY(amoutLbl.frame);
    }

    // 订单数量
    UILabel * orderCountLbl = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, y, CGRectGetWidth(demoView.frame)-leftMargin, lblHeight)];
    orderCountLbl.font = [UIFont systemFontOfSize:15];
    orderCountLbl.textColor = TextColor6;
    orderCountLbl.backgroundColor = [UIColor clearColor];
    orderCountLbl.textAlignment = NSTextAlignmentLeft;
    orderCountLbl.text = [NSString stringWithFormat:@"订单数量: %ld单",(long)orderCount];
    [demoView addSubview:orderCountLbl];
    
    y = CGRectGetMaxY(orderCountLbl.frame);
    
    // 配送费用
    if (DistribSubsidy > 0) { // 有配送费用
        UILabel * orderDistribSubsidyLbl = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, y, CGRectGetWidth(demoView.frame)-leftMargin, lblHeight)];
        orderDistribSubsidyLbl.font = [UIFont systemFontOfSize:15];
        orderDistribSubsidyLbl.textColor = TextColor6;
        orderDistribSubsidyLbl.backgroundColor = [UIColor clearColor];
        orderDistribSubsidyLbl.textAlignment = NSTextAlignmentLeft;
        orderDistribSubsidyLbl.text = [NSString stringWithFormat:@"配送费用: %.2f元",DistribSubsidy * orderCount];
        [demoView addSubview:orderDistribSubsidyLbl];
        
        y += lblHeight;
    }
    
    // 当前结算 ，剩余
    UILabel * orderBalanceLbl = [[UILabel alloc] initWithFrame:CGRectMake(leftMargin, y, CGRectGetWidth(demoView.frame)-leftMargin, lblHeight)];
    orderBalanceLbl.font = [UIFont systemFontOfSize:15];
    orderBalanceLbl.textColor = TextColor6;
    orderBalanceLbl.backgroundColor = [UIColor clearColor];
    orderBalanceLbl.textAlignment = NSTextAlignmentLeft;
    orderBalanceLbl.numberOfLines = 0;
    NSString * orderBalanceContent = [NSString stringWithFormat:@"消耗余额: %.2f元,剩余余额%.2f元",OrderBalance,RemainBalance];
    // NSAttributedString// 5
    NSRange yuanRage = [orderBalanceContent rangeOfString:@"元,"];
    // NSLog(@"%@",NSStringFromRange(yuanRage));
    NSRange redRage = NSMakeRange(5, yuanRage.location - 5);
    NSMutableAttributedString * orderBalanceContentAttr = [[NSMutableAttributedString alloc] initWithString:orderBalanceContent];
    [orderBalanceContentAttr addAttribute:NSForegroundColorAttributeName value:RedDefault range:redRage];
    orderBalanceLbl.attributedText = orderBalanceContentAttr;
    [demoView addSubview:orderBalanceLbl];
    //
    CGFloat contentHeight = [Tools stringHeight:orderBalanceContent fontSize:15 width:CGRectGetWidth(demoView.frame)-leftMargin].height;
    if (contentHeight > lblHeight) {
        orderBalanceLbl.frame = CGRectMake(leftMargin, y, CGRectGetWidth(demoView.frame)-leftMargin, contentHeight);
    }
    
    [demoView setFrame:CGRectMake(0, 0, 290, CGRectGetMaxY(orderBalanceLbl.frame) + 10)];
    
    return demoView;
}

#pragma mark 键盘相关处理
- (void)keyboardWillShow:(NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [_Hp_Scroller changeFrameHeight:ScreenHeight - keyboardRect.size.height - 64];
                         UIView *firstResponder = [Tools findFirstResponderFromView:_Hp_Scroller];
                         [_Hp_Scroller scrollRectToVisible:CGRectInset(firstResponder.frame, 0, -20) animated:YES];
                     }];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [_Hp_Scroller changeFrameHeight:ScreenHeight - 64 ];
                     }];
}

// HpMaxMoney
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (_Hp_view2_textfield == textField) {
        if ([toBeString integerValue] > HpMaxMoney ) {
            textField.text = [NSString stringWithFormat:@"%d",HpMaxMoney];
            [Tools showHUD:HpBeyondMaxMoneyErrString];
            return NO;
        }
        if ([toBeString length] > 5) {
            textField.text = [toBeString substringToIndex:5];
            [Tools showHUD:@"最大5位"];
            return NO;
        }
    }
    return YES;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}


#pragma mark - 处理订单数量变化的通知
- (void)updateOrderCountsWithNotification:(NSNotification *)notify{
    // NSLog(@"%@",notify.object);
    NSInteger regionFristLevelId = ((Hp9cellSecondaryRegion *)notify.object).regionFirstLevelId;
    [self updateRegionModelCountWithId:regionFristLevelId];
    
}

- (void)updateRegionModelCountWithId:(NSInteger)firstLevelId{
    for (Hp9CellRegionModel * aFisrtRegion in _Hp_RegionArray) {
        if (aFisrtRegion.regionId == firstLevelId) {
            NSInteger totalCount = 0;
            for (Hp9cellSecondaryRegion * a2ndRegion in aFisrtRegion.twoOrderRegionList) {
                totalCount += a2ndRegion.orderCount;
            }
            aFisrtRegion.orderCount = totalCount;
            break;
        }
    }
    
    [self updateOrderTotalCount];
    
}

/// 修改订单总量
- (void)updateOrderTotalCount{
    NSInteger allCount = 0;
    for (Hp9CellRegionModel * aFisrtRegion in _Hp_RegionArray) {
        allCount += aFisrtRegion.orderCount;
    }
    _totalCount = allCount;
    self.Hp_view2_total_count.text = [NSString stringWithFormat:@"订单数量: %ld单",_totalCount];
}



#pragma mark - Hp9ItemCellDelegate 有二级区域，点击减号，唤起二级区域
- (void)hp9ItemShouldCallOutSecondaryRegionView:(Hp9ItemCell *)cell{
    [self collectionView:_Hp_9cells didSelectItemAtIndexPath:[_Hp_9cells indexPathForCell:cell]];
}



#pragma mark - 用户推出登录
- (void)hpUserLogout{
    
    self.Hp_Scroller.hidden = YES;
    self.releaseButton.hidden = YES;
    
    [_Hp_RegionArray removeAllObjects];
    [_Hp_9cells reloadData];
    
    _Hp_view2_textfield.text = @"";
    _Hp_view2_total_count.text = @"订单数量: 0单";
    
}
@end
