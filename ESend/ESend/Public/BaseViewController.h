//
//  BaseViewController.h
//  USA
//
//  Created by 永来 付 on 14/11/24.
//  Copyright (c) 2014年 fuhuaqi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFHTTPRequestOperation;

@interface BaseViewController : UIViewController

@property (nonatomic, readonly) UIView *navBar;
@property (nonatomic, readonly) UIButton *leftBtn;
@property (nonatomic, readonly) UIButton *rightBtn;
@property (nonatomic, readonly) UILabel *titleLabel;
@property (nonatomic, readonly) UIView *line;

//
@property (nonatomic, strong) NSMutableArray *textFieldList;

@property (nonatomic, weak) NSMutableArray *operationList;

//初始化数据
- (void)initializeData;

//创建界面
- (void)bulidView;

//添加网络请求到管理队列
- (void)addOperation:(AFHTTPRequestOperation*)operation;

//取消网络请求
- (void)cancelOperation;

//刷新数据
- (void)refreshingData;

//返回上一层vc
- (void)back;
- (void)getTextFieldList:(UIView*)view;

@end
