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
#import "SSTipSelectionView.h"
#import "NSString+stringSizes.h"
#import "UIAlertView+Blocks.h"
#import "ETSGuideView.h"

#define SS_HPWrongPhoneNumberMsg @"请输入正确的手机号"
#define SS_HPNoFaAddressMsg @"请输入发货地址"
#define SS_HPNoShouAddressMsg @"请输入收货地址"

#define SS_HpMaxKilo @"重量不能超过500公斤"
#define SS_HpMinKilo @"重量不少于1公斤"

#define SS_HpMaxDistance @"距离不能超过500公里"

#define SS_HpNoMyCellPhoneMsg @"请输入您的手机号"
#define SS_HpNoMyCodeMsg @"请输入验证码"

#define SS_HpFaShouSamePhoneMsg @"发货收货电话不能相同"

#define SS_PriceConfigChangedMsg(amount) [NSString stringWithFormat:@"该账号已设置计费规则，实际配送费为%@元",amount]

@interface SSHomepageViewController ()<UINavigationControllerDelegate,UITextFieldDelegate,ABPeoplePickerNavigationControllerDelegate,SSAppointmentTimeViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,BMKRouteSearchDelegate,SSTipSelectionViewDelegate,ETSGuideViewDelegate>{
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

// 公斤
@property (nonatomic, assign) NSInteger api_kilo;
@property (strong, nonatomic) IBOutlet UITextField *kiloTextField;
// 距离
@property (nonatomic, assign) double api_distance;
@property (strong, nonatomic) IBOutlet UILabel *hp_distanceLabel;
@property (weak, nonatomic) IBOutlet UIButton *hp_priceRuleBtn;
// 小费
@property (weak, nonatomic) IBOutlet UIButton *tipSelectionBtn;
@property (nonatomic,assign) double api_tip;
// 取货时间
@property (nonatomic,assign) BOOL api_pick_now;
@property (nonatomic,copy) NSString * api_pick_time;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hp_timePickBtnWidth;
@property (weak, nonatomic) IBOutlet UIButton *hp_timePickBtn;

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
@property (nonatomic,strong) NSArray * priceRuleList;
/// 后台返回的总价格，以此为准
@property (assign, nonatomic) double api_server_amount;

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shanSongUserLogin) name:LoginNotification object:nil];
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
    if (!_locService) {
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    [_locService startUserLocationService];
    _searcher.delegate = self;
    
    if ([UserInfo isLogin]){
        NSArray * faAddrs = [DataArchive storedFaAddrsWithBusinessId:[UserInfo getUserId]];
        if (faAddrs.count >= 1) {
            SSAddressInfo * lastAddr = [faAddrs lastObject];
            self.api_addr_fa = lastAddr;
            self.api_addr_fa_hasValue = YES;
            self.hp_FaAddrLabel.text = [NSString stringWithFormat:@"%@(%@)%@",lastAddr.name,lastAddr.address,lastAddr.addition];
            self.hp_FaAddrLabel.textColor = DeepGrey;
            self.hp_FaAddrPhoneLabel.text = lastAddr.personPhone;
            self.hp_FaAddrPersonNameLabel.text = [lastAddr.personName stringByAppendingString:lastAddr.genderIsWoman?@"女士":@"先生"];
        }
    }
    // 计算价格公式
    [self getPriceRule];
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
    return [NSArray arrayWithObjects:@"api_addr_fa_hasValue", @"api_addr_shou_hasValue",@"api_distance",@"api_total_fee",@"api_tip", nil];
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
        if (self.api_distance <= 0.1) {
            self.hp_distanceLabel.text = [NSString stringWithFormat:@"0.1"];
        }else{
            self.hp_distanceLabel.text = [NSString stringWithFormat:@"%.1f",self.api_distance];
        }
        [self calculateAndDisplayTotalFee];
    }
    if ([keyPath isEqualToString:@"api_total_fee"]) {// 总价
        self.hp_totalFeeLabel.text = [NSString stringWithFormat:@"¥ %.2f",self.api_total_fee];
    }
    if ([keyPath isEqualToString:@"api_tip"]) { // 小费
        NSNumber * tipNumber = [NSNumber numberWithDouble:self.api_tip];
        [self.tipSelectionBtn setTitle:[NSString stringWithFormat:@"%@元",tipNumber] forState:UIControlStateNormal];
        [self calculateAndDisplayTotalFee];
    }
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // 添加引导页
    if (nil == [[NSUserDefaults standardUserDefaults] valueForKey:USERDEFSULTS_KEY_FIRST_START]) {
        ETSGuideView * guideView = [[ETSGuideView alloc] initWithView:self.view];
        [guideView setDelegate:self];
        NSMutableArray * imgArray = [[NSMutableArray alloc] initWithCapacity:3];
        NSString * deviceInfo = nil;
        if (iPhone6plus) {
            deviceInfo = @"6+";
        }else if (isiPhone5){
            deviceInfo = @"5";
        }else if (isiPhone4){
            deviceInfo = @"4";
        }else{
            deviceInfo = @"6";
        }
        for (int i = 0; i < 3; i++)
        {
            NSString * imgName = [NSString stringWithFormat:@"iph%@%d",deviceInfo,i + 1];
            [imgArray addObject:imgName];
        }
        [guideView guideViewWithArray:imgArray];
    }
}

- (void)guideView:(ETSGuideView *)guideView didTouchFinishButton:(id)button{
    if (guideView)
    {
        __block ETSGuideView * guideViewBlock = guideView;
        [[NSUserDefaults standardUserDefaults] setValue:@"yes" forKey:USERDEFSULTS_KEY_FIRST_START];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UIView animateWithDuration:0.8 animations:^{
            guideViewBlock.alpha = 0.0;
            guideViewBlock.transform = CGAffineTransformMakeScale(1.2, 1.2);
        } completion:^(BOOL finished) {
            for (int i = 0; i < [guideView subviews].count; i++) {
                UIView *aWelcomeView = [guideViewBlock subviews][i];
                [aWelcomeView removeFromSuperview];
                aWelcomeView = nil;
                //[[NSNotificationCenter defaultCenter] postNotificationName:firstShowUpShopListVc object:nil];
            }
            [guideView removeFromSuperview];
            guideViewBlock = nil;
        }];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
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

- (IBAction)tipSelectionAction:(UIButton *)sender {
    [Tools hiddenKeyboard];
    [SSHttpReqServer getOrderTipDetailSsuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSDictionary * result = [responseObject objectForKey:@"result"];
            NSArray * tiplist = [result objectForKey:@"list"];
            NSMutableArray * tipAmoutObjs = [NSMutableArray array];
            for (NSDictionary * tipModel in tiplist) {
                double amount = [[tipModel objectForKey:@"amount"] doubleValue];
                NSNumber * amoutObj = [NSNumber numberWithDouble:amount];
                [tipAmoutObjs addObject:amoutObj];
            }
            SSTipSelectionView * tipSelectView = [[SSTipSelectionView alloc] initWithDelegate:self tips:tipAmoutObjs];
            [tipSelectView showInView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

- (IBAction)timePickBtnAction:(UIButton *)sender {
    [Tools hiddenKeyboard];
    SSAppointmentTimeView * atv = [[SSAppointmentTimeView alloc] initWithDelegate:self];
    [atv showInView:self.view];
}

- (void)clickMyOrders{
    [Tools hiddenKeyboard];
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
    [Tools hiddenKeyboard];
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
        [[responseObject objectForKey:@"status"] integerValue];
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
    [Tools hiddenKeyboard];
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
    if ([self.api_addr_fa.personPhone compare:self.api_addr_shou.personPhone] == NSOrderedSame) {
        [Tools showHUD:SS_HpFaShouSamePhoneMsg];
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
    [Tools hiddenKeyboard];
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
    if (textField == self.productName && textField.text.length > 10) {
        textField.text = [textField.text substringToIndex:10];
        [Tools showHUD:@"物品名称不能超过10个字"];
    }
    if (textField == self.remark && textField.text.length > 30) {
        textField.text = [textField.text substringToIndex:30];
        [Tools showHUD:@"备注不能超过30个字"];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
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
- (void)SSAppointmentTimeView:(SSAppointmentTimeView*)view selectedDate:(NSString *)date rightNow:(BOOL)rightNow{
    self.api_pick_now = rightNow;
    NSString * dateStr = nil;
    if (rightNow) {
        self.api_pick_time = [self currentDateString];
        dateStr = @"立即取货";
    }else{
        self.api_pick_time = date;
        dateStr = [self.api_pick_time substringWithRange:NSMakeRange(0, self.api_pick_time.length - 3)];
    }
    [self.hp_timePickBtn setTitle:dateStr forState:UIControlStateNormal];
    CGFloat dateStrWidth = [dateStr stringSizeWidthWithFontSize:14 height:20];
    NSLog(@"%@",self.api_pick_now?@"yes":@"no");
    NSLog(@"str width %f",dateStrWidth);
    self.hp_timePickBtnWidth.constant = dateStrWidth + 25;
    
    
//    UIAlertView * av = [[UIAlertView alloc] initWithTitle:self.api_pick_now?@"Yes":@"No" message:dateStr delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles:nil, nil];
//    [av show];
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
                                @"pubname":self.hp_FaAddrPersonNameLabel.text,
                                @"islogin":[UserInfo isLogin]?@"true":@"false",
                                @"publongitude":self.api_addr_fa.longitude,
                                @"publatitude":self.api_addr_fa.latitude,
                                @"pubphoneno":self.hp_FaAddrPhoneLabel.text,
                                @"pubaddress":[NSString stringWithFormat:@"%@(%@)%@",self.api_addr_fa.name,self.api_addr_fa.address,self.api_addr_fa.addition],
                                @"taketype":self.api_pick_now?@"0":@"1",
                                @"currentlongitude":[NSNumber numberWithDouble:currentlongitude],
                                @"currentlatitude":[NSNumber numberWithDouble:currentlatitude],
                                @"taketime":self.api_pick_time,
                                @"recevicename":self.hp_ShouAddrPersonNameLabel.text,
                                @"recevicephoneno":self.hp_ShouAddrPhoneLabel.text,
                                @"receviceaddress":[NSString stringWithFormat:@"%@(%@)%@",self.api_addr_shou.name,self.api_addr_shou.address,self.api_addr_shou.addition],
                                @"recevicelongitude":self.api_addr_shou.longitude,
                                @"recevicelatitude":self.api_addr_shou.latitude,
                                @"productname":(self.productName.text == nil)?@"":self.productName.text,
                                @"remark":(self.remark.text == nil)?@"":self.remark.text,
                                @"amount":[NSNumber numberWithDouble:self.api_total_fee - self.api_tip],
                                @"weight":[NSNumber numberWithInteger:self.api_kilo],
                                @"km":[NSNumber numberWithDouble:self.api_distance],
                                @"tipamount":[NSNumber numberWithDouble:self.api_tip],
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{@"data":aesString,};
    }
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@"订单生成中…"];
    [SSHttpReqServer orderflashpush:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        NSString * message = [responseObject objectForKey:@"message"];
        if (status == 1) {
            if (isCanUseObj([[responseObject objectForKey:@"result"] objectForKey:@"amount"])) {// 前后台计算价格不相同，发单失败，弹框
                self.api_server_amount = [[[responseObject objectForKey:@"result"] objectForKey:@"amount"] doubleValue];
                // 弹出窗口
                NSNumber * showNumber = [NSNumber numberWithDouble:self.api_server_amount+self.api_tip];
                [UIAlertView showAlertViewWithTitle:nil message:SS_PriceConfigChangedMsg(showNumber) cancelButtonTitle:@"关闭" otherButtonTitles:@[@"确认"] onDismiss:^(NSInteger buttonIndex) {
                    self.api_total_fee = self.api_server_amount+self.api_tip;
                    [self releaseOrder];
                } onCancel:^{
                    
                }];
                
            }else{ // 前后台计算价格相同，发单成功
                // 本地缓存 ,收,发
                // uid  :  address{地址，经度，纬度，姓名，手机}
                NSDictionary * result = [responseObject objectForKey:@"result"];
                NSDictionary * uInfo = @{
                                         @"userId":[[responseObject objectForKey:@"result"] objectForKey:@"businessId"],
                                         };
                [UserInfo saveUserInfo:uInfo];
                if ([UserInfo isLogin]) {
                    [DataArchive storeFaAddress:self.api_addr_fa businessId:[UserInfo getUserId]];
                    [DataArchive storeShouAddress:self.api_addr_shou businessId:[UserInfo getUserId]];
                }
                //
                NSString * pickupCode = [NSString stringWithFormat:@"%@",[result objectForKey:@"pickupcode"]];
                SSpayViewController * svc = [[SSpayViewController alloc] initWithNibName:NSStringFromClass([SSpayViewController class]) bundle:nil];
                svc.orderId = [NSString stringWithFormat:@"%@",[result objectForKey:@"orderId"]];
                svc.balancePrice = [[result objectForKey:@"balanceprice"] doubleValue];
                svc.type = 1;
                svc.pickupcode = pickupCode;
                svc.tipAmount = self.api_total_fee;
                [self.navigationController pushViewController:svc animated:YES];
                // 清空内存？
                [self resetShansongData];
            }

        }else{
            [Tools showHUD:message];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
    }];
}
/// 获取计算价格公式
- (void)getPriceRule{
    _getPriceRuleCount++;
    NSDictionary * paraDict = @{
                                @"businessId":[UserInfo isLogin]?[UserInfo getUserId]:@"0",
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{@"data":aesString,};
    }
    [SSHttpReqServer gettaskdistributionconfigParam:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            self.priceRuleList = [responseObject objectForKey:@"result"];
            self.gotPriceRule = YES;
            self.hp_priceRuleBtn.hidden = NO;
            [self calculateAndDisplayTotalFee];
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
//    if (self.gotPriceRule && self.api_addr_fa_hasValue && self.api_addr_shou_hasValue) {// 获得计算规则，发收地理位置,重量(填)，距离（算）
//        self.api_total_fee = [self totalFeeWithPriceList:self.priceRuleList km:self.api_distance kg:self.api_kilo] + self.api_tip;
//    }
    if (self.gotPriceRule) {
        self.api_total_fee = [self totalFeeWithPriceList:self.priceRuleList km:self.api_distance kg:self.api_kilo] + self.api_tip;
    }
}

- (double)totalFeeWithPriceList:(NSArray *)list km:(double)km kg:(NSInteger)kg{
    double cost=0;
    if (list==nil)
        return cost;
    double baseKM = [list[0][@"kM"] doubleValue];
    double baseKG = [list[0][@"kG"] doubleValue];
    double baseDistributionPrice = [list[0][@"distributionPrice"] doubleValue];
    double kmDistributionPrice=0.0;
    for (int i = 1; i < list.count; i++){
        double currKM = [list[i][@"kM"] doubleValue];
        double currDistributionPrice = [list[i][@"distributionPrice"] doubleValue];
        int currSteps = [list[i][@"steps"] intValue];
        if(currKM>=baseKM && km>currKM){//获取第一个符合的值
            kmDistributionPrice = currDistributionPrice*ceil((km-currKM)/currSteps);
            break;
        }
    }
    double kgDistributionPrice=0.0;
    for (int i = 1; i < list.count; i++){
        double currKG = [list[i][@"kG"] doubleValue];
        double currDistributionPrice = [list[i][@"distributionPrice"] doubleValue];
        int currSteps = [list[i][@"steps"] intValue];
        if(currKG>=baseKG && kg>currKG){//获取第一个符合的值
            kgDistributionPrice = currDistributionPrice*ceil((kg-currKG)/currSteps);
            break;
        }
    }
    cost=baseDistributionPrice + kmDistributionPrice + kgDistributionPrice;
    return cost;
}

#pragma mark - BMKMapViewDelegate  BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation{
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
    MBProgressHUD *HUD = [Tools showProgressWithTitle:@""];
    NSDictionary * paraDict = @{
                                @"businessId":[UserInfo isLogin]?[UserInfo getUserId]:@"0",
                                };
    if (AES_Security) {
        NSString * jsonString2 = [Security JsonStringWithDictionary:paraDict];
        NSString * aesString = [Security AesEncrypt:jsonString2];
        paraDict = @{@"data":aesString,};
    }
    [SSHttpReqServer gettaskdistributionconfigParam:paraDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [Tools hiddenProgress:HUD];
        NSInteger status = [[responseObject objectForKey:@"status"] integerValue];
        if (1 == status) {
            NSArray * result = [responseObject objectForKey:@"result"];
            self.priceRuleList = result;
            NSString * remark = responseObject[@"message"];
            self.gotPriceRule = YES;
            self.hp_priceRuleBtn.hidden = NO;
            //
            [self calculateAndDisplayTotalFee];
            
            SSPriceTableView * priceTable = [[SSPriceTableView alloc] initWithRemark:remark];
            [priceTable showInView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [Tools hiddenProgress:HUD];
    }];
}


#pragma mark - 重置数据
- (void)resetShansongData{
    
    self.api_addr_shou = nil;
    self.api_addr_shou_hasValue = NO;
    self.hp_ShouAddrLabel.text = @"";
    self.hp_ShouAddrPersonNameLabel.text = @"";
    self.hp_ShouAddrPhoneLabel.text = @"";
    
    self.api_kilo= 1;
    self.kiloTextField.text = @"1";

    self.api_distance = 0;
    self.hp_distanceLabel.text = @"0";
    
    self.api_tip = 0;
    self.api_pick_now = YES;
    self.api_pick_time = [self currentDateString];
    NSString * dateStr = @"立即取货";
    [self.hp_timePickBtn setTitle:dateStr forState:UIControlStateNormal];
    CGFloat dateStrWidth = [dateStr stringSizeWidthWithFontSize:14 height:20];
    self.hp_timePickBtnWidth.constant = dateStrWidth + 25;
    //
    self.productName.text = @"";
    self.remark.text = @"";
    
    self.api_total_fee = 0;

    self.hp_myVerCodeTextField.text = @"";
}

- (void)shanSongUserLogout{
    
    self.api_addr_fa = nil;
    self.api_addr_fa_hasValue = NO;
    self.hp_FaAddrLabel.text = @"";
    self.hp_FaAddrPersonNameLabel.text = @"";
    self.hp_FaAddrPhoneLabel.text = @"";
    
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
        self.api_distance = (double)(plan.distance)/1000.0f;
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
    self.api_distance = distance/1000.0f;
}

#pragma mark - SSTipSelectionViewDelegate小费回调
- (void)SSTipSelectionView:(SSTipSelectionView*)view selectedTip:(NSNumber *)tip{
    self.api_tip = [tip doubleValue];
}



#pragma mark - 登录之后的通知
- (void)shanSongUserLogin{
    if ([UserInfo isLogin]){
        NSArray * faAddrs = [DataArchive storedFaAddrsWithBusinessId:[UserInfo getUserId]];
        if (faAddrs.count >= 1) {
            SSAddressInfo * lastAddr = [faAddrs lastObject];
            self.api_addr_fa = lastAddr;
            self.api_addr_fa_hasValue = YES;
            self.hp_FaAddrLabel.text = [NSString stringWithFormat:@"%@(%@)%@",lastAddr.name,lastAddr.address,lastAddr.addition];
            self.hp_FaAddrLabel.textColor = DeepGrey;
            self.hp_FaAddrPhoneLabel.text = lastAddr.personPhone;
            self.hp_FaAddrPersonNameLabel.text = [lastAddr.personName stringByAppendingString:lastAddr.genderIsWoman?@"女士":@"先生"];
        }
    }
}
@end
