//
//  MDNotesCell.m
//  ESend
//
//  Created by LiMingjie on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MDNotesCell.h"

#import "ControlsFactory.h"
#import "MissionDetailModel.h"

@implementation MDNotesCell

{
    UIView * _bgView;
    
    UILabel * markLabel1;
    UILabel * _noteLabel;
}

- (void)bulidView{
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1000)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    
    
    markLabel1 = [ControlsFactory label3WithFrame:CGRectMake(Space_Big, Space_Big, 40, 20)
                                             text:@"备注"
                                        superView:_bgView];
    
    _noteLabel = [ControlsFactory label2WithFrame:CGRectMake(VIEW_X_Right(markLabel1), VIEW_Y(markLabel1), ScreenWidth - VIEW_X_Right(markLabel1) - Space_Big, 1000)
                                             text:@""
                                        superView:_bgView];
}

- (void)loadData:(id)data{
    
    MissionDetailModel * model = (MissionDetailModel *)data;
    
    if (model.notes.length == 0) {
        _noteLabel.text = @"无";
    }else{
        _noteLabel.text = model.notes;
    }

    [_noteLabel sizeToFit];
    
    [_bgView setFrame:CGRectMake(0, 0, ScreenWidth, VIEW_Y_Bottom(_noteLabel) + Space_Big)];
}

+ (CGFloat)calculateCellHeight:(id)data{
    MissionDetailModel * model = (MissionDetailModel *)data;
    
    NSString * str;
    if (model.notes.length == 0) {
        str = @"无";
    }else{
        str = model.notes;
    }
    
    CGSize size = [Tools stringHeight:str fontSize:NormalFontSize width:(ScreenWidth - Space_Big - 40 - Space_Big)];
    
    return Space_Big + size.height + Space_Big + Space_Normal;
}

@end
