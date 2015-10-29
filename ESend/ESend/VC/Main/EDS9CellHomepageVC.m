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

@interface EDS9CellHomepageVC ()

@end

@implementation EDS9CellHomepageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configNavTitle];
    
    NSDictionary *requestData = @{
                                  @"BusinessId" : [UserInfo getUserId],
                                  @"version"    : @"1.0",
                                  };
    NSString * urlString = @"BusinessAPI/GetUserStatus";
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    
    [[FHQNetWorkingKit getHTTPSessionManagerWithHost:OPEN_API_SEVER] POST:urlString parameters:requestData success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];

    }];
    

}

/// 配置导航条
- (void)configNavTitle{
    self.titleLabel.text = @"呼叫配送员";
    CGSize titleSize = [self.titleLabel.text sizeWithAttributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:18]}];
    UIImageView *iconView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth/2 - titleSize.width/2 - 20 - 5, 20 + (44 - titleSize.height)/2, 20, 20)];
    iconView.image = [UIImage imageNamed:@"icon_80"];
    iconView.layer.cornerRadius = 5;
    iconView.layer.masksToBounds = YES;
    [self.navBar addSubview:iconView];
    
    self.leftBtn.hidden = YES;
    
    [self.rightBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(mineBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

- (void)mineBtnAction{
    MineViewController *vc = [[MineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 9 cell 



@end
