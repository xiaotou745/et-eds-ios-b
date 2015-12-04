//
//  SSAddressInfo.h
//  ESend
//
//  Created by 台源洪 on 15/11/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"
#import <BaiduMapAPI/BMapKit.h>

@interface SSAddressInfo : BaseModel

@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * uid;
@property (nonatomic,copy) NSString * address;
@property (nonatomic,copy) NSString * city;
@property (nonatomic,copy) NSString * latitude;
@property (nonatomic,copy) NSString * longitude;

@property (nonatomic,copy) NSString * addition;

@property (nonatomic,assign) BOOL selected;

- (instancetype)initWithBMKPoiInfo:(BMKPoiInfo *)poi;

- (BOOL)sameTo:(SSAddressInfo *)anAddr;

@end
