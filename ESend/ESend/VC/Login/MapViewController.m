//
//  MapViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/2.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MapViewController.h"
#import "DataBase.h"

@interface MapViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>
{
    BMKMapView *_mapView;
    BMKLocationService *_locService;
    BMKGeoCodeSearch *_searcher;
    DataBase *_dataBase;
}

@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self beginLoacation ];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    _mapView.delegate = self;
    if (_locationCoordinate2D.latitude != 0) {
        _mapView.centerCoordinate = _locationCoordinate2D;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    _mapView.delegate = nil;
}

- (void)initializeData {
    _dataBase = [DataBase shareDataBase];
}


- (void)bulidView {
    
    self.titleLabel.text = @"地址选择";
    
    [self.rightBtn setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightBtn addTarget:self action:@selector(saveAddress:) forControlEvents:UIControlEventTouchUpInside];
    self.rightBtn.enabled = YES;
    
    _mapView = [[BMKMapView alloc]initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64)];
    _mapView.zoomLevel = 18;
    _mapView.showsUserLocation = YES;
    [self.view addSubview:_mapView];
    
    UIImageView *view= [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 23, 30)];
    view.center = CGPointMake(MainWidth/2,(ScreenHeight-64)/2 + 64 - 15);
    view.image = [UIImage imageNamed:@"map_icon"];
    [self.view addSubview:view];
    
    //设置定位精确度，默认：kCLLocationAccuracyBest
    [BMKLocationService setLocationDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    //指定最小距离更新(米)，默认：kCLDistanceFilterNone
    [BMKLocationService setLocationDistanceFilter:100.f];
    
}

- (void)beginLoacation {
    
    if (!_locService) {
        //初始化BMKLocationService
        _locService = [[BMKLocationService alloc]init];
        _locService.delegate = self;
    }
    
    //启动LocationService
    [_locService startUserLocationService];
}

//实现相关delegate 处理位置信息更新
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [_mapView setCenterCoordinate:userLocation.location.coordinate animated:YES];
    [_locService stopUserLocationService];
    
    _searcher =[[BMKGeoCodeSearch alloc]init];
    _searcher.delegate = self;
    
    //发起反向地理编码检索
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = userLocation.location.coordinate;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if(flag) {
      NSLog(@"反geo检索发送成功");
    } else {
      NSLog(@"反geo检索发送失败");
    }
}

- (void)saveAddress:(UIButton *)sender {
    
    self.rightBtn.enabled= NO;
    
    if (!_searcher) {
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }

    
    CLLocationCoordinate2D newcoor = [_mapView convertPoint:CGPointMake(MainWidth/2,(ScreenHeight-64)/2 + 64) toCoordinateFromView:self.view];
    
    NSLog(@"%lf %lf",newcoor.latitude, newcoor.longitude);
    
    BMKReverseGeoCodeOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeOption alloc] init];
    reverseGeoCodeSearchOption.reverseGeoPoint = newcoor;
    BOOL flag = [_searcher reverseGeoCode:reverseGeoCodeSearchOption];
    if (flag) {
        NSLog(@"反geo检索发送成功");
    } else {
        NSLog(@"反geo检索发送失败");
        [Tools showHUD:@"定位失败！"];
        self.rightBtn.enabled= YES;

    }
    
    
}

//接收反向地理编码结果
-(void) onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error{
  if (error == BMK_SEARCH_NO_ERROR) {
      //在此处理正常结果
      
      if (!_dataBase) {
          _dataBase = [DataBase shareDataBase];
      }

      NSString *addres = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",result.addressDetail.province, result.addressDetail.city, result.addressDetail.district, result.addressDetail.streetName, result.addressDetail.streetNumber];
      CLog(@"%@",addres);
      
      if (!isCanUseString(result.addressDetail.city)) {
          [Tools showHUD:@"该地区暂未开通"];
          return;
      }
      
      OriginModel *origin = [_dataBase getDistrictWithName:result.addressDetail.district city:result.addressDetail.city];
      NSLog(@"%@",origin);
      if (origin.idCode == 0) {
          [Tools showHUD:@"该地区暂未开通"];
          return;
      }
      
      if ([_delegate respondsToSelector:@selector(mapViewControllerFinshLoacation:origin:)]) {
          [_delegate mapViewControllerFinshLoacation:result origin:origin];
      }
      

      if (self.rightBtn.enabled == NO) {
          if (self.navigationController.topViewController == self) {
              self.rightBtn.enabled = YES;

              [self.navigationController popViewControllerAnimated:YES];
          }
      }
      
  }
  else {
      [Tools showHUD:@"未找到结果"];
      NSLog(@"抱歉，未找到结果");
      self.rightBtn.enabled = YES;
  }
}




@end
