//
//  Tools.h
//  USA
//
//  Created by 永来 付 on 14/11/24.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBProgressHUD.h"

@interface Tools : NSObject

+ (CGRect)changeOrgByFrame:(CGRect)frame newX:(CGFloat)x newY:(CGFloat)y;

+ (CGRect)frameMoveDown:(CGRect)frame downLong:(CGFloat)y;

+ (void)alertViewShow:(NSString *)message;

//计算文字高度
+ (CGSize)stringHeight:(NSString*)str fontSize:(CGFloat)foneSize width:(CGFloat)width;

//计算label的位置以及大小
+ (CGRect)labelForString:(UILabel*)label;

//获取当前时间字符串
+ (NSString*)getCurrentTimeString;

//获取当前时间
+ (NSString*)getFrameCurrentTimeString;


+ (NSString *)getHour:(NSString *)hour sinceTime:(CGFloat)time;


//截取字符串

+(NSString *)subString :(NSString *)logoStr OriginStr:(NSString *)origin;

// 获取阶段性时间
+ (NSString *)getHour:(NSInteger)hour originTime:(NSString *)originTime;
/**
 生成文件路径
 @param _fileName 文件名
 @param _type 文件类型
 @returns 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type;

//获取城市字符串
+ (NSString*)getAddressStr:(NSDictionary*)addressInfo;

//
+ (NSInteger)getSecond:(NSNumber*)time;

//获取版本
+ (NSString*)getApplicationVersion;

//收起键盘
+ (void)hiddenKeyboard;

+ (BOOL)stringIsContainString:(NSString*)str1 OtherString:(NSString*)str2;

// 显示提示框
+ (void) showHUD:(NSString*)text;

+ (MBProgressHUD*)showProgressWithTitle:(NSString*)title;
+ (void)hiddenProgress:(MBProgressHUD*)progress;

//返回分割线
+ (UIView*)createLine;

//检测当前语言版本是否为汉语
+ (BOOL)currentLanguageIsChinese;

//寻找view中获取焦点的view
+ (UIView*)findFirstResponderFromView:(UIView*)view;

//从dic中获取字符串
+ (NSString*)getStringValueFromDic:(NSDictionary*)dic withKey:(NSString*)key;
+ (CGFloat)getFloatValueFromDic:(NSDictionary*)dic withKey:(NSString*)key;
+ (double)getDoubleValueFromDic:(NSDictionary*)dic withKey:(NSString*)key;

+ (BOOL)isContainsEmoji:(NSString *)string;

@end

@interface NSDictionary (Value)

- (NSString*)getStringWithKey:(NSString*)key;
- (NSInteger)getIntegerWithKey:(NSString*)key;
- (CGFloat)getFloatWithKey:(NSString*)key;
- (double)getDoubleWithKey:(NSString*)key;
- (NSArray*)getArrayWithKey:(NSString*)key;
- (NSDictionary*)getDictionaryWithKey:(NSString*)key;

@end

@interface UIView(ResizeFrame)

- (void)changeFrameOriginX:(CGFloat)x;
- (void)changeFrameOriginY:(CGFloat)y;
- (void)changeFrameWidth:(CGFloat)width;
- (void)changeFrameHeight:(CGFloat)height;
- (void)changeViewCenterX:(CGFloat)x;
- (void)changeViewCenterY:(CGFloat)y;

@end

@interface UIViewController (RemoveSelfPushOther)

- (void)pushWithRemoveSelf:(UIViewController*)viewController;

@end

@interface  UIImage(Extend)

// 无缓存读取图片
+ (UIImage *)noCacheImageNamed:(NSString *)name;


@end

@interface UIColor (Color16ToRgb)
+ (UIColor *) colorWithHexString: (NSString *)color;
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha;

@end



#pragma mark - UIImage+ResizableImage
@interface UIImage (ResizableImageAndNoCashedImage)

-(UIImage*)resizedImageWithCapInsets:(UIEdgeInsets)capInsets;

+ (UIImage *)imageNamed:(NSString *)name isCashed:(BOOL)isCashed;

-(UIImage*)scaleToSize:(CGSize)size;

@end

@interface UIButton (SetBackgroundImage)

- (void)setBackgroundSmallImageNor:(UIImage*)norImage smallImagePre:(UIImage*)preImage;

- (void)setBackgroundSmallImageNor:(NSString *)norImageName smallImagePre:(NSString *)preImageName smallImageDis:(NSString*)disImageName;

- (void)setBackgroundImageNor:(UIImage *)norImage smallImagePre:(UIImage *)preImage  ;

- (void)setImageNor:(UIImage *)norImage imagePre:(UIImage *)preImage;
- (void)setImageNor:(NSString *)norImageName imagePre:(NSString *)preImageName imageSelected:(NSString*)selectImageName;

@end

@interface NSString (verifty)

- (BOOL)validateIDCardNumber;

@end
