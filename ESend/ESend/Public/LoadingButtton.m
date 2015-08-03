//
//  LoadingButtton.m
//  USA-B
//
//  Created by 永来 付 on 15/1/21.
//  Copyright (c) 2015年 fuyonglai. All rights reserved.
//

#import "LoadingButtton.h"

@implementation LoadingButtton


- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    [self resizeActivity];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self resizeActivity];
}

- (void)resizeActivity {
    
    if (!_activityIndeicatorView) {
        _activityIndeicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [self addSubview:_activityIndeicatorView];
    }

    CGFloat height = self.frame.size.height;
    
    CGFloat width = [self.currentTitle
                     boundingRectWithSize:CGSizeMake(MAXFLOAT, self.frame.size.height)
                                                    options:NSStringDrawingTruncatesLastVisibleLine
                                                 attributes:@{NSFontAttributeName : self.titleLabel.font}
                                                    context:nil].size.width;
   _activityIndeicatorView.center = CGPointMake(self.frame.size.width/2 - width/2 - 20, height/2);
}

- (void)starLoadding {
    [_activityIndeicatorView startAnimating];
    self.enabled = NO;
}

- (void)stopLoadding {
    [_activityIndeicatorView stopAnimating];
    self.enabled = YES;
}

@end
