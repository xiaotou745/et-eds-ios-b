//
//  OrdersListTableVIewCell.m
//  ESend
//
//  Created by 永来 付 on 15/6/3.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "OrdersListTableVIewCell.h"

typedef NS_ENUM(NSInteger, ContentLabelType) {
    ContentLabelTypePhone = 0,
    ContentLabelTypeAddress,
    ContentLabelTypeOrderCount,
    ContentLabelTypeTotal
};

@interface OrdersListTableVIewCell()
{
    NSMutableArray *_titleLabelList;
    NSMutableArray *_contentLabelList;
    
    UILabel *_orderStatusLabel;
    UILabel *_orderTimeLabel;
}

@end

@implementation OrdersListTableVIewCell

- (void)initData {
    _titleLabelList = [NSMutableArray array];
    _contentLabelList = [NSMutableArray array];
}

- (void)bulidView {
    
    [self initData];
    
    self.backgroundColor = [UIColor whiteColor];
    
    _orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 20)];
    _orderStatusLabel.text = @"待接单";
    _orderStatusLabel.font = [UIFont systemFontOfSize:NormalFontSize];
    _orderStatusLabel.textColor = BlueColor;
    [self.contentView addSubview:_orderStatusLabel];
    
    _orderTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 160, 10, 150, 20)];
    _orderTimeLabel.text = @"今日16:20";
    _orderTimeLabel.font = [UIFont systemFontOfSize:SmallFontSize];
    _orderTimeLabel.textColor = MiddleGrey;
    _orderTimeLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_orderTimeLabel];
    
    NSArray *titleList = @[@"收货人电话", @"收货地址", @"订单数量", @"订单金额"];
    
    int i = 0;
    for (NSString *title in titleList) {
        UILabel *label = [self createTitleLabel:title];
        [label changeFrameOriginY:(CGRectGetMaxY(_orderTimeLabel.frame) + 10 + i*20 + i*8)];
        [self.contentView addSubview:label];
        [_titleLabelList addObject:label];
        
        UILabel *contentLale = [self createContentLabel:@""];
        [contentLale changeFrameOriginY:(CGRectGetMaxY(_orderTimeLabel.frame) + 10 + i*20 + i*8)];
        [self.contentView addSubview:contentLale];
        [_contentLabelList addObject:contentLale];
        i++;
    }
    
}

- (void)loadData:(SupermanOrderModel*)data {
    _orderStatusLabel.text = data.orderStatusStr;
    _orderStatusLabel.textColor = data.orderStatusColor;
    
    _orderTimeLabel.text = data.pubDate;
    
    NSArray *dataList = @[data.receivePhone,
                          data.receiveAddress,
                          [NSString stringWithFormat:@"%ld份",(long)data.orderCount],
                          [NSString stringWithFormat:@"%.2f元", data.totalAmount]];
    
    CGFloat height = 40;
    
    for (int i = 0; i < dataList.count; i++) {
        UILabel *label = [_contentLabelList objectAtIndex:i];
        label.text = dataList[i];
        [label changeFrameOriginY:height];
        label.frame = [Tools labelForString:label];
        height += FRAME_HEIGHT(label);
        height += 8;
        
        UILabel *titleLabel = [_titleLabelList objectAtIndex:i];
        [titleLabel changeFrameOriginY:FRAME_Y(label)];
    }
}

- (UILabel*)createTitleLabel:(NSString*)title {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85, 20)];
    label.text = title;
    label.font = [UIFont systemFontOfSize:NormalFontSize];
    label.textColor = MiddleGrey;
    label.textAlignment = NSTextAlignmentRight;
    return label;
}

- (UILabel*)createContentLabel:(NSString*)content {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(95, 0, MainWidth - 105, 20)];
    label.text = content;
    label.font = [UIFont systemFontOfSize:NormalFontSize];
    label.textColor = DeepGrey;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentLeft;
    return label;
}

+ (CGFloat)calculateCellHeight:(SupermanOrderModel*)data {
    CGFloat height = 40;

    height += 3*20;
    height += 4*8;
    
    height += [Tools stringHeight:data.receiveAddress fontSize:NormalFontSize width:MainWidth - 105].height;
    
    if (iPhone6plus) {
        height += 10;
    }
    
    return height;
}

@end
