//
//  Tools.m
//  USA
//
//  Created by 永来 付 on 14/11/24.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import "Tools.h"
#import "AppDelegate.h"

@implementation Tools


+ (CGRect)changeOrgByFrame:(CGRect)frame newX:(CGFloat)x newY:(CGFloat)y
{
    return CGRectMake(x, y, frame.size.width, frame.size.height);
}

+ (CGRect)frameMoveDown:(CGRect)frame downLong:(CGFloat)y
{
    return CGRectMake(frame.origin.x, frame.origin.y + y, frame.size.width, frame.size.height);
}

//显示不正确的信息
+ (void)alertViewShow:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
    
}



//计算文字高度
+ (CGSize)stringHeight:(NSString*)str fontSize:(CGFloat)foneSize width:(CGFloat)width
{
    
    if (!isCanUseString(str)) {
        return CGSizeZero;
    }
    CGSize contentSize =
    //    [str sizeWithFont:[UIFont systemFontOfSize:foneSize] constrainedToSize:CGSizeMake(width, MAXFLOAT)];
    [str boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                      options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:foneSize]}
                      context:nil].size;
    return contentSize;
}

//计算label的位置以及大小

+ (CGRect)labelForString:(UILabel*)label
{
    CGSize contentSize =
    [label.text boundingRectWithSize:CGSizeMake(FRAME_WIDTH(label), MAXFLOAT)
                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                          attributes:@{NSFontAttributeName : label.font}
                             context:nil].size;
       
    return CGRectMake(FRAME_X(label), FRAME_Y(label), FRAME_WIDTH(label), contentSize.height);
    
}

+ (NSString*)getCurrentTimeString
{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc]init];
    [dateformat setDateFormat:@"yyyyMMddHHmmss"];
    return [dateformat stringFromDate:[NSDate date]];
}

+ (NSString *)getCurrentTimeFormatString{
    NSDateFormatter *dateformat=[[NSDateFormatter  alloc] init];
    [dateformat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    return [dateformat stringFromDate:[NSDate date]];
}

+ (NSString*)getAddressStr:(NSDictionary*)addressInfo
{
    
    NSString *addressStr = [NSString stringWithFormat:@"%@%@%@%@",
                            [addressInfo objectForKey:@"city"],
                            [addressInfo objectForKey:@"county"],
                            [addressInfo objectForKey:@"addressbuilding"],
                            [addressInfo objectForKey:@"addressdetail"]
                            ];
    if (![[addressInfo objectForKey:@"addressbuilding"] isKindOfClass:[NSNull class]]) {
        addressStr = [NSString stringWithFormat:@"%@%@",addressStr,[addressInfo objectForKey:@"addressbuilding"]];
    }
    if (![[addressInfo objectForKey:@"addressdetail"] isKindOfClass:[NSNull class]]) {
        addressStr = [NSString stringWithFormat:@"%@%@",addressStr,[addressInfo objectForKey:@"addressdetail"]];
    }
    
    return addressStr;
}

/**
 生成文件路径
 @param _fileName 文件名
 @param _type 文件类型
 @returns 文件路径
 */
+ (NSString*)getPathByFileName:(NSString *)_fileName ofType:(NSString *)_type
{
    NSString* fileDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    fileDirectory = [[fileDirectory stringByAppendingPathComponent:_fileName]stringByAppendingPathExtension:_type];
    return fileDirectory;
}


+ (NSString*)getFrameCurrentTimeString
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *timeStr = [dateFormatter stringFromDate:[NSDate date]];
    
    return timeStr;
}

+(NSString *)subString :(NSString *)logoStr OriginStr:(NSString *)origin
{
    NSString *tempStr = logoStr;
    //查找://
    NSRange firstRange = [origin rangeOfString:tempStr];
    //从://的后面开始截取，结果放到str1中
    NSString *str1 = [origin substringFromIndex:firstRange.location + firstRange.length];
    return str1;
}

+ (NSString *)getHour:(NSInteger)hour originTime:(NSString *)originTime
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSDate *date2 = [formatter dateFromString:originTime];
    //在一个时间点往后推固定秒数
    NSDate *date3 = [NSDate dateWithTimeInterval:hour*60*60 sinceDate:date2];
    
    NSString *getHour = [formatter stringFromDate:date3];
    return getHour;
}

+ (NSString *)getHour:(NSString *)hour sinceTime:(CGFloat)time
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"HH:mm";
    NSDate *date2 = [formatter dateFromString:hour];
    //在一个时间点往后推固定秒数
    NSDate *date3 = [NSDate dateWithTimeInterval:time*60 sinceDate:date2];
    
    NSString *getHour = [formatter stringFromDate:date3];
    return getHour;

}

+ (NSInteger)getSecond:(NSNumber*)time
{
    if (!time) {
        return 0;
    }
    
    NSDate *date = [NSDate date];
    NSTimeInterval nowSecond = [date timeIntervalSince1970];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy-MM-dd hh:mm:ss";
    
    if ([time integerValue]/1000 > nowSecond) {
        return 0;
    }
    
    NSInteger offsetSecond = nowSecond - round(([time doubleValue]/1000.0));
    return offsetSecond < 0 ? 0 : offsetSecond;
}

+ (BOOL)stringIsContainString:(NSString*)str1 OtherString:(NSString*)str2
{
    NSRange range = [str1 rangeOfString:str2];
    if (range.location == NSNotFound) {
        return NO;
    }
    return YES;
}

//获取版本
+ (NSString*)getApplicationVersion
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *ver = [infoDic objectForKey:@"CFBundleShortVersionString"];
    return ver;
}

//获取应用名称
+ (NSString*)getApplicationName
{
    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *name = [infoDic objectForKey:@"CFBundleName"];
    return name;
}

+ (void)hiddenKeyboard
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}


// 显示提示框
+ (void) showHUD:(NSString*)text
{
    if ([text isEqualToString:@"该区县不存在"]) {
        return ;
    }
    
    AppDelegate *del = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:del.window];
    HUD.color = RGBACOLOR(29, 39, 39, 0.7);
    [del.window addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"检测更新表情.png"]];
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.labelText = text;
    
    [HUD show:YES];
    [HUD hide:YES afterDelay:1.5];
}

+ (MBProgressHUD*)showProgressWithTitle:(NSString*)title
{
    
    MBProgressHUD *progress = [[MBProgressHUD alloc] init];
    [[[UIApplication sharedApplication].delegate window] addSubview:progress];
    progress.removeFromSuperViewOnHide = YES;
    if (!isCanUseString(title)) {
        progress.labelText = @"";
    } else {
        progress.labelText = title;
    }
    
    [progress show:YES];
    
    return progress ;
    
}

+ (void)hiddenProgress:(MBProgressHUD*)progress
{
    [progress hide:YES];
}

+ (UIView*)createLine
{
    UIView *line = [[UIView alloc] init];
    line.frame = CGRectMake(0, 0, MainWidth, 0.5);
    line.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    return line;
}

+ (BOOL)currentLanguageIsChinese {
    
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    
    return [preferredLang isEqualToString:@"zh-Hant"] || [preferredLang isEqualToString:@"zh-Hans"];
    
}

+ (UIView*)findFirstResponderFromView:(UIView*)view {
    
    if (view.isFirstResponder) return view;
    for (UIView *subView in view.subviews) {
        UIView *firstResponder = [[self class] findFirstResponderFromView:subView];
        if (firstResponder != nil) return firstResponder;
    }
    
    return nil;
    
}

+ (NSString*)getStringValueFromDic:(NSDictionary*)dic withKey:(NSString*)key {
    if (isCanUseObj(dic) && [dic isKindOfClass:[NSDictionary class]]) {
        if (isCanUseObj(dic[key])) {
            return [NSString stringWithFormat:@"%@",dic[key]];
        }
    }
    return nil;
}

+ (CGFloat)getFloatValueFromDic:(NSDictionary*)dic withKey:(NSString*)key {
    if (isCanUseObj(dic) && [dic isKindOfClass:[NSDictionary class]]) {
        if (isCanUseObj(dic[key]) ) {
            return [dic[key] floatValue];
        }
    }
    return 0;
}

+ (double)getDoubleValueFromDic:(NSDictionary*)dic withKey:(NSString*)key {
    if (isCanUseObj(dic) && [dic isKindOfClass:[NSDictionary class]]) {
        if (isCanUseObj(dic[key]) ) {
            return [dic[key] doubleValue];
        }
    }
    return 0;
}

+ (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:
     ^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
         const unichar hs = [substring characterAtIndex:0];
         if (0xd800 <= hs && hs <= 0xdbff) {
             if (substring.length > 1) {
                 const unichar ls = [substring characterAtIndex:1];
                 const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                 if (0x1d000 <= uc && uc <= 0x1f77f) {
                     isEomji = YES;
                 }
             }
         } else if (substring.length > 1) {
             const unichar ls = [substring characterAtIndex:1];
             if (ls == 0x20e3) {
                 isEomji = YES;
             }
         } else {
             if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                 isEomji = YES;
             } else if (0x2B05 <= hs && hs <= 0x2b07) {
                 isEomji = YES;
             } else if (0x2934 <= hs && hs <= 0x2935) {
                 isEomji = YES;
             } else if (0x3297 <= hs && hs <= 0x3299) {
                 isEomji = YES;
             } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                 isEomji = YES;
             }
         }
     }];
    return isEomji;
}

@end

@implementation NSDictionary (Value)

- (NSString*)getStringWithKey:(NSString *)key {
    if (isCanUseObj([self objectForKey:key])) {
        return [NSString stringWithFormat:@"%@",[self objectForKey:key]];
    }
    return @"";
}

- (NSInteger)getIntegerWithKey:(NSString *)key {
    if (isCanUseObj([self objectForKey:key])) {
        return [[self objectForKey:key] integerValue];
    }
    return 0;
}

- (CGFloat)getFloatWithKey:(NSString *)key {
    if (isCanUseObj([self objectForKey:key])) {
        return [[self objectForKey:key] floatValue];
    }
    return 0;
}

- (double)getDoubleWithKey:(NSString *)key {
    if (isCanUseObj([self objectForKey:key])) {
        return [[self objectForKey:key] doubleValue];
    }
    return 0;
}

- (NSArray*)getArrayWithKey:(NSString *)key {
    if (isCanUseArray([self objectForKey:key])) {
        return [self objectForKey:key];
    }
    return nil;
}

- (NSDictionary*)getDictionaryWithKey:(NSString *)key {
    if (isCanUseObj([self objectForKey:key]) && [[self objectForKey:key] isKindOfClass:[NSDictionary class]]) {
        return [self objectForKey:key];
    }
    return nil;
}

@end

@implementation UIView(ResizeFrame)

- (void)changeFrameOriginX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)changeFrameOriginY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)changeFrameWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)changeFrameHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)changeViewCenterX:(CGFloat)x {
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (void)changeViewCenterY:(CGFloat)y {
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

@end


@implementation UIViewController (RemoveSelfPushOther)

- (void)pushWithRemoveSelf:(UIViewController *)viewController {
    NSMutableArray *vcs = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [vcs addObject:viewController];
    [vcs removeObject:self];
    [self.navigationController setViewControllers:vcs animated:YES];
}

@end

@implementation  UIImage(Extend)

// 无缓存读取图片
+ (UIImage *)noCacheImageNamed:(NSString *)name
{
    UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
    return image;
}

-(UIImage*)scaleToSize:(CGSize)size
{
    //等比例大小(缩的很丑)
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end


#pragma mark - UIImage+ResizableImage
@implementation UIImage (ResizableImageAndNoCashedImage)

-(UIImage*)resizedImageWithCapInsets:(UIEdgeInsets)capInsets{
    if(DEVICE_OS_VERSION >= 6){
        return [self resizableImageWithCapInsets:capInsets resizingMode:UIImageResizingModeStretch];
    } else {
        
        return [self resizableImageWithCapInsets:capInsets];
        //        return [self stretchableImageWithLeftCapWidth:capInsets.left topCapHeight:capInsets.top];
    }
}

+ (UIImage *)imageNamed:(NSString *)name isCashed:(BOOL)isCashed{
    UIImage *image = nil;
    
    if(!isCashed)
    {
        NSArray * nameArray = [name componentsSeparatedByString:@"."];
        if(nameArray && [nameArray count] > 1)
        {
            image = [UIImage imageWithContentsOfFile:
                     [[NSBundle mainBundle] pathForResource:[nameArray objectAtIndex:0 ] ofType:[nameArray lastObject]]];
        }
    } else
    {
        image = [UIImage imageNamed:name];
    }
    return image;
}

-(UIImage*)scaleToSize:(CGSize)size
{
    //等比例大小(缩的很丑)
    
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    float verticalRadio = size.height*1.0/height;
    float horizontalRadio = size.width*1.0/width;
    
    float radio = 1;
    if(verticalRadio>1 && horizontalRadio>1)
    {
        radio = verticalRadio > horizontalRadio ? horizontalRadio : verticalRadio;
    }
    else
    {
        radio = verticalRadio < horizontalRadio ? verticalRadio : horizontalRadio;
    }
    
    width = width*radio;
    height = height*radio;
    
    int xPos = (size.width - width)/2;
    int yPos = (size.height-height)/2;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(size);
    
    // 绘制改变大小的图片
    [self drawInRect:CGRectMake(xPos, yPos, width, height)];
    
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end


@implementation UIColor (Color16ToRgb)

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color alpha:(CGFloat)alpha
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor clearColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:alpha];
}

@end


@implementation UIButton (SetBackgroundImage)

- (void)setBackgroundSmallImageNor:(UIImage *)norImage smallImagePre:(UIImage *)preImage {
    
    norImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 7, 10, 10) resizingMode:UIImageResizingModeTile];
    preImage = [preImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 7, 10, 10) resizingMode:UIImageResizingModeTile];
    [self setBackgroundImage:norImage forState:UIControlStateNormal];
    [self setBackgroundImage:preImage forState:UIControlStateHighlighted];
}

- (void)setBackgroundSmallImageNor:(NSString *)norImageName smallImagePre:(NSString *)preImageName smallImageDis:(NSString*)disImageName {
    
    UIImage *norImage = [[UIImage imageNamed:norImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 7, 10, 10)  resizingMode:UIImageResizingModeTile];
    
    UIImage *preImage = [[UIImage imageNamed:preImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 7, 10, 10) resizingMode:UIImageResizingModeTile];
    
    UIImage *disImage = [[UIImage imageNamed:disImageName] resizableImageWithCapInsets:UIEdgeInsetsMake(10, 7, 10, 10) resizingMode:UIImageResizingModeTile];
    
    [self setBackgroundImage:norImage forState:UIControlStateNormal];
    [self setBackgroundImage:preImage forState:UIControlStateHighlighted];
    [self setBackgroundImage:disImage forState:UIControlStateDisabled];
}


- (void)setBackgroundImageNor:(UIImage *)norImage smallImagePre:(UIImage *)preImage {
    
    norImage = [norImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeTile];
    preImage = [preImage resizableImageWithCapInsets:UIEdgeInsetsMake(10, 10, 10, 10) resizingMode:UIImageResizingModeTile];
    [self setBackgroundImage:norImage forState:UIControlStateNormal];
    [self setBackgroundImage:preImage forState:UIControlStateHighlighted];
}

- (void)setImageNor:(UIImage *)norImage imagePre:(UIImage *)preImage {
    
    [self setImage:norImage forState:UIControlStateNormal];
    [self setImage:preImage forState:UIControlStateHighlighted];
}

- (void)setImageNor:(NSString *)norImageName imagePre:(NSString *)preImageName imageSelected:(NSString*)selectImageName {
    
    [self setImage:[UIImage imageNamed:norImageName] forState:UIControlStateNormal];
    [self setImage:[UIImage imageNamed:preImageName] forState:UIControlStateHighlighted];
    [self setImage:[UIImage imageNamed:selectImageName] forState:UIControlStateSelected];
}

@end


@implementation NSString (verifty)

- (BOOL)validateIDCardNumber {
    NSString *value = [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSInteger length = 0;
    if (!value) {
        return NO;
    }else {
        length = value.length;
        
        if (length !=15 && length !=18) {
            return NO;
        }
    }
    // 省份代码
    NSArray *areasArray =@[@"11",@"12", @"13",@"14", @"15",@"21", @"22",@"23", @"31",@"32", @"33",@"34", @"35",@"36", @"37",@"41", @"42",@"43", @"44",@"45", @"46",@"50", @"51",@"52", @"53",@"54", @"61",@"62", @"63",@"64", @"65",@"71", @"81",@"82", @"91"];
    
    NSString *valueStart2 = [value substringToIndex:2];
    BOOL areaFlag = NO;
    for (NSString *areaCode in areasArray) {
        if ([areaCode isEqualToString:valueStart2]) {
            areaFlag =YES;
            break;
        }
    }
    
    if (!areaFlag) {
        return false;
    }
    
    
    NSRegularExpression *regularExpression;
    NSUInteger numberofMatch;
    
    int year =0;
    switch (length) {
        case 15:
            return NO;
//            year = [value substringWithRange:NSMakeRange(6,2)].intValue +1900;
//            
//            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
//                
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}$"
//                                                                       options:NSRegularExpressionCaseInsensitive
//                                                                         error:nil];//测试出生日期的合法性
//            }else {
//                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}$"
//                                                                       options:NSRegularExpressionCaseInsensitive
//                                                                         error:nil];//测试出生日期的合法性
//            }
//            numberofMatch = [regularExpression numberOfMatchesInString:value
//                                                              options:NSMatchingReportProgress
//                                                                range:NSMakeRange(0, value.length)];
//            
//            
//            if(numberofMatch >0) {
//                return YES;
//            }else {
//                return NO;
//            }
        case 18:
            
            year = [value substringWithRange:NSMakeRange(6,4)].intValue;
            if (year %4 ==0 || (year %100 ==0 && year %4 ==0)) {
                
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|[1-2][0-9]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }else {
                regularExpression = [[NSRegularExpression alloc]initWithPattern:@"^[1-9][0-9]{5}19[0-9]{2}((01|03|05|07|08|10|12)(0[1-9]|[1-2][0-9]|3[0-1])|(04|06|09|11)(0[1-9]|[1-2][0-9]|30)|02(0[1-9]|1[0-9]|2[0-8]))[0-9]{3}[0-9Xx]$"
                                                                       options:NSRegularExpressionCaseInsensitive
                                                                         error:nil];//测试出生日期的合法性
            }
            numberofMatch = [regularExpression numberOfMatchesInString:value
                                                              options:NSMatchingReportProgress
                                                                range:NSMakeRange(0, value.length)];
            
            
            if(numberofMatch >0) {
                int S = ([value substringWithRange:NSMakeRange(0,1)].intValue + [value substringWithRange:NSMakeRange(10,1)].intValue) *7 + ([value substringWithRange:NSMakeRange(1,1)].intValue + [value substringWithRange:NSMakeRange(11,1)].intValue) *9 + ([value substringWithRange:NSMakeRange(2,1)].intValue + [value substringWithRange:NSMakeRange(12,1)].intValue) *10 + ([value substringWithRange:NSMakeRange(3,1)].intValue + [value substringWithRange:NSMakeRange(13,1)].intValue) *5 + ([value substringWithRange:NSMakeRange(4,1)].intValue + [value substringWithRange:NSMakeRange(14,1)].intValue) *8 + ([value substringWithRange:NSMakeRange(5,1)].intValue + [value substringWithRange:NSMakeRange(15,1)].intValue) *4 + ([value substringWithRange:NSMakeRange(6,1)].intValue + [value substringWithRange:NSMakeRange(16,1)].intValue) *2 + [value substringWithRange:NSMakeRange(7,1)].intValue *1 + [value substringWithRange:NSMakeRange(8,1)].intValue *6 + [value substringWithRange:NSMakeRange(9,1)].intValue *3;
                int Y = S %11;
                NSString *M =@"F";
                NSString *JYM =@"10X98765432";
                M = [JYM substringWithRange:NSMakeRange(Y,1)];// 判断校验位
                if ([M isEqualToString:[value substringWithRange:NSMakeRange(17,1)]]) {
                    return YES;// 检测ID的校验位
                }else {
                    return NO;
                }
                
            }else {
                return NO;
            }
        default:
            return false;
    }
}

@end
