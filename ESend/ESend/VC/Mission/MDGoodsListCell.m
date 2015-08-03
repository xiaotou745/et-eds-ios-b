//
//  MDGoodsListCell.m
//  ESend
//
//  Created by LiMingjie on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MDGoodsListCell.h"

#import "ControlsFactory.h"
#import "MissionDetailModel.h"
#import "MDSubOrderModel.h"

@implementation MDGoodsListCell
{
    UIView * _bgView;

    UILabel * _countLabel;
}
- (void)bulidView{

    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1000)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    
    
    UILabel * markLabel1 = [ControlsFactory label1WithFrame:CGRectMake(Space_Big, Space_Big, 70, 20) text:@"商品明细" superView:_bgView];
    
    
    _countLabel = [ControlsFactory label1WithFrame:CGRectMake(VIEW_X_Right(markLabel1), VIEW_Y(markLabel1), ScreenWidth - VIEW_X_Right(markLabel1) - 70, VIEW_HEIGHT(markLabel1))
                                                text:@""
                                           superView:self];
    
}

- (void)loadData:(id)data{

    MissionDetailModel * model = (MissionDetailModel *)data;
    
    _countLabel.text = [NSString stringWithFormat:@"共%ld份",(unsigned long)model.subOrderList.count];

    CGFloat height = VIEW_Y_Bottom(_countLabel)+Space_Small;
    
    for (MDSubOrderModel *subOrder in model.subOrderList) {
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space_Big, height, ScreenWidth - Space_Big - 135, 20)];
        subLabel.textColor     = DeepGrey;
        subLabel.text          = [NSString stringWithFormat:@"%@",subOrder.orderName];
        subLabel.font          = [UIFont systemFontOfSize:NormalFontSize];
        subLabel.frame         = [Tools labelForString:subLabel];
        subLabel.numberOfLines = 0;
        [self addSubview:subLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth -135, height, 120, 20)];
        priceLabel.text          = [NSString stringWithFormat:@"￥%.2f×%ld",subOrder.price,(long)subOrder.count];
        priceLabel.textColor     = DeepGrey;
        priceLabel.font          = [UIFont systemFontOfSize:NormalFontSize];
        priceLabel.frame         = [Tools labelForString:priceLabel];
        priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:priceLabel];
        
        height += FRAME_HEIGHT(subLabel);
        height += 10;
    }
    
    [_bgView setFrame:CGRectMake(0, 0, ScreenWidth, height)];
}

+ (CGFloat)calculateCellHeight:(id)data{
    
    MissionDetailModel * model = (MissionDetailModel *)data;
    
    CGFloat height = Space_Big + 20 +Space_Small;
    
    for (MDSubOrderModel *subOrder in model.subOrderList) {
        
        height += [Tools stringHeight:[NSString stringWithFormat:@"%@",subOrder.orderName] fontSize:NormalFontSize width:MainWidth - Space_Big - 135].height;
        height += 10;
    }
    
    return height + Space_Normal;
}

@end
