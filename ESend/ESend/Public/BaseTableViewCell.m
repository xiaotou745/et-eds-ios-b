//
//  BaseTableViewCell.m
//  USA-B
//
//  Created by 永来 付 on 14/12/15.
//  Copyright (c) 2014年 fuyonglai. All rights reserved.
//

#import "BaseTableViewCell.h"

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        [self bulidView];
    }
    return self;
}

- (void)awakeFromNib {
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self bulidView];
}

- (void)loadData:(id)data {
    
}

- (void)bulidView {
    
}

+ (CGFloat)calculateCellHeight:(id)data {
    return 44;
}

@end
