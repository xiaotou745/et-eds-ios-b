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

@interface SSEditAdderssViewController ()<UITextFieldDelegate,BMKPoiSearchDelegate,BMKLocationServiceDelegate,UITableViewDataSource,UITableViewDelegate>
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

@end

@implementation SSEditAdderssViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(SSAddressEditorType)type {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.type = type;
        //
        _POIs = [[NSMutableArray alloc] initWithCapacity:0];
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
}

- (void)addressTextChanged:(NSNotification *)notify{
    BMKNearbySearchOption *option = [[BMKNearbySearchOption alloc] init];
    option.pageIndex = 0;
    option.pageCapacity = 10;
    option.location = self.locCoordinate;
    option.radius = 5;
    option.keyword = ((UITextField *)(notify.object)).text;
    option.sortType = BMK_POI_SORT_BY_DISTANCE;
    BOOL flag = [_searcher poiSearchNearBy:option];
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
//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated{
    _searcher.delegate = nil;
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
        cell.addressInfo = [_POIs objectAtIndex:indexPath.row];
        [cell hideDeleteBtn];
        return cell;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    id a = [_POIs objectAtIndex:indexPath.row];
    NSLog(@"%@",a);
    [_POITable removeFromSuperview];
}

@end
