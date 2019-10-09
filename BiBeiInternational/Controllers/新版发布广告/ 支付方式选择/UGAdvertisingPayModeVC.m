//
//  UGAdvertisingPayModeVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/5.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAdvertisingPayModeVC.h"
#import "UGPayModeTableViewCell.h"
#import "UGButton.h"

@interface UGAdvertisingPayModeVC ()

@end

@implementation UGAdvertisingPayModeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"支付方式";
    [self setupTableFooterView];
    self.tableView.rowHeight = 50.0f;
    [self.tableView ug_registerNibCellWithCellClass:[UGPayModeTableViewCell class]];
    [self initData];
}

- (void)setupTableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, 187)];
    UGButton *confirmButton = [[UGButton alloc] initWithUGStyle:UGButtonStyleBlue];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitle:@"确定" forState:UIControlStateHighlighted];
    confirmButton.frame = CGRectMake((self.view.size.width - 240) /2 , 187 -46, 240, 46);
    [confirmButton addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmButton];
    self.tableView.tableFooterView = footerView;
}

- (void)initData {
    NSMutableArray *array = [NSMutableArray new];
    UGUserInfoModel *userInfoModel = [UGManager shareInstance].hostInfo.userInfoModel;
    if (userInfoModel.hasBankBinding) {
        UGAdPayWayModel *mode1 = [UGAdPayWayModel new];
        mode1.title = @"银行卡";
        [array addObject:mode1];
    }
    if (userInfoModel.hasAliPay) {
        UGAdPayWayModel *mode2 = [UGAdPayWayModel new];
        mode2.title = @"支付宝";
        [array addObject:mode2];
    }
    if (userInfoModel.hasWechatPay){
        UGAdPayWayModel *mode3 = [UGAdPayWayModel new];
        mode3.title = @"微信";
        [array addObject:mode3];
    }
    if (userInfoModel.hasUnionPay){
        UGAdPayWayModel *mode4 = [UGAdPayWayModel new];
        mode4.title = @"云闪付";
        [array addObject:mode4];
    }

    self.dataSource = [UGAdPayWayModel mj_objectArrayWithKeyValuesArray:array].copy;
    if (self.dataSource.count == 0) {
        self.tableView.tableFooterView = [UIView new];
    }
}

- (BOOL)hasHeadRefresh {
    return NO;
}

- (BOOL)hasFooterRefresh {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPayModeTableViewCell *cell = [tableView ug_dequeueReusableNibCellWithCellClass:[UGPayModeTableViewCell class] forIndexPath:indexPath];
     cell.model = self.dataSource[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return section = self.dataSource.count -1 ? CGFLOAT_MIN : 20.0f;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return section == 0 ? 9.0f : CGFLOAT_MIN;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGAdPayWayModel *model = self.dataSource[indexPath.section];
    model.selected = !model.selected;
}


- (void)clickConfirm:(UIButton *)sender {
    
    NSMutableArray <NSString *>*array = [NSMutableArray new];
    for (UGAdPayWayModel *model in self.dataSource) {
        if (model.selected) {
            [array addObject:model.title];
        }
    }
    
    if (self.choosePayModHandle) {
        self.choosePayModHandle(array);
    }
    [self.navigationController popViewControllerAnimated:YES];
}




@end
