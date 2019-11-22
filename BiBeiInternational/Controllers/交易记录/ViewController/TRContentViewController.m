//
//  TRContentViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "TRContentViewController.h"
#import "UGOTCOrderAPi.h"
#import "UGOredeModel.h"
#import "OTCComplaintingViewController.h"
#import "OTCWaitingForPayVC.h"
#import "OTCSellCoinViewController.h"
#import "OTCBuyViewController.h"
#import "UGExchangeApi.h"
#import "UGOTCExchageModel.h"
#import "TREntrustTableViewCell.h"
#import "UGCommissionPopView.h"
#import "UGOrderCancelApi.h"
#import "TROrderRecordTableViewCell.h"
#import "UGCancelAppealApi.h"
#import "UGOrderDetailApi.h"
#import "UGAffirmAppealLimitTimeApi.h"
#import "OTCComplaintViewController.h"

@interface TRContentViewController ()


@end

@implementation TRContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.tableView ug_registerNibCellWithCellClass:[TREntrustTableViewCell class]];
    [self.tableView ug_registerNibCellWithCellClass:[TROrderRecordTableViewCell class]];
    
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOrderType:) name:@"TROrderRefreshData" object:nil];
    
    if ([UIDevice isIphoneXSeries]) {
        //上拉加载忽略高度,因为顶部有40高度的切换高度
        self.tableView.mj_footer.ignoredScrollViewContentInsetBottom += 40.0f;
    }

    [self headerBeginRefresh];
}

- (void)changeOrderType:(NSNotification *)sender {
    NSNumber *number = (NSNumber *)sender.object;
    self.orderType = [number integerValue];
    [self headerBeginRefresh];
}

- (UGBaseRequest *)getRequestApiAppend:(BOOL)append {
    if (self.isOTC) { //OTC交易记录
        UGOTCOrderAPi *api = [UGOTCOrderAPi new];
        api.currentPage = [NSString stringWithFormat:@"%zd",self.minseq];
        api.status = self.title;
        api.advertiseType = self.orderType;
        return api;
    }
    //交易记录
    UGExchangeApi *api = [UGExchangeApi new];
    api.currentPage = [NSString stringWithFormat:@"%zd",self.minseq];
    api.status = self.title;
    api.direction = self.orderType;
    return api;
}

- (NSArray *)getDataFromDictionary:(NSDictionary *)object isAppend:(BOOL)append {
    if (object[@"rows"]) {
        if (self.isOTC) {
            NSArray *array = [UGOredeModel mj_objectArrayWithKeyValuesArray:object[@"rows"]];
            return array;
        }
        NSArray *array = [UGOTCExchageModel mj_objectArrayWithKeyValuesArray:object[@"rows"]];
        return array;
    }
    return nil;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isOTC) {
        TROrderRecordTableViewCell *orderCell = [tableView ug_dequeueReusableNibCellWithCellClass:[TROrderRecordTableViewCell class] forIndexPath:indexPath];
        orderCell.orderModel = self.dataSource[indexPath.section];

        @weakify(self);
        orderCell.clickButtonHandle = ^(UGOrderType oderType) {
            @strongify(self);
            [self otcOrderPushtWithOrderType:oderType withOrderModel:self.dataSource[indexPath.section]];

        };
        return orderCell;
    }
    TREntrustTableViewCell *cell = [tableView ug_dequeueReusableNibCellWithCellClass:[TREntrustTableViewCell class] forIndexPath:indexPath];
    cell.exchangeModel = self.dataSource[indexPath.section];
    //撤销
    @weakify(self);
    cell.clickCancelHandle = ^(UGOTCExchageModel * _Nonnull exchangeModel) {
        @strongify(self);
        [self showCancelPopViewWithModel:exchangeModel];
    };
    return cell;
}


/**
 点击底部按钮进行跳转
 @param oderType 按钮类型
 @param orderModel 订单数据
 */
- (void)otcOrderPushtWithOrderType:(UGOrderType )oderType withOrderModel:(UGOredeModel *)orderModel {
    
    //取消订单
    if (oderType == UGOrderTypeCancle) {
        [self cancelOroderWithOrderSn:orderModel.orderSn handle:^{
            
        }];
        return;
    }
    //去申诉
    if (oderType == UGOrderTypeAppeal) {
        if ([orderModel.status isEqualToString:@"4"]) {//申诉中
            [self sendOrderAppealDetailRequest:orderModel.orderSn];
        }else{
            if ([orderModel.appealStatus isEqualToString:@"2"]) {
                  [self pushToOrderAppealWithOrderSn:orderModel.orderSn WithReSubmit:YES];
            }else{
                 [self pushToOrderAppealWithOrderSn:orderModel.orderSn WithReSubmit:NO];
            }
        }
        return;
    }
    
    //查看资产
    if (oderType == UGOrderTypeAssets) {
        [self pushToAssetsViewController];
        return;
    }
    
    //放弃申诉
    if (oderType == UGOrderTypeGiveupAppeal) {
        __weak typeof(self) weakSelf = self;
        [[UGAlertPopView shareInstance] showAlertPopViewWithTitle:@"放弃申诉" andMessage:@"您确定要放弃当前申诉吗？" andCancelButtonTittle:@"取消" andConfirmlButtonTittle:@"确认" cancelBlock:^{
        } confirmBlock:^{
            //确定放弃申诉   调接口放弃
            UGCancelAppealApi *api = [UGCancelAppealApi  new];
            api.orderSn =  orderModel.orderSn;
            [MBProgressHUD ug_showHUDToKeyWindow];
            [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
                [MBProgressHUD ug_hideHUDFromKeyWindow];
                if (object) {
                    [weakSelf.view ug_showToastWithToast:@"放弃申诉成功 ! "];
                    [self headerBeginRefresh];
                    [self.tableView reloadData];
                    return;
                }else{
                    [weakSelf.view ug_showToastWithToast:apiError.desc];
                    return;
                }
            }];
        }];
        return;
    }
    
    //其它类型跳转
    [self pustToOTCOrderDetailsWithOrderSn:orderModel.orderSn];
}

#pragma mark - Request
//获取信息详情
- (void)sendOrderAppealDetailRequest:(NSString *)orderSno{
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOrderDetailApi *api = [UGOrderDetailApi new];
    api.orderSn = orderSno;
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        @strongify(self);
        if (object) {
            UGOrderDetailModel *detailModel = [UGOrderDetailModel mj_objectWithKeyValues:object];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                  [self pushToOrderAppealWithOrderSn:detailModel];
            });
        }{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

- (void)pushToOrderAppealWithOrderSn:(UGOrderDetailModel *)detailModel{
    UGAffirmAppealLimitTimeApi *api = [UGAffirmAppealLimitTimeApi new];
    api.orderSn = detailModel.orderSn;
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        if (object) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                OTCComplaintViewController *complaintVC = [OTCComplaintViewController new];
                complaintVC.orderSn = detailModel.orderSn;
                complaintVC.reSubmit = YES;
                complaintVC.orderDetailModel = detailModel;
                complaintVC.reApeal = YES;
                [self.navigationController pushViewController:complaintVC animated:YES];
            });
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.isOTC) {
        UGOredeModel *orderModel = self.dataSource[indexPath.section];
        //OTC订单页面跳转 orderModel.orderType 0 买入数字货币 1 卖出数字货币
        [self pustToOTCOrderDetailsWithOrderSn:orderModel.orderSn];
    }
    //币币交易即委托暂无详情
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    UGOredeModel *orderModel = self.dataSource[indexPath.section];
    //新修改 查看资产
    if ([orderModel.status isEqualToString:@"3"]) {
        return 132.0f;
    }
    return self.isOTC ? 132.0f: 145.0f;
}

#pragma mark-撤销
-(void)showCancelPopViewWithModel:(UGOTCExchageModel*)model {
    NSString*price;//委托价
    NSString*commissionAmount;//委托量
    NSString*commissionTotal;//委托总额
    if ([model.type isEqualToString:@"LIMIT_PRICE"]) {
        price = [NSString stringWithFormat:@"%.2f %@",[model.price doubleValue],model.baseSymbol];
        commissionAmount = [NSString stringWithFormat:@"%.2f %@",[model.amount doubleValue],model.coinSymbol];
        commissionTotal = [NSString stringWithFormat:@"%.2f %@",[model.price doubleValue]*[model.amount doubleValue],model.baseSymbol];
    }else{
        price = LocalizationKey(@"marketPrice");
        if ([model.direction isEqualToString:@"1"]) {
            commissionAmount = [NSString stringWithFormat:@"%.2f %@",[model.amount doubleValue],model.coinSymbol];
            commissionTotal = [NSString stringWithFormat:@"%@ %@",@"--",model.baseSymbol];
        }else{
            commissionAmount = [NSString stringWithFormat:@"%@ %@",@"--",model.coinSymbol];
            commissionTotal = [NSString stringWithFormat:@"%.2f %@",[model.amount doubleValue],model.coinSymbol];
        }
    }
    NSArray *contentArr= @[[model.direction isEqualToString:@"0"] ? LocalizationKey(@"Buy"):LocalizationKey(@"Sell"), price, commissionAmount, commissionTotal];
    
    @weakify(self);
    [UGCommissionPopView showPopViewWithTitle:LocalizationKey(@"Confirmation") Titles:contentArr WithTureBtn:@"撤单" clickItemHandle:^{
        @strongify(self);
        [self cancelCommissionWithModel:model];//撤单
    }];
}

-(void)cancelCommissionWithModel:(UGOTCExchageModel*)model {
    
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOrderCancelApi *api= [[UGOrderCancelApi alloc] init];
    api.orderId = model.orderId;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (!apiError) {
            [self.view ug_showToastWithToast:@"撤单成功！"];
            //获取下标
            NSInteger index = [self.dataSource indexOfObject:model];
            //移除当前数据
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataSource];
            [array removeObject:model];
            self.dataSource = array.copy;
            if (index != NSNotFound) {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [self.tableView reloadData];
            }
        } else
            [self.view ug_showToastWithToast:apiError.desc];
    }];
    
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
