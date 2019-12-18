//
//  UGBillContentVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBillContentVC.h"
#import "UGBillTableViewCell.h"
#import "UGBillDetailVC.h"
#import "UGOrderListModel.h"
#import "UGMineAdViewController.h"
#import "UGAdDetailVC.h"


@interface UGBillContentVC ()
@property (nonatomic, strong) NSMutableArray *listData;
@end

@implementation UGBillContentVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.noNetworkTipImage = @"ug_bill_defult";
    self.noDataTipText = @"暂无钱包记录";

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reciveMathDataNotice:) name:@"UG钱包记录筛选" object:nil];

    if ([UIDevice isIphoneXSeries]) {
        //上拉加载忽略高度,因为顶部有40高度的切换高度
        self.tableView.mj_footer.ignoredScrollViewContentInsetBottom += 40.0f;
    }
    self.tableView.rowHeight = 67.0f;
    [self.tableView ug_registerNibCellWithCellClass:([UGBillTableViewCell class])];
    
    [self headerBeginRefresh];
}

- (void)reciveMathDataNotice:(NSNotification *)notification{
    NSInteger idx = [[notification.userInfo objectForKey:@"appClass"] integerValue];
    self.appClassType = (UGAppClassType)idx;
    //当前选择的控制器做下拉刷新，其它直接拉取首页数据。不然已初始化d的控制器切换的时候会出现下拉刷新的效果。
    UIViewController *controller = [notification.userInfo objectForKey:@"currentConroller"];
    if (controller == self) {
        [self headerBeginRefresh];
    } else {
        [self refreshData];
    }
}

#pragma mark-数据请求

- (UGBaseRequest *)getRequestApiAppend:(BOOL)append {
    UGOrderListApi *api = [[UGOrderListApi alloc] init];
    api.searchType = self.title;
    api.appClassType = self.appClassType;
    api.currentPage =  @(self.minseq);
    return api;
}

- (NSArray *)getDataFromDictionary:(NSDictionary *)object isAppend:(BOOL)append {
    if (object[@"rows"]) {
        NSArray *array = [UGOrderListModel mj_objectArrayWithKeyValuesArray:object[@"rows"]];
        return array;
    }
    return nil;
}

- (NSMutableArray *)listData{
    if (!_listData) {
        _listData = NSMutableArray.array;
    }
    NSString *date;
    NSMutableArray *aList;
    for (UGOrderListModel*model in self.dataSource) {
        if (![date isEqualToString:model.createDate]) {
            date = model.createDate;
            aList = nil;
            aList = NSMutableArray.array;
            [aList addObject:model];
        }
    }
    
    return _listData;
}

#pragma mark -  UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;//self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGBillTableViewCell *billCell = [tableView ug_dequeueReusableNibCellWithCellClass:[UGBillTableViewCell class] forIndexPath:indexPath];
    billCell.orderListModel = self.dataSource[indexPath.row];
    return billCell;
}

#pragma mark -  UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGOrderListModel *model = self.dataSource[indexPath.row];
    //数据类型
    UGOrderListType orderListType = [model orderListType];
    
    if ( orderListType ==  UGOrderListType_OTC) {
        //OTC订单跳转
        [self pustToOTCOrderDetailsWithOrderSn:model.orderSn];
        
    } else if (orderListType == UGOrderListType_Advertis) {
        //交易 跳到广告详情
        UGAdDetailVC *vc = [UGAdDetailVC new];
        vc.advertiseId = model.businessId;//广告id
        [self.navigationController pushViewController:vc animated:YES];
        
    } else if (orderListType == UGOrderListType_Transfer) {
        //转收币
        UGBillDetailVC *vc = [UGBillDetailVC new];
        vc.orderSn = model.orderSn;
        //orderType :收币0 转币1   isIncome:是收入 0否 1是
        vc.orderType = [model.isIncome isEqualToString:@"0"] ? @"1" : @"0"; 
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
