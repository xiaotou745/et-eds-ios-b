//
//  EDSBillStatisticsVC.m
//  ESend
//
//  Created by 台源洪 on 15/9/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSBillStatisticsVC.h"

#import "FHQNetWorkingAPI.h"

@interface EDSBillStatisticsVC ()

@end

@implementation EDSBillStatisticsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [FHQNetWorkingAPI getrecordtypebSuccessBlock:^(id result, AFHTTPRequestOperation *operation) {
        
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
