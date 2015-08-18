//
//  OrderDetailViewController.m
//  ESend
//
//  Created by 永来 付 on 15/6/5.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "OrderDetailViewController.h"
#import "OrderDetailInfoTableCell.h"
#import "OrderDetailSenderTableCell.h"
#import "OrderDetailReciverTableCell.h"
#import "OrderDetailSubListTabelCell.h"
#import "OrderDetailRemarkTableCell.h"
#import "FHQNetWorkingAPI.h"
#import "UserInfo.h"
#import "ComplaintViewController.h"

@interface OrderDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    UITableView *_tableView;
    
    BOOL _isHaveSender;
}
@end

@implementation OrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initializeData{
    _isHaveSender = _orderModel.supermenName.length == 0 ? NO : YES;
}

- (void)bulidView {
    
    self.titleLabel.text = @"详情";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, MainWidth, ScreenHeight - 64) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    
    if (_orderModel.orderStatus == OrderStatusNewOrder) {
        UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 100)];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(10, 20, MainWidth - 20, 44);
        [btn setTitle:@"取消任务" forState:UIControlStateNormal];
        [btn setBackgroundSmallImageNor:@"blue_btn_nor" smallImagePre:@"blue_btn_pre" smallImageDis:nil];
        [btn addTarget:self action:@selector(cancelOrder) forControlEvents:UIControlEventTouchUpInside];
        [bottomView addSubview:btn];
        
        _tableView.tableFooterView = bottomView;
    }
    
    
    // 投诉,已经抢单到已完成
    if (_orderModel.orderStatus == OrderStatusAccepted || _orderModel.orderStatus == OrderStatusReceive || _orderModel.orderStatus == OrderStatusComplete) {
        //[self.rightBtn setImage:[UIImage imageNamed:@"person_icon"] forState:UIControlStateNormal];
        [self.rightBtn addTarget:self action:@selector(clickComplaint) forControlEvents:UIControlEventTouchUpInside];
        //[self.rightBtn setFrame:CGRectMake(MainWidth - 12 - 75, OffsetBarHeight + 6, 75, 32)];
        [self.rightBtn setTitle:@"投诉" forState:UIControlStateNormal];
        [self.rightBtn setTitle:@"已投诉" forState:UIControlStateDisabled];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateDisabled];
        self.rightBtn.hidden = NO;
        if (1 == _orderModel.IsComplain) {
            self.rightBtn.enabled = NO;
        }else{
            self.rightBtn.enabled = YES;
        }
    }else{
        self.rightBtn.hidden = YES;
    }
    
}

- (void)cancelOrder {
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"确认要取消订单吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alertView show];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (buttonIndex == 1) {
        NSDictionary *requsetData = @{@"version"      : APIVersion,
                                      @"businessId"   : [UserInfo getUserId],
                                      @"orderId"      : _orderModel.orderId,
                                      @"OrderNo"      : _orderModel.orderNumber};
        
        [FHQNetWorkingAPI cancelOrder:requsetData successBlock:^(id result, AFHTTPRequestOperation *operation) {
            NSLog(@"%@",result);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:CancelOrderNotification object:_orderModel];
            
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error, AFHTTPRequestOperation *operation) {
            
        }];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (_isHaveSender) {
        return 5;
    }
    return 4;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isHaveSender) {
        if (indexPath.section == 0) {
            
            static NSString *cellId = @"OrderDetailInfoTableCell";
            OrderDetailInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderDetailInfoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            [cell loadData:_orderModel];
            return cell;
        } else if (indexPath.section == 1) {
            
            static NSString *cellId = @"OrderDetailSenderTableCell";
            OrderDetailSenderTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderDetailSenderTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [cell loadData:_orderModel];
            }
            return cell;
        } else if (indexPath.section == 2) {
            
            static NSString *cellId = @"OrderDetailReciverTableCell";
            OrderDetailReciverTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderDetailReciverTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [cell loadData:_orderModel];
            }
            return cell;
            
        } else if (indexPath.section == 3) {
            
            static NSString *cellId = @"OrderDetailSubListTabelCell";
            OrderDetailSubListTabelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderDetailSubListTabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [cell loadData:_orderModel];
            }
            return cell;
        } else {
            static NSString *cellId = @"OrderDetailRemarkTableCell";
            OrderDetailRemarkTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderDetailRemarkTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [cell loadData:_orderModel.remark];
            }
            return cell;
        }
    }else{
        if (indexPath.section == 0) {
            
            static NSString *cellId = @"OrderDetailInfoTableCell";
            OrderDetailInfoTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderDetailInfoTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            [cell loadData:_orderModel];
            return cell;
        } else if (indexPath.section == 1) {
            
            static NSString *cellId = @"OrderDetailReciverTableCell";
            OrderDetailReciverTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderDetailReciverTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [cell loadData:_orderModel];
            }
            return cell;
        } else if (indexPath.section == 2) {
            
            static NSString *cellId = @"OrderDetailSubListTabelCell";
            OrderDetailSubListTabelCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderDetailSubListTabelCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [cell loadData:_orderModel];
            }
            return cell;
        } else {
            static NSString *cellId = @"OrderDetailRemarkTableCell";
            OrderDetailRemarkTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[OrderDetailRemarkTableCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                [cell loadData:_orderModel.remark];
            }
            return cell;
        }
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 2 || section == 3) {
        return 10.f;
    } else {
        return 0.f;
    }

}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 2 || section == 3) {
        return [[UIView alloc] initWithFrame:CGRectMake(0, 0, MainWidth, 10)];
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (_isHaveSender) {
        if (indexPath.section == 0) {
            return 80;
        } else if (indexPath.section == 1) {
            return [OrderDetailSenderTableCell calculateCellHeight:_orderModel];
        }else if (indexPath.section == 2){
            return [OrderDetailReciverTableCell calculateCellHeight:_orderModel];
        }else if (indexPath.section == 3) {
            return [OrderDetailSubListTabelCell calculateCellHeight:_orderModel];
        } else {
            return [OrderDetailRemarkTableCell calculateCellHeight:_orderModel.remark];
        }
    }else{
        if (indexPath.section == 0) {
            return 80;
        } else if (indexPath.section == 1) {
            return [OrderDetailReciverTableCell calculateCellHeight:_orderModel];
        } else if (indexPath.section == 2) {
            return [OrderDetailSubListTabelCell calculateCellHeight:_orderModel];
        } else {
            return [OrderDetailRemarkTableCell calculateCellHeight:_orderModel.remark];
        }
    }
    
    
    

}


#pragma mark - 投诉界面
- (void)clickComplaint{
    ComplaintViewController *vc = [[ComplaintViewController alloc] initWithNibName:@"ComplaintViewController" bundle:nil];
    vc.orderModel = self.orderModel;
    vc.callBackBlock = ^{
        self.rightBtn.enabled = NO;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
@end
