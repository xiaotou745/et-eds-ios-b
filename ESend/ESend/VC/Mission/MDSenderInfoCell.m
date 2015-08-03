//
//  MDSenderInfoCell.m
//  ESend
//
//  Created by LiMingjie on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MDSenderInfoCell.h"

#import "ControlsFactory.h"
#import "MissionDetailModel.h"

@implementation MDSenderInfoCell
{
    UIView * _bgView;
    
    UILabel * markLabel1;
    UILabel * _nameLabel;
    
    UIImageView * _phoneBgIcon;
    UILabel     * _phoneNoLabel;
}

- (void)bulidView{
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1000)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    
    
    
    markLabel1 = [ControlsFactory label3WithFrame:CGRectMake(Space_Big, Space_Big, 70, 20)
                                             text:@"配 送 方"
                                        superView:_bgView];
    
    _nameLabel = [ControlsFactory label2WithFrame:CGRectMake(VIEW_X_Right(markLabel1), VIEW_Y(markLabel1), ScreenWidth - VIEW_X_Right(markLabel1) - Space_Big, 1000)
                                             text:@""
                                        superView:_bgView];
    
    

    
    
    _phoneBgIcon = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 250, 40)];
    _phoneBgIcon.center = CGPointMake(ScreenWidth/2, VIEW_CENTER_Y(_phoneBgIcon));
    _phoneBgIcon.userInteractionEnabled = YES;
    UIImage * iconImg   = [UIImage imageNamed:@"拨打电话按钮"];
    UIEdgeInsets edge   = UIEdgeInsetsMake(20, 50, 24, 17);
    iconImg = [iconImg resizableImageWithCapInsets:edge resizingMode:UIImageResizingModeStretch];
    _phoneBgIcon.image  = iconImg;
    [self addSubview:_phoneBgIcon];
    
    
    _phoneNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0,250, 40)];
    _phoneNoLabel.textAlignment = NSTextAlignmentCenter;
    _phoneNoLabel.font          = FONT_SIZE(NormalFontSize);
    _phoneNoLabel.textColor     = [UIColor colorWithRed:29.f/255.f green:187.f/255.f blue:136.f/255.f alpha:1.f];
    [_phoneBgIcon addSubview:_phoneNoLabel];
    
    
    UIButton * clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [clickBtn setFrame:_phoneNoLabel.frame];
    [clickBtn setBackgroundColor:[UIColor clearColor]];
    [clickBtn addTarget:self action:@selector(clickPhoneNo) forControlEvents:UIControlEventTouchUpInside];
    [_phoneBgIcon addSubview:clickBtn];
}

- (void)loadData:(id)data{
    
    MissionDetailModel * model = (MissionDetailModel *)data;
    
    _phoneNoLabel.text = model.senderPhoneNo;
    
    _nameLabel.text = model.senderName;
    [_nameLabel sizeToFit];
    
    [_phoneBgIcon setFrame:CGRectMake(VIEW_X(_phoneBgIcon), VIEW_Y_Bottom(_nameLabel)+Space_Big, VIEW_WIDTH(_phoneBgIcon), VIEW_HEIGHT(_phoneBgIcon))];
    [_bgView setFrame:CGRectMake(0, 0, ScreenWidth, VIEW_Y_Bottom(_phoneBgIcon)+Space_Big)];
}

+ (CGFloat)calculateCellHeight:(id)data{
    MissionDetailModel * model = (MissionDetailModel *)data;
    
    CGSize size = [Tools stringHeight:model.senderName fontSize:NormalFontSize width:(ScreenWidth - Space_Big - 70 - Space_Big)];
    
    return Space_Big + size.height + Space_Big + 40 + Space_Big + Space_Normal;
}

- (void)clickPhoneNo{
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_phoneNoLabel.text];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

@end
