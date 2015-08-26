//
//  ExpensesDetailVC.m
//  ESend
//
//  Created by Maxwell on 15/8/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "ExpensesDetailVC.h"

@interface ExpensesDetailVC ()
@property (strong, nonatomic) IBOutlet UIView *FirstBlock;
@property (strong, nonatomic) IBOutlet UILabel *expenseStatus;
@property (strong, nonatomic) IBOutlet UILabel *RMBFlag;
@property (strong, nonatomic) IBOutlet UILabel *expenseAmount;
@property (strong, nonatomic) IBOutlet UIImageView *FirstBlockSeperator;
@property (strong, nonatomic) IBOutlet UILabel *expenseOperationName;


@property (strong, nonatomic) IBOutlet UIView *SecondBlock;
@property (strong, nonatomic) IBOutlet UIImageView *secondBlockSeperator;
@property (strong, nonatomic) IBOutlet UILabel *detailFix;
@property (strong, nonatomic) IBOutlet UILabel *expenseDetail;
@property (strong, nonatomic) IBOutlet UILabel *timeFix;
@property (strong, nonatomic) IBOutlet UILabel *expenseTime;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *scrollerHeight;  // scrollerView高度
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *SecondBlockHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *expenseDetailHeight;

@end

@implementation ExpensesDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = NO;

    self.titleLabel.text = @"收支详情";
    
    self.FirstBlock.backgroundColor =
    self.SecondBlock.backgroundColor = [UIColor whiteColor];
    
    self.expenseStatus.textColor = [UIColor colorWithHexString:@"bbc0c7"];
    self.expenseStatus.font = [UIFont systemFontOfSize:12];
    
    self.RMBFlag.font = [UIFont boldSystemFontOfSize:27.5];
    self.expenseAmount.textColor =
    self.RMBFlag.textColor = DeepGrey;
    
    self.expenseAmount.font = [UIFont boldSystemFontOfSize:37.5];
    
    self.secondBlockSeperator.backgroundColor =
    self.FirstBlockSeperator.backgroundColor = [UIColor colorWithHexString:@"dfdfdf"];
    
    self.expenseOperationName.font = [UIFont systemFontOfSize:12];
    self.expenseOperationName.textColor = DeepGrey;
    
    self.detailFix.font =
    self.timeFix.font =
    self.expenseDetail.font =
    self.expenseTime.font = [UIFont systemFontOfSize:16];
    
    self.detailFix.textColor =
    self.timeFix.textColor =
    self.expenseDetail.textColor =
    self.expenseTime.textColor = DeepGrey;
    
    self.expenseDetail.numberOfLines = 0;
    
    ///
    NSString * remarkString = _expenseInfoModel.Remark;
    //remarkString = @"我的八十多了空间烦死了都放假了圣诞节放了假佛网i示例打开副教授李的会计覅偶尔建佛寺就放塑料袋口附近噢诶骄傲圣诞节烦死了快放假的累计放假的累计";
    
    
    self.expenseStatus.text = _expenseInfoModel.state;
    self.expenseAmount.text = [NSString stringWithFormat:@"%.2f",_expenseInfoModel.amount];
    self.expenseOperationName.text = _expenseInfoModel.infoType;
    
    self.expenseDetail.text = remarkString;
    self.expenseTime.text = _expenseInfoModel.OperateTime;
    
    
    
    // 46-16 = 30, 30/2 = 15;
    // width ;  12 + 76 + 10 + width + 12 = screenWidth
    CGFloat remarkHeight = [Tools stringHeight:remarkString fontSize:16 width:ScreenWidth - 12 - 76 - 10 - 12].height - 2;
    CGFloat remarkLabelHeight = remarkHeight + 30;
    
    //
    self.expenseDetailHeight.constant = remarkLabelHeight;
    self.SecondBlockHeight.constant = remarkLabelHeight + 4 + 50;
    
    self.scrollerHeight.constant = MAX(ScreenHeight - 64, remarkLabelHeight + 4 + 50 + 10 + 160 + 15);
}


//- (void)setExpenseInfoModel:(ExpensesInfoModel *)expenseInfoModel{
//    _expenseInfoModel = expenseInfoModel;
//    
//    self.expenseStatus.text = _expenseInfoModel.state;
//    self.expenseAmount.text = [NSString stringWithFormat:@"%.2f",_expenseInfoModel.amount];
//    self.expenseOperationName.text = _expenseInfoModel.infoType;
//    
//    self.expenseDetail.text = _expenseInfoModel.infoType;
//    self.expenseTime.text = _expenseInfoModel.time;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
