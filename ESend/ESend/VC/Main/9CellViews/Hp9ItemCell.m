//
//  Hp9ItemCell.m
//  ESend
//
//  Created by 台源洪 on 15/10/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "Hp9ItemCell.h"
#import "UIColor+KMhexColor.h"

@implementation Hp9ItemCell

- (void)awakeFromNib {
    // Initialization code
    self.contents.layer.borderWidth = 0.5f;
    self.contents.layer.borderColor = [SeparatorColorC CGColor];
    self.contents.layer.cornerRadius = 4;
    self.contents.layer.masksToBounds = YES;
    self.contents.backgroundColor = [UIColor km_colorWithHexString:@"FAFAFA"];
    
    self.regionName.textColor = DeepGrey;
    //self.countLabel.textColor = [UIColor km_colorWithHexString:@"f7585d"];
    
//    self.minusButton.layer.borderColor = [[UIColor redColor] CGColor];
//    self.minusButton.layer.borderWidth = 0.5f;
//    self.minusButton.layer.cornerRadius = 5.0f;
    
    self.orderCountLbl.backgroundColor = RedDefault;
    self.orderCountLbl.layer.cornerRadius = 10;
    self.orderCountLbl.layer.masksToBounds = YES;
    self.orderCountLbl.textColor = [UIColor whiteColor];
    self.orderCountLbl.hidden = YES;

    
    //[self.minusButton addTarget:self action:@selector(minusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    // 监听
    [self addObserver:self forKeyPath:@"dataModel.orderCount" options:NSKeyValueObservingOptionNew context:NULL];
    [self.minusActionBtn addTarget:self action:@selector(minusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //self.orderCount = 0;
}

- (void)minusButtonAction:(id)sender{
    if (self.dataModel.twoOrderRegionList.count > 0) { // 有二级区域，唤起二级区域
        if ([self.delegate respondsToSelector:@selector(hp9ItemShouldCallOutSecondaryRegionView:)]) {
            [self.delegate hp9ItemShouldCallOutSecondaryRegionView:self];
        }
    }else{
        self.dataModel.orderCount -- ;
    }
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
        //self.countLabel.backgroundColor = [UIColor km_colorWithHexString:@"D3D3D3"];
    }else{
        self.contents.backgroundColor = [UIColor km_colorWithHexString:@"FAFAFA"];
        //self.countLabel.backgroundColor = [UIColor km_colorWithHexString:@"FAFAFA"];
    }
    // 隐藏 按钮； 刷新  订单数量
    self.minusImg.hidden = !(self.dataModel.orderCount > 0);
    self.orderCountLbl.hidden = !(self.dataModel.orderCount > 0);
    self.minusActionBtn.enabled = (self.dataModel.orderCount > 0);
//    self.countLabel.text = (self.dataModel.orderCount>0)?[NSString stringWithFormat:@"%ld单",self.dataModel.orderCount]:@"" ;
    self.orderCountLbl.text = (self.dataModel.orderCount>0)?[NSString stringWithFormat:@"%ld",self.dataModel.orderCount]:@"" ;
    // 通知首页修改订单数量
    [[NSNotificationCenter defaultCenter] postNotificationName:Hp9cellOrderCountChangedNotification object:nil];
}

/// minnusbutton关注 数据的订单单数




- (void)setDataModel:(Hp9CellRegionModel *)dataModel{
    _dataModel = dataModel;
    self.regionName.text = [NSString stringWithFormat:@"%@",_dataModel.regionName];
}

@end
