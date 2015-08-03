//
//  PaymentDetailViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/9.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "PaymentDetailViewController.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"

@interface PaymentDetailViewController ()

@end

@implementation PaymentDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)bulidView {
    

    NSDictionary *requestData = @{@"BusinessId"     : @(25),
                                  @"Version"        : @"1.0"};
    
    [FHQNetWorkingAPI getPaymentDetail:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    } isShowError:NO];

    
}

@end
