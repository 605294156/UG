//
//  UGAdDetailVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/25.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAdDetailVC.h"
#import "UGAdTableViewCell.h"
#import "UGDeleteADApi.h"
#import "UGShelvesAdApi.h"
#import "AdvertisingSellViewController.h"
#import "AdvertisingBuyViewController.h"
#import "UGAdDetailApi.h"
#import "UGAdDetailModel.h"
#import "UGOTCPayDetailModel.h"
#import "UGADDetailCell.h"
#import "OTCJpushViewController.h"

@interface UGAdDetailVC ()
@property (nonatomic,strong)UGAdDetailModel *detailModel;
@end

@implementation UGAdDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"交易详情";
    
    self.noDataTipText = @"暂无更多";
    [self.tableView ug_registerNibCellWithCellClass:[UGAdTableViewCell class]];
    [self.tableView ug_registerNibCellWithCellClass:[UGADDetailCell class]];
    [self headerBeginRefresh];
}

- (UGBaseRequest *)getRequestApiAppend:(BOOL)append {
    UGAdDetailApi *api = [UGAdDetailApi new];
    api.ID = self.advertiseId;
    return api;
}

- (NSArray *)getDataFromDictionary:(NSDictionary *)object isAppend:(BOOL)append {
    if (object) {
        self.detailModel = [UGAdDetailModel mj_objectWithKeyValues:object];
        if (self.detailModel && [self.detailModel.sysBuy isEqualToString:@"1" ]) {
                self.noDataTipText = @"回购申请中";
        }else{
                self.noDataTipText = @"暂无更多";
        }
        [self.detailModel replaceAdModel];
        if (self.detailModel && !UG_CheckArrayIsEmpty(self.detailModel.order)) {
            return self.detailModel.order;
        }
    }
    return [NSArray new];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        UGAdTableViewCell *cell = [tableView ug_dequeueReusableNibCellWithCellClass:[UGAdTableViewCell class] forIndexPath:indexPath];
        if (self.detailModel) {
            cell.model = self.detailModel.adModel;
            cell.isNotify = YES;
            return cell;
        }
    }else{
        if (self.dataSource.count>0 && indexPath.section-1<self.dataSource.count) {
            UGADDetailCell *cell = [tableView ug_dequeueReusableNibCellWithCellClass:[UGADDetailCell class] forIndexPath:indexPath];
            cell.model = self.dataSource[indexPath.section-1];
            return cell;
        }
    }
    return [UITableViewCell new];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(self.detailModel){
        return self.dataSource.count + 1;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 135.0f;
    }
    return 145;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath != 0 && self.dataSource.count>0 && indexPath.section-1<self.dataSource.count) {
        UGAdDetailListModel *model = self.dataSource[indexPath.section-1];
        [self pustToOTCOrderDetailsWithOrderSn:model.orderSn];
    }
}
 
@end
