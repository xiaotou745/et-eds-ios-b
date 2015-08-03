//
//  OrderDetailRemarkTableCell.m
//  ESend
//
//  Created by 永来 付 on 15/6/5.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "OrderDetailRemarkTableCell.h"

@interface OrderDetailRemarkTableCell()
{
    UILabel *_remarkLabel;
}
@end

@implementation OrderDetailRemarkTableCell

- (void)bulidView {
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 40, 20)];
    title.text = @"备注";
    title.font = [UIFont systemFontOfSize:NormalFontSize];
    title.textColor = MiddleGrey;
    [self.contentView addSubview:title];
    
    _remarkLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, MainWidth - 10 - 50, 20)];
    _remarkLabel.numberOfLines = 0;
    _remarkLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    _remarkLabel.textColor = DeepGrey;
    [self.contentView addSubview:_remarkLabel];
    
}

- (void)loadData:(NSString*)data {
    _remarkLabel.text = data;
    _remarkLabel.frame = [Tools labelForString:_remarkLabel];
}

+ (CGFloat)calculateCellHeight:(id)data {
    CGFloat height = 10 + 10;
    
    height += [Tools stringHeight:data fontSize:NormalFontSize width:MainWidth - 10 - 50].height;
    return height;
}

@end
