//
//  MDSenderDetailCell.m
//  ESend
//
//  Created by LiMingjie on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MDSenderDetailCell.h"

#import "ControlsFactory.h"
#import "MissionDetailModel.h"

@implementation MDSenderDetailCell

{
    UIView * _bgView;
    
    UILabel * markLabel1;
    UILabel * _shippingFeeLabel;
    
    UILabel * markLabel2;
    UILabel * _invoiceNameLabel;
}

- (void)bulidView{
    
    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1000)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    
    
    
    markLabel1 = [ControlsFactory label3WithFrame:CGRectMake(Space_Big, Space_Big, 70, 20)
                                                          text:@"配送费："
                                                     superView:_bgView];
    
    _shippingFeeLabel = [ControlsFactory label3WithFrame:CGRectMake(VIEW_X_Right(markLabel1), VIEW_Y(markLabel1), ScreenWidth - VIEW_X_Right(markLabel1) - 70, VIEW_HEIGHT(markLabel1))
                                                text:@""
                                           superView:self];
    
    
    
    
    
    markLabel2 = [ControlsFactory label3WithFrame:CGRectMake(Space_Big, VIEW_Y_Bottom(markLabel1) +Space_Small, 40, 20)
                                             text:@"发票"
                                        superView:_bgView];
    
    _invoiceNameLabel = [ControlsFactory label2WithFrame:CGRectMake(VIEW_X_Right(markLabel2), VIEW_Y(markLabel2), ScreenWidth - VIEW_X_Right(markLabel2) - Space_Big, 1000)
                                             text:@""
                                        superView:_bgView];
}

- (void)loadData:(id)data{
    
    MissionDetailModel * model = (MissionDetailModel *)data;
    
    
    _shippingFeeLabel.text = [NSString stringWithFormat:@"￥%0.2f",model.shippingFee];
    
    if (model.invoiceName.length == 0) {
        _invoiceNameLabel.text = @"无";
    }else{
        _invoiceNameLabel.text = model.invoiceName;
    }
    
    [_invoiceNameLabel sizeToFit];
    
    [_bgView setFrame:CGRectMake(0, 0, ScreenWidth, VIEW_Y_Bottom(_invoiceNameLabel) + Space_Big)];
}

+ (CGFloat)calculateCellHeight:(id)data{
    MissionDetailModel * model = (MissionDetailModel *)data;
    
    NSString * str;
    if (model.invoiceName.length == 0) {
        str = @"无";
    }else{
        str = model.invoiceName;
    }
    
    CGSize size = [Tools stringHeight:str fontSize:NormalFontSize width:(ScreenWidth - Space_Big - 40 - Space_Big)];
    
    return Space_Big + 20 + Space_Small + size.height + Space_Big + Space_Normal;
}

@end
