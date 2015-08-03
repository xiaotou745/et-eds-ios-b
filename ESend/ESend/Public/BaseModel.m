//
//  BaseModel.m
//  JiaLiMei
//
//  Created by 永来 付 on 15/4/20.
//  Copyright (c) 2015年 fuyonglai. All rights reserved.
//

#import "BaseModel.h"
#import <objc/runtime.h>

@implementation BaseModel

- (id)initWithDic:(NSDictionary*)dic {
    return nil;
}

- (NSString*)description {
    
    NSMutableString *description = [NSMutableString string];
    
    unsigned int number = 0;
    Ivar *vars = class_copyIvarList([self class], &number);
    
    for (int i = 0; i < number; i++) {
        Ivar var = vars[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(var)];
//        NSString *type = [NSString stringWithUTF8String:ivar_getTypeEncoding(var)];
        [description appendFormat:@"\n%@:%@", name, [self valueForKey:name]];
    }
    free(vars);
    
    return description;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    
    unsigned int number = 0;
    Ivar *vars = class_copyIvarList([self class], &number);
    for (int i = 0; i < number; i++) {
        Ivar var = vars[i];
        NSString *name = [NSString stringWithUTF8String:ivar_getName(var)];
        [aCoder encodeObject:[self valueForKey:name] forKey:name];
        
    }

}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super init];
    
    if (self) {
        unsigned int number = 0;
        Ivar *vars = class_copyIvarList([self class], &number);
        for (int i = 0; i < number; i++) {
            Ivar var = vars[i];
            NSString *name = [NSString stringWithUTF8String:ivar_getName(var)];
            
            [self setValue:[aDecoder decodeObjectForKey:name] forKey:name];
            
        }
    }
    return self;
}

- (void)save {
    //获取路径和保存文件
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:NSStringFromClass([self class])];
    [NSKeyedArchiver archiveRootObject:self toFile:filename];
}

+ (instancetype)initWithSaveFile {
    
    id object = nil;

    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:NSStringFromClass([self class])];
    object = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    
    return object;
}

@end
