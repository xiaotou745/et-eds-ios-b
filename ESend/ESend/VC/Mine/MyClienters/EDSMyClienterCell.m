//
//  EDSMyClienterCell.m
//  ESend
//
//  Created by 台源洪 on 15/11/6.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSMyClienterCell.h"
#import "UIImageView+WebCache.h"

NSString *const EDSMyClienterInService = @"解绑";
NSString *const EDSMyClienterApplyingAdd = @"添加";
NSString *const EDSMyClienterApplyingReject = @"拒绝";


@interface EDSMyClienterCell ()
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *ClienterImg;
@property (strong, nonatomic) IBOutlet UILabel *ClienterNameFix;
@property (strong, nonatomic) IBOutlet UILabel *ClienterName;
@property (strong, nonatomic) IBOutlet UILabel *ClienterPhoneFix;
@property (strong, nonatomic) IBOutlet UILabel *ClienterPhone2;
@property (strong, nonatomic) IBOutlet UIButton *ClienterButton;
@property (strong, nonatomic) IBOutlet UIButton *ClienterButton2;

@end

@implementation EDSMyClienterCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = BackgroundColor;
    
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.borderColor = [SeparatorLineColor CGColor];
    self.bgView.layer.borderWidth = 0.5f;
    
    self.ClienterNameFix.textColor =
    self.ClienterName.textColor =
    self.ClienterPhoneFix.textColor =
    self.ClienterPhone2.textColor = TextColor6;
    
    self.ClienterImg.layer.cornerRadius = CGRectGetWidth(self.ClienterImg.frame)/2;
    self.ClienterImg.layer.borderWidth = 2.0f;
    self.ClienterImg.layer.borderColor = [SeparatorLineColor CGColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)clienterButtonAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clienterCell:didClickTitle:cellInfo:)]) {
        [self.delegate clienterCell:self didClickTitle:sender.currentTitle cellInfo:self.datasource];
    }
}

- (void)setDatasource:(EDSMyClienter *)datasource{
    _datasource = datasource;
    [self.ClienterImg sd_setImageWithURL:[NSURL URLWithString:_datasource.headPhoto] placeholderImage:[UIImage imageNamed:@"default_clienter_img"]];
    self.ClienterName.text = _datasource.trueName;
    self.ClienterPhone2.text = _datasource.phoneNo;
}

- (void)setButtonTitle:(NSString *)buttonTitle{
    [self.ClienterButton setTitle:buttonTitle forState:UIControlStateNormal];
    if ([buttonTitle compare:EDSMyClienterInService] == NSOrderedSame) {
        self.ClienterButton2.hidden = YES;
    }else{
        self.ClienterButton2.hidden = NO;
    }
}
- (void)setButtonTitle2:(NSString *)buttonTitle2{
    [self.ClienterButton2 setTitle:buttonTitle2 forState:UIControlStateNormal];
}

@end
