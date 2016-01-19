//
//  SSHomepageViewController.m
//  ESend
//
//  Created by 台源洪 on 15/11/25.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSHomepageViewController.h"
#import "SSAddrInfoVC.h"
#import "MineViewController.h"
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/AddressBook.h>
#import "NSString+PhoneFormat.h"
#import "SSAppointmentTimeView.h"
#import "NSDate+KMdate.h"
#import "SSHttpReqServer.h"
#import "NSString+evaluatePhoneNumber.h"
#import "UserInfo.h"
#import "SSLoginVC.h"
#import "NSString+allSpace.h"
#import "DataArchive.h"
#import "SSpayViewController.h"
#import "SSMyOrdersVC.h"
#import "SSPriceTableView.h"
#import "NSString+evaluatePhoneNumber.h"

#define SS_HPWrongPhoneNumberMsg @"请输入正确的手机号"
#define SS_HPNoFaAddressMsg @"请输入发货地址"
#define SS_HPNoShouAddressMsg @"请输入收货地址"
#define SS_HpNoShouNameMsg @"请输入收件人姓名"
#define SS_HpNoShouPhoneMsg @"请输入收件人电话"
#define SS_HpWrongShouPhongMsg @"收件人电话格式不对"
#define SS_HpNoFaNameMsg @"请输入寄件人姓名"
#define SS_HpNoFaPhoneMsg @"请输入寄件人电话"
#define SS_HpWrongFaPhongMsg @"寄件人电话格式不对"
#define SS_HpNoProductNameMsg @"请输入物品名称"
#define SS_HpLessProductNameMsg @"物品名称不少于2个字"

#define SS_HpMaxKilo @"重量不能超过500公斤"
#define SS_HpMinKilo @"重量不少于1公斤"

#define SS_HpMaxDistance @"距离不能超过500公里"

#define SS_HpNoMyCellPhoneMsg @"请输入您的手机号"
#define SS_HpNoMyCodeMsg @"请输入验证码"

#define SS_HpFaNameMaxLengh @"寄件人姓名不能超过10个字"
#define SS_HpShouNameMaxLengh @"收件人姓名不能超过10个字"

#define SS_HpFaNameMinLengh @"寄件人姓名不能少于2个字"
#define SS_HpShouNameMinLengh @"收件人姓名不能少于2个字"

@interface SSHomepageViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,SSAppointmentTimeViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate>{
    SSAppointmentTimeView * _appointTimeView;
    dispatch_source_t _timer;
    
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    CLLocationCoordinate2D _currentCoordinate;
    
    NSInteger _getPriceRuleCount;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollerHeight;

// 定位反解码，城市
@property (nonatomic,copy) NSString * currentCityName;

// 地址
@property (strong, nonatomic) IBOutlet UILabel *hp_FaAddrLabel;
@property (strong, nonatomic) IBOutlet UILabel *hp_ShouAddrLabel;
@property (strong, nonatomic) SSAddressInfo * api_addr_fa;
@property (strong, nonatomic) SSAddressInfo * api_addr_shou;
@property (assign, nonatomic) BOOL api_addr_fa_hasValue;
@property (assign, nonatomic) BOOL api_addr_shou_hasValue;
@property (weak, nonatomic) IBOutlet UILabel *hp_FaAddrMarker;
@property (weak, nonatomic) IBOutlet UILabel *hp_ShouAddrMarker;
@property (weak, nonatomic) IBOutlet UILabel *hp_FaAddrPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *hp_ShouAddrPhoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *hp_FaAddrPersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hp_ShouAddrPersonNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *hp_FaAddrPlaceholder;
@property (weak, nonatomic) IBOutlet UILabel *hp_ShouAddrPlaceholder;

@property (strong,nonatomic) SSAddressInfo * localAddrInfo;

// 公斤
@property (nonatomic, assign) NSInteger api_kilo;
@property (strong, nonatomic) IBOutlet UITextField *kiloTextField;

// 距离
@property (nonatomic, assign) double api_distance;
@property (strong, nonatomic) IBOutlet UILabel *hp_distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *hp_priceRuleBtn;

// 取货时间
@property (nonatomic,assign) BOOL api_pick_now;
@property (nonatomic,copy) NSString * api_pick_time;

@property (strong, nonatomic) IBOutlet UIView *hp_appointmentBg;
@property (strong, nonatomic) IBOutlet UILabel *hp_appointmentLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *hp_appointmentHeight;

// 名称 备注
@property (strong, nonatomic) IBOutlet UITextField *productName;
@property (strong, nonatomic) IBOutlet UITextField *remark;

// 手机号，验证码
@property (strong, nonatomic) IBOutlet UIView *hp_myPhoneCodeBg;
@property (strong, nonatomic) IBOutlet UIButton *getVerCodeAction;
@property (strong, nonatomic) IBOutlet UITextField *hp_myPhoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *hp_myVerCodeTextField;
///

@property (strong, nonatomic) IBOutlet UIButton *hp_nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *hp_totalFeeLabel;
@property (assign,nonatomic) double api_total_fee;

// 价格规则
@property (assign,nonatomic) BOOL gotPriceRule;
@property (assign,nonatomic) NSInteger oneKM;
@property (assign,nonatomic) NSInteger masterKM;
@property (assign,nonatomic) double oneDistributionPrice;
@property (assign,nonatomic) double twoDistributionPrice;
@property (assign,nonatomic) NSInteger twoKG;
@property (assign,nonatomic) double masterDistributionPrice;
@property (assign,nonatomic) NSInteger masterKG;



@end

@implementation SSHomepageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    // notify
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shanSongUserLogout) name:LogoutNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kiloTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shanSongAddrAdditionFinishedNotify:) name:ShanSongAddressAdditionFinishedNotify object:nil];
    // KVO
    [self registerForKVO];
    // delegate
    self.productName.delegate = self;
    self.remark.delegate = self;
    //
    self.titleLabel.text = @"E代送";
    [self.leftBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(clickUserVC) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setImage:[UIImage imageNamed:@"ss_nav_order"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickMyOrders) forControlEvents:UIControlEventTouchUpInside];
    
    self.api_pick_now = YES;
    self.api_pick_time = [self currentDateString];
    
    self.api_kilo = 1;
    _currentCoordinate = CLLocationCoordinate2DMake(0, 0);
    //
    [self.getVerCodeAction setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    [self.hp_nextBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    
    _searcher = [[BMKGeoCodeSearch alloc] init];
    // 定位，反编码
    if (!_locService) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    //启动LocationService
    [_locService startUserLocationService];
    _searcher.delegate = self;
    //
}

#pragma mark - KVO
- (void)registerForKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self addObserver:self forKeyPath:keyPath options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)unregisterFromKVO {
    for (NSString *keyPath in [self observableKeypaths]) {
        [self removeObserver:self forKeyPath:keyPath];
    }
}

- (NSArray *)observableKeypaths {
    return [NSArray arrayWithObjects:@"api_addr_fa_hasValue", @"api_addr_shou_hasValue",@"api_distance", nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"api_addr_fa_hasValue"]) {
        self.hp_FaAddrMarker.text = self.api_addr_fa_hasValue?@"更改":@"添加";
        self.hp_FaAddrPlaceholder.hidden = self.api_addr_fa_hasValue;
    }
    if ([keyPath isEqualToString:@"api_addr_shou_hasValue"]) {
        self.hp_ShouAddrMarker.text = self.api_addr_shou_hasValue?@"更改":@"添加";
        self.hp_ShouAddrPlaceholder.hidden= self.api_addr_shou_hasValue;
    }
    if ([keyPath isEqualToString:@"api_distance"]) {// 距离
        self.hp_distanceLabel.text = [NSString stringWithFormat:@"%.1f",self.api_distance];
        [self calculateAndDisplayTotalFee];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getPriceRule];

    self.hp_myPhoneCodeBg.hidden = [UserInfo isLogin];
    CGFloat contentHeight = [UserInfo isLogin]?CGRectGetMinY(self.hp_myPhoneCodeBg.frame):CGRectGetMaxY(self.hp_myPhoneCodeBg.frame) + 10;
    self.scrollerHeight.constant = MAX(contentHeight, CGRectGetHeight(self.scroller.frame) + 2);
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    if (_locService) {
//        [_locService stopUserLocationService];
//        _locService.delegate = nil;
//    }
    if (_searcher) {
        _searcher.delegate = nil;
    }

}

- (void)dealloc{
    [self unregisterFromKVO];
}

- (void)pickTimeType:(UITapGestureRecognizer *)tap{
    [Tools hiddenKeyboard];
    if (tap.view.tag == 1102) {
        self.api_pick_now = NO;
        if (!_appointTimeView) {
            _appointTimeView = [[SSAppointmentTimeView alloc] initWithDelegate:self];
        }
        [_appointTimeView showInView:self.view];
    }else if (tap.view.tag == 1101){
        self.api_pick_now = YES;
    }
}


#pragma mark - outlet actions
- (IBAction)addKilo:(UIButton *)sender {
    [self.kiloTextField resignFirstResponder];
    ++self.api_kilo;
    if (self.api_kilo > 500) {
        self.api_kilo = 500;
        self.kiloTextField.text = [NSString stringWithFormat:@"%ld",self.api_kilo];
        [Tools showHUD:SS_HpMaxKilo];
        return;
    }
    self.kiloTextField.text = [NSString stringWithFormat:@"%ld",self.api_kilo];
    [self calculateAndDisplayTotalFee];
}

- (IBAction)minusKilo:(UIButton *)sender {
    [self.kiloTextField resignFirstResponder];
    if (self.api_kilo <= 1) {
        self.api_kilo = 1;
        self.kiloTextField.text = [NSString stringWithFormat:@"%ld",self.api_kilo];
        [Tools showHUD:SS_HpMinKilo];
        return;
    }
    self.kiloTextField.text = [NSString stringWithFormat:@"%ld",--self.api_kilo];
    [self calculateAndDisplayTotalFee];
}

- (void)clickMyOrders{
    if ([UserInfo isLogin]) {
        SSMyOrdersVC *vc = [[SSMyOrdersVC alloc] initWithNibName:NSStringFromClass([SSMyOrdersVC class]) bundle:nil];
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        SSLoginVC * welcomeVC = [[SSLoginVC alloc] init];
        [self.navigationController pushViewController:welcomeVC animated:YES];
    }
}

- (void)clickUserVC{
    if ([UserInfo isLogin]) {
        MineViewController *vc = [[MineViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{

        SSLoginVC * welcomeVC = [[SSLoginVC alloc] init];
        [self.navigationController pushViewController:welcomeVC animated:YES];
    }
}
- (IBAction)getVerCodeBtnAction:(UIButton *)sender {
    
    if (![_hp_myPhoneTextField.text isRightPhoneNumberFormat]) {
        [Tools showHUD:SS_HPWrongPhoneNumberMsg];
        return;
    }
    
    NSDictionary * paraDict = @{
                                @"phoneNo":_hp_myPhoneTextField.text,
                                @"type":@"6",
                                @"messageType":@"0",
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{@"data":aesString,};
    }
    
    [SSHttpReqServer businesssendcode:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            
            
        }else{
//            NSString * message = [responseObject objectForKey:@"message"];
//            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
    if (!_timer) {
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
        dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    }
    __block int i = 60;
    __weak typeof(_getVerCodeAction) weakBtn = _getVerCodeAction;
    dispatch_source_set_event_handler(_timer, ^{
        if (i == 0) {
            dispatch_suspend(_timer);
            [weakBtn setTitle:[NSString stringWithFormat:@"获取验证码"] forState:UIControlStateNormal];
            weakBtn.enabled = YES;
            i = 60;
            return ;
        }
        [weakBtn setTitle:[NSString stringWithFormat:@"已发送(%d)",i] forState:UIControlStateNormal];
        weakBtn.enabled = NO;
        i--;
    });
    dispatch_resume(_timer);
    return ;
}

- (IBAction)nextStepAction:(UIButton *)sender {
    if (!self.api_addr_fa_hasValue) {
        [Tools showHUD:SS_HPNoFaAddressMsg];
        return;
    }
    if (!self.api_addr_shou_hasValue) {
        [Tools showHUD:SS_HPNoShouAddressMsg];
        return;
    }
    // 重量
    if (self.api_distance > 500) {
        [Tools showHUD:SS_HpMaxDistance];
        return;
    }
    if (self.productName.text.length <= 0 || [self.productName.text allSpace]) {
        [Tools showHUD:SS_HpNoProductNameMsg];
        return;
    }
    if (self.productName.text.length < 2 || [self.productName.text allSpace]) {
        [Tools showHUD:SS_HpLessProductNameMsg];
        return;
    }
    
    if (![UserInfo isLogin]) {
        if (self.hp_myPhoneTextField.text.length <= 0 || [self.hp_myPhoneTextField.text allSpace]) {
            [Tools showHUD:SS_HpNoMyCellPhoneMsg];
            return;
        }
        if (self.hp_myVerCodeTextField.text.length <= 0 || [self.hp_myVerCodeTextField.text allSpace]) {
            [Tools showHUD:SS_HpNoMyCodeMsg];
            return;
        }
    }
    
    [self releaseOrder];
}

#pragma mark -
- (IBAction)editAddress:(UIButton *)sender {
    SSAddressEditorType type = [SSEditorTypeTransformer typeWithEditorTitleStr:sender.currentTitle];
    SSAddrInfoVC * aivc = [[SSAddrInfoVC alloc] init];
    aivc.addrType = type;
    aivc.currentCityName = self.currentCityName;
    if (type == SSAddressEditorTypeFa && self.api_addr_fa_hasValue) {
        aivc.addrInfo = self.api_addr_fa;
    }
    if (type == SSAddressEditorTypeShou && self.api_addr_shou_hasValue) {
        aivc.addrInfo = self.api_addr_shou;
    }
    [self.navigationController pushViewController:aivc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (navigationController.viewControllers.count == 1) {
        navigationController.interactivePopGestureRecognizer.enabled = NO;
    } else {
        navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
}

#pragma mark - UITextFieldDelegate
- (void)kiloTextFieldChanged:(NSNotification *)notify{
    UITextField * textField = (UITextField *)notify.object;
    // 公斤
    if (textField == self.kiloTextField) {
        NSInteger notifyKilo = [((UITextField *)notify.object).text integerValue];
        if (notifyKilo > 500) {
            self.api_kilo = 500;
            self.kiloTextField.text = [NSString stringWithFormat:@"%ld",self.api_kilo];
            [Tools showHUD:SS_HpMaxKilo];
            return;
        }
        if (notifyKilo <= 0) {
            self.api_kilo = 1;
            self.kiloTextField.text = [NSString stringWithFormat:@"%ld",self.api_kilo];
            [Tools showHUD:SS_HpMinKilo];
            return;
        }
        self.api_kilo = notifyKilo;
        [self calculateAndDisplayTotalFee];
    }
    
    if (textField == self.productName && textField.text.length > 20) {
        textField.text = [textField.text substringToIndex:20];
        [Tools showHUD:@"物品名称不能超过20个字"];
    }
    
    if (textField == self.remark && textField.text.length > 30) {
        textField.text = [textField.text substringToIndex:30];
        [Tools showHUD:@"备注不能超过30个字"];
    }
}

#pragma mark - nofitys
- (void)shanSongAddrAdditionFinishedNotify:(NSNotification *)notify{
    NSDictionary * info = notify.userInfo;
    SSAddressEditorType addrType = [[info objectForKey:NotifyTypeKey] integerValue];
    SSAddressInfo * addrInfo = [info objectForKey:NotifyInfoKey];
    if (addrType == SSAddressEditorTypeFa) {
        self.hp_FaAddrLabel.text = [NSString stringWithFormat:@"%@(%@)%@",addrInfo.name,addrInfo.address,addrInfo.addition];
        self.hp_FaAddrLabel.textColor = DeepGrey;
        self.api_addr_fa = addrInfo;
        self.api_addr_fa_hasValue = YES;
        self.hp_FaAddrPhoneLabel.text = addrInfo.personPhone;
        self.hp_FaAddrPersonNameLabel.text = [addrInfo.personName stringByAppendingString:addrInfo.genderIsWoman?@"女士":@"先生"];
    }else if(addrType == SSAddressEditorTypeShou){
        self.hp_ShouAddrLabel.text = [NSString stringWithFormat:@"%@(%@)%@",addrInfo.name,addrInfo.address,addrInfo.addition];
        self.hp_ShouAddrLabel.textColor = DeepGrey;
        self.api_addr_shou = addrInfo;
        self.api_addr_shou_hasValue = YES;
        self.hp_ShouAddrPhoneLabel.text = addrInfo.personPhone;
        self.hp_ShouAddrPersonNameLabel.text = [addrInfo.personName stringByAppendingString:addrInfo.genderIsWoman?@"女士":@"先生"];
    }
    if (self.api_addr_fa_hasValue && self.api_addr_shou_hasValue) {
        CLLocationCoordinate2D pa = CLLocationCoordinate2DMake([self.api_addr_fa.latitude doubleValue], [self.api_addr_fa.longitude doubleValue]);
        CLLocationCoordinate2D pb = CLLocationCoordinate2DMake([self.api_addr_shou.latitude doubleValue], [self.api_addr_shou.longitude doubleValue]);
        [self calculateNavigationDistanceBetweenPointA:pa pointB:pb];
    }
}

#pragma mark 键盘相关处理
- (void)keyboardWillShow:(NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    CGRect keyboardRect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         [_scroller changeFrameHeight:ScreenHeight - keyboardRect.size.height - 64];
                         UIView *firstResponder = [Tools findFirstResponderFromView:_scroller];
                         [_scroller scrollRectToVisible:CGRectInset(firstResponder.frame, 0, -20) animated:YES];
                     }];
}

- (void)keyboardWillHide:(NSNotification*)notification {
    
    NSDictionary *userInfo = [notification userInfo];
    [UIView animateWithDuration:[[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue]
                     animations:^{
                         
                         [_scroller changeFrameHeight:ScreenHeight - 64 - 44 ];
                         
                     }];
}

#pragma mark - 日期选择
- (void)SSAppointmentTimeView:(SSAppointmentTimeView*)view selectedDate:(NSString *)date{
    // NSLog(@"%@ \n %@",date, [date km_simpleToString]);
    self.api_pick_time = date;
    self.hp_appointmentLabel.text = self.api_pick_time;
}

- (NSString *)currentDateString{
    NSDate * date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return [localeDate km_simpleToString];
}

#pragma mark - API
- (void)releaseOrder{
//    NSString * pubaddress = []
    // ShouAddr
    double currentlongitude = _currentCoordinate.longitude;
    double currentlatitude = _currentCoordinate.latitude;
    NSDictionary * paraDict = @{
                                @"businessid":[UserInfo isLogin]?[UserInfo getUserId]:@"",
                                @"businessphoneno":self.hp_myPhoneTextField.text,
                                @"verificationcode":self.hp_myVerCodeTextField.text,
                                //@"pubname":self.hp_ShouNameTextField.text, // 名称不对，注意
                                @"islogin":[UserInfo isLogin]?@"true":@"false",
                                @"publongitude":self.api_addr_fa.longitude,
                                @"publatitude":self.api_addr_fa.latitude,
                                //@"pubphoneno":self.hp_ShouPhoneTextField.text, // 名称不对，注意
                                @"pubaddress":[NSString stringWithFormat:@"%@(%@)%@",self.api_addr_fa.name,self.api_addr_fa.address,self.api_addr_fa.addition],
                                @"taketype":self.api_pick_now?@"0":@"1",
                                @"currentlongitude":[NSNumber numberWithDouble:currentlongitude],
                                @"currentlatitude":[NSNumber numberWithDouble:currentlatitude],
                                @"taketime":self.api_pick_time,
                                //@"recevicename":self.hp_FaNameTextField.text, // 名称不对，注意
                                //@"recevicephoneno":self.hp_FaPhoneTextField.text, // 名称不对，注意
                                @"receviceaddress":[NSString stringWithFormat:@"%@(%@)%@",self.api_addr_shou.name,self.api_addr_shou.address,self.api_addr_shou.addition],
                                @"recevicelongitude":self.api_addr_shou.longitude,
                                @"recevicelatitude":self.api_addr_shou.latitude,
                                @"productname":self.productName.text,
                                @"remark":(self.remark.text == nil)?@"":self.remark.text,
                                @"amount":[NSNumber numberWithDouble:self.api_total_fee],
                                @"weight":[NSNumber numberWithInteger:self.api_kilo],
                                @"km":[NSNumber numberWithDouble:self.api_distance],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{@"data":aesString,};
    }
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [SSHttpReqServer orderflashpush:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        NSString * message = [responseObject objectForKey:@"message"];
        [Tools showHUD:message];
        if (status == 1) {
            // 本地缓存 ,收,发
            // uid  :  address{地址，经度，纬度，姓名，手机}
            NSDictionary * result = [responseObject objectForKey:@"result"];
            NSDictionary * uInfo = @{
                                        @"userId":[[responseObject objectForKey:@"result"] objectForKey:@"businessId"],
                                    };
            [UserInfo saveUserInfo:uInfo];
            if ([UserInfo isLogin]) {
//                self.api_addr_fa.uid = [self generateUniqueId];
//                self.api_addr_fa.personName = self.hp_ShouNameTextField.text;
//                self.api_addr_fa.personPhone = self.hp_ShouPhoneTextField.text;
//                [DataArchive storeFaAddress:self.api_addr_fa businessId:[UserInfo getUserId]];
//                self.api_addr_shou.uid = [self generateUniqueId];
//                self.api_addr_shou.personName = self.hp_FaNameTextField.text;
//                self.api_addr_shou.personPhone = self.hp_FaPhoneTextField.text;
//                [DataArchive storeShouAddress:self.api_addr_shou businessId:[UserInfo getUserId]];
            }
            //
            SSpayViewController * svc = [[SSpayViewController alloc] initWithNibName:NSStringFromClass([SSpayViewController class]) bundle:nil];
            svc.orderId = [NSString stringWithFormat:@"%@",[result objectForKey:@"orderId"]];
            svc.balancePrice = [[result objectForKey:@"balanceprice"] doubleValue];
            svc.type = 1;
            svc.tipAmount = self.api_total_fee;
            [self.navigationController pushViewController:svc animated:YES];
            
            // 清空内存？
            [self resetShansongData];

        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];

    }];
}
/// 获取计算价格公式
- (void)getPriceRule{
    _getPriceRuleCount++;
    [SSHttpReqServer gettaskdistributionconfigsuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSDictionary * result = [responseObject objectForKey:@"result"];
            self.oneKM = [[result objectForKey:@"oneKM"] integerValue];
            self.oneDistributionPrice = [[result objectForKey:@"oneDistributionPrice"] doubleValue];
            self.masterDistributionPrice = [[result objectForKey:@"masterDistributionPrice"] doubleValue];
            self.masterKG = [[result objectForKey:@"masterKG"] integerValue];
            self.masterKM = [[result objectForKey:@"masterKM"] integerValue];
            self.twoDistributionPrice = [[result objectForKey:@"twoDistributionPrice"] doubleValue];
            self.twoKG = [[result objectForKey:@"twoKG"] integerValue];
            self.gotPriceRule = YES;
            //
            self.hp_priceRuleBtn.hidden = NO;
        }else{
            if (_getPriceRuleCount < 5) {
                [self getPriceRule];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (_getPriceRuleCount < 5) {
            [self getPriceRule];
        }
    }];
}

- (void)calculateAndDisplayTotalFee{
    if (self.gotPriceRule && self.api_addr_fa_hasValue && self.api_addr_shou_hasValue) {// 获得计算规则，发收地理位置,重量(填)，距离（算）
        if (self.api_distance <= self.masterKM && self.api_kilo <= self.masterKG) {
            self.api_total_fee = self.masterDistributionPrice;
        }else if (self.api_distance <= self.masterKM && self.api_kilo > self.masterKG){
            self.api_total_fee = self.masterDistributionPrice + ceil((self.api_kilo - self.masterKG)/self.twoKG) * self.twoDistributionPrice;
        }else if (self.api_distance > self.masterKM && self.api_kilo <= self.masterKG){
            self.api_total_fee = self.masterDistributionPrice + ceil((self.api_distance - self.masterKM)/self.oneKM) * self.oneDistributionPrice;
        }else if (self.api_distance > self.masterKM && self.api_kilo > self.masterKG){
            self.api_total_fee = self.masterDistributionPrice + ceil((self.api_distance - self.masterKM)/self.oneKM) * self.oneDistributionPrice + ceil((self.api_kilo - self.masterKG)/self.twoKG) * self.twoDistributionPrice;
        }
        self.hp_totalFeeLabel.text = [NSString stringWithFormat:@"¥ %.2f",self.api_total_fee];
    }
}

#pragma mark - BMKMapViewDelegate  BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
    _currentCoordinate = userLocation.location.coordinate;
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    } else {
        NSLog(@"反geo检索发送失败");
        
    }
}

#pragma mark - BMKGeoCodeSearchDelegate
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.currentCityName = result.addressDetail.city;
    }else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - 价格表
- (IBAction)showPriceTable:(UIButton *)sender {
    //
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    [SSHttpReqServer gettaskdistributionconfigsuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSDictionary * result = [responseObject objectForKey:@"result"];
            self.oneKM = [[result objectForKey:@"oneKM"] integerValue];
            self.oneDistributionPrice = [[result objectForKey:@"oneDistributionPrice"] doubleValue];
            self.masterDistributionPrice = [[result objectForKey:@"masterDistributionPrice"] doubleValue];
            self.masterKG = [[result objectForKey:@"masterKG"] integerValue];
            self.masterKM = [[result objectForKey:@"masterKM"] integerValue];
            self.twoDistributionPrice = [[result objectForKey:@"twoDistributionPrice"] doubleValue];
            self.twoKG = [[result objectForKey:@"twoKG"] integerValue];
            self.gotPriceRule = YES;
            //
            self.hp_priceRuleBtn.hidden = NO;
            //
            SSPriceTableView * priceTable = [[SSPriceTableView alloc] initWithmasterKG:self.masterKG masterKM:self.masterKM masterDistributionPrice:self.masterDistributionPrice oneKM:self.oneKM oneDistributionPrice:self.oneDistributionPrice twoKG:self.twoKG twoDistributionPrice:self.twoDistributionPrice];
            [priceTable showInView:self.view];
            
        }else{
            
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
    }];
    

}


#pragma mark - 重置数据
- (void)resetShansongData{
    self.api_addr_fa = self.localAddrInfo;
    self.api_addr_fa_hasValue = YES;
    self.api_addr_shou = nil;
    self.api_addr_shou_hasValue = NO;
    self.hp_myPhoneTextField.text = @"";
//    self.hp_FaNameTextField.text = @"";
//    self.hp_FaPhoneTextField.text = @"";
    self.hp_myVerCodeTextField.text = @"";
    self.api_pick_now = YES;
    self.api_pick_time = [self currentDateString ];
//    self.self.hp_ShouNameTextField.text = @"";
//    self.hp_ShouPhoneTextField.text = @"";
    self.productName.text = @"";
    self.remark.text = @"";
    self.api_total_fee = 0;
    self.hp_totalFeeLabel.text = [NSString stringWithFormat:@"¥ %.2f",self.api_total_fee];
    self.api_kilo= 1;
    self.kiloTextField.text = @"1";
    self.api_distance = 0;
    self.hp_distanceLabel.text = @"0";
    self.hp_FaAddrLabel.text = self.api_addr_fa.name;
    //            self.hp_FaAddrLabel.textColor = BBC0C7Color;
    self.hp_ShouAddrLabel.text = @"请输入收货地址";
    self.hp_ShouAddrLabel.textColor = BBC0C7Color;
}

- (void)shanSongUserLogout{
    [self resetShansongData];
}



#pragma mark - 两点测距离
// 导航距离
- (void)calculateNavigationDistanceBetweenPointA:(CLLocationCoordinate2D)pa pointB:(CLLocationCoordinate2D)pb{
    BMKPlanNode* pickNode = [[BMKPlanNode alloc]init];
    pickNode.pt = pa;
    BMKPlanNode* receiveNode = [[BMKPlanNode alloc]init];
    receiveNode.pt = pb;
    BMKWalkingRoutePlanOption *meToPickWalkingRouteSearchOption = [[BMKWalkingRoutePlanOption alloc]init];
    meToPickWalkingRouteSearchOption.from = pickNode;
    meToPickWalkingRouteSearchOption.to = receiveNode;
    BMKRouteSearch * routeSearch = [[BMKRouteSearch alloc] init];
    routeSearch.delegate = self;
    BOOL flag = [routeSearch walkingSearch:meToPickWalkingRouteSearchOption];
    if(flag){
        NSLog(@"me to pick walk检索发送成功");
    }else{
        NSLog(@"me to pick walk检索发送失败");
        [self calculateStraightDistanceBetweenPA:pa pB:pb];
    }
}

#pragma mark - 地图路径规划
- (void)onGetWalkingRouteResult:(BMKRouteSearch*)searcher result:(BMKWalkingRouteResult*)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        BMKWalkingRouteLine* plan = (BMKWalkingRouteLine*)[result.routes objectAtIndex:0];
        self.api_distance = plan.distance/1000;
    }else{
        CLLocationCoordinate2D pa = CLLocationCoordinate2DMake([self.api_addr_fa.latitude doubleValue], [self.api_addr_fa.longitude doubleValue]);
        CLLocationCoordinate2D pb = CLLocationCoordinate2DMake([self.api_addr_shou.latitude doubleValue], [self.api_addr_shou.longitude doubleValue]);
        [self calculateStraightDistanceBetweenPA:pa pB:pb];
    }
}

// 直线距离
- (void)calculateStraightDistanceBetweenPA:(CLLocationCoordinate2D)pa pB:(CLLocationCoordinate2D)pb{
    BMKMapPoint point1 = BMKMapPointForCoordinate(pa);
    BMKMapPoint point2 = BMKMapPointForCoordinate(pb);
    CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2); //m
    self.api_distance = distance/1000;
}
@end
