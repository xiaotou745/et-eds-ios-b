//
//  SSOrderDetailVC.m
//  ESend
//
//  Created by 台源洪 on 15/12/15.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSOrderDetailVC.h"

@interface SSOrderDetailVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerContentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollerBottomToBound;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *OrderHeaderToTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderContentHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderFaAddrHeight; // default 25;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderShouAddrHeight;  // default 25;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderNameToAddrBottomDistance;  // default 35;有配送信息， 否则 5
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderRemarkHeight;

@end

@implementation SSOrderDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"订单详情";
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
