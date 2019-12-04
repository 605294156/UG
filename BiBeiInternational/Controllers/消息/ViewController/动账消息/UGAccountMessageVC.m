//
//  UGAccountMessageVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAccountMessageVC.h"
#import "UGAccountCell.h"
#import "UGRemotemessageHandle.h"
#import "UGOTCMessageCell.h"
#import "UGBillDetailVC.h"
#import "UGAdDetailVC.h"
#import "UGSysFreezeResultCell.h"

#define  UGAccountCellIdentifier  @"UGAccountCell"
#define  UGOTCMessageCellIdentifier  @"UGOTCMessageCell"
#define  UGSysFreezeResultCellIdentifier @"UGSysFreezeResultCell"

@interface UGAccountMessageVC ()
@end

@implementation UGAccountMessageVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self initUI];
}

-(void)languageChange{
    self.navigationItem.title = @"动账消息";
}

-(void)initUI{
    
    [self languageChange];
    
    self.noDataTipText = @"暂无动账消息";

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGAccountCell class]) bundle:nil] forCellReuseIdentifier:UGAccountCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGOTCMessageCell class]) bundle:nil] forCellReuseIdentifier:UGOTCMessageCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGSysFreezeResultCell class]) bundle:nil] forCellReuseIdentifier:UGSysFreezeResultCellIdentifier];
    [self.tableView.mj_header beginRefreshing];
}


- (UGRequestMessageType)requestMessageType {
    return UGRequestMessageType_DYNAMIC;
}


#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGNotifyModel *obj = self.dataSource[indexPath.section];
    if ([obj.data isKindOfClass:[UGTransferModel class]]) {
        //转收币
        UGAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:UGAccountCellIdentifier forIndexPath:indexPath];
        cell.model = obj;
        return cell;
    }
    
    if([obj.data isKindOfClass:[UGOTCOrderMeeageModel class]]){
        //OTC 、交易
        UGOTCMessageCell*cell = [tableView dequeueReusableCellWithIdentifier:UGOTCMessageCellIdentifier forIndexPath:indexPath];
        cell.model = obj;
        @weakify(self);
        cell.clickDetailedHandle = ^(UGNotifyModel * _Nonnull model) {
            @strongify(self);
            UGOTCOrderMeeageModel *oderModel = (UGOTCOrderMeeageModel *)obj.data;
            [self gotoNextView:oderModel];
        };
        return cell;
    }
    
    if ([obj.data isKindOfClass:[UGSysFreezeResultModel class]]) {
        UGSysFreezeResultCell *cell = [tableView dequeueReusableCellWithIdentifier:UGSysFreezeResultCellIdentifier forIndexPath:indexPath];
        cell.model = obj;
        return cell;
        
    }
    
    return [UITableViewCell new];
}


#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGNotifyModel *obj = self.dataSource[indexPath.section];
    if ([obj.data isKindOfClass:[UGTransferModel class]]) {
        return 335;
    }

    if([obj.data isKindOfClass:[UGOTCOrderMeeageModel class]]){
//        CGFloat hight =  [((UGOTCOrderMeeageModel*)obj.data).otcMessageType isEqualToString:@"OTC_ADVERTISE_MSG"] ? 238.0f + 108 : 274.0f + 108;
        return 382;//hight;
    }
    
    if ([obj.data isKindOfClass:[UGSysFreezeResultModel class]]) {
        
        return 160;
    }
    
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UGNotifyModel *obj = self.dataSource[indexPath.section];
    //转收币
    if ([obj.data isKindOfClass:[UGTransferModel class]]) {
        UGTransferModel *model = (UGTransferModel *)obj.data;
        UGBillDetailVC *vc = [UGBillDetailVC new];
        vc.orderType = [model.orderType isEqualToString:@"SUB_TYPE_RECEIPT"] ? @"0" : @"1";
        vc.orderSn = model.orderSn;
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    //OTC、交易
    if ([obj.data isKindOfClass:[UGOTCOrderMeeageModel class]]) {
        UGOTCOrderMeeageModel *oderModel = (UGOTCOrderMeeageModel *)obj.data;
        [self gotoNextView:oderModel];
    }
}

-(void)gotoNextView:(UGOTCOrderMeeageModel *)oderModel{
    if ([oderModel.otcMessageType isEqualToString: @"OTC_ORDER_MSG"]) {
        //订单详情
        [self pustToOTCOrderDetailsWithOrderSn:oderModel.orderSn];
        
    } else if ([oderModel.otcMessageType isEqualToString: @"OTC_ADVERTISE_MSG"]) {
        //广告详情
        UGAdDetailVC *vc =  [UGAdDetailVC new];
        vc.advertiseId = oderModel.advertiseId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
