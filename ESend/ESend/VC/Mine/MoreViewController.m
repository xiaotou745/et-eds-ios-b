//
//  MoreViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/9.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MoreViewController.h"
#import "MoreTableViewCell.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "ForgetPasswordViewController.h"
#import "AboutViewController.h"
#import "HelpViewController.h"
#import "SCFeedbackVC.h"

@interface MoreViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView *_tableView;
    
    NSArray *_titles;
}
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)bulidView {
    
    self.titleLabel.text = @"更多";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView registerClass:[MoreTableViewCell class] forCellReuseIdentifier:NSStringFromClass([MoreTableViewCell class])];
    [self.view addSubview:_tableView];
    
    _titles = @[@"修改密码", @"联系客服",@"意见反馈",  @"版本号"
                ];
    
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 94)];
    UIButton *logoutBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [logoutBtn setTitle:@"退出登录" forState:UIControlStateNormal];
    logoutBtn.frame = CGRectMake(10, 50, MainWidth - 20, 44);
    [logoutBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    [logoutBtn addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:logoutBtn];
    _tableView.tableFooterView = bottomView;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _titles.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MoreTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MoreTableViewCell class]) forIndexPath:indexPath];
    [cell loadData:[_titles objectAtIndex:indexPath.section]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ForgetPasswordViewController *vc = [[ForgetPasswordViewController alloc] init];
        vc.isChangePassword = YES;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    if (indexPath.section == 1) {
        NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",@"4006380177"];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        return;
    }
    
    if (indexPath.section == 2) {   // 意见反馈
//        AboutViewController *vc = [[AboutViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//        return;
        SCFeedbackVC * vc = [[SCFeedbackVC alloc] initWithNibName:@"SCFeedbackVC" bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
//    if (indexPath.section == 3) {
//        HelpViewController *vc = [[HelpViewController alloc] init];
//        [self.navigationController pushViewController:vc animated:YES];
//    }
    
    

}

- (void)logout {
    
    UIAlertView *alerView = [[UIAlertView alloc] initWithTitle:@"" message:@"您确定要退出登录吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alerView show];
    
    

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [UserInfo clearUserInfo];
        [APPDLE showLoginAnimated:YES];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LogoutNotifaction object:nil];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

@end
