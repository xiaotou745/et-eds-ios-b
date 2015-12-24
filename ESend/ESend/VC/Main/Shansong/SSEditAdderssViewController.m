//
//  SSEditAdderssViewController.m
//  ESend
//
//  Created by 台源洪 on 15/11/26.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSEditAdderssViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "SSAdressCell.h"
#import "SSAddrAdditionViewController.h"
#import "DataArchive.h"
#import "UserInfo.h"
#import "UIColor+KMhexColor.h"


@interface SSEditAdderssViewController ()<UITextFieldDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate,SSAdressCellDelegate>
{
    BMKPoiSearch * _searcher;
    BMKLocationService * _locService;
    
    UITableView * _POITable;
}
@property (nonatomic,assign) SSAddressEditorType type;
@property (nonatomic,assign) CLLocationCoordinate2D locCoordinate;

@property (strong, nonatomic) IBOutlet UITextField *addressTextField;
@property (strong, nonatomic) IBOutlet UIView *headerBg;
@property (strong, nonatomic) IBOutlet UIImageView *headerImg;

@property (strong, nonatomic) NSMutableArray * POIs;

@property (strong, nonatomic) IBOutlet UITableView *historyTable;
@property (strong, nonatomic) NSMutableArray * historyAddrs;

@end

@implementation SSEditAdderssViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(SSAddressEditorType)type {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.type = type;
        //
        _POIs = [[NSMutableArray alloc] initWithCapacity:0];
        _historyAddrs = [[NSMutableArray alloc] initWithCapacity:0];
        //初始化检索对象
        _searcher =[[BMKPoiSearch alloc] init];
        _searcher.delegate = self;
        _locService = [[BMKLocationService alloc] init];
        _locService.delegate = self;
        [_locService startUserLocationService];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = [SSEditorTypeTransformer titleStringWithEditorType:self.type];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addressTextChanged:) name:UITextFieldTextDidChangeNotification object:self.addressTextField];
    self.headerImg.image = [SSEditorTypeTransformer imageWithEditorType:self.type];
    self.addressTextField.placeholder = (self.type == SSAddressEditorTypeFa)?@"请输入发货地址":@"请输入收货地址";
    
    NSArray * faAddrs = [DataArchive storedFaAddrsWithBusinessId:[UserInfo getUserId]];
    NSArray * ShouAddrs = [DataArchive storedShouAddrsWithBusinessId:[UserInfo getUserId]];
//    NSLog(@"fff -- %@",faAddrs);
//    for (SSAddressInfo * ind in ShouAddrs) {
//        
//        NSLog(@"sss -- %@",ind);
//        NSLog(@"%@ - %@",ind.uid,ind.name);
//
//    }
    
    if (self.type == SSAddressEditorTypeFa) {
        [_historyAddrs addObjectsFromArray:faAddrs];
    }else if (self.type == SSAddressEditorTypeShou){
        [_historyAddrs addObjectsFromArray:ShouAddrs];
    }
    
    if (_historyAddrs.count > 0) {
        _historyTable.hidden = NO;
        [_historyTable reloadData];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.addressTextField becomeFirstResponder];
}

- (void)addressTextChanged:(NSNotification *)notify{
    BMKCitySearchOption *option = [[BMKCitySearchOption alloc] init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.city = isCanUseString(self.currentCityName)?self.currentCityName:@"北京";
    option.keyword = ((UITextField *)(notify.object)).text;
    BOOL flag = [_searcher poiSearchInCity:option];
    if(flag){
        NSLog(@"周边检索发送成功");
    }else{
        NSLog(@"周边检索发送失败");
    }
}

- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    self.locCoordinate = userLocation.location.coordinate;
    [_locService stopUserLocationService];
}

//不使用时将delegate设置为 nil
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_searcher) {
        _searcher.delegate = nil;
    }
    if (_locService) {
        _locService.delegate = nil;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BMKPoiSearchDelegate
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        if (poiResultList.poiInfoList.count > 0) {
            [_POIs removeAllObjects];
            for (BMKPoiInfo * poiInfo in poiResultList.poiInfoList) {
                SSAddressInfo * addrInfo = [[SSAddressInfo alloc] initWithBMKPoiInfo:poiInfo];
                [_POIs addObject:addrInfo];
            }
            [self displayPOIList];
        }
        //在此处理正常结果
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}



- (void)displayPOIList{
    if (!_POITable) {
        _POITable = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.headerBg.frame) + 10, ScreenWidth, ScreenHeight - CGRectGetMaxY(self.headerBg.frame) - 10) style:UITableViewStylePlain];
        _POITable.dataSource = self;
        _POITable.delegate = self;
        _POITable.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _POITable.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    [self.view addSubview:_POITable];
    [_POITable reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _POITable) {
        return _POIs.count;
    }else if (tableView == self.historyTable){
        return _historyAddrs.count;
    }else{
        return 0;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _POITable) {
        static NSString * EApoiTableCellId = @"EApoiTableCellId";
        SSAdressCell * cell = [tableView dequeueReusableCellWithIdentifier:EApoiTableCellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSAdressCell class]) owner:self options:nil] lastObject];
        }
        cell.cellStyle = SSAdressCellStylePOI;
        cell.addressInfo = [_POIs objectAtIndex:indexPath.row];
        [cell hideDeleteBtn];
        return cell;
    }else if (tableView == self.historyTable){
        static NSString * EAhistoryTableCellId = @"EAhistoryTableCellId";
        SSAdressCell * cell = [tableView dequeueReusableCellWithIdentifier:EAhistoryTableCellId];
        if (nil == cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSAdressCell class]) owner:self options:nil] lastObject];
        }
        cell.cellStyle = SSAdressCellStyleHistory;
        cell.addressInfo = [_historyAddrs objectAtIndex:indexPath.row];
        cell.delegate = self;
        return cell;
    }else{
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _POITable) {
        return 55;
    }else if (tableView == self.historyTable){
        return 55;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.historyTable) {
        return 25;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (tableView == self.historyTable) {
        UIView * aView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 25)];
        aView.backgroundColor = BackgroundColor;
        UILabel * aLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, ScreenWidth - 12, 25)];
        aLabel.backgroundColor = [UIColor clearColor];
        aLabel.text = @"历史地址";
        aLabel.font = [UIFont systemFontOfSize:13];
        aLabel.textAlignment = NSTextAlignmentLeft;
        aLabel.textColor = [UIColor km_colorWithHexString:@"888888"];
        [aView addSubview:aLabel];
        return aView;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == _POITable) {
        SSAddressInfo *info = [_POIs objectAtIndex:indexPath.row];
        // NSLog(@"%@",a);
        // [_POITable removeFromSuperview];
        SSAddrAdditionViewController * aavc = [[SSAddrAdditionViewController alloc] initWithNibName:NSStringFromClass([SSAddrAdditionViewController class]) bundle:nil Type:self.type Addr:info];
        [self.navigationController pushViewController:aavc animated:YES];
    }else if (tableView == self.historyTable){
        SSAddressInfo *info = [_historyAddrs objectAtIndex:indexPath.row];
        if ([self.delegate respondsToSelector:@selector(editAddressVC:didSelectHistroyAddr:type:)]) {
            [self.delegate editAddressVC:self didSelectHistroyAddr:info type:self.type];
        }
        [self.navigationController popViewControllerAnimated:YES];
    }

}

- (IBAction)mapAddrAction:(UIButton *)sender {
    SSMapAddrViewController * mavc = [[SSMapAddrViewController alloc] initWithNibName:NSStringFromClass([SSMapAddrViewController class]) bundle:nil Type:self.type];
    [self.navigationController pushViewController:mavc animated:YES];
}

#pragma mark - SSAdressCellDelegate
- (void)deleteAddressWithId:(NSString *)uid{
    for (SSAddressInfo * addrInfo in _historyAddrs) {
        if ([addrInfo.uid isEqualToString:uid]) {
            [_historyAddrs removeObject:addrInfo];
            break;
        }
    }
    [self.historyTable reloadData];
    if (_historyAddrs.count <= 0) {
        self.historyTable.hidden = YES;
    }
    
    if (self.type == SSAddressEditorTypeFa) {
        [DataArchive deleteFaAddrWithId:uid bid:[UserInfo getUserId]];
    }else if (self.type == SSAddressEditorTypeShou){
        [DataArchive deleteShouAddrWithId:uid bid:[UserInfo getUserId]];
    }
}
@end
