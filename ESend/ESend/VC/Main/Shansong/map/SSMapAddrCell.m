//
//  SSMapAddrCell.m
//  ESend
//
//  Created by 台源洪 on 15/11/30.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSMapAddrCell.h"

@implementation SSMapAddrCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddrInfo:(SSAddressInfo *)addrInfo{
    
    _addrInfo  = addrInfo;
    self.statusImg.image = _addrInfo.selected?[UIImage imageNamed:@"ss_release_selected"]:[UIImage imageNamed:@"ss_release_normal"];
    self.upperSeparator.backgroundColor = _addrInfo.selected?BlueColor:SeparatorLineColor;
    self.bottomSeparator.backgroundColor = _addrInfo.selected?BlueColor:SeparatorLineColor;
    self.addressName.text = _addrInfo.name;
    self.addressDetail.text = [NSString stringWithFormat:@"%@",_addrInfo.address];

}
@end
