//
//  SSPriceTableView.m
//  ESend
//
//  Created by 台源洪 on 15/12/20.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSPriceTableView.h"

#define PriceTableWidth 280
#define PriceTableHeight 170
@interface SSPriceTableView()
{
    UIView * _mask;
}

@end

@implementation SSPriceTableView


- (id)initWithRemark:(NSString *)remark{
    if (self = [super init]) {
        self.frame = CGRectMake((ScreenWidth - PriceTableWidth)/2, (ScreenHeight-PriceTableHeight)/2, PriceTableWidth, PriceTableHeight);
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 2;
        //
        UILabel * title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 50)];
        title.text = @"价格表";
        title.textAlignment = NSTextAlignmentCenter;
        title.font = [UIFont systemFontOfSize:16];
        title.textColor = DeepGrey;
        [self addSubview:title];
        UILabel * line = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(title.frame), PriceTableWidth - 20, 0.5f)];
        line.backgroundColor = SeparatorLineColor;
        [self addSubview:line];
        // 30 * 30
        UIButton * cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(PriceTableWidth - 10 - 30, 10, 30, 30)];
        [cancelbtn setImage:[UIImage imageNamed:@"ss_addr_delete"] forState:UIControlStateNormal];
        [cancelbtn addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelbtn];
        
        UITextView * textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 58, self.frame.size.width-10, 105)];
        textView.font = [UIFont systemFontOfSize:16];
        textView.text = remark;
        textView.editable = NO;
        textView.textColor = DeepGrey;
        [self addSubview:textView];
    }
    return self;
}

- (void)showInView:(UIView *)view{
    if (!_mask) {
        _mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    }
    _mask.backgroundColor = DeepGrey;
    _mask.alpha = 0.0f;
    [view addSubview:_mask];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelView)];
    [_mask addGestureRecognizer:tap];
    
    //self.frame = CGRectMake(0, view.frame.size.height, ScreenWidth, self.frame.size.height);
    [view addSubview:self];
    
    [UIView animateWithDuration:0.1 animations:^{
        _mask.alpha = 0.8f;
    }completion:^(BOOL finished) {

    }];
}

- (void)cancelView{
    [UIView animateWithDuration:0.1
                     animations:^{
                         _mask.alpha = 0.0f;
                     }
                     completion:^(BOOL finished){
                         [_mask removeFromSuperview];
                         _mask = nil;
                         [self removeFromSuperview];
                     }];
}



- (void)cancelClicked:(UIButton *)sender {
    [self cancelView];
}

@end
