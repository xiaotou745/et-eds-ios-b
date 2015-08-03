//
//  ExpensesInfoCell.m
//  ESend
//
//  Created by LiMingjie on 15/6/27.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ExpensesInfoCell.h"

#import "ExpensesInfoModel.h"

@implementation ExpensesInfoCell
{
    UILabel * _infoType;
    UILabel * _amount;
    UILabel * _time;
    UILabel * _state;
}

- (void)bulidView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    _infoType = [[UILabel alloc] initWithFrame:CGRectMake(Space_Big, Space_Small, 250, 30)];
    _infoType.textColor = [UIColor blackColor];
    _infoType.font      = FONT_SIZE(BigFontSize);
    [self addSubview:_infoType];
    
    _amount = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth -150 -Space_Big, VIEW_Y(_infoType), 150, 30)];
    _amount.textColor     = [UIColor blackColor];
    _amount.textAlignment = NSTextAlignmentRight;
    _amount.font          = FONT_SIZE(BigFontSize);
    [self addSubview:_amount];
    
    _time = [[UILabel alloc] initWithFrame:CGRectMake(Space_Big, VIEW_Y_Bottom(_infoType), 100, 20)];
    _time.textColor = LightGrey;
    _time.font      = FONT_SIZE(SmallFontSize);
    [self addSubview:_time];
    
    _state = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth -80 -Space_Big, VIEW_Y(_time), 80, 20)];
    _state.textColor     = LightGrey;
    _state.textAlignment = NSTextAlignmentRight;
    _state.font          = FONT_SIZE(SmallFontSize);
    [self addSubview:_state];
    
    
    UIView * line = [Tools createLine];
    [line setFrame:CGRectMake(Space_Big, 59.5, ScreenWidth - Space_Big*2, 0.5f)];
    [self addSubview:line];
}

- (void)loadData:(id)data{
    ExpensesInfoModel * model = (ExpensesInfoModel *)data;
    
    _infoType.text = model.infoType;
    _amount.text   = [NSString stringWithFormat:@"￥%0.2f",model.amount];
    _time.text     = model.time;
    _state.text    = model.state;
}

+ (CGFloat)calculateCellHeight:(id)data{
    return 60.f;
}

@end
