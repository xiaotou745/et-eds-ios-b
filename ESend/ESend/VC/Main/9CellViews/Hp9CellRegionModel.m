//
//  Hp9CellRegionModel.m
//  ESend
//
//  Created by 台源洪 on 15/11/3.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "Hp9CellRegionModel.h"

@implementation Hp9CellRegionModel

- (id)initWithDic:(NSDictionary *)dic{
    if (self = [super init]) {
        self.regionName = [dic objectForKey:@"regionName"];
        self.regionId = [[dic objectForKey:@"id"] integerValue];
        NSMutableArray * secondaryRegionList = [[NSMutableArray alloc] initWithCapacity:0];
        for (NSDictionary * adict in [dic objectForKey:@"twoOrderRegionList"]) {
            Hp9cellSecondaryRegion * secondaryRegion = [[Hp9cellSecondaryRegion alloc] initWithDic:adict];
            [secondaryRegionList addObject:secondaryRegion];
        }
        self.twoOrderRegionList = [[NSArray alloc] initWithArray:secondaryRegionList];
        
        //
        self.orderCount = 0;
    }
    return self;
}

@end
