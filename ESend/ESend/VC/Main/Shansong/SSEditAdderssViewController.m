//
//  SSEditAdderssViewController.m
//  ESend
//
//  Created by 台源洪 on 15/11/26.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSEditAdderssViewController.h"
#import <BaiduMapAPI/BMapKit.h>

@interface SSEditAdderssViewController ()<UITextFieldDelegate,BMKPoiSearchDelegate>
{
    BMKPoiSearch * _searcher;
}
@property (nonatomic,assign) SSAddressEditorType type;

@end

@implementation SSEditAdderssViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil Type:(SSAddressEditorType)type {
    if (self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil]) {
        self.type = type;
        //初始化检索对象
        _searcher =[[BMKPoiSearch alloc]init];
        _searcher.delegate = self;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = [SSEditorTypeTransformer titleStringWithEditorType:self.type];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- UITextFieldDelegate
/// 字符变化
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@"\n"])
    {
        return YES;
    }
    
    NSString * toBeString = [textField.text stringByReplacingCharactersInRange:range withString:string];
     NSLog(@"%@",toBeString);
//    if (textField == _phoneTF2 && toBeString.length >= 3) {
//        // 手机号，超过3级以上，联想
//        [_consigneeArrayForDisplay removeAllObjects];
//        for (ConsigneeModel * aConsignee in _consigneeArray) {
//            if ([aConsignee.consigneePhone includesAString:toBeString]) {
//                [_consigneeArrayForDisplay addObject:aConsignee];
//            }
//        }
//        [_consigneeHistoryTV reloadData];
//    }
//    
//    if (textField == _personName) {
//        if ([toBeString length] > 20) {
//            textField.text = [toBeString substringToIndex:20];
//            [Tools showHUD:@"收货人姓名长度不能超过20位"];
//            return NO;
//        }
//    }
    
    return YES;
}

#pragma mark - BMKPoiSearchDelegate
//实现PoiSearchDeleage处理回调结果
- (void)onGetPoiResult:(BMKPoiSearch*)searcher result:(BMKPoiResult*)poiResultList errorCode:(BMKSearchErrorCode)error{
    if (error == BMK_SEARCH_NO_ERROR) {
        //在此处理正常结果
    }
    else if (error == BMK_SEARCH_AMBIGUOUS_KEYWORD){
        //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
        // result.cityList;
        NSLog(@"起始点有歧义");
    } else {
        NSLog(@"抱歉，未找到结果");
    }
}
//不使用时将delegate设置为 nil
-(void)viewWillDisappear:(BOOL)animated{
    _searcher.delegate = nil;
}

@end
