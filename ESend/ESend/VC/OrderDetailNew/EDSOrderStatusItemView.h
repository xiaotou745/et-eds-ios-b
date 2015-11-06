//
//  EDSOrderStatusItemView.h
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EDSOrderStatusItemView : UIView

- (instancetype)initWithString:(NSString *)name highlighted:(BOOL)highlighted;

@property (nonatomic, copy) NSString * name;
@property (nonatomic, assign) BOOL highlighted;

@end