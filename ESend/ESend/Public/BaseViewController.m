//
//  BaseViewController.m
//  USA
//
//  Created by 永来 付 on 14/11/24.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import "BaseViewController.h"
#import "AFNetworking.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (IOSVERSION >= 7) {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    
    self.textFieldList = [NSMutableArray array];
    
    [self bulidNavBar];
    
    [self initializeData];
    [self bulidView];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
}

- (void)bulidNavBar
{
    _navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 44 + OffsetBarHeight)];
    _navBar.backgroundColor = [UIColor colorWithHexString:@"1f2226"];
    [self.view addSubview:_navBar];
    
    _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(0, OffsetBarHeight, 45, 44);
    _leftBtn.titleLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    [_leftBtn setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"back_nor"] forState:UIControlStateHighlighted];
    [_leftBtn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightBtn.frame = CGRectMake(MainWidth - 60, OffsetBarHeight, 60, 44);
    _rightBtn.titleLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    [_rightBtn setImage:[UIImage imageNamed:@"more_nor"] forState:UIControlStateNormal];
    [_rightBtn setImage:[UIImage imageNamed:@"more_pre"] forState:UIControlStateHighlighted];
    [_rightBtn setImage:[UIImage imageNamed:@"more_pre"] forState:UIControlStateSelected];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, OffsetBarHeight, MainWidth - 100,  44)];
    _titleLabel.font = [UIFont boldSystemFontOfSize:18];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor  = [UIColor whiteColor];
    
    _line = [Tools createLine];
    _line.frame = CGRectMake(0, 63.5, MainWidth, 0.5);
    
    [_navBar addSubview:_line];
    [_navBar addSubview:_titleLabel];
    [_navBar addSubview:_leftBtn];
    [_navBar addSubview:_rightBtn];

    self.view.backgroundColor = [UIColor colorWithHexString:@"e8e8e8"];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}

- (void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getTextFieldList:(UIView*)view {
    
    for (UIView *textField in view.subviews) {
        if ([textField isKindOfClass:[UITextField class]]) {
            [self.textFieldList addObject:textField];
        }
    }
}

//创建View
- (void)bulidView {

}

//初始化数据
- (void)initializeData {
    
}

- (void)refreshingData {
    
}

- (void)addOperation:(AFHTTPRequestOperation*)operation {
    if (!self.operationList) {
        self.operationList = [NSMutableArray array];
    }
    if (operation) {
        [self.operationList addObject:operation];
    }

}

- (void)cancelOperation {
    
    if (self.operationList) {
        [self.operationList enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            [obj cancel];
        }];
    }
}

- (void)dealloc {
    [self cancelOperation];
}

//-(UIStatusBarStyle)preferredStatusBarStyle {
//    return UIStatusBarStyleDefault;
//}

@end
