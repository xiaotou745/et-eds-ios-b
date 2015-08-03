//
//  OriginModel.h
//  ESend
//
//  Created by 永来 付 on 15/6/3.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface OriginModel : BaseModel

@property (nonatomic, copy) NSString *name;
@property (nonatomic, assign) NSInteger idCode;
@property (nonatomic, assign) NSInteger parentId;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, copy) NSString *zipCode;

@end
