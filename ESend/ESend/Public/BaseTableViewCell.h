//
//  BaseTableViewCell.h
//  USA-B
//
//  Created by 永来 付 on 14/12/15.
//  Copyright (c) 2014年 fuyonglai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseTableViewCell : UITableViewCell

//创建View
- (void)bulidView;

//加载数据
- (void)loadData:(id)data;

//计算cell高度
+ (CGFloat)calculateCellHeight:(id)data;

@end
