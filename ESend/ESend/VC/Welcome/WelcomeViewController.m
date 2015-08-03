//
//  WelcomeViewController.m
//  ESend
//
//  Created by LiMingjie on 15/6/28.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "WelcomeViewController.h"
#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "LMJPageControl.h"

@interface WelcomeViewController () <UIScrollViewDelegate>
{
    LMJPageControl * _pageControl;
    
    UIButton * _loginBtn;
    UIButton * _signBtn;
}
@end

@implementation WelcomeViewController

- (void)bulidView{
    self.view.backgroundColor = [UIColor whiteColor];
    self.navBar.hidden = YES;
    
    [self creatScrollView];
    [self createBtns];
}

-(void)creatScrollView{
    NSArray *imageNameArray = nil;
    
    if(ScreenHeight <= 480){
        imageNameArray = @[@"640X960_01", @"640X960_02", @"640X960_03"];
    }else if(ScreenHeight <= 568){
        imageNameArray = @[@"640X1136_01", @"640X1136_02", @"640X1136_03"];
    }else if (ScreenHeight <= 662){
        imageNameArray = @[@"750X1334_01", @"750X1334_02", @"750X1334_03"];
    }else if (ScreenHeight <= 1104){
        imageNameArray = @[@"1242X2208_01", @"1242X2208_02", @"1242X2208_03"];
    }
    
    
    UIScrollView * pageScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    pageScrollView.pagingEnabled                  = YES;
    pageScrollView.bounces                        = NO;
    pageScrollView.showsHorizontalScrollIndicator = NO;
    pageScrollView.contentSize                    = CGSizeMake(ScreenWidth * imageNameArray.count, ScreenHeight);
    pageScrollView.delegate                       = self;
    [self.view addSubview:pageScrollView];
    
    for (int i = 0; i < imageNameArray.count; i++) {
        
        UIImageView * imgView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth *i, 0, ScreenWidth, ScreenHeight)];
        imgView.image                  = [UIImage imageNamed:imageNameArray[i]];
        imgView.userInteractionEnabled = YES;
        [pageScrollView addSubview:imgView];
    }
    
    
    _pageControl = [[LMJPageControl alloc] initWithFrame:CGRectMake(0, ScreenHeight - 100, 40, 30) pointSize:6.f normalColor:[UIColor whiteColor] selectedColor:RGBCOLOR(32.f, 188.f, 211.f)];
    [_pageControl setCenter:CGPointMake(ScreenWidth/2, VIEW_CENTER_Y(_pageControl))];
    [_pageControl setNumberOfPages:imageNameArray.count];
    [_pageControl setCurrentPage:0];
    [self.view addSubview:_pageControl];
    
}

- (void)createBtns{
    
    CGFloat btnWidth = (ScreenWidth - 40*2 - 30)/2;
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setFrame:CGRectMake(40, ScreenHeight - 70, btnWidth, 40)];
    [_loginBtn setBackgroundColor:RGBCOLOR(32.f, 188.f, 211.f)];
    [_loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(clickLoginBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
    
    _loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_loginBtn setFrame:CGRectMake(ScreenWidth- 40 - btnWidth, ScreenHeight - 70, btnWidth, 40)];
    [_loginBtn setBackgroundColor:[UIColor whiteColor]];
    [_loginBtn setTitle:@"免费开店" forState:UIControlStateNormal];
    [_loginBtn setTitleColor:RGBCOLOR(32.f, 188.f, 211.f) forState:UIControlStateNormal];
    [_loginBtn addTarget:self action:@selector(clickSignBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_loginBtn];
    
}

#pragma mark - ClickBtn Methods
- (void)clickLoginBtn{
    
    NSMutableArray *VCs = [NSMutableArray array];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [VCs addObject:loginVC];
    [self.navigationController setViewControllers:VCs animated:YES];
    
}
- (void)clickSignBtn{
    NSMutableArray *VCs = [NSMutableArray array];
    
    LoginViewController *loginVC = [[LoginViewController alloc] init];
    [VCs addObject:loginVC];
    RegisterViewController * vc = [[RegisterViewController alloc] init];
    [VCs addObject:vc];
    [self.navigationController setViewControllers:VCs animated:YES];
    

}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_pageControl setCurrentPage:scrollView.contentOffset.x/ScreenWidth];
}


@end
