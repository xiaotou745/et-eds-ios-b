//
//  Hp9cellSecondaryRegion.h
//  ESend
//
//  Created by 台源洪 on 15/11/3.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface Hp9cellSecondaryRegion : BaseModel
@property (assign, nonatomic) NSInteger regionId;
@property (nonatomic, copy) NSString * regionName;

// 加入订单数量
@property (assign, nonatomic) NSInteger orderCount;

@end
