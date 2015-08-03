//
//  OrderRefuseViewController.m
//  ESend
//
//  Created by LiMingjie on 15/6/26.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "OrderRefuseViewController.h"

@interface OrderRefuseViewController () <UITextFieldDelegate>
{
    UIButton * _selectionBtn1;
    UIButton * _selectionBtn2;
    UIButton * _selectionBtn3;
    
    UIImageView * _selectIcon;
    
    UITextField * _otherReasonTF;
}
@end
@implementation OrderRefuseViewController


- (void)bulidView{
    
    self.titleLabel.text = @"拒绝订单";
    [self.leftBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.rightBtn setTitle:@"确定" forState:UIControlStateNormal];
    
    
    UILabel * markLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space_Big,64 +Space_Large, ScreenWidth, 20)];
    markLabel.text = @"拒绝（取消）理由";
    markLabel.textColor = [UIColor blackColor];
    markLabel.font = FONT_SIZE(NormalFontSize);
    [self.view addSubview:markLabel];
    
    
    _selectionBtn1 = [self createSelectionBtnWithFrameY:VIEW_Y_Bottom(markLabel) +Space_Big Title:@"无法配餐" No:0];
    _selectionBtn2 = [self createSelectionBtnWithFrameY:VIEW_Y_Bottom(_selectionBtn1) +Space_Big Title:@"无法配送" No:1];
    _selectionBtn3 = [self createSelectionBtnWithFrameY:VIEW_Y_Bottom(_selectionBtn2) +Space_Big Title:@"临时取消" No:2];
    
    
    _selectIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth - 35, 0, 20, 20)];
    _selectIcon.image  = [UIImage imageNamed:@"radio_pre"];
    _selectIcon.center = CGPointMake(VIEW_CENTER_X(_selectIcon), VIEW_HEIGHT(_selectionBtn1)/2);
    
    [self clickSelectionBtn:_selectionBtn1]; // 默认选择第一个
    
    
    
    UIView * importBgView = [[UIView alloc] initWithFrame:CGRectMake(0, VIEW_Y_Bottom(_selectionBtn3) +Space_Big, ScreenWidth, VIEW_HEIGHT(_selectionBtn3))];
    importBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:importBgView];
    
    _otherReasonTF = [[UITextField alloc] initWithFrame:CGRectMake(Space_Big, 0, ScreenWidth - Space_Big, VIEW_HEIGHT(importBgView))];
    _otherReasonTF.placeholder = @"其他原因";
    _otherReasonTF.textColor   = MiddleGrey;
    _otherReasonTF.font        = FONT_SIZE(NormalFontSize);
    _otherReasonTF.delegate    = self;
    [importBgView addSubview:_otherReasonTF];
    
}


- (UIButton *)createSelectionBtnWithFrameY:(CGFloat)y Title:(NSString *)title No:(NSInteger)num{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setFrame:CGRectMake(0, y, ScreenWidth, 45)];
    [btn setBackgroundColor:[UIColor whiteColor]];
    [btn setSelected:NO];
    [btn setTag:num];
    [btn addTarget:self action:@selector(clickSelectionBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UILabel * titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space_Big, 0, 100, VIEW_HEIGHT(btn))];
    titleLabel.text      = title;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font      = FONT_SIZE(NormalFontSize);
    [btn addSubview:titleLabel];
    
    return btn;
}

- (void)clickSelectionBtn:(UIButton *)button{
    if (button == _selectionBtn1) {
        
        [_selectionBtn1 addSubview:_selectIcon];
        [_selectionBtn1 setBackgroundColor:RGBCOLOR(224.f, 224.f, 224.f)];
        
        [_selectionBtn2 setBackgroundColor:[UIColor whiteColor]];
        [_selectionBtn3 setBackgroundColor:[UIColor whiteColor]];
        
    }else if (button == _selectionBtn2){
        
        [_selectionBtn2 addSubview:_selectIcon];
        [_selectionBtn2 setBackgroundColor:RGBCOLOR(224.f, 224.f, 224.f)];
        
        [_selectionBtn1 setBackgroundColor:[UIColor whiteColor]];
        [_selectionBtn3 setBackgroundColor:[UIColor whiteColor]];
    }else if (button == _selectionBtn3){
        
        [_selectionBtn3 addSubview:_selectIcon];
        [_selectionBtn3 setBackgroundColor:RGBCOLOR(224.f, 224.f, 224.f)];
        
        [_selectionBtn1 setBackgroundColor:[UIColor whiteColor]];
        [_selectionBtn2 setBackgroundColor:[UIColor whiteColor]];
    }
}

#pragma mark - UITextField Delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [_otherReasonTF resignFirstResponder];
    return YES;
}

@end
