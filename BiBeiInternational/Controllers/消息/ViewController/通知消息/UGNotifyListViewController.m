//
//  UGNotifyListViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/11.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGNotifyListViewController.h"
#import "UGNotifyTableViewCell.h"
#import "UGNotifyModel.h"

@interface UGNotifyListViewController ()

@end

@implementation UGNotifyListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"通知消息";
    self.noDataTipText = @"暂无通知消息";
    [self.tableView ug_registerNibCellWithCellClass:[UGNotifyTableViewCell class]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeMessageStatus:) name:@"订单完成更改消息列表中的数据状态" object:nil];
}


- (void)changeMessageStatus:(NSNotification *)notification {
    //这条消息的ID
    NSString *messageId = notification.object;
    [self.dataSource enumerateObjectsUsingBlock:^(UGNotifyModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        //找到了
        if ([obj.ID isEqualToString:messageId]) {
            obj.deal = YES;
            NSLog(@"订单详情处理后，在订单列表找到了这个订单。列表更改为已处理状态");
            *stop = YES;
        }
    }];
}

- (UGRequestMessageType)requestMessageType {
    return UGRequestMessageType_INFORM;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGNotifyTableViewCell *cell = [tableView ug_dequeueReusableNibCellWithCellClass:[UGNotifyTableViewCell class] forIndexPath:indexPath];
    UGNotifyModel *obj = self.dataSource[indexPath.section];
    if ([obj.data isKindOfClass:[UGJpushNotifyModel class]]) {
        cell.model = obj ;
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGNotifyModel *obj = self.dataSource[indexPath.section];
    if ([obj.data isKindOfClass:[UGJpushNotifyModel class] ]) {
        NSString *otcMessageType = ((UGJpushNotifyModel*)obj.data).otcMessageType;
        //交易
        if ([otcMessageType isEqualToString:@"OTC_ADVERTISE_MSG"]) {
            return 175.0f;
        } else if ([otcMessageType isEqualToString:@"OTC_ORDER_MSG"])  {
            //OTC
            return 175.0f - 20.0f;
        }
        return 0;
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGNotifyModel *obj = self.dataSource[indexPath.section];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"通知消息列表进入订单详情操作" object:obj.ID];
    [self pustToOTCOrderDetailsWithOrderSn:((UGJpushNotifyModel*)obj.data).orderSn];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
