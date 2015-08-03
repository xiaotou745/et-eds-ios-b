//
//  MineCell.h
//  ESend
//
//  Created by 永来 付 on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCell : UIView

@property (nonatomic, strong) UILabel *contentLabel;

- (id)initWithTitle:(NSString*)title imageName:(NSString*)imageName content:(NSString*)content;


@end
