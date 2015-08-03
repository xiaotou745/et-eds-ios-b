//
//  TakeOrderListViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/3.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "TakeOrderListViewController.h"
#import "OrdersListTableViewController.h"
#import "HMSegmentedControl.h"
#import "WaitOrderListViewController.h"
#import "MineViewController.h"
#import "ReleseOrderViewController.h"
#import "ThirdOrderListViewController.h"
#import "UserInfo.h"
#import "MJRefresh.h"

@interface TakeOrderListViewController ()<UIScrollViewDelegate, UINavigationControllerDelegate>
{
    HMSegmentedControl *_segmentedControl;
    
    UIScrollView *_scrollView;
    
    OrdersListTableViewController *_uncompleteVC;
    OrdersListTableViewController *_completeVC;
    
    UIButton * _releseBtn; // 发布按钮
}

@end

@implementation TakeOrderListViewController

- (void)viewDidLoad {

    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSuccess) name:UserStatusChangeToReviewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(releaseOrderSuccess) name:ReleseOrderNotification object:nil];
    
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([UserInfo getStatus] == UserStatusComplete) {
        [_releseBtn setTitle:@"发  布" forState:UIControlStateNormal];
        _releseBtn.enabled = YES;
    } else {
        [_releseBtn setTitle:@"审核中" forState:UIControlStateNormal];
        _releseBtn.enabled = NO;
    }

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_uncompleteVC.tableView.header beginRefreshing];
    [_completeVC.tableView.header beginRefreshing];

}

- (void)bulidView {
    
    self.titleLabel.text = @"呼叫配送员";
    
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18]}];
    
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth/2 - titleSize.width/2 - 20 - 5, 20 + (44 - titleSize.height)/2, 20, 20)];
    iconView.image = [UIImage imageNamed:@"icon_80"];
    iconView.layer.cornerRadius = 5;
    iconView.layer.masksToBounds = YES;
    [self.navBar addSubview:iconView];
    
//    [self.leftBtn setImageNor:nil imagePre:nil imageSelected:nil];
//    [self.leftBtn setTitle:@"待确认" forState:UIControlStateNormal];
//    [self.leftBtn changeFrameWidth:80];
    self.leftBtn.hidden = YES;
    
    
    
    [self.rightBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickUser) forControlEvents:UIControlEventTouchUpInside];
    
    NSArray *segmentedList = @[@"未完成",@"已完成"];
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 64, MainWidth, 50)];
    _segmentedControl.sectionTitles                = segmentedList;
    _segmentedControl.selectedSegmentIndex         = 0;
    _segmentedControl.font                         = [UIFont systemFontOfSize:BigFontSize];
    _segmentedControl.backgroundColor              = [UIColor whiteColor];
    _segmentedControl.textColor                    = DeepGrey;
    _segmentedControl.selectedTextColor            = DeepGrey;
    _segmentedControl.selectionIndicatorColor      = BlueColor;
    _segmentedControl.selectionStyle               = HMSegmentedControlSelectionStyleBox;
    _segmentedControl.selectionIndicatorBoxOpacity = 0;
    _segmentedControl.selectionIndicatorLocation   = HMSegmentedControlSelectionIndicatorLocationDown;
    _segmentedControl.selectionIndicatorHeight     = 2.f;
    [self.view addSubview:_segmentedControl];
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 64 + 50, MainWidth, ScreenHeight - 64 - 50)];
    _scrollView.contentSize = CGSizeMake(MainWidth * 2, ScreenHeight - 64 - 50);
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    __weak typeof(self) weakSelf = self;
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        [weakSelf.scrollView scrollRectToVisible:CGRectMake(MainWidth * index, 0, MainWidth, ScreenHeight - 64 - 50) animated:YES];
    }];
    
    _uncompleteVC = [[OrdersListTableViewController alloc] init];
    _uncompleteVC.view.frame = CGRectMake(0, 0, MainWidth, ScreenHeight - 64 - 50);
    _uncompleteVC.orderStatus = OrderStatusUncomplete;
    [_scrollView addSubview:_uncompleteVC.view];
    
    _completeVC = [[OrdersListTableViewController alloc] init];
    _completeVC.view.frame = CGRectMake(MainWidth, 0, MainWidth, ScreenHeight - 64 - 50);
    _completeVC.orderStatus = OrderStatusComplete;
    [_scrollView addSubview:_completeVC.view];
    

    _releseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_releseBtn setTitle:@"发  布" forState:UIControlStateNormal];
    [_releseBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_releseBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:@"blue_btn_noSelect"];
    [_releseBtn addTarget:self action:@selector(releseTask) forControlEvents:UIControlEventTouchUpInside];
    _releseBtn.frame = CGRectMake(10, ScreenHeight - 54, MainWidth - 20, 44);
    
    if ([UserInfo getStatus] != UserStatusComplete) {
        [_releseBtn setTitle:@"审核中" forState:UIControlStateNormal];
        _releseBtn.enabled = NO;
    }else{
        [_releseBtn setTitle:@"发  布" forState:UIControlStateNormal];
        _releseBtn.enabled = YES;
    }

    [self.view addSubview:_releseBtn];
}

- (void)back {
    ThirdOrderListViewController *vc = [[ThirdOrderListViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)releseTask {
    ReleseOrderViewController *vc = [[ReleseOrderViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)userLoginSuccess {
    if ([UserInfo getStatus] != UserStatusComplete) {
        [_releseBtn setTitle:@"审核中" forState:UIControlStateNormal];
        _releseBtn.enabled = NO;
    }else{
        [_releseBtn setTitle:@"发  布" forState:UIControlStateNormal];
        _releseBtn.enabled = YES;
    }
}

- (void)releaseOrderSuccess {
    [_segmentedControl setSelectedSegmentIndex:0 animated:YES];
    [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = (scrollView.contentOffset.x/MainWidth);
    [_segmentedControl setSelectedSegmentIndex:index animated:YES];
}

- (void)clickUser {
    MineViewController *vc = [[MineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

@end
