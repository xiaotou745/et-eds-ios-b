//
//  KMMonthDateCalendarView.m
//  KMMonthDateCalendarView
//
//  Created by Maxwell on 15/10/6.
//  Copyright © 2015年 Maxwell. All rights reserved.
//

#import "KMMonthDateCalendarView.h"

#import "UIColor+KMhexColor.h"
#import "NSDate+KMdate.h"



static NSString* const KMCalendarHexColorDark = @"333333";
static NSString* const KMCalendarHexColorGray = @"666666";

static NSInteger const KMCalendarBigFontSize = 20;
static NSInteger const KMCalendarNormalFontSize = 14;


@interface KMMonthDateCalendarView ()<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIView * backgroundImageView;     // background img view

@property (nonatomic, strong) UIView * dateInfoSubViewContainer;

@property (nonatomic, strong) UILabel * dateTimeLabel;          // date label
@property (nonatomic, strong) UIButton * leftIndicatorImg;   // left swipe indicator
@property (nonatomic, strong) UIButton * rightIndicatorImg;  // right swipe indicator

@property (nonatomic, strong) UILabel * OrderOverviewLabel;     // order overview

// data,记录上一次date
@property (nonatomic, strong) NSDate * dateStyleLastDate;
@property (nonatomic, strong) NSDate * monthStyleLastDate;

@end

@implementation KMMonthDateCalendarView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.dateStyleLastDate = [NSDate new];
        self.monthStyleLastDate = [NSDate new];
        _style = EDSBillStatisticsVCStyleDay; // 默认是 天
        [self addSubview:self.backgroundImageView];
    }
    return self;
}


#pragma mark - property

- (UIView *)backgroundImageView{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        
        _backgroundImageView.userInteractionEnabled = YES;
        [_backgroundImageView addSubview:self.dateInfoSubViewContainer];
        [_backgroundImageView addSubview:self.leftIndicatorImg];
        [_backgroundImageView addSubview:self.rightIndicatorImg];
        
        // swipe gesture
        UISwipeGestureRecognizer *recognizerRight;
        recognizerRight.delegate=self;
        
        recognizerRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
        [recognizerRight setDirection:UISwipeGestureRecognizerDirectionRight];
        [_backgroundImageView addGestureRecognizer:recognizerRight];
        
        UISwipeGestureRecognizer *recognizerLeft;
        recognizerLeft.delegate=self;
        recognizerLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        [recognizerLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
        [_backgroundImageView addGestureRecognizer:recognizerLeft];
    }
    _backgroundImageView.backgroundColor = [UIColor whiteColor];
    return _backgroundImageView;
}

- (UIView *)dateInfoSubViewContainer{
    if (!_dateInfoSubViewContainer) {
        _dateInfoSubViewContainer = [[UIView alloc] initWithFrame:CGRectMake(KMDateTimeMargin, 0, self.bounds.size.width - 2*KMDateTimeMargin, self.bounds.size.height)];
        _dateInfoSubViewContainer.userInteractionEnabled = YES;
        _dateInfoSubViewContainer.backgroundColor = [UIColor whiteColor];
        
        [_dateInfoSubViewContainer addSubview:self.dateTimeLabel];
        [_dateInfoSubViewContainer addSubview:self.OrderOverviewLabel];
    }
    return _dateInfoSubViewContainer;
}


- (UILabel *)dateTimeLabel{
    if (!_dateTimeLabel) {
        _dateTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KMDateTimeTopPadding, self.bounds.size.width - 2*KMDateTimeMargin , KMDateTimeHeight)];
        _dateTimeLabel.backgroundColor = [UIColor clearColor];
        _dateTimeLabel.userInteractionEnabled = YES;
        _dateTimeLabel.textAlignment = NSTextAlignmentCenter;
        _dateTimeLabel.textColor = [UIColor km_colorWithHexString:KMCalendarHexColorDark];
        _dateTimeLabel.font = [UIFont boldSystemFontOfSize:KMCalendarBigFontSize];
        
        //
        if (_style == EDSBillStatisticsVCStyleDay) {
            _dateTimeLabel.text = [[NSDate date] dateToStringWithFormat:KMCalendarDatePrintFormat];
        }else if (_style == EDSBillStatisticsVCStyleMonth) {
            _dateTimeLabel.text = [[NSDate date] dateToStringWithFormat:KMCalendarMonthPrintFormat];
        }
    }
    return _dateTimeLabel;
}

- (UIButton *)leftIndicatorImg
{
    if (!_leftIndicatorImg) {
        _leftIndicatorImg = [[UIButton alloc] initWithFrame:CGRectMake(KMIndicatorMargin, (KMMonthDateCalenderViewHeight-KMIndicatorWidthHeight)/2, KMIndicatorWidthHeight, KMIndicatorWidthHeight)];
        _leftIndicatorImg.backgroundColor = [UIColor clearColor];
        //_leftIndicatorImg.userInteractionEnabled = YES;
        [_leftIndicatorImg setImage:[UIImage imageNamed:@"calendar_indicator_left_disable"] forState:UIControlStateDisabled];
        [_leftIndicatorImg setImage:[UIImage imageNamed:@"calendar_indicator_left_normal"] forState:UIControlStateNormal];
        [_leftIndicatorImg addTarget:self action:@selector(swipeRight:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _leftIndicatorImg;
}

- (UIButton *)rightIndicatorImg{
    if (!_rightIndicatorImg) {
        _rightIndicatorImg = [[UIButton alloc] initWithFrame:CGRectMake(self.bounds.size.width - KMIndicatorWidthHeight - KMIndicatorMargin, (KMMonthDateCalenderViewHeight-KMIndicatorWidthHeight)/2, KMIndicatorWidthHeight, KMIndicatorWidthHeight)];
        _rightIndicatorImg.backgroundColor = [UIColor clearColor];
        [_rightIndicatorImg setImage:[UIImage imageNamed:@"calendar_indicator_right_disable"] forState:UIControlStateDisabled];
        [_rightIndicatorImg setImage:[UIImage imageNamed:@"calendar_indicator_right_normal"] forState:UIControlStateNormal];
        [_rightIndicatorImg addTarget:self action:@selector(swipeLeft:) forControlEvents:UIControlEventTouchUpInside];
    }
    if (_style == EDSBillStatisticsVCStyleDay) {
        _rightIndicatorImg.enabled = ![self.dateStyleLastDate isToday];
    }else if (_style == EDSBillStatisticsVCStyleMonth){
        _rightIndicatorImg.enabled = ![self.monthStyleLastDate isTheCurrentMonth];
    }
    return _rightIndicatorImg;
}

- (UILabel *)OrderOverviewLabel{
    if (!_OrderOverviewLabel) {
        _OrderOverviewLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, KMDateTimeTopPadding + KMDateTimeHeight, self.bounds.size.width - 2*KMDateTimeMargin, KMOrderOverviewHeight)];
        _OrderOverviewLabel.userInteractionEnabled = YES;
        _OrderOverviewLabel.textAlignment = NSTextAlignmentCenter;
        _OrderOverviewLabel.textColor = [UIColor km_colorWithHexString:KMCalendarHexColorGray];
        _OrderOverviewLabel.font = [UIFont systemFontOfSize:KMCalendarNormalFontSize];
    }
    _OrderOverviewLabel.text = KMOrderOverviewTextDefault;
    return _OrderOverviewLabel;
}

- (void)setStyle:(EDSBillStatisticsVCStyle)style{
    _style = style;
}

/// 更改日月的样式
- (void)setMonthDayStyle:(EDSBillStatisticsVCStyle)style date:(NSDate *)aDate{
    _style = style;
    if (_dateTimeLabel) {
        if (_style == EDSBillStatisticsVCStyleDay) {
            self.dateStyleLastDate = aDate;
            _dateTimeLabel.text = [self.dateStyleLastDate dateToStringWithFormat:KMCalendarDatePrintFormat];
            _rightIndicatorImg.enabled = ![self.dateStyleLastDate isToday];
        }else if (_style == EDSBillStatisticsVCStyleMonth){
            self.monthStyleLastDate = aDate;
            _dateTimeLabel.text = [self.monthStyleLastDate dateToStringWithFormat:KMCalendarMonthPrintFormat];
            _rightIndicatorImg.enabled = ![self.monthStyleLastDate isTheCurrentMonth];
        }
    }
}

#pragma mark - gestures action

- (void)swipeRight:(UISwipeGestureRecognizer *)swipe{
    [self swipeAnimationRight:YES];
}

- (void)swipeLeft:(UISwipeGestureRecognizer *)swipe{
    [self swipeAnimationRight:NO];

}

- (void)swipeAnimationRight:(BOOL)swipeRight
{
    if (!swipeRight) {
        if (_style == EDSBillStatisticsVCStyleDay && [self.dateStyleLastDate isToday]) {
            return;
        }else if (_style == EDSBillStatisticsVCStyleMonth && [self.monthStyleLastDate isTheCurrentMonth]){
            return;
        }
    }else{
        if (_style == EDSBillStatisticsVCStyleDay && [self.dateStyleLastDate is20140101Day]) {
            return;
        }else if (_style == EDSBillStatisticsVCStyleMonth && [self.monthStyleLastDate is201401Month]){
            return;
        }
    }
    
    CATransition *animation = [CATransition animation];
    [animation setDelegate:self];
    [animation setType:kCATransitionPush];
    [animation setSubtype:(swipeRight)?kCATransitionFromLeft:kCATransitionFromRight];
    [animation setDuration:0.30];
    [animation setTimingFunction:
     [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [self.dateInfoSubViewContainer.layer addAnimation:animation forKey:kCATransition];
    
    // right/left  style()
    [self performSelector:@selector(renderSwipeData:) withObject:[NSNumber numberWithBool:swipeRight] afterDelay:0.05];
}

- (void)renderSwipeData:(NSNumber *)swipeData{
    BOOL swipeDirectionRight = [swipeData boolValue];
    NSString * resultDateString = nil;
    if (_style == EDSBillStatisticsVCStyleDay) {
        self.dateStyleLastDate = [self.dateStyleLastDate addDays:swipeDirectionRight?-1:1];
        resultDateString = [self.dateStyleLastDate dateToStringWithFormat:KMCalendarDatePrintFormat];
        _rightIndicatorImg.enabled = ![self.dateStyleLastDate isToday];
        _leftIndicatorImg.enabled = ![self.dateStyleLastDate is20140101Day];
    }else if (_style == EDSBillStatisticsVCStyleMonth){
        self.monthStyleLastDate = [self.monthStyleLastDate addMonths:swipeDirectionRight?-1:1];
        resultDateString = [self.monthStyleLastDate dateToStringWithFormat:KMCalendarMonthPrintFormat];
        _rightIndicatorImg.enabled = ![self.monthStyleLastDate isTheCurrentMonth];
        _leftIndicatorImg.enabled = ![self.monthStyleLastDate is201401Month];
    }
    _dateTimeLabel.text = resultDateString;
}

- (void)animationDidStart:(CAAnimation *)anim{
    // NSLog(@"%@",anim);
    if ([self.delegate respondsToSelector:@selector(calendarViewDidStartChangeDate:)]) {
        [self.delegate calendarViewDidStartChangeDate:self];
    }
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    
    if ([self.delegate respondsToSelector:@selector(calendarView:didStopChangeDate:dateString:)]) {
        if (_style == EDSBillStatisticsVCStyleDay) {
            [self.delegate calendarView:self didStopChangeDate:self.dateStyleLastDate dateString:[self.dateStyleLastDate dateToStringWithFormat:KMCalendarDatePrintFormat]];
        }else if (_style == EDSBillStatisticsVCStyleMonth){
            [self.delegate calendarView:self didStopChangeDate:self.monthStyleLastDate dateString:[self.monthStyleLastDate dateToStringWithFormat:KMCalendarMonthPrintFormat]];
        }
    }
}

/// 请求接口得到出账入账金额
- (void)setOutBillAmount:(double)outAmount inAmount:(double)inAmout{
    NSLog(@"%f,%f",outAmount,inAmout);
    _OrderOverviewLabel.text = [NSString stringWithFormat:@"出账 %.2f元  入账 %.2f元",outAmount,inAmout];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
 */

@end
