//
//  EDSBusinessShouldKnow.m
//  ESend
//
//  Created by 台源洪 on 15/9/22.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSBusinessShouldKnow.h"
#import "SSHttpReqServer.h"
#import "UserInfo.h"

@interface EDSBusinessShouldKnow ()<UIWebViewDelegate>
{
    MBProgressHUD *_HUD;
}

@property (strong, nonatomic) IBOutlet UITextView *BS_businessShouldKnow;

@end

@implementation EDSBusinessShouldKnow

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"价格表";
    
    _HUD = [Tools showProgressWithTitle:@""];
    NSDictionary * paraDict = @{
                                @"businessId":[UserInfo isLogin]?[UserInfo getUserId]:@"0",
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{@"data":aesString,};
    }
    [SSHttpReqServer gettaskdistributionconfigParam:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:_HUD];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSArray * result = [responseObject objectForKey:@"result"];
            NSString * remark = result[0][@"remark"];
            self.BS_businessShouldKnow.text = remark;
            self.BS_businessShouldKnow.font = [UIFont systemFontOfSize:16];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:_HUD];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
