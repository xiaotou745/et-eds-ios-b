//
//  MNDatePicker.m
//  with
//
//  Created by Maxwell on 15/5/3.
//  Copyright (c) 2015年 Maxwell. All rights reserved.
//

#import "MNDatePicker.h"
#import "WithCommenHeader.h"
#import "WithUtility.h"
#import "UIColor+Utility.h"
#import "AppDelegate.h"

@implementation MNDatePicker{
    UIView * _mask;
}

- (id)initWithDelegate:(id <MNDatePicerDelegate>)delegate{
    self = [[[NSBundle mainBundle] loadNibNamed:@"MNDatePicker" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        
        self.actionBg.layer.masksToBounds = YES;
        self.actionBg.layer.borderColor = [[UIColor colorWithHexString:WithColorSeparator] CGColor];
        self.actionBg.layer.borderWidth = 0.5f;
    }
    
    return self;
}


- (void)showInView:(UIView *)view{
    _mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mask.backgroundColor = [UIColor colorWithHexString:WithColorSeparator alpha:1];
    _mask.alpha = 0.0f;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_mask];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelPicker)];
    [_mask addGestureRecognizer:tap];
    
    self.frame = CGRectMake(0, view.frame.size.height, SCREEN_WIDTH, self.frame.size.height);
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, SCREEN_WIDTH, self.frame.size.height);
        _mask.alpha = 0.8f;
    }];
}

- (void)cancelPicker{
    [UIView animateWithDuration:0.3
                     animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, SCREEN_WIDTH, self.frame.size.height);
                         _mask.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [_mask removeFromSuperview];
                         _mask = nil;
                         [self removeFromSuperview];
                         
                     }];
}



- (IBAction)cancelClicked:(UIButton *)sender {
    [self cancelPicker];
}
- (IBAction)confirmClicked:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(MNDatePickerDidSelected:)]) {
        [self.delegate MNDatePickerDidSelected:self];
    }
    [self cancelPicker];
}

@end
