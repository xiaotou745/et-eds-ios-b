//
//  MapViewController.h
//  ESend
//
//  Created by 永来 付 on 15/6/2.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseViewController.h"
#import <BaiduMapAPI/BMapKit.h>
#import "OriginModel.h"

@protocol MapViewControllerDelegate <NSObject>

- (void)mapViewControllerFinshLoacation:(BMKReverseGeoCodeResult*)addressCodeResult origin:(OriginModel*)origin;

@end


@interface MapViewController : BaseViewController

@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate2D;
@property (nonatomic, weak) id<MapViewControllerDelegate> delegate;

- (void)beginLoacation;

@end
