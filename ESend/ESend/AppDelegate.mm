//
//  AppDelegate.m
//  ESend
//
//  Created by 永来 付 on 15/5/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "AppDelegate.h"
#import "UserInfo.h"
#import <AlipaySDK/AlipaySDK.h>
#import "APService.h"
#import "MessageDetailViewController.h"
#import "MessageModel.h"
#import "SSHomepageViewController.h"
#import "RegisterViewController.h"
#import "WelcomeViewController.h"
#import "MobClick.h"
#import "FHQNetWorkingAPI.h"
#import "LoginViewController.h"

#import "DataBase.h"
#import "AddressPickerView.h"
#import "Tools.h"
#import "ConsigneeModel.h"
#import "DataArchive.h"

// 微信支付
#import "WechatPay.h"

#import "NSString+X136.h"

@interface AppDelegate ()<WXApiDelegate>
{
    BMKMapManager* _mapManager;
    UINavigationController *_rootNav;
    NSString *_downloadUrl;
    
    UINavigationController *_welcomeNav;
    
    NSTimer * _tokenTimer;                      // refresh token timer
    int _getTokenCount;                         // refresh token wrong times
    int _getTokenSuccessCount;                  // refresh token success times, default = 0, when == 1, some request start
    
    NSTimer * _consigneeAddressBTimer;          // 24小时刷新，刷单地址，用户手机列表
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    //
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
    }];
    
    // 更新银行列表，需要token
    [self updateBankCityList];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotifyAction:) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPushTag) name:LogoutNotifaction object:nil];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    _mapManager = [[BMKMapManager alloc]init]; 
    BOOL ret = [_mapManager start:BaiduLbsKey  generalDelegate:nil];
    if (!ret) {
        CLog(@"map start fail");
    }
    
    SSHomepageViewController * takeOrderVC = [[SSHomepageViewController alloc] initWithNibName:NSStringFromClass([SSHomepageViewController class]) bundle:nil];
    _rootNav = [[UINavigationController alloc] initWithRootViewController:takeOrderVC];
    _rootNav.navigationBarHidden = YES;
    self.window.rootViewController = _rootNav;
    
    // [self showWelcomeLoginAnimated:NO];
    [self setupJpush:launchOptions];
    [self setPushTag];
    
//    [MobClick setLogEnabled:YES];
//    [MobClick startWithAppkey:@"55962f3267e58ef3fc001ad7" reportPolicy:REALTIME channelId:@"appstore"];
    //处理推送
    if ([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]) {
        NSDictionary *data = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self pushNotificationView:data];
    }

    [self updateCityList];
    //向微信注册
    [WXApi registerApp:APP_ID withDescription:@"EDS_B_SS"];
    
    
    return YES;
}

- (void)updateCityList {
    if (![UserInfo isLogin]) {
        return;
    }
    
    NSString *dataVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"Bussiness_Address_Id"];
    
    NSDictionary *requestData = @{@"version" : isCanUseString(dataVersion) ? dataVersion : @"20150525",
                                  @"UserId" : [UserInfo getUserId]};
    
    [FHQNetWorkingAPI getCityList:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",result);
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        NSLog(@"%@",operation.responseObject);
        NSDictionary *result = operation.responseObject;
        if ([result getIntegerWithKey:@"Status"] == 0) {
            if ([[[result getDictionaryWithKey:@"Result"] getArrayWithKey:@"AreaModels"] count] == 0) {
                return ;
            }
            NSArray *addressList = [[result getDictionaryWithKey:@"Result"] getArrayWithKey:@"AreaModels"];
            [[DataBase shareDataBase] updateCityListData:addressList];
            // NSLog(@"4434445  %@",[[[result getDictionaryWithKey:@"Result"] getStringWithKey:@"Version"] getStringWithKey:@"Bussiness_Address_Id"]);
            [[NSUserDefaults standardUserDefaults] setObject:[[result getDictionaryWithKey:@"Result"] getStringWithKey:@"Version"] forKey:@"Bussiness_Address_Id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    } isShowError:NO];
}

- (void)updateBankCityList {
    
    NSString *dataVersion = [[NSUserDefaults standardUserDefaults] stringForKey:@"Bank_Address_Id"];
    NSDictionary *requestData = @{@"version" : APIVersion,
                                  @"dataversion" : isCanUseString(dataVersion) ? dataVersion : @"20150723"};
    [FHQNetWorkingAPI getBankCityList:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        if ([[result getArrayWithKey:@"AreaModels"] count] == 0) {
            return ;
        }
        [[DataBase shareDataBase] updateBankCityData:[result getArrayWithKey:@"AreaModels"]];
        [[NSUserDefaults standardUserDefaults] setObject:[result getStringWithKey:@"Version"] forKey:@"Bank_Address_Id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    } isShowError:NO];
}

- (void)pushNotificationView:(NSDictionary*)data {
    if ([UserInfo isLogin]) {
        NSString *sound = [[data getDictionaryWithKey:@"aps"]  getStringWithKey:@"sound"];
        NSArray *info = [sound componentsSeparatedByString:@":"];
        if ([info count] != 2) {
            return;
        }
        if ([info[0] isEqualToString:@"Notice"]) {
            MessageModel *message = [[MessageModel alloc] init];
            message.messageId = info[1];
            MessageDetailViewController *vc = [[MessageDetailViewController alloc] init];
            vc.message = message;
            [_rootNav pushViewController:vc animated:YES];
        }
    }
}

- (void)setPushTag {
    NSString *tag = nil ;
    if ([UserInfo isLogin]) {
        tag = [NSString stringWithFormat:@"B_%@",[UserInfo getUserId]];
    }
    if (tag) {
        [APService setTags:[NSSet setWithArray:@[tag, [UserInfo getUserId]]] alias:tag callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    } else {
        [APService setTags:[NSSet set] alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }

}

-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (void)setupJpush:(NSDictionary*)launchOptions {
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    } else {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    // Required
    [APService setupWithOption:launchOptions];
}

- (void)showLoginAnimated:(BOOL)animated {
    if (![UserInfo isLogin]) {
        LoginViewController * loginVC = [[LoginViewController alloc] init];
        UINavigationController *loginNav = [[UINavigationController alloc] initWithRootViewController:loginVC];
        loginNav.navigationBarHidden     = YES;
        [self.window.rootViewController presentViewController:loginNav animated:animated completion:^{
        }];
    }
}

- (void)showWelcomeLoginAnimated:(BOOL)animated {
    if (![UserInfo isLogin]) {
        if (!_welcomeNav) {
            WelcomeViewController * welcomeVC = [[WelcomeViewController alloc] init];
            _welcomeNav = [[UINavigationController alloc] initWithRootViewController:welcomeVC];
            _welcomeNav.navigationBarHidden     = YES;
        }
        [self.window.rootViewController presentViewController:_welcomeNav animated:animated completion:^{
        }];
    }
}

- (void)showRegister {
    RegisterViewController *vc = [[RegisterViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    nav.navigationBarHidden = YES;
    [self.window.rootViewController presentViewController:nav animated:NO completion:^{
        
    }];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [APService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
    if (application.applicationState == UIApplicationStateInactive) {
        [self pushNotificationView:userInfo];
    } else {
        NSLog(@"我收到了");
    }

}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // IOS 7 Support Required
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    if (application.applicationState == UIApplicationStateInactive) {
        [self pushNotificationView:userInfo];
    } else {
        NSLog(@"我收到了");
    }

}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    
    if ([url.host isEqualToString:@"safepay"]) {
        //Esendaipay://safepay/?%7B%22memo%22:%7B%22result%22:%22%22,%22ResultStatus%22:%226001%22,%22memo%22:%22%E7%94%A8%E6%88%B7%E4%B8%AD%E9%80%94%E5%8F%96%E6%B6%88%22%7D,%22requestType%22:%22safepay%22%7D
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            if ([resultDic getIntegerWithKey:@"resultStatus"] == 9000) {
                [[NSNotificationCenter defaultCenter] postNotificationName:AliPaySuccessNotification object:nil];
            } else {
                [Tools showHUD:@"支付失败"];
            }
        }];
    }
    if ([url.host isEqualToString:@"pay"]) {
         return  [WXApi handleOpenURL:url delegate:self];

    }
    
    return YES;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return  [WXApi handleOpenURL:url delegate:self];
}



#pragma mark - 登录之后的通知
- (void)loginNotifyAction:(NSNotification *)notify{
    [self setPushTag];
    [self updateCityList];
}



#pragma mark - 微信代理
/// 微信代理
-(void) onResp:(BaseResp*)resp{
    //NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
    NSString *strTitle;
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        strTitle = [NSString stringWithFormat:@"支付结果"];
        if (WXSuccess == resp.errCode) {
            [[NSNotificationCenter defaultCenter] postNotificationName:WechatPaySuccessNotification object:nil];
        } else {
            [Tools showHUD:@"支付失败"];
        }
    }
}



@end
