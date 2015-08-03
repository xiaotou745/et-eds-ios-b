//
//  UploadImageModel.h
//  ESend
//
//  Created by 永来 付 on 15/6/27.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "BaseModel.h"

@interface UploadImageModel : BaseModel

@property (nonatomic, strong) NSData *imageData;
@property (nonatomic, strong) NSString *imageFileName;
@property (nonatomic, copy) NSString *imageName;

@end
