//
//  CommendDefine.h
//  USA
//
//  Created by 永来 付 on 14/11/24.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#ifndef USA_CommendDefine_h
#define USA_CommendDefine_h


#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width
#define StateBarHeight 20
#define MainHeight (ScreenHeight - StateBarHeight)
#define MainWidth ScreenWidth
#define isiPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define isiPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

//判断iPhone6+
#define iPhone6plus ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? (CGSizeEqualToSize(CGSizeMake(1125, 2001), [[UIScreen mainScreen] currentMode].size) || CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size)) : NO)

//判断iPad
#define IPAD ([[UIDevice currentDevice] respondsToSelector:@selector(userInterfaceIdiom)] && [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)


#define isSmallScreen (isiPhone5 || isiPhone4)

#define OffsetBarHeight  (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (20):(0))

#define IOSVERSION  [[[UIDevice currentDevice] systemVersion] floatValue]

#define RealMainHeight (([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)? (ScreenHeight):(MainHeight))


#define NavOffsetHeight (([[[UIDevice currentDevice] systemVersion] floatValue] >=7.0) ? 20 : 0)


#define SCREENSIZE  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [UIScreen mainScreen].currentMode.size : CGSizeZero)
#define IS_RETINA   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? [[UIScreen mainScreen] currentMode].size.width > 320 : NO)

////用于打印日志
#define __ISOPENNSLog__ 1

#if __ISOPENNSLog__
#define CLog(format, ...)   {\
fprintf(stderr, "<%s : %d> %s\n",                                           \
[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String],  \
__LINE__, __func__);                                                        \
(NSLog)((format), ##__VA_ARGS__);                                           \
fprintf(stderr, "-------\n");                                               \
}
#else
#define NSLog(...) {}
#endif

//打印Url
#define __IsPrintUrl__ 1

#if __IsPrintUrl__
#define UrlLog(format, ...) (NSLog)((format), ##__VA_ARGS__)
#else
#define UrlLog(...) {}
#endif

#pragma mark - Font

#define FONT_SIZE(f)            [UIFont systemFontOfSize:(f)]
#define FONT_BOLD_SIZE(f)       [UIFont boldSystemFontOfSize:(f)]
#define FONT_ITALIC_SIZE(f)     [UIFont italicSystemFontOfSize:(f)]

#define IsNullClass(obj)         [obj isKindOfClass:[NSNull class]]

#pragma mark - Color

#define RGBCOLOR(r,g,b)         [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define UICLEAR_COLOR           [UIColor clearColor]
#define LineColor                RGBCOLOR(226,226,226)
#define FRAME_HEADERVIEW_DEFAULT        CGRectMake(0, -70, 320, 70)

#pragma mark - Frame

#define FRAME(aView)            ((aView).frame)

#define FRAME_CENTER(aView)     ((aView).center)
#define FRAME_CENTER_X(aView)   ((aView).center.x)
#define FRAME_CENTER_Y(aView)   ((aView).center.y)

#define FRAME_ORIGIN(aView)     ((aView).frame.origin)
#define FRAME_X(aView)          ((aView).frame.origin.x)
#define FRAME_Y(aView)          ((aView).frame.origin.y)

#define FRAME_SIZE(aView)       ((aView).frame.size)
#define FRAME_HEIGHT(aView)     ((aView).frame.size.height)
#define FRAME_WIDTH(aView)      ((aView).frame.size.width)

// 判断字符串是否为空
#define STRINGHASVALUE(str)		(str && [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length > 0)
#define NUMBER(x)				[NSNumber numberWithInt:x]

// 判断系统版本是否大于4.0
#define IOSVersion_4			([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0 && [[[UIDevice currentDevice] systemVersion] floatValue] <= 5.0)
//获取系统版本
#define DEVICE_OS_VERSION       [[[UIDevice currentDevice] systemVersion] floatValue]

//字体
#define MaxFontSize (isSmallScreen ? 21.f : 25.f )
#define LagerFontSize (isSmallScreen ? 17.f : 19.f )
#define BigFontSize (isSmallScreen ? 15.f : 17.f )
#define NormalFontSize (isSmallScreen ? 13.f : 15.f )
#define SmallFontSize (isSmallScreen ? 11.f : 13.f )

//StoreCell高度
#define StoreCellHeight (isSmallScreen ? 95 : 120 )
#define StoreCellBorderWith (isSmallScreen ? 10 : 20 )


//颜色
#define BlueColor       [UIColor colorWithHexString:@"00bcd5"]
#define DeepGrey        [UIColor colorWithHexString:@"333333"]
#define MiddleGrey      [UIColor colorWithHexString:@"9daabc"]
#define LightGrey       [UIColor colorWithHexString:@"a6a6a6"]

#define GreenDefault    [UIColor colorWithHexString:@"2fc648"]
#define RedDefault      [UIColor colorWithHexString:@"f7585d"]
#define BuleColor       [UIColor colorWithHexString:@"2e8ee7"]

#define Pink            [UIColor colorWithHexString:@"ff2e75"]
#define MainRedColor    [UIColor colorWithHexString:@"c83838"]

#define TextColor6       [UIColor colorWithHexString:@"666666"]  //e8e8e8
#define BackgroundColor  [UIColor colorWithHexString:@"e8e8e8"]
//
#define SeparatorLineColor [UIColor colorWithHexString:@"dfdfdf"]

// 1f2226
#define BlackColor  [UIColor colorWithHexString:@"1f2226"]

//
#define BBC0C7Color [UIColor colorWithHexString:@"bbc0c7"]

#define isCanUseString(str) ( (str != nil) && ![str isKindOfClass:[NSNull class]] && [str isKindOfClass:[NSString class]] && [str length] > 0 )
#define isCanUseObj(str) ( str && (str != nil) && ![str isKindOfClass:[NSNull class]] )
#define isCanUseArray(arr) ( arr && (arr != nil) && ![arr isKindOfClass:[NSNull class]] )

#define APPDLE (AppDelegate*)[[UIApplication sharedApplication] delegate]

#pragma mark color
#define RGBCOLOR(r,g,b)         [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a)      [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define JLMBGColor RGBCOLOR(242,242,242)

//-----------------------------------间距-------------LMJ add-------------------------------
#define Space_Large   20.f
#define Space_Big     15.f
#define Space_Normal  10.f
#define Space_Small    5.f

#define VIEW_ORIGIN(aView)       ((aView).frame.origin)
#define VIEW_X(aView)            ((aView).frame.origin.x)
#define VIEW_Y(aView)            ((aView).frame.origin.y)

#define VIEW_SIZE(aView)         ((aView).frame.size)
#define VIEW_HEIGHT(aView)       ((aView).frame.size.height)
#define VIEW_WIDTH(aView)        ((aView).frame.size.width)


#define VIEW_X_Right(aView)      ((aView).frame.origin.x + (aView).frame.size.width)
#define VIEW_Y_Bottom(aView)     ((aView).frame.origin.y + (aView).frame.size.height)


//------------------------------------Center相关---------------------------------------------
#define VIEW_CENTER(aView)       ((aView).center)
#define VIEW_CENTER_X(aView)     ((aView).center.x)
#define VIEW_CENTER_Y(aView)     ((aView).center.y)

/*
 Notification
 */

//购物车商品发生变化通知

#define ShoppingCartChangeNotification @"ShoppingCartChangeNotification"

//注册发出通知
#define SelectAddressNotification @"SelectAddressNotification"

//登陆状态变化
#define LoginNotification @"LoginNotification"
#define LogoutNotifaction @"LogoutNotifaction"

//订单状态发生变化
#define OrderStatusChangeNotification @"OrderStatusChangeNotification"
//用户上传头像
#define UserUploadHeaderimageNotification @"UserUploadHeaderimageNotification"

//用户编辑地址发生变化
#define UserInfoEditAddressNotification @"UserInfoEditAddressNotification"

#define RefundChangeStatusNotification @"RefundChangeStatusNotification"

//支付宝支付成功通知
#define AliPaySuccessNotification @"AliPaySuccessNotification"

// 微信支付成功通知
#define WechatPaySuccessNotification @"WechatPaySuccessNotification"

//发布订单成功
#define ReleseOrderNotification @"ReleseOrderNotification"

//取消本地订单
#define CancelOrderNotification @"CancelOrderNotification"

//发布订单时 显示隐藏删除按钮
#define ShowDeleteIconNotification @"ShowDeleteIconNotification"
#define HiddenDeleteIconNotification @"HiddenDeleteIconNotification"

//用户状态改变 进入审核
#define UserStatusChangeToReviewNotification @"UserStatusChangeToReviewNotification"

// 修改密码，成功之后的通知
#define UserModifiedPasswordNotification @"UserModifiedPasswordNotification"

//获取验证码倒计时时间
#define CodeWaitTime 120

#define APIVersion @"1.0"

// static NSString * const AFAppJavaAPIBaseURLString = @"http://10.8.7.42:8094/api-http/services/";// 新版java接口

/*闪送相关的通知*/
#define ShanSongAddressAdditionFinishedNotify @"ShanSongAddressAdditionFinishedNotify" // 补充地址完成
#define ShanSongAddressHistorySelectedNotify @"ShanSongAddressHistorySelectedNotify" // 选择历史地址

// 闪送地图
#define ShanSongAddressMapPOISectedNotify @"ShanSongAddressMapPOISectedNotify" // 地图选择地址

#if 0

    #define OPEN_API_SEVER @"http://api.edaisong.com/20151223/" //生产
    #define UPLOAD_IMAGE_API_SERVER @"http://upload.edaisong.com/20151223/" //上传图片地址
    #define UPDATE_APP_API_SERVER @"http://api.edaisong.com/" // 升级接口

    #define Java_API_SERVER @"http://japi.edaisong.com/20151223/services/" // java服务器-加密

#elif 0
    #define OPEN_API_SEVER @"http://10.8.10.130:8081/"   //曹赫洋
#elif 0
    #define OPEN_API_SEVER @"http://edsapi.yitaoyun.net/"       //线上
    #define UPLOAD_IMAGE_API_SERVER @"" //上传图片地址
#elif 1
    #define OPEN_API_SEVER @"http://10.8.7.251:7178/"   //本地服务器 251
    #define UPLOAD_IMAGE_API_SERVER @"" //上传图片地址
    #define UPDATE_APP_API_SERVER  @""// 升级接口

    #if 0
        #define Java_API_SERVER @"http://10.8.7.42:8094/api-http/services/" // java服务器-不加密
    #elif 1
        #define Java_API_SERVER @"http://10.8.7.253:7178/api-http/services/" // java服务器-加密
    #endif


#elif 0
    #define  OPEN_API_SEVER @"http://10.8.7.40:7178/"   //本地服务器 40
    #define UPLOAD_IMAGE_API_SERVER @"" //上传图片地址
    #define UPDATE_APP_API_SERVER  @""// 升级接口

#elif 0
    #define  OPEN_API_SEVER @"http://10.8.7.44:7178/"   //本地服务器 窦海超
    #define UPLOAD_IMAGE_API_SERVER @"" //上传图片地址
    #define UPDATE_APP_API_SERVER  @""// 升级接口

    #define Java_API_SERVER @"http://10.8.7.42:8094/api-http/services/" // java服务器-不加密

#elif 0
    #define  OPEN_API_SEVER @"http://10.8.8.105:8069/api/ios/" //边亮
#elif 0
    #define  OPEN_API_SEVER @"http://10.8.8.187:8131/api/ios/"  //俊杰
#endif

//
#if 1    // 闪送
    #define BaiduLbsKey @"gKvODXZFWkDSYDrHvPIgRxKX"
    #define JpushKey @""
#endif

/// Java版新接口，是否加密
#if 1
    #define AES_Security YES   // 加密
#elif 1
    #define AES_Security NO    // 不加密
#endif





#endif

