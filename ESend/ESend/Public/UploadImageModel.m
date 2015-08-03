//
//  UploadImageModel.m
//  ESend
//
//  Created by 永来 付 on 15/6/27.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "UploadImageModel.h"

@implementation UploadImageModel

- (NSString*)imageName {
    if (isCanUseString(_imageName)) {
        return _imageName;
    }
    return @"File";
}

- (NSString*)imageFileName {
    if (isCanUseString(_imageFileName)) {
        return _imageFileName;
    }
    return @"temp.jpg";
}

@end
