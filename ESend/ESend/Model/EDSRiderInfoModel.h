//
//  EDSRiderInfoModel.h
//  ESend
//
//  Created by 台源洪 on 15/9/15.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface EDSRiderInfoModel : BaseModel

@property (nonatomic,copy) NSString * riderPortraitURL;
@property (nonatomic,copy) NSString * riderName;
@property (nonatomic,copy) NSString * riderPhone;
@property (nonatomic,copy) NSString * riderOrderCount;
@property (nonatomic,copy) NSString * riderId;

@end
