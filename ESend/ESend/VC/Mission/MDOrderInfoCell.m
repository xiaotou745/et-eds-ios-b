//
//  MDOrderInfoCell.m
//  ESend
//
//  Created by LiMingjie on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MDOrderInfoCell.h"

#import "ControlsFactory.h"
#import "MissionDetailModel.h"

@implementation MDOrderInfoCell
{
    UILabel * markLabel1;
    UILabel * _orderNoLabel;
    
    UILabel * markLabel2;
    UILabel * _orderTimeLabel;
    
    UILabel * markLabel3;
    UILabel * _orderSourceLabel;
    
    UILabel * markLabel4;
    UILabel * _thirdPartyOrderNoLabel;
    
    UIImageView * _orderStateIcon;
    UILabel     * _orderStateInfo;
}
- (void)bulidView{

    markLabel1 = [ControlsFactory label3WithFrame:CGRectMake(Space_Big, Space_Big, 70, 20)
                                             text:@"运单编号"
                                        superView:self];
    
    _orderNoLabel = [ControlsFactory label2WithFrame:CGRectMake(VIEW_X_Right(markLabel1), VIEW_Y(markLabel1), ScreenWidth - VIEW_X_Right(markLabel1) - 70, VIEW_HEIGHT(markLabel1))
                                                text:@""
                                           superView:self];
    
    
    
    
    markLabel2 = [ControlsFactory label3WithFrame:CGRectMake(VIEW_X(markLabel1), VIEW_Y_Bottom(markLabel1) +Space_Small, VIEW_WIDTH(markLabel1), VIEW_HEIGHT(markLabel1))
                                             text:@"发布时间"
                                        superView:self];
    
    _orderTimeLabel = [ControlsFactory label2WithFrame:CGRectMake(VIEW_X(_orderNoLabel), VIEW_Y(markLabel2), VIEW_WIDTH(_orderNoLabel), VIEW_HEIGHT(markLabel2))
                                                  text:@""
                                             superView:self];
    
    
    
    
    
    markLabel3 = [ControlsFactory label3WithFrame:CGRectMake(VIEW_X(markLabel1), VIEW_Y_Bottom(markLabel2) +Space_Small, VIEW_WIDTH(markLabel1), VIEW_HEIGHT(markLabel1))
                                             text:@"订单来源"
                                        superView:self];
    _orderSourceLabel = [ControlsFactory label2WithFrame:CGRectMake(VIEW_X(_orderNoLabel), VIEW_Y(markLabel3), VIEW_WIDTH(_orderNoLabel), VIEW_HEIGHT(markLabel3))
                                                    text:@""
                                               superView:self];
    
    
    
    
    
    markLabel4 = [ControlsFactory label3WithFrame:CGRectMake(VIEW_X(markLabel1), VIEW_Y_Bottom(markLabel3) +Space_Small, 100, VIEW_HEIGHT(markLabel1))
                                             text:@"第三方订单号"
                                        superView:self];
    
    _thirdPartyOrderNoLabel = [ControlsFactory label2WithFrame:CGRectMake(VIEW_X_Right(markLabel4), VIEW_Y(markLabel4), ScreenWidth - VIEW_X_Right(markLabel4) - 70, VIEW_HEIGHT(markLabel1))
                                                          text:@""
                                                     superView:self];
    
    
    
    
    
    _orderStateIcon = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth -55, VIEW_Y(markLabel1), 40, 40)];
    [self addSubview:_orderStateIcon];
    
    
    _orderStateInfo = [[UILabel alloc] initWithFrame:CGRectMake(VIEW_X(_orderStateIcon), VIEW_Y_Bottom(_orderStateIcon), VIEW_WIDTH(_orderStateIcon), 20)];
    _orderStateInfo.textAlignment = NSTextAlignmentCenter;
    _orderStateInfo.font = FONT_SIZE(SmallFontSize);
    [self addSubview:_orderStateInfo];
}

- (void)loadData:(id)data{
    MissionDetailModel * model = (MissionDetailModel *)data;
    
    _orderNoLabel.text = model.orderNo;
    _orderTimeLabel.text = model.time;
    
    if (model.orderType == 0) {
        
        _orderSourceLabel.text         = @"自发";
        
        markLabel4.hidden              = YES;
        _thirdPartyOrderNoLabel.hidden = YES;
        
    }else if (model.orderType == 1){
        _orderSourceLabel.text         = model.orderSource;
        _thirdPartyOrderNoLabel.text   = model.thirdPartyOrderNo;
        
        markLabel4.hidden              = NO;
        _thirdPartyOrderNoLabel.hidden = NO;
    }
    
    
    if (model.orderStatus == 0) {  // 送货中
        [_orderStateIcon setImage:[UIImage imageNamed:@"sending_icon"]];
        
        _orderStateInfo.text = @"送货中";
        _orderStateInfo.textColor = [UIColor colorWithRed:245.f/255.f green:90.f/255.f blue:97.f/255.f alpha:1.f];
    }else if (model.orderStatus == 1){ // 取货中
        [_orderStateIcon setImage:[UIImage imageNamed:@"receive_icon"]];
        
        _orderStateInfo.text = @"取货中";
        _orderStateInfo.textColor = [UIColor colorWithRed:31.f/255.f green:188.f/255.f blue:211.f/255.f alpha:1.f];
    }else if (model.orderStatus == 2){ // 已完成
        [_orderStateIcon setImage:[UIImage imageNamed:@"compeleted_icon"]];
        
        _orderStateInfo.text = @"已完成";
        _orderStateInfo.textColor = [UIColor colorWithRed:29.f/255.f green:187.f/255.f blue:136.f/255.f alpha:1.f];
    }
}

+ (CGFloat)calculateCellHeight:(id)data{
    MissionDetailModel * model = (MissionDetailModel *)data;
    
    if (model.orderType == 0) {
        return Space_Big + 20 + Space_Small + 20 + Space_Small + 20 + Space_Big;
    }else if (model.orderType == 1){
        return Space_Big + 20 + Space_Small + 20 + Space_Small + 20 + Space_Small + 20 + Space_Big;
    }
    return 0.f;
}

@end
