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

@interface SSHomepageViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,SSAppointmentTimeViewDelegate>{
    SSAppointmentTimeView * _appointTimeView;
    dispatch_source_t _timer;
}
@property (strong, nonatomic) IBOutlet UIScrollView *scroller;

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

// 名称 备注
@property (strong, nonatomic) IBOutlet UITextField *productName;
@property (strong, nonatomic) IBOutlet UITextField *remark;

// 手机号，验证码
@property (strong, nonatomic) IBOutlet UIButton *getVerCodeAction;
@property (strong, nonatomic) IBOutlet UITextField *hp_myPhoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *hp_myVerCodeTextField;
///

@property (strong, nonatomic) IBOutlet UIButton *hp_nextBtn;
@property (strong, nonatomic) IBOutlet UILabel *hp_totalFeeLabel;

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
    // tap
    UITapGestureRecognizer * tapNow = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickTimeType:)];
    UITapGestureRecognizer * tapAppointment = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pickTimeType:)];
    [self.hp_PickNowBgView addGestureRecognizer:tapNow];
    [self.hp_pickAppointmentBgView addGestureRecognizer:tapAppointment];
    //
    [self.getVerCodeAction setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];

    [self.hp_nextBtn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
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
    }
}

#pragma mark - outlet actions
- (IBAction)addKilo:(UIButton *)sender {
    [self.kiloTextField resignFirstResponder];
    self.kiloTextField.text = [NSString stringWithFormat:@"%ld",++self.api_kilo];
}

- (IBAction)minusKilo:(UIButton *)sender {
    [self.kiloTextField resignFirstResponder];
    if (self.api_kilo == 0) {
        return;
    }
    self.kiloTextField.text = [NSString stringWithFormat:@"%ld",--self.api_kilo];
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
    MineViewController *vc = [[MineViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}
- (IBAction)getVerCodeBtnAction:(UIButton *)sender {
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
        BMKMapPoint point1 = BMKMapPointForCoordinate(self.api_addr_fa.coordinate);
        BMKMapPoint point2 = BMKMapPointForCoordinate(self.api_addr_shou.coordinate);
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2); //m
        self.api_distance = distance/1000;
        self.hp_distanceLabel.text = [NSString stringWithFormat:@"%.2f",self.api_distance];
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
}

- (NSString *)currentDateString{
    NSDate * date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];
    return [localeDate km_simpleToString];
}

@end
