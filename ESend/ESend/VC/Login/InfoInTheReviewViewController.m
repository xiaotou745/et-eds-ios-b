//
//  InfoInTheReviewViewController.m
//  ESend
//
//  Created by LiMingjie on 15/6/28.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "InfoInTheReviewViewController.h"
#import "UserInfo.h"

@interface InfoInTheReviewViewController ()

@end

@implementation InfoInTheReviewViewController

- (void)bulidView{
    
    self.titleLabel.text = @"信息审核中";
    self.leftBtn.hidden  = YES;
    
    
    UIButton * loginOutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginOutBtn setFrame:CGRectMake(Space_Big, Space_Large, 75, 44)];
    [loginOutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    [loginOutBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [loginOutBtn addTarget:self action:@selector(clickLoginOutBtn) forControlEvents:UIControlEventTouchUpInside];
    loginOutBtn.titleLabel.font = FONT_SIZE(18.f);
    [self.navBar addSubview:loginOutBtn];

    
    UIImageView * logoImg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 112, 112)];
    logoImg.image  = [UIImage imageNamed:@"orderLogo"];
    logoImg.center = CGPointMake(ScreenWidth/2, VIEW_HEIGHT(self.view)/3);
    [self.view addSubview:logoImg];
    
    UILabel * markLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(logoImg) +Space_Large, ScreenWidth, 60)];
    markLabel.numberOfLines = 0;
    markLabel.text          = @"信息已提交，我们将在3个工作\n日之内完成资料审核";
    markLabel.textAlignment = NSTextAlignmentCenter;
    markLabel.textColor     = DeepGrey;
    markLabel.font          = FONT_SIZE(LagerFontSize);
    [self.view addSubview:markLabel];
    
    
    UIButton * gotoHomePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [gotoHomePageBtn setFrame:CGRectMake(Space_Big, ScreenHeight - 90, ScreenWidth - Space_Big*2, 40)];
    [gotoHomePageBtn setTitle:@"进首页" forState:UIControlStateNormal];
    [gotoHomePageBtn setTintColor:[UIColor whiteColor]];
    [gotoHomePageBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    [gotoHomePageBtn addTarget:self action:@selector(clickGotoHomePageBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:gotoHomePageBtn];
    
    
    UILabel * markLabel2 = [[UILabel alloc]
                            initWithFrame:CGRectMake(0, VIEW_Y_Bottom(gotoHomePageBtn), ScreenWidth, 50)];
    markLabel2.text          = @"审核通过后即可发布订单";
    markLabel2.textAlignment = NSTextAlignmentCenter;
    markLabel2.textColor     = LightGrey;
    markLabel2.font          = FONT_SIZE(NormalFontSize);
    [self.view addSubview:markLabel2];
}
- (void)clickGotoHomePageBtn{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)clickLoginOutBtn{
    
    [UserInfo clearUserInfo];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
