//
//  SSMapAddrViewController.m
//  ESend
//
//  Created by 台源洪 on 15/11/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSMapAddrViewController.h"
#import "SSMapAddrCell.h"

@interface SSMapAddrViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BMKLocationService *_locService;
    UIImageView *_mapIcon;
    BMKGeoCodeSearch *_searcher;
    
    BOOL _selectPOIFlag;
}
@property (strong, nonatomic) IBOutlet BMKMapView *mapView;
@property (strong, nonatomic) NSMutableArray * addressList;
@property (strong, nonatomic) IBOutlet UITableView *addressTableView;

@end

@implementation SSMapAddrViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"地图选址";
    
    _searcher =[[BMKGeoCodeSearch alloc] init];
    _searcher.delegate = self;
    _addressList = [[NSMutableArray alloc] initWithCapacity:0];
    
    _mapView.zoomLevel = 18;
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
    _mapIcon= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 30)];
    _mapIcon.center = CGPointMake(MainWidth/2,(CGRectGetHeight(_mapView.frame)-64)/2 + 64 + 15);
    _mapIcon.image = [UIImage imageNamed:@"map_icon"];
    [self.view addSubview:_mapIcon];

    self.addressTableView.backgroundColor = BackgroundColor;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.delegate = self;
//    if (_locationCoordinate2D.latitude != 0) {
//        _mapView.centerCoordinate = _locationCoordinate2D;
//    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    _mapView.showsUserLocation = YES;
    if (!_locService) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    //启动LocationService
    [_locService startUserLocationService];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - BMKMapViewDelegate  BMKLocationServiceDelegate
//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [_locService stopUserLocationService];
}

- (void)mapView:(BMKMapView *)mapView regionWillChangeAnimated:(BOOL)animated{
    CGRect  imgRect = _mapIcon.frame;
    imgRect.origin.y -= 5;
    _mapIcon.frame = imgRect;
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated{
    CGRect  imgRect = _mapIcon.frame;
    imgRect.origin.y += 5;
    _mapIcon.frame = imgRect;
    
    CLLocationCoordinate2D newcoor = [_mapView convertPoint:CGPointMake(MainWidth/2,(self.mapView.frame.size.height)/2) toCoordinateFromView:self.mapView];
    NSLog(@"%lf %lf",newcoor.latitude, newcoor.longitude);
    
    if (!_selectPOIFlag) { // 非手动选择
        BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
        reverseGeoCodeSearchOption.reverseGeoPoint = newcoor;
        BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
        if (flag) {
            NSLog(@"反geo检索发送成功");
        } else {
            NSLog(@"反geo检索发送失败");
            [Tools showHUD:@"定位失败！"];
            
        }
    }
    _selectPOIFlag = NO;
}

#pragma mark - BMKGeoCodeSearchDelegate
//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
        [_addressList removeAllObjects];
        /*
         @property (nonatomic,copy) NSString * name;
         @property (nonatomic,copy) NSString * uid;
         @property (nonatomic,copy) NSString * address;
         @property (nonatomic,copy) NSString * city;
         @property (nonatomic,assign) CLLocationCoordinate2D coordinate;
         
         @property (nonatomic,copy) NSString * addition;
         */
        SSMapAddrInfo * mapAddr1 = [[SSMapAddrInfo alloc] init];
        mapAddr1.name = result.addressDetail.streetName;
        mapAddr1.address = result.address;
        mapAddr1.city = result.addressDetail.city;
        mapAddr1.coordinate = result.location;
        mapAddr1.selected = YES;
        [_addressList addObject:mapAddr1];
        
        for (BMKPoiInfo * info in result.poiList) {
            //NSLog(@"%f,%f",info.pt.latitude,info.pt.longitude);
            SSMapAddrInfo * mapAddr = [[SSMapAddrInfo alloc] initWithBMKPoiInfo:info];
            mapAddr.selected = NO;
            [_addressList addObject:mapAddr];
        }
        
        [self.addressTableView reloadData];
        [self.addressTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:YES];
        
    }else {
        [Tools showHUD:@"未找到结果"];
        NSLog(@"抱歉，未找到结果");
    }
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _addressList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString * mapAddrVCCellId = @"mapAddrVCCellId";
    SSMapAddrCell * cell = [tableView dequeueReusableCellWithIdentifier:mapAddrVCCellId];
    if (nil == cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([SSMapAddrCell class]) owner:self options:nil] lastObject];
    }
    cell.addrInfo = [_addressList objectAtIndex:indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * aHeader = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 10)];
    aHeader.backgroundColor = [UIColor clearColor];
    return aHeader;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self highlightThisIdx:indexPath.section];
    [tableView reloadData];
    SSMapAddrInfo * info = [_addressList objectAtIndex:indexPath.section];
    _selectPOIFlag = YES;
    [_mapView setCenterCoordinate:info.coordinate animated:YES];
    
}

#pragma mark - dealing datasource
- (void)highlightThisIdx:(NSInteger)section{
    for (int i = 0; i < _addressList.count; i++) {
        SSMapAddrInfo * aInfo = [_addressList objectAtIndex:i];
        aInfo.selected = (i == section);
    }
}

@end