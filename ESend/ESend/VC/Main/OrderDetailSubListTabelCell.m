//
//  OrderDetailSubListTabelCell.m
//  ESend
//
//  Created by 永来 付 on 15/6/5.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "OrderDetailSubListTabelCell.h"
#import "OrderModel.h"
#import "SubOrderModel.h"
#import "ChildOrderModel.h"

@interface OrderDetailSubListTabelCell()
{
    UILabel *_totalLabel;
}

@end

@implementation OrderDetailSubListTabelCell

- (void)bulidView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    titleLabel.text = @"订单总额";
    titleLabel.textColor = DeepGrey;
    titleLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    [self.contentView addSubview:titleLabel];
    
    _totalLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 200, 10, 190, 20)];
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
    [self.contentView addSubview:_totalLabel];
    
    UIView *line = [Tools createLine];
    line.frame = CGRectMake(10, CGRectGetMaxY(titleLabel.frame) + 5, MainWidth - 20, 0.5);
    [self.contentView addSubview:line];
}

- (void)loadData:(SupermanOrderModel*)data {
    
    CGFloat height = 50;
    for (ChildOrderModel *subOrder in data.childOrderList) {
        UILabel *subLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, height, MainWidth - 10 - 80, 20)];
        subLabel.textColor = DeepGrey;
        subLabel.text = [NSString stringWithFormat:@"订单%@",subOrder.orderNumber];
        subLabel.font = [UIFont systemFontOfSize:NormalFontSize];
        subLabel.frame = [Tools labelForString:subLabel];
        subLabel.numberOfLines = 0;
        [self.contentView addSubview:subLabel];
        
        UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 100, height, 90, 20)];
        priceLabel.text = [NSString stringWithFormat:@"￥%.2f",subOrder.goodPrice];
        priceLabel.textColor = DeepGrey;
        priceLabel.font = [UIFont systemFontOfSize:NormalFontSize];
        priceLabel.frame = [Tools labelForString:priceLabel];
        priceLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:priceLabel];
        
        height += FRAME_HEIGHT(subLabel);
        height += 10;
    }
    
    UILabel *deliverTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, height, 80, 20)];
    deliverTitle.textColor = DeepGrey;
    deliverTitle.text = @"送餐费";
    deliverTitle.font = [UIFont systemFontOfSize:NormalFontSize];
    deliverTitle.frame = [Tools labelForString:deliverTitle];
    deliverTitle.numberOfLines = 0;
    [self.contentView addSubview:deliverTitle];
    
    
    UILabel *priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 100, height, 90, 20)];
    priceLabel.text = [NSString stringWithFormat:@"￥%.2f",data.totalDeliverPrce];
    priceLabel.textColor = DeepGrey;
    priceLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    priceLabel.frame = [Tools labelForString:priceLabel];
    priceLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:priceLabel];
    
    NSString *str = [NSString stringWithFormat:@"%@  ￥%.2f",data.isPay ? @"已付款" : @"未付款", data.totalAmount];
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
    
}

+ (CGFloat)calculateCellHeight:(SupermanOrderModel*)data {
   
    CGFloat height = 50;
    for (ChildOrderModel *subOrder in data.childOrderList) {
        height += [Tools stringHeight:[NSString stringWithFormat:@"订单%@",subOrder.orderNumber] fontSize:NormalFontSize width:MainWidth - 10 - 80].height;
        height += 10;
    }
    
    height += 20;
    
    return height + 10;
}

@end
