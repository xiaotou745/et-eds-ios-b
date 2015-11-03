//
//  Hp9ItemCell.m
//  ESend
//
//  Created by 台源洪 on 15/10/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "Hp9ItemCell.h"

@implementation Hp9ItemCell

- (void)awakeFromNib {
    // Initialization code
    self.contents.layer.borderWidth = 0.5f;
    self.contents.layer.borderColor = [[UIColor blackColor] CGColor];
    
    self.minusButton.layer.borderColor = [[UIColor redColor] CGColor];
    self.minusButton.layer.borderWidth = 0.5f;
    self.minusButton.layer.cornerRadius = 5.0f;
    
    [self.minusButton addTarget:self action:@selector(minusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 监听
    [self addObserver:self forKeyPath:@"orderCount" options:NSKeyValueObservingOptionNew context:NULL];
    
    
    self.orderCount = 0;
}

- (void)minusButtonAction:(id)sender{
    self.orderCount -- ;
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"orderCount"];
}


- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (![NSThread isMainThread]) {
        [self performSelectorOnMainThread:@selector(updateItemUIForKeypath:) withObject:keyPath waitUntilDone:NO];
    } else {
        [self updateItemUIForKeypath:keyPath];
    }
}

- (void)updateItemUIForKeypath:(NSString *)keypath{
    // 隐藏 按钮； 刷新  订单数量
    self.minusButton.hidden = !(self.orderCount > 0);
    self.countLabel.text = (self.orderCount>0)?[NSString stringWithFormat:@"%ld",self.orderCount]:@"" ;
}

/// minnusbutton关注 数据的订单单数




- (void)setDataModel:(Hp9CellRegionModel *)dataModel{
    _dataModel = dataModel;
    self.regionName.text = [NSString stringWithFormat:@"%ld%@",_dataModel.regionId,_dataModel.regionName];
}

@end
