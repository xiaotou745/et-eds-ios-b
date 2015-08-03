//
//  MoreTableViewCell.m
//  ESend
//
//  Created by 永来 付 on 15/6/9.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MoreTableViewCell.h"

@interface MoreTableViewCell ()
{
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UIImageView *_leftView;
}

@end

@implementation MoreTableViewCell

- (void)bulidView {
    
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *line = [Tools createLine];
    line.frame = CGRectMake(0, 0, MainWidth, 0.5);
    [self.contentView addSubview:line];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, MainWidth, 45)];
    _titleLabel.textColor = DeepGrey;
    _titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [self.contentView addSubview:_titleLabel];
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(MainWidth - 100, 0, 80, 45)];
    _contentLabel.textColor = MiddleGrey;
    _contentLabel.font = [UIFont systemFontOfSize:BigFontSize];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_contentLabel];
    
    _leftView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth - 45, 0, 45, 45)];
    _leftView.image = [UIImage imageNamed:@"right_indicate"];
    _leftView.contentMode = UIViewContentModeCenter;
    [self.contentView addSubview:_leftView];
    
    UIView *line1 = [Tools createLine];
    line1.frame = CGRectMake(0, 44.5, MainWidth, 0.5);
    [self.contentView addSubview:line1];
}

- (void)loadData:(NSString*)title {
    if ([title isEqualToString:@"版本号"]) {
        _contentLabel.text = [NSString stringWithFormat:@"v%@",[Tools getApplicationVersion]];
        _leftView.hidden = YES;
    } else {
        _contentLabel.text = @"";
        _leftView.hidden = NO;
    }
    
    _titleLabel.text = title;
}

@end
