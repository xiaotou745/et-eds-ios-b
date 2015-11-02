//
//  EDSOrderStatusItemView.m
//  ESend
//
//  Created by 台源洪 on 15/11/2.
//  Copyright © 2015年 Saltlight. All rights reserved.
//

#import "EDSOrderStatusItemView.h"
#import "UIColor+KMhexColor.h"

#define EDSOrderStatusItemViewNameLabelNormalColorString @""
#define EDSOrderStatusItemViewNameLabelHighlightedColorString @""

@interface EDSOrderStatusItemView ()

@property (strong, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation EDSOrderStatusItemView

- (instancetype)initWithString:(NSString *)name highlighted:(BOOL)highlighted{
    self = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    if (self) {
        self.name = name;
        self.highlighted = highlighted;
    }
    return self;
}

- (void)setName:(NSString *)name{
    _name = name;
    self.nameLabel.text = _name;
}

- (void)setHighlighted:(BOOL)highlighted{
    _highlighted = highlighted;
    self.nameLabel.backgroundColor = _highlighted?[UIColor km_colorWithHexString:EDSOrderStatusItemViewNameLabelHighlightedColorString]:[UIColor km_colorWithHexString:EDSOrderStatusItemViewNameLabelNormalColorString];
}

@end
