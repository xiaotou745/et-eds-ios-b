//
//  EDSMyClientersVC.m
//  ESend
//
//  Created by 台源洪 on 15/11/5.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSMyClientersVC.h"

#define MC_HeadButtonTagTrans 1105

@interface EDSMyClientersVC ()
// optionView
@property (strong, nonatomic) IBOutlet UIView *MC_OptionBg;
@property (strong, nonatomic) IBOutlet UIButton *MC_OptionBtn1;
@property (strong, nonatomic) IBOutlet UIButton *MC_OptionBtn2;
@property (strong, nonatomic) IBOutlet UIImageView *MC_OptionSeparator;
@property (strong, nonatomic) IBOutlet UIImageView *MC_OptionIndicator;
// tables
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *MC_HorizonScrollWidth;
@property (strong, nonatomic) IBOutlet UITableView *MC_Table1;
@property (strong, nonatomic) IBOutlet UITableView *MC_Table2;
@property (strong, nonatomic) IBOutlet UIScrollView *MC_HorizonScroller;
// dataSource
@property (nonatomic, strong) NSMutableArray * MC_TableDatasource1;
@property (nonatomic, strong) NSMutableArray * MC_TableDatasource2;

@end

@implementation EDSMyClientersVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"我的骑士";
    
    [self mc_configOptionView];
}

- (void)mc_configOptionView{
    self.MC_OptionSeparator.backgroundColor = BackgroundColor;
    
    // optionView  buttons
    self.MC_OptionBtn1.tag = 1 + MC_HeadButtonTagTrans;
    self.MC_OptionBtn2.tag = 2 + MC_HeadButtonTagTrans;
    
    [self setOptionButton:self.MC_OptionBtn1 count:0];
    [self setOptionButton:self.MC_OptionBtn2 count:0];
    
    self.MC_OptionBtn1.titleLabel.font =
    self.MC_OptionBtn2.titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    self.MC_OptionBtn1.backgroundColor =
    self.MC_OptionBtn2.backgroundColor = [UIColor whiteColor];
    
    self.MC_OptionIndicator.backgroundColor = BlueColor;
}
- (void)setOptionButton:(UIButton *)btn count:(long)count{
    NSString * tCount = (count>99)?[NSString stringWithFormat:@"99+"]:[NSString stringWithFormat:@"%ld",count];
    NSString * text = nil;
    if (btn.tag == 1 + MC_HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"服务中(%@)",tCount];
    }else if (btn.tag == 2 + MC_HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"申请中(%@)",tCount];
    }
    
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [AttributedString addAttribute:NSForegroundColorAttributeName value:DeepGrey range:NSMakeRange(0,AttributedString.length)];
    [btn setAttributedTitle:AttributedString forState:UIControlStateNormal];
    
    NSMutableAttributedString * hightedAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [hightedAttributedString addAttribute:NSForegroundColorAttributeName value:BlueColor range:NSMakeRange(0, hightedAttributedString.length)];
    [btn setAttributedTitle:hightedAttributedString forState:UIControlStateDisabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.MC_HorizonScrollWidth.constant = ScreenWidth * 2;
}

@end
