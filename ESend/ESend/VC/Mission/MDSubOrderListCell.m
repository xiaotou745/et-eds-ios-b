//
//  MDSubOrderListCell.m
//  ESend
//
//  Created by LiMingjie on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MDSubOrderListCell.h"

#import "ControlsFactory.h"
#import "MissionDetailModel.h"
#import "MDSubOrderModel.h"

@implementation MDSubOrderListCell
{
    UIView * _bgView;
    
    UILabel * _totalLabel;
}
- (void)bulidView{

    _bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 1000)];
    _bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bgView];
    
    
    
    
    UILabel * markLabel1 = [ControlsFactory label2WithFrame:CGRectMake(Space_Big, Space_Big, 80, 20) text:@"订单总额" superView:_bgView];
    
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth -165, Space_Big, 150, 20)];
    NSString *str = [NSString stringWithFormat:@"未付款  ￥%.2f",122.0];
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:str];
    [mstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:NormalFontSize],
                          NSForegroundColorAttributeName : [UIColor whiteColor],
                          }
                  range:NSMakeRange(0, str.length)];
    [mstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:SmallFontSize],
                          NSForegroundColorAttributeName : MiddleGrey,
                          }
                  range:NSMakeRange(0, 3)];
    [mstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:NormalFontSize],
                          NSForegroundColorAttributeName : RedDefault,
                          }
                  range:NSMakeRange(3, str.length - 3)];
    _totalLabel.textAlignment = NSTextAlignmentRight;
    _totalLabel.attributedText = mstr;
    [self addSubview:_totalLabel];
    
    
    
    
    UIView * line = [Tools createLine];
    line.frame = CGRectMake(Space_Big, VIEW_Y_Bottom(markLabel1)+Space_Small, ScreenWidth - Space_Big *2, 0.5f);
    [self addSubview:line];
 
}

- (void)loadData:(id)data{
    
    MissionDetailModel * model = (MissionDetailModel *)data;
    

    CGFloat height = VIEW_Y_Bottom(_totalLabel)+Space_Small*2;
    for (MDSubOrderModel *subOrder in model.subOrderList) {
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(Space_Big, height, ScreenWidth - Space_Big - 85, 20)];
        subLabel.textColor     = DeepGrey;
        subLabel.text          = [NSString stringWithFormat:@"%@",subOrder.orderName];
        subLabel.font          = [UIFont systemFontOfSize:NormalFontSize];
        subLabel.frame         = [Tools labelForString:subLabel];
        subLabel.numberOfLines = 0;
        [self addSubview:subLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 85, height, 70, 20)];
        priceLabel.text          = [NSString stringWithFormat:@"￥%.2f",subOrder.price];
        priceLabel.textColor     = DeepGrey;
        priceLabel.font          = [UIFont systemFontOfSize:NormalFontSize];
        priceLabel.frame         = [Tools labelForString:priceLabel];
        priceLabel.textAlignment = NSTextAlignmentRight;
        [self addSubview:priceLabel];
        
        height += FRAME_HEIGHT(subLabel);
        height += 10;
    }
    
    UILabel *deliverTitle = [[UILabel alloc] initWithFrame:CGRectMake(Space_Big, height, 80, 20)];
    deliverTitle.textColor = DeepGrey;
    deliverTitle.text      = @"送餐费";
    deliverTitle.font      = [UIFont systemFontOfSize:NormalFontSize];
    deliverTitle.frame     = [Tools labelForString:deliverTitle];
    deliverTitle.numberOfLines = 0;
    [self addSubview:deliverTitle];
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 85, height, 70, 20)];
    priceLabel.text          = [NSString stringWithFormat:@"￥%.2f",model.shippingFee];
    priceLabel.textColor     = DeepGrey;
    priceLabel.font          = [UIFont systemFontOfSize:NormalFontSize];
    priceLabel.frame         = [Tools labelForString:priceLabel];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:priceLabel];
    
    NSString *str = [NSString stringWithFormat:@"%@  ￥%.2f",model.isPay ? @"已付款" : @"未付款", model.totalDeliverPrce];
    NSMutableAttributedString *mstr = [[NSMutableAttributedString alloc] initWithString:str];
    [mstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:NormalFontSize],
                          NSForegroundColorAttributeName : [UIColor whiteColor],
                          }
                  range:NSMakeRange(0, str.length)];
    [mstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:SmallFontSize],
                          NSForegroundColorAttributeName : MiddleGrey,
                          }
                  range:NSMakeRange(0, 3)];
    [mstr addAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:NormalFontSize],
                          NSForegroundColorAttributeName : RedDefault,
                          }
                  range:NSMakeRange(3, str.length - 3)];
    _totalLabel.textAlignment  = NSTextAlignmentRight;
    _totalLabel.attributedText = mstr;

    [_bgView setFrame:CGRectMake(VIEW_X(_bgView), VIEW_Y(_bgView), VIEW_WIDTH(_bgView), VIEW_Y_Bottom(deliverTitle) +Space_Normal)];
    
}

+ (CGFloat)calculateCellHeight:(id)data{
    
    MissionDetailModel * model = (MissionDetailModel *)data;

    CGFloat height = Space_Big + 20 +Space_Small*2;
    
    for (MDSubOrderModel *subOrder in model.subOrderList) {
        
        height += [Tools stringHeight:[NSString stringWithFormat:@"%@",subOrder.orderName] fontSize:NormalFontSize width:MainWidth - Space_Big - 85].height;
        height += 10;
    }
    
    height += 20;
    height += Space_Normal;
    
    return height + Space_Normal;
}

@end
