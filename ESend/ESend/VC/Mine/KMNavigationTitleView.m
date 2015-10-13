//
//  KMNavigationTitleView.m
//  ESend
//
//  Created by 台源洪 on 15/10/10.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "KMNavigationTitleView.h"

#define KmNavigationTitleLabelWidth 90.0f
#define KmNavigationTiltelImgWidth 8.0f

@interface KMNavigationTitleView ()

@property (nonatomic, strong) UILabel * titleLabel;
@property (nonatomic, strong) UIImageView * titleImg;
@property (nonatomic, strong) UIButton * titleBtn;

@end

@implementation KMNavigationTitleView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self configViews];
        
        // default value
        self.style = KMNavigationTitleViewStyleDay;
    }
    return self;
}


- (void)configViews{
    //self.backgroundColor = [UIColor clearColor];
    [self addSubview:self.titleImg];
    [self addSubview:self.titleLabel];
    [self addSubview:self.titleBtn];
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KmNavigationTitleLabelWidth, self.bounds.size.height)];
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.font = [UIFont boldSystemFontOfSize:18];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.text = @"全部账单";
    }
    return _titleLabel;
}

- (UIImageView *)titleImg{
    if (!_titleImg) {
        _titleImg = [[UIImageView alloc] initWithFrame:CGRectMake(KmNavigationTitleLabelWidth + 2, (44-KmNavigationTiltelImgWidth)/2, KmNavigationTiltelImgWidth, KmNavigationTiltelImgWidth)];
        _titleImg.image = [UIImage imageNamed:@"triangle_down"];
        //_titleImg.backgroundColor = [UIColor whiteColor];
    }
    return _titleImg;
}

- (UIButton *)titleBtn{
    if (!_titleBtn) {
        _titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _titleBtn.backgroundColor = [UIColor clearColor];
        [_titleBtn addTarget:self action:@selector(titleButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _titleBtn;
}

- (void)titleButtonAction:(UIButton *)sender{
    // type
    if (_style == KMNavigationTitleViewStyleMonth) { // month 不能点击
        return;
    }
    
    if (_imgIsUp) { // 显示中...
        _imgIsUp = NO;
        _titleImg.image = [UIImage imageNamed:@"triangle_down"];
        if ([self.delegate respondsToSelector:@selector(KMNavigationTitleView:shouldHideContentView:typeId:)]) {
            [self.delegate KMNavigationTitleView:self shouldHideContentView:self.optionType typeId:self.typeId];
        }
        
    }else{
        _imgIsUp = YES;
        _titleImg.image = [UIImage imageNamed:@"triangle_up"];
        if ([self.delegate respondsToSelector:@selector(KMNavigationTitleView:shouldShowContentView:typeId:)]) {
            [self.delegate KMNavigationTitleView:self shouldShowContentView:self.optionType typeId:self.typeId];
        }
    }
}

- (void)setStyle:(KMNavigationTitleViewStyle)style{
    _style = style;
    if (_style == KMNavigationTitleViewStyleDay) { // 天，有img
        [UIView animateWithDuration:0.1 animations:^{
            // _titleLabel.frame = CGRectMake(0, 0, KmNavigationTitleLabelWidth, self.bounds.size.height);
            // _titleImg.frame = CGRectMake(KmNavigationTitleLabelWidth + 2, (44-KmNavigationTiltelImgWidth)/2, KmNavigationTiltelImgWidth, KmNavigationTiltelImgWidth);
            _titleImg.hidden = NO;
        } completion:^(BOOL finished) {
            //_titleLabel.textAlignment = NSTextAlignmentRight;
        }];
    }else if (_style == KMNavigationTitleViewStyleMonth){
        [UIView animateWithDuration:0.1 animations:^{
            // _titleLabel.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            _titleImg.hidden = YES;
        } completion:^(BOOL finished) {
            // _titleLabel.textAlignment = NSTextAlignmentCenter;
        }];
    }
}

- (void)setTitleString:(NSString *)titleString{
    _titleString = titleString;
    _titleLabel.text = _titleString;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
