//
//  SSTipSelectionView.m
//  ESend
//
//  Created by 台源洪 on 16/1/19.
//  Copyright © 2016年 Saltlight. All rights reserved.
//

#import "SSTipSelectionView.h"
@interface SSTipSelectionView()<UIPickerViewDataSource,UIPickerViewDelegate>{
    UIView * _mask;
}
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (weak, nonatomic) IBOutlet UIView * actionBg;
@property (strong,nonatomic) NSMutableArray * dataSource;
@end

@implementation SSTipSelectionView

- (id)initWithDelegate:(id <SSTipSelectionViewDelegate>)delegate tips:(NSArray *)tips{
    self = [[[NSBundle mainBundle] loadNibNamed:@"SSTipSelectionView" owner:self options:nil] objectAtIndex:0];
    if (self) {
        self.delegate = delegate;
        self.actionBg.layer.masksToBounds = YES;
        self.actionBg.layer.borderColor = [SeparatorLineColor CGColor];
        self.actionBg.layer.borderWidth = 0.5f;
        _dataSource = [[NSMutableArray alloc] initWithArray:tips];
        self.picker.delegate = self;
        self.picker.dataSource = self;
    }
    return self;
}
- (void)showInView:(UIView *)view{
    _mask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _mask.backgroundColor = SeparatorLineColor;
    _mask.alpha = 0.0f;
    [[[[UIApplication sharedApplication] delegate] window] addSubview:_mask];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancel:)];
    [_mask addGestureRecognizer:tap];
    //
    self.frame = CGRectMake(0, view.frame.size.height, ScreenWidth, self.frame.size.height);
    [[[[UIApplication sharedApplication] delegate] window] addSubview:self];
    
    [UIView animateWithDuration:0.3 animations:^{
        self.frame = CGRectMake(0, view.frame.size.height - self.frame.size.height, ScreenWidth, self.frame.size.height);
        _mask.alpha = 0.8f;
    }completion:^(BOOL finished) {
    }];
}

- (IBAction)confirm:(UIButton *)sender {
    NSInteger selectedTip = [self.picker selectedRowInComponent:0];
    
    if (selectedTip == -1) {
        [Tools showHUD:@"您未选择小费"];
        return;
    }

    double selectedTipAmout = [[_dataSource objectAtIndex:selectedTip] doubleValue];
    
    if ([self.delegate respondsToSelector:@selector(SSTipSelectionView:selectedTip:)]) {
        [self.delegate SSTipSelectionView:self selectedTip:selectedTipAmout];
    }
    [self cancel:nil];
}

- (IBAction)cancel:(UIButton *)sender {
    [UIView animateWithDuration:0.3 animations:^{
                         self.frame = CGRectMake(0, self.frame.origin.y+self.frame.size.height, ScreenWidth, self.frame.size.height);
                         _mask.alpha = 0.0f;
                     }completion:^(BOOL finished){
                         [_mask removeFromSuperview];
                         _mask = nil;
                         [self removeFromSuperview];
                     }];
}

#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return _dataSource.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%.2f元",[_dataSource[row] doubleValue]];
}

@end
