//
//  MineCell.m
//  ESend
//
//  Created by 永来 付 on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MineCell.h"

@implementation MineCell

- (id)initWithTitle:(NSString*)title imageName:(NSString*)imageName content:(NSString*)content {
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, MainWidth - 20, 45);
        [self createCellWithTitle:title imageName:imageName content:content];
    }
    return self;
}

- (void)createCellWithTitle:(NSString*)title imageName:(NSString*)imageName content:(NSString*)content {
    
    self.backgroundColor = [UIColor whiteColor];
    self.layer.borderColor = [UIColor colorWithHexString:@"cccccc"].CGColor;
    self.layer.borderWidth = 0.5;
    self.layer.cornerRadius = 5;
    self.userInteractionEnabled = YES;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, 26, 45)];
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeCenter;
    [self addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(45, 0, 90, 45)];
    titleLabel.text = title;
    titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    titleLabel.textColor = DeepGrey;
    [self addSubview:titleLabel];
    
    self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(titleLabel.frame), 0, FRAME_WIDTH(self) - CGRectGetMaxX(titleLabel.frame) - 45, 45)];
    _contentLabel.textAlignment = NSTextAlignmentRight;
    _contentLabel.text = content;
    _contentLabel.textColor = MiddleGrey;
    _contentLabel.font = [UIFont systemFontOfSize:BigFontSize];
    [self addSubview:_contentLabel];
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(MainWidth - 20 - 40, 0, 40, 45)];
    rightImageView.contentMode = UIViewContentModeCenter;
    rightImageView.image = [UIImage imageNamed:@"right_indicate"];
    [self addSubview:rightImageView];
    
}

@end
