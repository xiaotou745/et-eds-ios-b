//
//  Hp9ItemSecondaryCell.m
//  ESend
//
//  Created by 台源洪 on 15/11/11.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "Hp9ItemSecondaryCell.h"
#import "UIColor+KMhexColor.h"

@implementation Hp9ItemSecondaryCell

- (void)awakeFromNib {
    // Initialization code
    self.contents.layer.borderWidth = 0.5f;
    self.contents.layer.borderColor = [SeparatorColorC CGColor];
    self.contents.layer.cornerRadius = 4;
    self.contents.layer.masksToBounds = YES;
    self.contents.backgroundColor = [UIColor km_colorWithHexString:@"FAFAFA"];
    
    self.regionName.textColor = DeepGrey;
    self.countLabel.textColor = [UIColor km_colorWithHexString:@"f7585d"];
    
    //    self.minusButton.layer.borderColor = [[UIColor redColor] CGColor];
    //    self.minusButton.layer.borderWidth = 0.5f;
    //    self.minusButton.layer.cornerRadius = 5.0f;
    
    [self.minusButton addTarget:self action:@selector(minusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 监听
    [self addObserver:self forKeyPath:@"dataModel.orderCount" options:NSKeyValueObservingOptionNew context:NULL];
}


- (void)minusButtonAction:(id)sender{
    self.dataModel.orderCount -- ;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"dataModel.orderCount"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateItemUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateItemUIForKeypath:keyPath];
    }
}

- (void)updateItemUIForKeypath:(NSString *)keypath{
    if (self.dataModel.orderCount > 0) {
        self.contents.backgroundColor = [UIColor km_colorWithHexString:@"E2E2E2"];
        self.countLabel.backgroundColor = [UIColor km_colorWithHexString:@"D3D3D3"];
    }else{
        self.contents.backgroundColor = [UIColor km_colorWithHexString:@"FAFAFA"];
        self.countLabel.backgroundColor = [UIColor km_colorWithHexString:@"FAFAFA"];
    }
    
    NSNotification * notification = [[NSNotification alloc] initWithName:Hp9CellSecondaryRegionOrderCountChangedNotification object:self.dataModel userInfo:nil];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    // 隐藏 按钮； 刷新  订单数量
    self.minusButton.hidden = !(self.dataModel.orderCount > 0);
    self.countLabel.text = (self.dataModel.orderCount>0)?[NSString stringWithFormat:@"%ld单",self.dataModel.orderCount]:@"" ;
//    
//    // 通知首页修改订单数量
//    [[NSNotificationCenter defaultCenter] postNotificationName:Hp9cellOrderCountChangedNotification object:nil];
}

/// minnusbutton关注 数据的订单单数




- (void)setDataModel:(Hp9cellSecondaryRegion *)dataModel{
    _dataModel = dataModel;
    self.regionName.text = [NSString stringWithFormat:@"%@",_dataModel.regionName];
}

@end
