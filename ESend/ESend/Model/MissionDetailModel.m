//
//  MissionDetailModel.m
//  ESend
//
//  Created by LiMingjie on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MissionDetailModel.h"

@implementation MissionDetailModel

- (id)init{
    self = [super init];
    if (self) {
        _subOrderList = [NSMutableArray array];
    }
    
    return self;
}

@end
