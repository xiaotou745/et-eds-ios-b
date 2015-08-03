//
//  MessagesTableViewCell.m
//  ESend
//
//  Created by 永来 付 on 15/6/16.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MessagesTableViewCell.h"
#import "MessageModel.h"

@interface MessagesTableViewCell()
{
    UILabel *_titleLabel;
    UILabel *_dateLabel;
    UIView *_markView;
}

@end

@implementation MessagesTableViewCell

- (void)bulidView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, MainWidth - 55, 25)];
    _titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    _titleLabel.textColor = DeepGrey;
    _titleLabel.numberOfLines = 0;
    [self.contentView addSubview:_titleLabel];
    
    _dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_titleLabel.frame), 200, 20)];
    _dateLabel.font = [UIFont systemFontOfSize:SmallFontSize];
    _dateLabel.textColor = MiddleGrey;
    [self.contentView addSubview:_dateLabel];
    
    _markView = [[UIView alloc] initWithFrame:CGRectMake(0, 22.5 - 5, 10, 10)];
    _markView.backgroundColor = RedDefault;
    _markView.layer.cornerRadius = 5;
    _markView.hidden = YES;
    [self.contentView addSubview:_markView];
    
    NSLog(@"%f",CGRectGetMaxY(_dateLabel.frame) + 10);
}

- (void)loadData:(MessageModel*)data {
    _titleLabel.text = data.title;
    _dateLabel.text = data.date;
    
    if (data.isRead) {
        _markView.hidden = YES;
        
    } else {
        _markView.hidden = NO;
        
        CGRect frame = [data.title boundingRectWithSize:CGSizeMake(MainWidth - 50, 30) options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:BigFontSize]} context:nil];
        if (frame.size.width > MainWidth - 50 - 10) {
            
            [_markView changeFrameOriginX:MainWidth - 45];
        } else {
            [_markView changeFrameOriginX:frame.size.width + 20];
        }
    }
    
}



@end
