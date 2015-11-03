//
//  Hp9CellRegionModel.h
//  ESend
//
//  Created by 台源洪 on 15/11/3.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"
#import "Hp9cellSecondaryRegion.h"

@interface Hp9CellRegionModel : BaseModel

// id
@property (assign, nonatomic) NSInteger regionId;
@property (nonatomic, copy) NSString * regionName;
@property (nonatomic, strong) NSArray * twoOrderRegionList;


@end
