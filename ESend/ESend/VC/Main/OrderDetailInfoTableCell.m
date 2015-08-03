//
//  OrderDetailInfoTableCell.m
//  ESend
//
//  Created by 永来 付 on 15/6/5.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "OrderDetailInfoTableCell.h"
#import "OrderModel.h"

//typedef NS_ENUM(NSInteger, ContentLabel) {
//    ContentLabelOrderNumber = 0,
//    con
//};

@interface OrderDetailInfoTableCell()
{
    UILabel *_orderNumberLabel;
    UILabel *_orderTimeLabel;
    UILabel *_orderOriginLabel;
    
    UIImageView *_orderStatusIV;
    UILabel *_orderStatusLabel;
    
    NSMutableArray *_contentLabels;
    
}

@end

@implementation OrderDetailInfoTableCell


- (void)bulidView {
    
    _contentLabels = [NSMutableArray array];
    
    NSArray *titles = @[@"运单号", @"发布时间", @"订单来源"];
    
    CGFloat height = 10;
    
    for (int i = 0; i < 3; i++) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, height, 70, 20)];
        label.text = titles[i];
        label.textColor = MiddleGrey;
        label.font = [UIFont systemFontOfSize:SmallFontSize];
        label.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:label];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, height, 200, 20)];
        contentLabel.text = @"123123";
        contentLabel.textColor = DeepGrey;
        contentLabel.font = [UIFont systemFontOfSize:SmallFontSize];
        [self.contentView addSubview:contentLabel];
        [_contentLabels addObject:contentLabel];
        
        height += 20 ;
    }
    
    _orderStatusIV = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth - 15 - 45, 10, 45, 45)];
    _orderStatusIV.image = [UIImage imageNamed:@"order_wait_accept"];
    [self.contentView addSubview:_orderStatusIV];
    
    _orderStatusLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 15 - 45, CGRectGetMaxY(_orderStatusIV.frame), 45, 20)];
    _orderStatusLabel.font = [UIFont systemFontOfSize:SmallFontSize];
    _orderStatusLabel.textColor = BlueColor;
    _orderStatusLabel.text = @"待处理";
    _orderStatusLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_orderStatusLabel];
    [_orderStatusLabel changeFrameWidth:60];
    [_orderStatusLabel changeViewCenterX:_orderStatusIV.center.x];
    
    
    NSLog(@"%f",CGRectGetMaxY(_orderStatusLabel.frame));
}

- (void)loadData:(SupermanOrderModel*)data {
    
    NSArray *datas = @[data.orderNumber,
                       data.pubDate,
                       data.orderChannelStr];
    for (NSInteger i = 0; i < datas.count; i++) {
        UILabel *label = [_contentLabels objectAtIndex:i];
        label.text = datas[i];
    }
    
    _orderStatusIV.image = [UIImage imageNamed:data.orderStatusImageName];
    _orderStatusLabel.text = data.orderStatusStr;
    _orderStatusLabel.textColor = data.orderStatusColor;
}

@end
