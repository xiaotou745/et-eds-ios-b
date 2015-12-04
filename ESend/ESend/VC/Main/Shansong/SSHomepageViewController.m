//
//  SSHomepageViewController.m
//  ESend
//
//  Created by 台源洪 on 15/11/25.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSHomepageViewController.h"
#import "SSEditAdderssViewController.h"
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

#define SS_HPWrongPhoneNumberMsg @"请输入正确的手机号"
#define SS_HPNoFaAddressMsg @"请输入发货地址"
#define SS_HPNoShouAddressMsg @"请输入收货地址"
#define SS_HpNoShouNameMsg @"请输入收件人姓名"
#define SS_HpNoShouPhoneMsg @"请输入收件人电话"
#define SS_HpNoFaNameMsg @"请输入寄件人姓名"
#define SS_HpNoFaPhoneMsg @"请输入寄件人电话"
#define SS_HpNoProductNameMsg @"请输入物品名称"

#define SS_HpNoMyCellPhoneMsg @"请输入您的手机号"
#define SS_HpNoMyCodeMsg @"请输入验证码"

@interface SSHomepageViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,SSAppointmentTimeViewDelegate>{
    SSAppointmentTimeView * _appointTimeView;
    dispatch_source_t _timer;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollerHeight;

// 地址
@property (strong, nonatomic) IBOutlet UILabel *hp_FaAddrLabel;
@property (strong, nonatomic) IBOutlet UILabel *hp_ShouAddrLabel;
@property (strong, nonatomic) SSAddressInfo * api_addr_fa;
@property (strong, nonatomic) SSAddressInfo * api_addr_shou;
@property (assign, nonatomic) BOOL api_addr_fa_hasValue;
@property (assign, nonatomic) BOOL api_addr_shou_hasValue;

// 公斤
@property (nonatomic, assign) NSInteger api_kilo;
@property (strong, nonatomic) IBOutlet UITextField *kiloTextField;

// 距离
@property (nonatomic, assign) double api_distance;
@property (strong, nonatomic) IBOutlet UILabel *hp_distanceLabel;

// 姓名,电话
@property (strong, nonatomic) IBOutlet UITextField *hp_ShouNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *hp_ShouPhoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *hp_FaNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *hp_FaPhoneTextField;
@property (assign,nonatomic) SSAddressEditorType phoneType;

// 取货时间
@property (nonatomic,assign) BOOL api_pick_now;
@property (nonatomic,copy) NSString * api_pick_time;
@property (strong, nonatomic) IBOutlet UIImageView *hp_PickNowImg;
@property (strong, nonatomic) IBOutlet UILabel *hp_PickNowLabel;
@property (strong, nonatomic) IBOutlet UIImageView *hp_pickAppointmentImg;
@property (strong, nonatomic) IBOutlet UILabel *hp_pickAppointmentLabel;
@property (strong, nonatomic) IBOutlet UIView *hp_PickNowBgView;
@property (strong, nonatomic) IBOutlet UIView *hp_pickAppointmentBgView;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shanSongAddrAdditionFinishedNotify:) name:ShanSongAddressAdditionFinishedNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kiloTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];

    self.titleLabel.text = @"E代送";
    [self.leftBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(clickUserVC) forControlEvents:UIControlEventTouchUpInside];
    
    [self addObserver:self forKeyPath:@"api_pick_now" options:NSKeyValueObservingOptionNew context:NULL];
    self.api_pick_now = YES;
    self.api_pick_time = [self currentDateString];
    
    self.api_distance = 0.0f;
    self.api_kilo = 1;
    // tap
    UITapGestureRecognizer * tapNow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickTimeType:)];
    UITapGestureRecognizer * tapAppointment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickTimeType:)];
    [self.hp_PickNowBgView addGestureRecognizer:tapNow];
    [self.hp_pickAppointmentBgView addGestureRecognizer:tapAppointment];
    //
    [self.getVerCodeAction setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    [self.hp_nextBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
    
    //
    [self getPriceRule];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.hp_myPhoneCodeBg.hidden = [UserInfo isLogin];
    CGFloat contentHeight = [UserInfo isLogin]?CGRectGetMinY(self.hp_myPhoneCodeBg.frame):CGRectGetMaxY(self.hp_myPhoneCodeBg.frame) + 10;
    self.scrollerHeight.constant = MAX(contentHeight, CGRectGetHeight(self.scroller.frame) + 2);
}

- (void)pickTimeType:(UITapGestureRecognizer *)tap{
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

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateUIForKeypath:keyPath];
    }
}

- (void)updateUIForKeypath:(NSString *)keyPath {
    if ([keyPath isEqualToString:@"api_pick_now"]) {
        self.hp_PickNowImg.highlighted = self.api_pick_now;
        self.hp_pickAppointmentImg.highlighted = !self.api_pick_now;
        self.hp_PickNowLabel.textColor = self.api_pick_now?DeepGrey:BBC0C7Color;
        self.hp_pickAppointmentLabel.textColor = self.api_pick_now?BBC0C7Color:DeepGrey;
        //
        self.hp_appointmentBg.hidden = self.api_pick_now;
        self.hp_appointmentHeight.constant = self.api_pick_now?0:30;
        self.scrollerHeight.constant += self.api_pick_now?-30:+30;
    }
}

#pragma mark - outlet actions
- (IBAction)addKilo:(UIButton *)sender {
    [self.kiloTextField resignFirstResponder];
    self.kiloTextField.text = [NSString stringWithFormat:@"%ld",++self.api_kilo];
    [self calculateAndDisplayTotalFee];
}

- (IBAction)minusKilo:(UIButton *)sender {
    [self.kiloTextField resignFirstResponder];
    if (self.api_kilo == 1) {
        return;
    }
    self.kiloTextField.text = [NSString stringWithFormat:@"%ld",--self.api_kilo];
    [self calculateAndDisplayTotalFee];
}

- (IBAction)shouPhoneAction:(UIButton *)sender {
    self.phoneType = SSAddressEditorTypeShou;
    ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:^{}];
}
- (IBAction)faPhoneAction:(UIButton *)sender {
    self.phoneType = SSAddressEditorTypeFa;
    ABPeoplePickerNavigationController *picker =[[ABPeoplePickerNavigationController alloc] init];
    picker.peoplePickerDelegate = self;
    [self presentViewController:picker animated:YES completion:^{}];
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
                                @"type":@"1",
                                @"messageType":@"0",
                                };
//    if (AES_Security) {
//        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
//        NSString * aesString = [Security AesEncrypt:jsonString2];
//        paraDict = @{@"data":aesString,};
//    }
    
    [SSHttpReqServer businesssendcode:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (200 == status) {
            
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
            
        }else{
            NSString * message = [responseObject objectForKey:@"message"];
            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
    if (self.hp_ShouNameTextField.text.length <= 0 || [self.hp_ShouNameTextField.text allSpace]) {
        [Tools showHUD:SS_HpNoShouNameMsg];
        return;
    }
    if (self.hp_ShouPhoneTextField.text.length <= 0 || [self.hp_ShouPhoneTextField.text allSpace]) {
        [Tools showHUD:SS_HpNoShouPhoneMsg];
        return;
    }
    if (self.hp_FaNameTextField.text.length <= 0 || [self.hp_FaNameTextField.text allSpace]) {
        [Tools showHUD:SS_HpNoFaNameMsg];
        return;
    }
    if (self.hp_FaPhoneTextField.text.length <= 0 || [self.hp_FaPhoneTextField.text allSpace]) {
        [Tools showHUD:SS_HpNoFaPhoneMsg];
        return;
    }
    if (self.productName.text.length <= 0 || [self.productName.text allSpace]) {
        [Tools showHUD:SS_HpNoProductNameMsg];
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
    SSEditAdderssViewController * eavc = [[SSEditAdderssViewController alloc] initWithNibName:NSStringFromClass([SSEditAdderssViewController class]) bundle:nil Type:[SSEditorTypeTransformer typeWithEditorTitleStr:sender.currentTitle]];
    [self.navigationController pushViewController:eavc animated:YES];
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
    if (((UITextField *)notify.object) == self.kiloTextField) {
        self.api_kilo = [((UITextField *)notify.object).text integerValue];
        [self calculateAndDisplayTotalFee];
    }
}

#pragma mark - nofitys
- (void)shanSongAddrAdditionFinishedNotify:(NSNotification *)notify{
    NSDictionary * info = notify.userInfo;
    SSAddressEditorType addrType = [[info objectForKey:NotifyTypeKey] integerValue];
    SSAddressInfo * addrInfo = [info objectForKey:NotifyInfoKey];
    if (addrType == SSAddressEditorTypeFa) {
        self.hp_FaAddrLabel.text = [NSString stringWithFormat:@"%@%@",addrInfo.name,addrInfo.addition];
        self.hp_FaAddrLabel.textColor = DeepGrey;
        self.api_addr_fa = addrInfo;
        self.api_addr_fa_hasValue = YES;
    }else if(addrType == SSAddressEditorTypeShou){
        self.hp_ShouAddrLabel.text = [NSString stringWithFormat:@"%@%@",addrInfo.name,addrInfo.addition];
        self.hp_ShouAddrLabel.textColor = DeepGrey;
        self.api_addr_shou = addrInfo;
        self.api_addr_shou_hasValue = YES;
    }
    if (self.api_addr_fa_hasValue && self.api_addr_shou_hasValue) {
        BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([self.api_addr_fa.latitude doubleValue], [self.api_addr_fa.longitude doubleValue]));
        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([self.api_addr_shou.latitude doubleValue], [self.api_addr_shou.longitude doubleValue]));
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2); //m
        self.api_distance = distance/1000;
        self.hp_distanceLabel.text = [NSString stringWithFormat:@"%.2f",self.api_distance];
        
        // 计算费用总计;
        [self calculateAndDisplayTotalFee];
    }
}


#pragma mark - ABPeoplePickerNavigationControllerDelegate
//选择属性之后，注意如果上面的代理方法实现后此方法不会被调用
-(void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (person && property == kABPersonPhoneProperty) {
        ABMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString * phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        //NSLog(@"%@",[phone phoneFormat]);
        if (self.phoneType == SSAddressEditorTypeFa) {
            self.hp_FaPhoneTextField.text = [phone phoneFormat];
        }else{
            self.hp_ShouPhoneTextField.text = [phone phoneFormat];
        }
    }
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (person && property == kABPersonPhoneProperty) {
        ABMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString * phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        //NSLog(@"%@",[phone phoneFormat]);
        if (self.phoneType == SSAddressEditorTypeFa) {
            self.hp_FaPhoneTextField.text = [phone phoneFormat];
        }else{
            self.hp_ShouPhoneTextField.text = [phone phoneFormat];
        }
    }
    return NO;
}
//点击取消按钮
-(void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker{
   // NSLog(@"取消选择.");
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
- (void)SSAppointmentTimeView:(SSAppointmentTimeView*)view selectedDate:(NSDate *)date{
    // NSLog(@"%@ \n %@",date, [date km_simpleToString]);
    self.api_pick_time = [date km_simpleToString];
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
    NSDictionary * paraDict = @{
                                @"businessid":[UserInfo isLogin]?[UserInfo getUserId]:@"",
                                @"businessphoneno":self.hp_myPhoneTextField.text,
                                @"verificationcode":self.hp_myVerCodeTextField.text,
                                @"pubname":self.hp_FaNameTextField.text,
                                @"islogin":[UserInfo isLogin]?@"true":@"false",
                                @"publongitude":self.api_addr_fa.longitude,
                                @"publatitude":self.api_addr_fa.latitude,
                                @"pubphoneno":self.hp_FaPhoneTextField.text,
                                @"pubaddress":[NSString stringWithFormat:@"%@%@",self.api_addr_fa.name,self.api_addr_fa.addition],
                                @"taketype":self.api_pick_now?@"0":@"1",
                                @"takelongitude":@"0",
                                @"takelatitude":@"0",
                                @"recevicename":self.hp_ShouNameTextField.text,
                                @"recevicephoneno":self.hp_ShouPhoneTextField.text,
                                @"receviceaddress":[NSString stringWithFormat:@"%@%@",self.api_addr_shou.name,self.api_addr_shou.addition],
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
            NSDictionary * uInfo = @{
                                        @"userId":[[responseObject objectForKey:@"result"] objectForKey:@"businessId"],
                                    };
            [UserInfo saveUserInfo:uInfo];
            if ([UserInfo isLogin]) {
                self.api_addr_fa.uid = [self generateUniqueId];
                [DataArchive storeFaAddress:self.api_addr_fa businessId:[UserInfo getUserId]];
                self.api_addr_shou.uid = [self generateUniqueId];
                [DataArchive storeShouAddress:self.api_addr_shou businessId:[UserInfo getUserId]];
            }
            
            // 清空内存？
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];

    }];
}
/// 获取计算价格公式
- (void)getPriceRule{
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
        }else{
            [self getPriceRule];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self getPriceRule];
    }];
}

- (void)calculateAndDisplayTotalFee{
    if (self.gotPriceRule && self.api_addr_fa_hasValue && self.api_addr_shou_hasValue) {// 获得计算规则，发收地理位置,重量(填)，距离（算）
        if (self.api_distance <= self.masterKM && self.api_kilo <= self.masterKG) {
            self.api_total_fee = self.masterDistributionPrice;
        }else if (self.api_distance <= self.masterKM && self.api_kilo > self.masterKG){
            self.api_total_fee = self.masterDistributionPrice + ceil(self.api_kilo - self.masterKG) * self.twoDistributionPrice;
        }else if (self.api_distance > self.masterKM && self.api_kilo <= self.masterKG){
            self.api_total_fee = self.masterDistributionPrice + ceil(self.api_distance - self.masterKM) * self.oneDistributionPrice;
        }else if (self.api_distance > self.masterKM && self.api_kilo > self.masterKG){
            self.api_total_fee = self.masterDistributionPrice + ceil(self.api_distance - self.masterKM) * self.oneDistributionPrice + ceil(self.api_kilo - self.masterKG) * self.twoDistributionPrice;
        }
        self.hp_totalFeeLabel.text = [NSString stringWithFormat:@"¥ %.2f",self.api_total_fee];
    }
}

#pragma mark - general uid
- (NSString *)generateUniqueId{
    CFUUIDRef uuidRef =CFUUIDCreate(NULL);
    CFStringRef uuidStringRef =CFUUIDCreateString(NULL, uuidRef);
    CFRelease(uuidRef);
    NSString *uniqueId = (__bridge NSString *)uuidStringRef;
    return uniqueId;
}

@end
