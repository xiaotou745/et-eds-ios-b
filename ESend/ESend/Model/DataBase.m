//
//  DataBase.m
//  FoodMaterial
//
//  Created by 永来 付 on 14-9-24.
//  Copyright (c) 2014年 shicaiguanjia. All rights reserved.
//

#import "DataBase.h"

@implementation DataBase

- (id)init
{
    self = [super init];
    if (self) {
        
        NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [NSString stringWithFormat:@"%@/Address.sqlite",pathArray[0]];
        
        NSLog(@"%@",path);
        
        NSFileManager *manager = [NSFileManager defaultManager];
        if (![manager fileExistsAtPath:path]) {
            NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Address" ofType:@"sqlite"];
            [manager copyItemAtPath:filePath toPath:path error:nil];
        }

        _dataBase = [[FMDatabase alloc] initWithPath:path];
        [_dataBase open];
    }
    return self;
}

+ (id)shareDataBase
{
    static DataBase *dataBase;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        dataBase = [[DataBase alloc] init];
    });
    
    return dataBase;
}

#pragma mark-
#pragma mark 商户所在地区列表
- (void)updateCityListData:(NSArray*)list {
    
    if (list.count == 0) {
        return;
    }
    dispatch_queue_t urls_queue = dispatch_queue_create("saltlight.esend.com", NULL);
    dispatch_async(urls_queue, ^{
        BOOL success =  [_dataBase executeUpdate:@"delete from address"];
        NSLog(@"%d",success);
        if (!success) {
            return;
        }
        
        for (NSDictionary *dic in list) {
            NSString *sql = [NSString stringWithFormat:@"insert into address (id_code, name, level, parent_id) values ('%@','%@','%@','%@')",[dic objectForKey:@"Code"],[dic objectForKey:@"Name"], [dic objectForKey:@"JiBie"], [dic objectForKey:@"ParentId"] ];
            NSLog(@"business--%@",sql);
            BOOL success = [_dataBase executeUpdate:sql];
            NSLog(@"%d",success);
            
        }
    });
    

}

- (NSMutableArray*)getProvinceWithAddressType:(AddressType)addressType {
    
    
    NSMutableArray *provinceList = [NSMutableArray array];
    
    NSString *sql = @"";
    if (addressType == AddressTypeBusiness) {
        sql = [NSString stringWithFormat:@"select * from address where level = 1"];
    } else {
        sql = [NSString stringWithFormat:@"select * from bank_address where level = 1"];
    }
    NSLog(@"%@",sql);
    FMResultSet *result = [_dataBase executeQuery:sql];
    while ([result next]) {
        OriginModel *origin = [[OriginModel alloc] init];
        origin.name = [result stringForColumn:@"name"];
        origin.idCode = [result intForColumn:@"id_code"];
        origin.level = 1;
        [provinceList addObject:origin];
    }
    
    
    return provinceList;
}

- (NSMutableArray*)getCityListWithProvince:(NSInteger)provinceId withAddressType:(AddressType)addressType {
    
    NSMutableArray *cityList = [NSMutableArray array];
    NSString *sql = @"";
    if (addressType == AddressTypeBusiness) {
        sql = [NSString stringWithFormat:@"select * from address where level = 2 and parent_id = '%ld'",(long)provinceId];
    } else {
        sql = [NSString stringWithFormat:@"select * from bank_address where level = 2 and parent_id = '%ld'",(long)provinceId];
    }
    
    NSLog(@"%@",sql);
    
    FMResultSet *result = [_dataBase executeQuery:sql];
    while ([result next]) {
        OriginModel *origin = [[OriginModel alloc] init];
        origin.name = [result stringForColumn:@"name"];
        origin.idCode = [result intForColumn:@"id_code"];
        origin.level = 2;
        [cityList addObject:origin];
    }
    
    
    return cityList;
}


#pragma mark-
#pragma mark 获取银行地区列表
- (void)updateBankCityData:(NSArray*)bankCityList {
    
    if (bankCityList.count == 0) {
        return;
    }
    
   
    
    dispatch_queue_t urls_queue = dispatch_queue_create("saltlight.esend.com", NULL);
    dispatch_async(urls_queue, ^{
        
        BOOL success =  [_dataBase executeUpdate:@"delete from bank_address"];
        NSLog(@"%d",success);
        if (!success) {
            return;
        }
        
        for (NSDictionary *dic in bankCityList) {
            NSString *sql = [NSString stringWithFormat:@"insert into bank_address (id_code, name, level, parent_id) values ('%@','%@','%@','%@')",[dic objectForKey:@"Code"],[dic objectForKey:@"Name"], [dic objectForKey:@"JiBie"], [dic objectForKey:@"ParentId"]];
                         NSLog(@"%@",sql);
            BOOL success = [_dataBase executeUpdate:sql];
            NSLog(@"%d",success);
            
        }
    });
 
    
}

- (OriginModel*)getDistrictWithName:(NSString*)name city:(NSString*)city {

    OriginModel *origin = [[OriginModel alloc] init];
    
    NSString *sql = [NSString stringWithFormat:@"select * from address where name like '%%%@%%' and level = 3 and parent_id = (select id_code from address where name like '%%%@%%' and level = 2)", name, city];
    NSLog(@"%@",sql);
    
    FMResultSet *result = [_dataBase executeQuery:sql];
    while ([result next]) {
        
        origin.name = [result stringForColumn:@"name"];
        origin.idCode = [result intForColumn:@"id_code"];
        origin.parentId = [result intForColumn:@"parent_id"];
        origin.level = [result intForColumn:@"level"];
        NSLog(@"%@",origin.name);
    }
    
    if (origin.idCode != 0) {
        NSString *sql = [NSString stringWithFormat:@"select * from city where city like '%%%@%%' ", [city substringWithRange:NSMakeRange(0, origin.name.length - 1)]];
//        NSString *sql = [NSString stringWithFormat:@"select * from city"];
        NSLog(@"%@",sql);
        
        FMResultSet *result1 = [_dataBase executeQuery:sql];
        while ([result1 next]) {
            
            origin.zipCode = [result1 stringForColumn:@"number"];
            NSLog(@"%@",origin.zipCode);
        }
    }
    

    return origin;
}


#pragma mark-

- (NSString*)getAddressWithCountyId:(NSString*)countyId {
    NSString *countyName ;
    NSString *cityId;
    FMResultSet *result = [_dataBase executeQuery:[NSString stringWithFormat:@"select name,cityid from ChinaCounty where id = %@", countyId]];
    while ([result next]) {
        countyName = [result stringForColumn:@"name"];
        cityId = [result stringForColumn:@"cityid"];
    }
    
    NSString *cityName;
    NSString *provinceId;
    FMResultSet *result1 = [_dataBase executeQuery:[NSString stringWithFormat:@"select name,provinceId from ChinaCity where id = %@", cityId]];
    while ([result1 next]) {
        cityName = [result1 stringForColumn:@"name"];
        provinceId = [result1 stringForColumn:@"provinceId"];
    }
    
    NSString *provinceName;
    FMResultSet *result2 = [_dataBase executeQuery:[NSString stringWithFormat:@"select name from ChinaProvince where id = %@", provinceId]];
    while ([result2 next]) {
        provinceName = [result2 stringForColumn:@"name"];
    }
    
    return [NSString stringWithFormat:@"%@%@%@",provinceName, cityName, countyName];
    
    
}


@end
