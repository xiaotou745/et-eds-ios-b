//
//  EDSFullfillMoneyVC.m
//  ESend
//
//  Created by 台源洪 on 15/9/11.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "EDSFullfillMoneyVC.h"

@interface EDSFullfillMoneyVC ()
@property (strong, nonatomic) IBOutlet UIScrollView *FFM_Scroller;
@property (strong, nonatomic) IBOutlet UIView *FFM_ScrollerContent;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *FFM_ScrollerContentHeight;

@property (strong, nonatomic) IBOutlet UIView *FFM_TitleBlock;
@property (strong, nonatomic) IBOutlet UIImageView *FFM_SeparatorLine;
@property (strong, nonatomic) IBOutlet UILabel *FFM_AmoutRemainFix;
@property (strong, nonatomic) IBOutlet UILabel *FFM_AmoutRemain;
@property (strong, nonatomic) IBOutlet UILabel *FFM_AmoutToRechargeFix;
@property (strong, nonatomic) IBOutlet UITextField *FFM_AmoutToRecharge;

@property (strong, nonatomic) IBOutlet UITableView *FFM_PaymentOptionTable;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *FFM_PaymentOptionTableHeight;

@property (strong, nonatomic) IBOutlet UIButton *FFM_PaymentSubmitBtn;


@end

@implementation EDSFullfillMoneyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"充值";

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    
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
