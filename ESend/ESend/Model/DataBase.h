//
//  DataBase.h
//  FoodMaterial
//
//  Created by 永来 付 on 14-9-24.
//  Copyright (c) 2014年 shicaiguanjia. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "OriginModel.h"

typedef NS_ENUM(NSInteger, AddressType) {
    AddressTypeBusiness = 1,           /**< 商户地址列表 */
    AddressTypeBank                     /**< 银行地址列表 */
};

@interface DataBase : NSObject
{
    FMDatabase *_dataBase;
}

+ (id)shareDataBase;

- (void)updateCityListData:(NSArray*)list;                  /**< 升级商户地区列表 */
- (void)updateBankCityData:(NSArray*)bankCityList; /**< 升级银行地区列表 */

- (OriginModel*)getDistrictWithName:(NSString*)name city:(NSString*)city;

- (NSMutableArray*)getProvinceWithAddressType:(AddressType)addressType;
- (NSMutableArray*)getCityListWithProvince:(NSInteger)provinceId withAddressType:(AddressType)addressType;

//- (NSString*)getAddressWithCountyId:(NSString*)countyId;
//
//- (NSMutableArray*)getAllProvice;
//- (NSMutableArray*)getCityListWithPrivinceId:(NSInteger)provinceId;
//- (NSMutableArray*)getCountyListWithCityId:(NSInteger)cityId;
//
//- (NSMutableArray *)searchCountyWihstring:(NSString *)str ;
//
//- (NSMutableDictionary*)getAllCommunity;
//- (NSMutableDictionary*)getCommunityListWithCountyId:(NSInteger)CountyId ;
//
//- (NSMutableArray*)getAllCountyWithCityId:(NSInteger)cityId;

@end
