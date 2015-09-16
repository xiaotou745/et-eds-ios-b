//
//  ManFactory.h
//  MANFactory
//
//  Created by 满孝河 on 14-8-20.
//  Copyright (c) 2014年 manxiaohe. All rights reserved.
//
//使用此类，在工程pch文件里面加入该头文件，即可在工程内任意地方进行创建
//此类设计模式为最简单的工厂模式  
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ManFactory : NSObject
#pragma mark --创建Label
+(UILabel*)createLabelWithFrame:(CGRect)frame Font:(CGFloat)font Text:(NSString*)text;
#pragma mark --创建View
+(UIView*)viewWithFrame:(CGRect)frame;
#pragma mark --创建imageView
+(UIImageView*)createImageViewWithFrame:(CGRect)frame ImageName:(NSString*)imageName;
#pragma mark --创建button
+(UIButton*)createButtonWithFrame:(CGRect)frame ImageName:(NSString*)imageName Target:(id)target Action:(SEL)action Title:(NSString*)title;
#pragma mark --创建UITextField
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font;

//适配器的方法  扩展性方法
//现有方法，已经在工程里面存在，如果修改工程内所有方法，工作量巨大，就需要使用适配器的方法
+(UITextField*)createTextFieldWithFrame:(CGRect)frame placeholder:(NSString*)placeholder passWord:(BOOL)YESorNO leftImageView:(UIImageView*)imageView rightImageView:(UIImageView*)rightImageView Font:(float)font backgRoundImageName:(NSString*)imageName;
#pragma mark 创建UITextView
+(UITextView*)createTextViewWithFrame:(CGRect)frame font:(CGFloat)font text:(NSString *)text editable:(BOOL)YESorNO;
#pragma mark 创建UIWebView
+(UIWebView*)createWebViewWithFrame:(CGRect)frame htmlString:(NSString *)htmlString;
#pragma mark 创建UIScrollView
+(UIScrollView*)createScrollViewWithFrame:(CGRect)frame andSize:(CGSize)size;
#pragma mark 创建UIPageControl
+(UIPageControl*)createPageControlWithFrame:(CGRect)frame;
#pragma mark 创建UISlider
+(UISlider*)createSliderWithFrame:(CGRect)frame AndImage:(UIImage*)image;
#pragma mark 创建UIStepper
+(UIStepper*)createStepperWithFrame:(CGRect)frame maxValue:(double)max minValue:(double)min stepValue:(double)step Target:(id)target  Action:(SEL)action;
#pragma mark 创建UISegmentedControl
+(UISegmentedControl*)createSegmentWithFrame:(CGRect)frame itemsArray:(NSArray *)itemsArray Target:(id)target  Action:(SEL)action;
#pragma mark 创建时间转换字符串
+(NSString *)createStringFromDateWithHourAndMinute:(NSDate *)date;
#pragma mark --判断导航的高度64or44
+(float)isIOS7;
@end
