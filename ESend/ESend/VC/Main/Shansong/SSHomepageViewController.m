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

@interface SSHomepageViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,SSAppointmentTimeViewDelegate,SSEditAdderssViewControllerDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>{
    SSAppointmentTimeView * _appointTimeView;
    dispatch_source_t _timer;
    
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
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

@property (strong,nonatomic) SSAddressInfo * localAddrInfo;

// 公斤
@property (nonatomic, assign) NSInteger api_kilo;
@property (strong, nonatomic) IBOutlet UITextField *kiloTextField;

// 距离
@property (nonatomic, assign) double api_distance;
@property (strong, nonatomic) IBOutlet UILabel *hp_distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *hp_priceRuleBtn;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shanSongUserLogout) name:LogoutNotifaction object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter ] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shanSongAddrAdditionFinishedNotify:) name:ShanSongAddressAdditionFinishedNotify object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(kiloTextFieldChanged:) name:UITextFieldTextDidChangeNotification object:nil];

    // 的爱里
    self.productName.delegate = self;
    self.remark.delegate = self;
    //
    self.titleLabel.text = @"E代送";
    [self.leftBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
    [self.leftBtn addTarget:self action:@selector(clickUserVC) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn setImage:[UIImage imageNamed:@"ss_nav_order"] forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(clickMyOrders) forControlEvents:UIControlEventTouchUpInside];
    
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

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self getPriceRule];

    self.hp_myPhoneCodeBg.hidden = [UserInfo isLogin];
    CGFloat contentHeight = [UserInfo isLogin]?CGRectGetMinY(self.hp_myPhoneCodeBg.frame):CGRectGetMaxY(self.hp_myPhoneCodeBg.frame) + 10;
    self.scrollerHeight.constant = MAX(contentHeight, CGRectGetHeight(self.scroller.frame) + 2);
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
//    if (AES_Security) {
//        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
//        NSString * aesString = [Security AesEncrypt:jsonString2];
//        paraDict = @{@"data":aesString,};
//    }
    
    [SSHttpReqServer businesssendcode:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            
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
    // 重量
    if (self.api_distance > 500) {
        [Tools showHUD:SS_HpMaxDistance];
        return;
    }
    if (self.hp_ShouNameTextField.text.length <= 0 || [self.hp_ShouNameTextField.text allSpace]) { // 寄件人
        [Tools showHUD:SS_HpNoFaNameMsg];
        return;
    }
    if (self.hp_ShouNameTextField.text.length < 2) { // 寄件人
        [Tools showHUD:SS_HpFaNameMinLengh];
        return;
    }
    if (self.hp_ShouPhoneTextField.text.length <= 0 || [self.hp_ShouPhoneTextField.text allSpace]) { // 寄件人
        [Tools showHUD:SS_HpNoFaPhoneMsg];
        return;
    }
    if (![self.hp_ShouPhoneTextField.text rightConsigneeContactInfo]) {// 寄件人
        [Tools showHUD:SS_HpWrongFaPhongMsg];
        return;
    }
    if (self.hp_FaNameTextField.text.length <= 0 || [self.hp_FaNameTextField.text allSpace]) { // 收件人
        [Tools showHUD:SS_HpNoShouNameMsg];
        return;
    }
    if (self.hp_FaNameTextField.text.length < 2) { // 收件人
        [Tools showHUD:SS_HpShouNameMinLengh];
        return;
    }
    if (self.hp_FaPhoneTextField.text.length <= 0 || [self.hp_FaPhoneTextField.text allSpace]) { // 收件人
        [Tools showHUD:SS_HpNoShouPhoneMsg];
        return;
    }
    if (![self.hp_FaPhoneTextField.text rightConsigneeContactInfo]) { // 收件人
        [Tools showHUD:SS_HpWrongShouPhongMsg];
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
    SSEditAdderssViewController * eavc = [[SSEditAdderssViewController alloc] initWithNibName:NSStringFromClass([SSEditAdderssViewController class]) bundle:nil Type:type];
    if (type == SSAddressEditorTypeFa) {
        if (self.api_addr_fa_hasValue) {
            eavc.addrInfo = self.api_addr_fa;
        }
    }else if (type == SSAddressEditorTypeShou){
        if (self.api_addr_shou_hasValue) {
            eavc.addrInfo = self.api_addr_shou;
        }
    }
    eavc.delegate = self;
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
    
    if (textField == self.hp_FaNameTextField && textField.text.length > 10) { // 收件人名称
        textField.text = [textField.text substringToIndex:10];
        [Tools showHUD:SS_HpShouNameMaxLengh];
    }
    
    if (textField == self.hp_ShouNameTextField && textField.text.length > 10) { // 寄件人名称
        textField.text = [textField.text substringToIndex:10];
        [Tools showHUD:SS_HpFaNameMaxLengh];
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
    }else if(addrType == SSAddressEditorTypeShou){
        self.hp_ShouAddrLabel.text = [NSString stringWithFormat:@"%@(%@)%@",addrInfo.name,addrInfo.address,addrInfo.addition];
        self.hp_ShouAddrLabel.textColor = DeepGrey;
        self.api_addr_shou = addrInfo;
        self.api_addr_shou_hasValue = YES;
    }
    if (self.api_addr_fa_hasValue && self.api_addr_shou_hasValue) {
        BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([self.api_addr_fa.latitude doubleValue], [self.api_addr_fa.longitude doubleValue]));
        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([self.api_addr_shou.latitude doubleValue], [self.api_addr_shou.longitude doubleValue]));
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2); //m
        self.api_distance = distance/1000;
        self.hp_distanceLabel.text = [NSString stringWithFormat:@"%.1f",self.api_distance];
        // 限制距离？？
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
        
        NSString * name = (__bridge NSString *)(ABRecordCopyCompositeName(person));
        if (self.phoneType == SSAddressEditorTypeFa) {
            self.hp_FaPhoneTextField.text = [phone phoneFormat];
            self.hp_FaNameTextField.text = name;
        }else{
            self.hp_ShouPhoneTextField.text = [phone phoneFormat];
            self.hp_ShouNameTextField.text = name;
        }
    }
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier{
    if (person && property == kABPersonPhoneProperty) {
        ABMultiValueRef phoneMulti = ABRecordCopyValue(person, property);
        CFIndex index = ABMultiValueGetIndexForIdentifier(phoneMulti, identifier);
        NSString * phone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, index);
        
        NSString * name = (__bridge NSString *)(ABRecordCopyCompositeName(person));
        //NSLog(@"%@",name);
        
        //NSLog(@"%@",[phone phoneFormat]);
        if (self.phoneType == SSAddressEditorTypeFa) {
            self.hp_FaPhoneTextField.text = [phone phoneFormat];
            self.hp_FaNameTextField.text = name;
        }else{
            self.hp_ShouPhoneTextField.text = [phone phoneFormat];
            self.hp_ShouNameTextField.text = name;
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
//    NSString * pubaddress = []
    // ShouAddr
    NSDictionary * paraDict = @{
                                @"businessid":[UserInfo isLogin]?[UserInfo getUserId]:@"",
                                @"businessphoneno":self.hp_myPhoneTextField.text,
                                @"verificationcode":self.hp_myVerCodeTextField.text,
                                @"pubname":self.hp_ShouNameTextField.text, // 名称不对，注意
                                @"islogin":[UserInfo isLogin]?@"true":@"false",
                                @"publongitude":self.api_addr_fa.longitude,
                                @"publatitude":self.api_addr_fa.latitude,
                                @"pubphoneno":self.hp_ShouPhoneTextField.text, // 名称不对，注意
                                @"pubaddress":[NSString stringWithFormat:@"%@(%@)%@",self.api_addr_fa.name,self.api_addr_fa.address,self.api_addr_fa.addition],
                                @"taketype":self.api_pick_now?@"0":@"1",
                                @"takelongitude":@"0",
                                @"takelatitude":@"0",
                                @"taketime":self.api_pick_time,
                                @"recevicename":self.hp_FaNameTextField.text, // 名称不对，注意
                                @"recevicephoneno":self.hp_FaPhoneTextField.text, // 名称不对，注意
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
                self.api_addr_fa.uid = [self generateUniqueId];
                self.api_addr_fa.personName = self.hp_ShouNameTextField.text;
                self.api_addr_fa.personPhone = self.hp_ShouPhoneTextField.text;
                [DataArchive storeFaAddress:self.api_addr_fa businessId:[UserInfo getUserId]];
                self.api_addr_shou.uid = [self generateUniqueId];
                self.api_addr_shou.personName = self.hp_FaNameTextField.text;
                self.api_addr_shou.personPhone = self.hp_FaPhoneTextField.text;
                [DataArchive storeShouAddress:self.api_addr_shou businessId:[UserInfo getUserId]];
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

#pragma mark - SSEditAdderssViewControllerDelegate
- (void)editAddressVC:(SSEditAdderssViewController *)vc didSelectHistroyAddr:(SSAddressInfo *)address type:(SSAddressEditorType)type{
    
    if (type == SSAddressEditorTypeFa) {
        self.hp_FaAddrLabel.text = [NSString stringWithFormat:@"%@(%@)%@",address.name,address.address,address.addition];
        self.hp_FaAddrLabel.textColor = DeepGrey;
        self.api_addr_fa = address;
        self.api_addr_fa_hasValue = YES;
        //
        self.hp_ShouNameTextField.text = address.personName;
        self.hp_ShouPhoneTextField.text = address.personPhone;
    }else if (type == SSAddressEditorTypeShou){
        self.hp_ShouAddrLabel.text = [NSString stringWithFormat:@"%@(%@)%@",address.name,address.address,address.addition];
        self.hp_ShouAddrLabel.textColor = DeepGrey;
        self.api_addr_shou = address;
        self.api_addr_shou_hasValue = YES;
        //
        self.hp_FaNameTextField.text = address.personName;
        self.hp_FaPhoneTextField.text = address.personPhone;
    }
    if (self.api_addr_fa_hasValue && self.api_addr_shou_hasValue) {
        BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([self.api_addr_fa.latitude doubleValue], [self.api_addr_fa.longitude doubleValue]));
        BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([self.api_addr_shou.latitude doubleValue], [self.api_addr_shou.longitude doubleValue]));
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2); //m
        self.api_distance = distance/1000;
        self.hp_distanceLabel.text = [NSString stringWithFormat:@"%.1f",self.api_distance];
        
        // 计算费用总计;
        [self calculateAndDisplayTotalFee];
    }
}

#pragma mark - BMKMapViewDelegate  BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_locService stopUserLocationService];
    
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
        //在此处理正常结果
        /*
         */
        SSAddressInfo * mapAddr1 = [[SSAddressInfo alloc] init];
        mapAddr1.name = result.addressDetail.streetName;
        mapAddr1.address = result.address;
        mapAddr1.addition = @"";
        mapAddr1.city = result.addressDetail.city;
        mapAddr1.latitude = [NSString stringWithFormat:@"%f",result.location.latitude];
        mapAddr1.longitude = [NSString stringWithFormat:@"%f",result.location.longitude];
        mapAddr1.selected = YES;
        
        self.hp_FaAddrLabel.text = [NSString stringWithFormat:@"%@(%@)",mapAddr1.name,mapAddr1.address];
        self.hp_FaAddrLabel.textColor = DeepGrey;
        self.api_addr_fa = mapAddr1;
        self.localAddrInfo = mapAddr1;
        self.api_addr_fa_hasValue = YES;
        
    }else {
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - 价格表
- (IBAction)showPriceTable:(UIButton *)sender {
    SSPriceTableView * priceTable = [[SSPriceTableView alloc] initWithmasterKG:self.masterKG masterKM:self.masterKM masterDistributionPrice:self.masterDistributionPrice oneKM:self.oneKM oneDistributionPrice:self.oneDistributionPrice twoKG:self.twoKG twoDistributionPrice:self.twoDistributionPrice];
    [priceTable showInView:self.view];
}


#pragma mark - 重置数据
- (void)resetShansongData{
    self.api_addr_fa = self.localAddrInfo;
    self.api_addr_fa_hasValue = YES;
    self.api_addr_shou = nil;
    self.api_addr_shou_hasValue = NO;
    self.hp_myPhoneTextField.text = @"";
    self.hp_FaNameTextField.text = @"";
    self.hp_FaPhoneTextField.text = @"";
    self.hp_myVerCodeTextField.text = @"";
    self.api_pick_now = YES;
    self.api_pick_time = [self currentDateString ];
    self.self.hp_ShouNameTextField.text = @"";
    self.hp_ShouPhoneTextField.text = @"";
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


#pragma mark - UITextFieldDelegate
/// 字符变化
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([string isEqualToString:@"\n"])
//    {
//        return YES;
//    }
//    
//    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
//    NSLog(@"%@",toBeString);
//    if (textField == self.productName && toBeString.length > 20) {
//        textField.text = [toBeString substringToIndex:20];
//        [Tools showHUD:@"物品名称不能超过20个字"];
//        return NO;
//    }
//    
//    if (textField == self.remark && toBeString.length > 30) {
//        textField.text = [toBeString substringToIndex:20];
//        [Tools showHUD:@"备注不能超过30个字"];
//        return NO;
//    }
//    
//    return YES;
//}

@end
