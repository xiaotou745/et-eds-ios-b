//
//  EDSTaskListInRegionVC.m
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSTaskListInRegionVC.h"
#import "EDSTaskListInRegionCell.h"

#define TLIR_HeadButtonTagTrans 1104
#define TLIR_Table_1st_cellId @"TLIR_Table_1st_cellId"
#define TLIR_Table_2nd_cellId @"TLIR_Table_2nd_cellId"
#define TLIR_Table_3rd_cellId @"TLIR_Table_3rd_cellId"

@interface EDSTaskListInRegionVC ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate>
// header option
@property (strong, nonatomic) IBOutlet UIView *TLIR_OptionBgView;

@property (strong, nonatomic) IBOutlet UIButton *TLIR_OptionFirstBtn;
@property (strong, nonatomic) IBOutlet UIButton *TLIR_OptionSecondBtn;
@property (strong, nonatomic) IBOutlet UIButton *TLIR_OptionThirdBtn;

@property (strong, nonatomic) IBOutlet UIImageView *TLIR_OptionSeparator1;
@property (strong, nonatomic) IBOutlet UIImageView *TLIR_OptionSeparator2;

@property (strong, nonatomic) IBOutlet UIImageView *TLIR_OptionIndicator;

// tables
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *TLIR_TableScrollerWidth;
@property (strong, nonatomic) IBOutlet UIScrollView *TLIR_HorizonScroller;

@property (strong, nonatomic) IBOutlet UITableView *TLIR_TableFirst;
@property (strong, nonatomic) IBOutlet UITableView *TLIR_TableSecond;
@property (strong, nonatomic) IBOutlet UITableView *TLIR_TableThird;

// dataSource
@property (strong, nonatomic) NSMutableArray * TLIR_DataSourceFirst;
@property (strong, nonatomic) NSMutableArray * TLIR_DataSourceSecond;
@property (strong, nonatomic) NSMutableArray * TLIR_DataSourceThird;

@end

@implementation EDSTaskListInRegionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _TLIR_DataSourceFirst = [[NSMutableArray alloc] initWithCapacity:0];
    _TLIR_DataSourceSecond = [[NSMutableArray alloc] initWithCapacity:0];
    _TLIR_DataSourceThird = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self configOptionView];
}

- (void)updateViewConstraints{
    [super updateViewConstraints];
    self.TLIR_TableScrollerWidth.constant = ScreenWidth * 3;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    UIButton * abtn = (UIButton *)[self.view viewWithTag:self.selectedIndex + TLIR_HeadButtonTagTrans];
    NSLog(@"%@",abtn.currentAttributedTitle);
    [self optionButtonAction:abtn];
    
    self.titleLabel.text = self.TLIR_Title;
}

- (void)configOptionView{
    self.TLIR_OptionSeparator1.backgroundColor =
    self.TLIR_OptionSeparator2.backgroundColor = BackgroundColor;
    
    // optionView  buttons
    self.TLIR_OptionFirstBtn.tag = 1 + TLIR_HeadButtonTagTrans;
    self.TLIR_OptionSecondBtn.tag = 2 + TLIR_HeadButtonTagTrans;
    self.TLIR_OptionThirdBtn.tag = 3 + TLIR_HeadButtonTagTrans;
    
    //self.TLIR_OptionFirstBtn.enabled = NO;
    
    [self setOptionButton:self.TLIR_OptionFirstBtn count:0];
    [self setOptionButton:self.TLIR_OptionSecondBtn count:0];
    [self setOptionButton:self.TLIR_OptionThirdBtn count:0];
    
    self.TLIR_OptionFirstBtn.titleLabel.font =
    self.TLIR_OptionSecondBtn.titleLabel.font =
    self.TLIR_OptionThirdBtn.titleLabel.font = [UIFont systemFontOfSize:BigFontSize];
    self.TLIR_OptionFirstBtn.backgroundColor =
    self.TLIR_OptionSecondBtn.backgroundColor =
    self.TLIR_OptionThirdBtn.backgroundColor = [UIColor whiteColor];
    
    self.TLIR_OptionIndicator.backgroundColor = BlueColor;
}

- (void)configTableViews{
    [self.TLIR_TableFirst registerClass:[EDSTaskListInRegionCell class] forCellReuseIdentifier:TLIR_Table_1st_cellId];
    [self.TLIR_TableSecond registerClass:[EDSTaskListInRegionCell class] forCellReuseIdentifier:TLIR_Table_2nd_cellId];
    [self.TLIR_TableThird registerClass:[EDSTaskListInRegionCell class] forCellReuseIdentifier:TLIR_Table_3rd_cellId];
}

- (void)setOptionButton:(UIButton *)btn count:(long)count{
    NSString * tCount = (count>99)?[NSString stringWithFormat:@"99+"]:[NSString stringWithFormat:@"%ld",count];
    NSString * text = nil;
    if (btn.tag == 1 + TLIR_HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"待接单(%@)",tCount];
    }else if (btn.tag == 2 + TLIR_HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"待取货(%@)",tCount];
    }else if (btn.tag == 3 + TLIR_HeadButtonTagTrans) {
        text = [NSString stringWithFormat:@"配送中(%@)",tCount];
    }
    
    NSMutableAttributedString *AttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [AttributedString addAttribute:NSForegroundColorAttributeName value:DeepGrey range:NSMakeRange(0,AttributedString.length)];
    [btn setAttributedTitle:AttributedString forState:UIControlStateNormal];
    
    NSMutableAttributedString * hightedAttributedString = [[NSMutableAttributedString alloc] initWithString:text];
    [hightedAttributedString addAttribute:NSForegroundColorAttributeName value:BlueColor range:NSMakeRange(0, hightedAttributedString.length)];
    [btn setAttributedTitle:hightedAttributedString forState:UIControlStateDisabled];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat delta = ScreenWidth/6;
    if (scrollView == self.TLIR_HorizonScroller) {
        CGFloat movCenterY = self.TLIR_OptionIndicator.center.y;
        CGFloat newCenterX = scrollView.contentOffset.x/3 + delta;
        self.TLIR_OptionIndicator.center = CGPointMake(newCenterX, movCenterY);
        [self _configScrollOffSetPropertys:scrollView.contentOffset.x];
    }
}

- (void)_configScrollOffSetPropertys:(CGFloat)x{
    self.TLIR_OptionFirstBtn.enabled = (x == 0)?NO:YES;
    self.TLIR_TableFirst.scrollsToTop = !self.TLIR_OptionFirstBtn.enabled;
    self.TLIR_OptionSecondBtn.enabled = (x == ScreenWidth)?NO:YES;
    self.TLIR_TableSecond.scrollsToTop = !self.TLIR_OptionSecondBtn.enabled;
    self.TLIR_OptionThirdBtn.enabled = (x == ScreenWidth * 2)?NO:YES;
    self.TLIR_TableThird.scrollsToTop = !self.TLIR_OptionThirdBtn.enabled;
    
    if (0 == x) {
        
    }else if (ScreenWidth == x){
        
    }else if (ScreenWidth * 2 == x){
        
    }
}

- (IBAction)optionButtonAction:(UIButton *)sender {
    [self _buttonEventWithSender:sender];
    
}

- (void)_enableHeadBtns{
    self.TLIR_OptionFirstBtn.enabled = YES;
    self.TLIR_OptionSecondBtn.enabled = YES;
    self.TLIR_OptionThirdBtn.enabled = YES;
}

- (void)_buttonEventWithSender:(UIButton *)sender{
    [self _enableHeadBtns];
    sender.enabled = NO;
    [self.TLIR_HorizonScroller setContentOffset:CGPointMake(CGRectGetWidth([[UIScreen mainScreen] bounds])*(sender.tag - 1 - TLIR_HeadButtonTagTrans), 0) animated:YES];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    if (tableView == self.TLIR_TableFirst) {
//        return _TLIR_DataSourceFirst.count;
//    }else if (tableView == self.TLIR_TableSecond) {
//        return _TLIR_DataSourceSecond.count;
//    }else if (tableView == self.TLIR_TableThird) {
//        return _TLIR_DataSourceThird.count;
//    }else{
//        return 0;
//    }
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 10;
//}
//
//- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 20)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.TLIR_TableFirst) { // 待接单
        EDSTaskListInRegionCell *cell = [tableView dequeueReusableCellWithIdentifier:TLIR_Table_1st_cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EDSTaskListInRegionCell class]) owner:self options:nil] lastObject];
        }
        //[cell loadData:_Hp_ContentLists2nd[indexPath.section]];
        return cell;
    }else if (tableView == self.TLIR_TableSecond) {  // 待取货
        EDSTaskListInRegionCell *cell = [tableView dequeueReusableCellWithIdentifier:TLIR_Table_2nd_cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EDSTaskListInRegionCell class]) owner:self options:nil] lastObject];
        }
        //[cell loadData:_Hp_ContentLists2nd[indexPath.section]];
        return cell;
    }else if (tableView == self.TLIR_TableThird) {  // 配送中
        EDSTaskListInRegionCell *cell = [tableView dequeueReusableCellWithIdentifier:TLIR_Table_3rd_cellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([EDSTaskListInRegionCell class]) owner:self options:nil] lastObject];
        }
        //[cell loadData:_Hp_ContentLists2nd[indexPath.section]];
        return cell;
    }else{
        return nil;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (tableView == self.Hp_ContentList1st) { // 待接单
//        return [OrdersListTableVIewCell calculateCellHeight:[_Hp_ContentLists1st objectAtIndex:indexPath.section]];
//    }else if (tableView == self.Hp_ContentList2nd) {  // 待取货
//        return [OrdersListTableVIewCell calculateCellHeight:[_Hp_ContentLists2nd objectAtIndex:indexPath.section]];
//    }else if (tableView == self.Hp_ContentList3rd) {  // 配送中
//        return [OrdersListTableVIewCell calculateCellHeight:[_Hp_ContentLists3rd objectAtIndex:indexPath.section]];
//    }else{
//        return 0.0f;
//    }
    return 118;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    if (tableView == self.Hp_ContentList1st) { // 待接单
//        [self getOrderDetail:[_Hp_ContentLists1st objectAtIndex:indexPath.section] ];
//    }else if (tableView == self.Hp_ContentList2nd) {  // 待取货
//        [self getOrderDetail:[_Hp_ContentLists2nd objectAtIndex:indexPath.section] ];
//    }else if (tableView == self.Hp_ContentList3rd) {  // 配送中
//        [self getOrderDetail:[_Hp_ContentLists3rd objectAtIndex:indexPath.section] ];
//    }else{
//    }
}

@end
