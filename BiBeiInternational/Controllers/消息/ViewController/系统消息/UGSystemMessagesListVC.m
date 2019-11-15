//
//  UGSystemMessagesListVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGSystemMessagesListVC.h"
#import "UGHomeMessageCell.h"
#import "ChatGroupFMDBTool.h"
#import "UGSystemMessageDetailVC.h"


@implementation UGSystemMessagesListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight = 60.0f;
    [self languageChange];
    self.noDataTipText = @"暂无系统消息";
    [self.tableView ug_registerNibCellWithCellClass:[UGHomeMessageCell class]];
    [self.tableView.mj_header beginRefreshing];
}


-(void)languageChange{
    self.navigationItem.title = @"系统消息";
}

#pragma mark-数据请求

- (UGRequestMessageType)requestMessageType {
    return UGRequestMessageType_SYSTEM;
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGNotifyModel *notifyModel = self.dataSource[indexPath.section];
    UGHomeMessageCell *cell = [tableView ug_dequeueReusableNibCellWithCellClass:[UGHomeMessageCell class] forIndexPath:indexPath];
    cell.subMessageVC = YES;
    [cell updateWithModel:notifyModel WithBage:0];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGNotifyModel *notifyModel = self.dataSource[indexPath.section];
    if ([notifyModel isKindOfClass:[UGNotifyModel class]]) {
        UGJpushSystemModel *systemModel = (UGJpushSystemModel *)notifyModel.data;
        UGSystemMessageDetailVC *detailVC = [UGSystemMessageDetailVC new];
        detailVC.notifyModel = systemModel;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(BOOL)hasFooterRefresh{
    return NO;
}

@end
