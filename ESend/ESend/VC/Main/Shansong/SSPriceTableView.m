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


- (id)initWithmasterKG:(NSInteger)masterKG
              masterKM:(NSInteger)masterKM
masterDistributionPrice:(double)masterDistributionPrice
                 oneKM:(NSInteger)oneKM
  oneDistributionPrice:(double)oneDistributionPrice
                 twoKG:(NSInteger)twoKG
  twoDistributionPrice:(double)twoDistributionPrice{
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
        UIImageView * line = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(title.frame), PriceTableWidth - 20, 0.5f)];
        line.backgroundColor = SeparatorLineColor;
        [self addSubview:line];
        // 30 * 30
        UIButton * cancelbtn = [[UIButton alloc] initWithFrame:CGRectMake(PriceTableWidth - 10 - 30, 10, 30, 30)];
        [cancelbtn setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [cancelbtn addTarget:self action:@selector(cancelClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancelbtn];
        
        NSString * Ltext1 = [NSString stringWithFormat:@"%ld公里以内 %ld公斤以下",(long)masterKM,(long)masterKG];
        NSString * Ltext2 = [NSString stringWithFormat:@"超过%ld公里 每增加%ld公里",(long)masterKM,(long)oneKM];
        NSString * Ltext3 = [NSString stringWithFormat:@"超过%ld公斤 每增加%ld公斤",(long)masterKG,(long)twoKG];
        NSString * Rtext1 = [NSString stringWithFormat:@"%.2f元",masterDistributionPrice];
        NSString * Rtext2 = [NSString stringWithFormat:@"增加%.2f元",oneDistributionPrice];
        NSString * Rtext3 = [NSString stringWithFormat:@"增加%.2f元",twoDistributionPrice];
        NSArray * Ltexts = [NSArray arrayWithObjects:Ltext1,Ltext2,Ltext3, nil];
        NSArray * Rtexts = [NSArray arrayWithObjects:Rtext1,Rtext2,Rtext3, nil];
        //
        for (int i = 0; i <3; i++) {
            UIImageView * aIv = [self leadingImg];
            aIv.frame = CGRectMake(10, 77 + i * 30, 8, 8);
            aIv.layer.masksToBounds = YES;
            aIv.layer.cornerRadius = 4;
            [self addSubview:aIv];
            
            UILabel * aL = [self deepGrayLabel];
            aL.frame = CGRectMake(23, 68 + i * 30, 170, 25);
            aL.text = [Ltexts objectAtIndex:i];
            [self addSubview:aL];
            
            UILabel * aR = [self blueLabel];
            aR.frame = CGRectMake(185, 68 + i * 30, 80, 25);
            aR.text = [Rtexts objectAtIndex:i];
            [self addSubview:aR];
        }
    }
    return self;
}

- (UILabel *)deepGrayLabel{
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    aLabel.font = [UIFont systemFontOfSize:14];
    aLabel.textColor = DeepGrey;
    aLabel.textAlignment = NSTextAlignmentLeft;
    return aLabel;
}

- (UILabel *)blueLabel{
    UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    aLabel.font = [UIFont systemFontOfSize:14];
    aLabel.textColor = BlueColor;
    aLabel.textAlignment = NSTextAlignmentRight;
    return aLabel;
}

- (UIImageView *)leadingImg{
    UIImageView * lI = [[UIImageView alloc] initWithFrame:CGRectZero];
    lI.layer.borderWidth = 2;
    lI.layer.borderColor = [SeparatorLineColor CGColor];
    return lI;
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
