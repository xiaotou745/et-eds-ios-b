//
//  SSAdressCell.m
//  ESend
//
//  Created by 台源洪 on 15/11/27.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "SSAdressCell.h"

@implementation SSAdressCell

- (void)awakeFromNib {
    self.separator.backgroundColor = SeparatorLineColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)hideSeparator{
    self.separator.hidden = YES;
}

- (void)hideDeleteBtn{
    self.deleteBtnWidth.constant = 0.0f;
    self.deleteBtn.hidden = YES;
}

- (void)setAddressInfo:(SSAddressInfo *)addressInfo{
    _addressInfo =  addressInfo;
    if (self.cellStyle == SSAdressCellStyleHistory) {
        self.AddressName.text = [NSString stringWithFormat:@"%@(%@)",_addressInfo.name,_addressInfo.address];
        NSString * sex = _addressInfo.genderIsWoman?@"女士":@"先生";
        self.AddressDetail.text = [NSString stringWithFormat:@"%@%@ %@",_addressInfo.personName,sex,_addressInfo.personPhone];
    }else if (self.cellStyle == SSAdressCellStylePOI){
        self.AddressName.text = _addressInfo.name;
        self.AddressDetail.text = _addressInfo.address;
    }

}

- (IBAction)deleteCell:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(deleteAddressWithId:)]) {
        [self.delegate deleteAddressWithId:_addressInfo.uid];
    }
}
@end
