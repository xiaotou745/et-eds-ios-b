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
#import "TakeOrderListViewController.h"
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


#import "NSString+X136.h"

@interface AppDelegate ()
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
    // token
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"net status: %ld",(long)status);
    }];
    
    [self refreshToken];
    [self scheduledTimerRefreshToken];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:NO];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginNotifyAction:) name:LoginNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(setPushTag) name:LogoutNotifaction object:nil];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    
    _mapManager = [[BMKMapManager alloc]init]; 
    BOOL ret = [_mapManager start:@"GX7M71BZnCnhLntRAFXg34fn"  generalDelegate:nil];
    if (!ret) {
        CLog(@"flai");
    }
    
    TakeOrderListViewController * takeOrderVC = [[TakeOrderListViewController alloc] init];
    _rootNav = [[UINavigationController alloc] initWithRootViewController:takeOrderVC];
    _rootNav.navigationBarHidden = YES;
    self.window.rootViewController = _rootNav;
    
    [self showWelcomeLoginAnimated:NO];
    [self setupJpush:launchOptions];
    [self setPushTag];
    
    [MobClick setLogEnabled:YES];
    [MobClick startWithAppkey:@"55962f3267e58ef3fc001ad7" reportPolicy:REALTIME channelId:@"appstore"];
    
    // 检测更新接口
    [self checkNewVersion];
    
    //处理推送
    if ([launchOptions objectForKey:@"UIApplicationLaunchOptionsRemoteNotificationKey"]) {
        NSDictionary *data = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
        [self pushNotificationView:data];
    }

    [self updateCityList];

    /*
     以下接口需要token,为保证请求有效，在第一次获取token成功之后请求
     */
//    [self updateBankCityList];
////    // 同步发单用户电话号码
//    [self consigneeAddressB];
    

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

- (void)appUpdate:(NSDictionary *)appInfo {
    // NSLog(@"%@",appInfo);
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
    
    // NSLog(@"%@",data);
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

- (void)checkNewVersion {
    
    //        PlatForm=1:Android 2 :IOS 默认Android
    //        UserType= 1 骑士 2 商家 默认1骑士
    NSDictionary *requestData = @{@"PlatForm" : @(2),
                                  @"UserType" : @(2)};
    
    [FHQNetWorkingAPI update:requestData successBlock:^(id result, AFHTTPRequestOperation *operation) {
        
        //判断版本升级
        NSString * build = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSComparisonResult results = [build compare:[result objectForKey:@"Version"]];
        if (results == NSOrderedAscending) {
            _downloadUrl = [result objectForKey:@"UpdateUrl"];
            UIAlertView *updateAlertView = nil;
            if ([[result objectForKey:@"IsMust"] integerValue] == 1) {
                updateAlertView = [[UIAlertView alloc] initWithTitle:@"版本升级" message:[result objectForKey:@"Message"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"立刻升级", nil];
                updateAlertView.tag = 10000;
            } else {
                
                updateAlertView = [[UIAlertView alloc] initWithTitle:@"版本升级" message:[result objectForKey:@"Message"] delegate:self cancelButtonTitle:@"以后提醒我" otherButtonTitles:@"立刻升级", nil];
                updateAlertView.tag = 10001;
            }
            [updateAlertView show];
        }
    } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
        
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            if (alertView.tag == 10000) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadUrl]];
                NSLog(@"强制升级");
                exit(0);
            } else {
                NSLog(@"取消");
            }
            break;
        case 1:
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:_downloadUrl]];
            NSLog(@"选择升级");
            break;
        default:
            break;
    }
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    // token
    //[self refreshToken];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
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
    
    //跳转支付宝钱包进行支付，处理支付结果
    [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
        NSLog(@"result = %@",resultDic);
        if ([resultDic getIntegerWithKey:@"resultStatus"] == 9000) {
            [[NSNotificationCenter defaultCenter] postNotificationName:AliPaySuccessNotification object:nil];
        } else {
            [Tools showHUD:@"支付失败"];
        }
    }];
    
    return YES;
}

#pragma mark - getToken

- (void)scheduledTimerRefreshToken{
    [_tokenTimer invalidate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _tokenTimer = [NSTimer scheduledTimerWithTimeInterval:90*60 target:self selector:@selector(refreshToken) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    });
}

- (void)refreshToken{
    if ([UserInfo isLogin]) {
        NSDictionary * paraDict = @{
                                    @"ssid":[UserInfo getUUID],
                                    @"appkey":[UserInfo getAppkey]
                                    };
        [FHQNetWorkingAPI getToken:paraDict successBlock:^(id result, AFHTTPRequestOperation *operation) {
            NSString * token = [NSString stringWithFormat:@"%@",result];
            [UserInfo saveToken:token];
            
            NSString * localtoken = [UserInfo getToken];
            NSLog(@"local:%@",localtoken);
            
            _getTokenSuccessCount ++;
            if (1 == _getTokenSuccessCount) { // 第一次通过接口获得token
                // 更新银行列表，需要token
                [self updateBankCityList];
                // 同步发单用户电话号码，需要token
                [self consigneeAddressB];
            }

            
        } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
            _getTokenCount ++;
            if (_getTokenCount < 5) {
                [self refreshToken];
            }
        }];
    }

}

#pragma mark - 电话联想,24小时同步商户发单历史到本地

- (void)consigneeAddressB{
    if ([UserInfo isLogin]) {
        
        NSString * firstTime = @"2015-01-01 00:00:00";
        if ([UserInfo getMaxDate]) {
            firstTime = [UserInfo getMaxDate];
        }
        
        NSDictionary * paraDict = @{
                                    @"BusinessId":[UserInfo getUserId],
                                    @"PubDate":firstTime,
                                    @"Version":APIVersion
                                    };
        //NSLog(@"para:%@",paraDict);
        
        [FHQNetWorkingAPI consigneeAddress:paraDict successBlock:^(id result, AFHTTPRequestOperation *operation) {
            NSString * MaxDate = result[@"MaxDate"];
            NSArray * ConsigneeAdressBDM = result[@"Data"];
            if (MaxDate) {
                [UserInfo saveMaxDate:MaxDate];
            }
            if (ConsigneeAdressBDM.count > 0) {
                NSLog(@"arr:%@",ConsigneeAdressBDM);
                // 村本地
                [self storeConsignees:ConsigneeAdressBDM];
            }else{
                //NSLog(@"array:0");
            }
        } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
            
        }];
    }
}

- (void)storeConsignees:(NSArray *)ConsigneeAdressBDM{
    /*
     Id	数据库id
     PhoneNo	电话号码
     Address	地址
     PubDate	订单发布时间
     */
    NSString * bid = [UserInfo getUserId];
    
    for (NSDictionary * adict in ConsigneeAdressBDM) {
        
        NSMutableArray * localConsignees = [NSMutableArray arrayWithArray:[DataArchive storedConsigneesWithShopid:bid]];
        ConsigneeModel * consignee = [[ConsigneeModel alloc] init];
        consignee.consigneePhone = adict[@"PhoneNo"];
        consignee.consigneeAddress = adict[@"Address"];
        consignee.consigneePubDate = adict[@"PubDate"];
        consignee.consigneeUserName = adict[@"UserName"];
        consignee.consigneeId = [NSString stringWithFormat:@"%@",adict[@"Id"]];
        
        if (localConsignees.count > 0) {
            
            //        for (ConsigneeModel * aConsignee in localConsignees) {
            //            if ([aConsignee samePhoneWithConsignee:consignee]) {
            //                localConsignees repla
            //            }
            //        }
            BOOL contain = NO;
            for (int i = 0; i < localConsignees.count; i ++) {
                ConsigneeModel * aConsignee = [localConsignees objectAtIndex:i];
                if ([consignee samePhoneWithConsignee:aConsignee]) {
                    [localConsignees replaceObjectAtIndex:i withObject:consignee];
                    contain = YES;
                    break;
                }
                
            }
            
            if (!contain) {
                [localConsignees addObject:consignee];
            }
            
            [DataArchive storeConsignees:localConsignees shopId:bid];
            
        }else{
            [DataArchive storeConsignees:[NSArray arrayWithObjects:consignee, nil] shopId:bid];
        }
    }
}

- (void)scheduledTimerConsigneeAddressB{
    [_consigneeAddressBTimer invalidate];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _consigneeAddressBTimer = [NSTimer scheduledTimerWithTimeInterval:24*60*60 target:self selector:@selector(consigneeAddressB) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];
    });
}


#pragma mark - 登录之后的通知
- (void)loginNotifyAction:(NSNotification *)notify{
    [self setPushTag];
    [self consigneeAddressB];
}


@end
