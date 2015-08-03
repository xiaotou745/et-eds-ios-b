//
//  MissionDetailViewController.m
//  ESend
//
//  Created by LiMingjie on 15/6/25.
//  Copyright (c) 2015年 Saltlight. All rights reserved.
//

#import "MissionDetailViewController.h"

#import "MissionDetailModel.h"
#import "MDSubOrderModel.h"

#import "MDGoodsListCell.h"
#import "MDNotesCell.h"
#import "MDOrderInfoCell.h"
#import "MDReciverInfoCell.h"
#import "MDSenderDetailCell.h"
#import "MDSenderInfoCell.h"
#import "MDSubOrderListCell.h"

@interface MissionDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    MissionDetailModel * _dataModel; // 数据
    
    UITableView * _mainListView;     // 主列表
}
@end

@implementation MissionDetailViewController

- (void)initializeData{
    
    _dataModel = [[MissionDetailModel alloc] init];
    
    MBProgressHUD * waitingProcess = [Tools showProgressWithTitle:@"加载中..."];
////----------------------------数据加载-------------------------------------
//    
//    if (1) {
//        // **************假数据1****************
//        _dataModel.orderNo     = @"323903092345";
//        _dataModel.time        = @"15.4.23 12:34";
//        _dataModel.orderStatus = 1;
//        _dataModel.orderType   = 1;
//        _dataModel.orderSource = @"美团";
//        _dataModel.thirdPartyOrderNo = @"2362345234";
//        
//        _dataModel.senderName  = @"骑士姓名  哦买噶";
//        _dataModel.senderPhoneNo = @"13426344334";
//        
//        _dataModel.receiverName = @"北京市朝阳区华腾北塘商务大厦胡同小卖部";
//        _dataModel.receiverPhoneNo = @"12344353245";
//        
//        
//        for (int i = 0; i < 6; i++) {
//            MDSubOrderModel * model = [[MDSubOrderModel alloc] init];
//            model.orderName = @"订单";
//            model.price     = 30.f;
//            model.count     = 1;
//            [_dataModel.subOrderList addObject:model];
//        }
//        
//        _dataModel.shippingFee = 3.0f;
//        
//        _dataModel.invoiceName = @"北京市超级无敌牛逼网络科技有限公司";
//        
//        _dataModel.notes = @"阿斯顿就快点撒覅阿四渡河覅";
//    }else{
//        // **************假数据2****************
//        _dataModel.orderNo     = @"323903092345";
//        _dataModel.time        = @"15.4.23 12:34";
//        _dataModel.orderStatus = 0;
//        _dataModel.orderType   = 0;
//
//        _dataModel.senderName  = @"骑士姓名  哦买噶";
//        _dataModel.senderPhoneNo = @"13426344334";
//        
//        _dataModel.receiverName = @"北京市朝阳区华腾北塘商务大厦胡同小卖部";
//        _dataModel.receiverPhoneNo = @"12344353245";
//        
//        for (int i = 0; i < 6; i++) {
//            MDSubOrderModel * model = [[MDSubOrderModel alloc] init];
//            model.orderName = @"订单";
//            model.price     = 30.f;
//            model.count     = 1;
//            [_dataModel.subOrderList addObject:model];
//        }
//        
//        _dataModel.shippingFee = 5.0f;
//        
//        _dataModel.notes = @"阿斯顿就快点撒覅阿四渡河覅苏啊是滴回复就是卡奥斯卡交电费卡就是阿斯顿发科技卡萨觉得男方";
//    }
////----------------------------数据加载完毕-------------------------------------
    
    [Tools hiddenProgress:waitingProcess];
    [self createMainListView];
}

- (void)bulidView{
    self.titleLabel.text = @"详情";
}


- (void)createMainListView{
    _mainListView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight - 64)];
    _mainListView.delegate        = self;
    _mainListView.dataSource      = self;
    _mainListView.backgroundColor = [UIColor clearColor];
    _mainListView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_mainListView];
}

#pragma mark - UITableView Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_dataModel.orderType == 0) {
        return 5;
    }else if (_dataModel.orderType == 1){
        return 6;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataModel.orderType == 0) {
        switch (indexPath.row) {
            case 0:
            {
                return [MDOrderInfoCell calculateCellHeight:_dataModel];
            }break;
            case 1:
            {
                return [MDSenderInfoCell calculateCellHeight:_dataModel];
            }break;
            case 2:
            {
                return [MDReciverInfoCell calculateCellHeight:_dataModel];
            }break;
            case 3:
            {
                return [MDSubOrderListCell calculateCellHeight:_dataModel];
            }
                break;
            case 4:
            {
                return [MDNotesCell calculateCellHeight:_dataModel];
            }
                break;
                
            default:
                break;
        }
    }else if (_dataModel.orderType == 1){
        switch (indexPath.row) {
            case 0:
            {
                return [MDOrderInfoCell calculateCellHeight:_dataModel];
            }break;
            case 1:
            {
                return [MDSenderInfoCell calculateCellHeight:_dataModel];
            }break;
            case 2:
            {
                return [MDReciverInfoCell calculateCellHeight:_dataModel];
            }break;
            case 3:
            {
                return [MDGoodsListCell calculateCellHeight:_dataModel];
            }break;
            case 4:
            {
                return [MDSenderDetailCell calculateCellHeight:_dataModel];
            }break;
            case 5:
            {
                return [MDNotesCell calculateCellHeight:_dataModel];
            }break;
                
            default:
                break;
        }
    }
    return 0.f;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (_dataModel.orderType == 0) {
        switch (indexPath.row) {
            case 0:
            {
                static NSString * cellId = @"MDOrderInfoCell";
                MDOrderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[MDOrderInfoCell alloc] init];
                }
                [cell loadData:_dataModel];
                return cell;
            }break;
            case 1:
            {
                static NSString * cellId = @"MDSenderInfoCell";
                MDSenderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[MDSenderInfoCell alloc] init];
                }
                [cell loadData:_dataModel];
                return cell;
            }break;
            case 2:
            {
                static NSString * cellId = @"MDReciverInfoCell";
                MDReciverInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[MDReciverInfoCell alloc] init];
                }
                [cell loadData:_dataModel];
                return cell;
            }break;
            case 3:
            {
                static NSString * cellId = @"MDSubOrderListCell";
                MDSubOrderListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[MDSubOrderListCell alloc] init];
                }
                [cell loadData:_dataModel];
                return cell;
            }
                break;
            case 4:
            {
                static NSString * cellId = @"MDNotesCell";
                MDNotesCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[MDNotesCell alloc] init];
                }
                [cell loadData:_dataModel];
                return cell;
            }
                break;
                
            default:
                break;
        }
    }else if (_dataModel.orderType == 1){
        switch (indexPath.row) {
            case 0:
            {
                static NSString * cellId = @"MDOrderInfoCell";
                MDOrderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[MDOrderInfoCell alloc] init];
                }
                [cell loadData:_dataModel];
                return cell;
            }break;
            case 1:
            {
                static NSString * cellId = @"MDSenderInfoCell";
                MDSenderInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[MDSenderInfoCell alloc] init];
                }
                [cell loadData:_dataModel];
                return cell;
            }break;
            case 2:
            {
                static NSString * cellId = @"MDReciverInfoCell";
                MDReciverInfoCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[MDReciverInfoCell alloc] init];
                }
                [cell loadData:_dataModel];
                return cell;
            }break;
            case 3:
            {
                static NSString * cellId = @"MDGoodsListCell";
                MDGoodsListCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[MDGoodsListCell alloc] init];
                }
                [cell loadData:_dataModel];
                return cell;
            }
                break;
            case 4:
            {
                static NSString * cellId = @"MDSenderDetailCell";
                MDSenderDetailCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[MDSenderDetailCell alloc] init];
                }
                [cell loadData:_dataModel];
                return cell;
            }
                break;
            case 5:
            {
                static NSString * cellId = @"MDNotesCell";
                MDNotesCell * cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[MDNotesCell alloc] init];
                }
                [cell loadData:_dataModel];
                return cell;
            }
                break;
                
            default:
                break;
        }
    }
    
    return nil;
}

@end
