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

#define HpMaxMoney 15000

#define HpBeyondMaxMoneyErrString @"最大金额15000"

#define Hp9ItemCellId @"Hp9cellItemCellId"

@interface EDS9CellHomepageVC ()<UIScrollViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate,UINavigationControllerDelegate>
{
    // 其他情况的
    UIView * _otherSituationView;
    UIImageView * _otherSituationImgView;   // img
    UILabel * _otherSituationTextLabel;     // label
    
    UILabel * _otherSituation9CellShortageTitle;    // 9 cell shortage title
    UILabel * _otherSituation9CellShortageContent;  // 9 cell shortage content
    
    // 是否配置过 config9Cells
    BOOL _9cellsHasConfiged;
    // 是否需要输入金额 getAllowInputMoney
    NSInteger _allowInputMoney;
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

@end

@implementation EDS9CellHomepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    _Hp_RegionArray = [[NSMutableArray alloc] initWithCapacity:0];
    _9cellsHasConfiged = NO;    // 默认未配置colletionView
    _allowInputMoney = 0;       // 默认需要输入金额
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    [self configNavTitle];
    [self _configNibViews];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 只有登录了才能到这个界面。
    // 用户状态
     [self synchronizeTheBusinessStatus];
    //[self synchronizeBusiness9CellRegionInfo];
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
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    Hp9ItemCell * cell = (Hp9ItemCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.dataModel.twoOrderRegionList.count > 0) {
        // secondary
        NSLog(@"有二级区域");
    }else{
        cell.orderCount ++;
    }
}

#pragma mark - API
/// 获取商户用户当前状态
- (void)synchronizeTheBusinessStatus{
    // 8436
    NSDictionary *requestData = @{
                                  @"userId" : [UserInfo getUserId],
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
                [self synchronizeBusiness9CellRegionInfo];
            }else{
                [self _showOtherSituationViewWithStatus:userStatus];
            }
        }else{
            [Tools showHUD:Message];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
    }];
    
}

/// 获取商户用户的9个区域信息
- (void)synchronizeBusiness9CellRegionInfo{
    NSDictionary * paraDict = @{
                                @"businessId":[NSNumber numberWithInteger:260],//[UserInfo getUserId],
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
            [self getAllowInputMoney];
//            if (9 == regionArray.count) {   // 九宫格
//                [self _removeOtherSituationViews];
//            }else{
//                [self _showOtherSituationView9CellShortage];
//            }
        }else{
            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];

    }];
    
}

/// 是否需要输入金额
- (void)getAllowInputMoney{
    /// 是否需要输入金额
    NSDictionary * paraDict = @{
                                @"businessId":[NSNumber numberWithInt:260],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{
                     @"data":aesString,
                     };
    }
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [EDSHttpReqManager3 getisallowinputmoney:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        NSString * message = [responseObject objectForKey:@"message"];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
            // NSLog(@"%ld",result);
            // 0 需要 1 不需要
            _allowInputMoney = result;
        }else{
            NSLog(@"getAllowInputMoney %@",message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
    }];
}

/// 发布订单接口
- (void)tstPushOrder{
    
    NSDictionary * aregionsss = @{@"orderCount":[NSNumber numberWithInteger:5],@"orderRegionTwoId":[NSNumber numberWithInteger:4],@"orderRegionOneId":[NSNumber numberWithInteger:1],};
    NSDictionary * aregionssb = @{@"orderCount":[NSNumber numberWithInteger:5],@"orderRegionTwoId":[NSNumber numberWithInteger:5],@"orderRegionOneId":[NSNumber numberWithInteger:2],};
    
    NSArray * arraya = [NSArray arrayWithObjects:aregionsss,aregionssb, nil];
    NSString * aassdfsdf = [Security JsonStringWithDictionary:arraya];
    NSLog(@"%@",aassdfsdf);
    
    NSString * listOrderRegionStr = @"[{\"orderCount\":5,\"orderRegionTwoId\":4,\"orderRegionOneId\":1},{\"orderCount\":5,\"orderRegionTwoId\":5,\"orderRegionOneId\":2}]";
    if ([listOrderRegionStr compare:aassdfsdf] == NSOrderedSame) {
        NSLog(@"same--");
    }else{
        NSLog(@"not same ");
    }
    
    NSDictionary * paraDict = @{
                                @"businessid":[NSNumber numberWithInt:260],
                                @"ordercount":[NSNumber numberWithInteger:10],
                                @"amount":[NSNumber numberWithInteger:100],
                                @"orderfrom":[NSNumber numberWithInteger:0],
                                @"ispay":@"true",
                                @"listOrderRegionStr":aassdfsdf,
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
            //NSInteger result = [[responseObject objectForKey:@"result"] integerValue];
            //NSLog(@"%ld",result);
            //1成功-7获取商户信息失败-9您已被取消发单资格-10订单已经存在
        }else{
            NSLog(@"%@",message);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];

    }];

}

#pragma mark - 审核未通过的其他情况
/// 审核未通过的其他情况
- (void)_showOtherSituationViewWithStatus:(NSInteger)statusCode{
    [self _removeOtherSituationViews];
    
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
}

/// 清空otherSituationView
- (void)_removeOtherSituationViews{
    if (_otherSituationView) {
        for (UIView * aview in _otherSituationView.subviews) {
            [aview removeFromSuperview];
        }
        [_otherSituationView removeFromSuperview];
    }
}

/// 九宫格不满九个格子的情况
- (void)_showOtherSituationView9CellShortage{
    [self _removeOtherSituationViews];
    
    if (!_otherSituationView) {
        _otherSituationView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
        _otherSituationView.backgroundColor = [UIColor whiteColor];
    }
    if (!_otherSituation9CellShortageTitle) {
        _otherSituation9CellShortageTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 30)];
        _otherSituation9CellShortageTitle.text = @"请在电脑版商户中心设置配送区域！";
        _otherSituation9CellShortageTitle.backgroundColor = [UIColor clearColor];
        _otherSituation9CellShortageTitle.textAlignment = NSTextAlignmentCenter;
        _otherSituation9CellShortageTitle.textColor = DeepGrey;
        _otherSituation9CellShortageTitle.font = FONT_SIZE(BigFontSize);
    }
    _otherSituation9CellShortageTitle.center = CGPointMake(ScreenWidth/2, (ScreenHeight-64)/3);
    [_otherSituationView addSubview:_otherSituation9CellShortageTitle];
    
    if (!_otherSituation9CellShortageContent) {
        _otherSituation9CellShortageContent = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_otherSituation9CellShortageTitle) +Space_Normal, ScreenWidth, 20)];
        _otherSituation9CellShortageContent.text = @"网址:http://sh.edaisong.com";
        _otherSituation9CellShortageContent.backgroundColor = [UIColor clearColor];
        _otherSituation9CellShortageContent.textAlignment = NSTextAlignmentCenter;
        _otherSituation9CellShortageContent.textColor = DeepGrey;
        _otherSituation9CellShortageContent.font = FONT_SIZE(NormalFontSize);
    }
    [_otherSituationView addSubview:_otherSituation9CellShortageContent];
    [self.view addSubview:_otherSituationView];

}

#pragma mark - 发布任务Action:
- (IBAction)hpReleaseBtnAction:(UIButton *)sender {
    NSLog(@"%s",__func__);
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

@end
