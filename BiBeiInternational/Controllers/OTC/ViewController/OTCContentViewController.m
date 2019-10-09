//
//  OTCContentViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/16.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCContentViewController.h"
#import "OTCOrderCell.h"
#import "TOCBuyDetailViewController.h"
#import "UGOTCListApi.h"
#import "OTCViewController.h"
#import "UGBaseViewController+UGGuidMaskView.h"
#import "UGTabBarController.h"
#import "MXRGuideMaskView.h"
#import "UGNewGuidStatusManager.h"
#import "UGScheduleView.h"
#import "UGPayWaySettingViewController.h"
#import "UGOTCBuyApi.h"
#import "OTCWaitingForPayVC.h"
#import "OTCSellCoinViewController.h"
#import "UIViewController+Utils.h"

@interface OTCContentViewController ()
@property (nonatomic,strong)MXRGuideMaskView *maskView;
@property (nonatomic,strong)UGScheduleView *scheduleView;
@property (nonatomic,assign) BOOL isShow;
@end

@implementation OTCContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.tableView.rowHeight = 120.0f;
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OTCOrderCell class])  bundle:nil] forCellReuseIdentifier:NSStringFromClass([OTCOrderCell class])];
    [self headerBeginRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerBeginRefresh) name:@"OTC筛选条件更改刷新数据" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(headerBeginRefresh) name:@"刷新OTC列表" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reShowScheduleView) name:@"发现有待办事项" object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hidenShowGuideView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self reShowScheduleView];
}

-(void)reShowScheduleView{
    if ([self isCardVip]) {
        //卡商
        if (![[NSUserDefaultUtil GetDefaults:@"haveShowOTCGuidView"] isEqualToString:@"1"] && ! [[UGNewGuidStatusManager shareInstance].OTCStatus isEqualToString:@"1"] && !self.isShow && !self.isBuy){
        }else{
            if (!self.maskView) {
                [self getOrderWaitingData];
            }
        }
    }else{
        if (![[NSUserDefaultUtil GetDefaults:@"haveShowOTCGuidView"] isEqualToString:@"1"] && ! [[UGNewGuidStatusManager shareInstance].OTCStatus isEqualToString:@"1"] && !self.isShow && self.isBuy){
        }else{
            if (!self.maskView) {
                [self getOrderWaitingData];
            }
        }
    }
}
#pragma mark -隐藏新手指引
-(void)hidenShowGuideView{
    //新手指引
    if (self.maskView) {
        [self.maskView dismissMaskView];
        self.maskView = nil;
    }
    //待办事项
    if (self.scheduleView) {
        [UGScheduleView hidePopView];
        self.scheduleView = nil;
    }
}

- (UGBaseRequest *)getRequestApiAppend:(BOOL)append {
    UGOTCListApi *request = [UGOTCListApi new];
    request.advertiseType = self.isBuy ? 1 : 0;
    request.currentPage =  @(self.minseq);
    request.marketPrice = @"1";
    OTCViewController *otcVC = (OTCViewController *)self.parentViewController;
    request.filterModel = otcVC.filterModel;
    return  request;
}

- (NSArray *)getDataFromDictionary:(NSDictionary *)object isAppend:(BOOL)append  {
    if (object[@"rows"]) {
        NSArray *array = [UGOTCAdModel mj_objectArrayWithKeyValuesArray:object[@"rows"]];
        if ( ! self.isShow ) {
            if ( ! [[UGNewGuidStatusManager shareInstance].OTCShowOne isEqualToString:@"1"]) {
                [UGNewGuidStatusManager shareInstance].OTCShowOne = @"1";
                 [self showGuid:array.count];
            }
        }
        [self getUserForData];
        return array;
    }
    return nil;
}

-(void)getUserForData{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
        }];
    });
}

-(void)showGuid:(NSInteger )count{
    UGTabBarController *ugTabbar=(UGTabBarController *) APPLICATION.window.rootViewController;
    if ([self isCardVip]) {
        //卡商
        if (![[NSUserDefaultUtil GetDefaults:@"haveShowOTCGuidView"] isEqualToString:@"1"] && ugTabbar.selectedIndex == 1 && ! [[UGNewGuidStatusManager shareInstance].OTCStatus isEqualToString:@"1"] && !self.isShow && ! self.isBuy) {
            if (![[UIViewController currentViewController] isKindOfClass:[OTCViewController class]]) {
                return;
            }
            @weakify(self);
            self.isShow = YES;
            [self setOTCGuidView:count WithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
                @strongify(self);
                self.maskView = maskView;
            } WithHiden:^{
                @strongify(self);
                [self getOrderWaitingData];
            }];
        }
    }else{
        if (![[NSUserDefaultUtil GetDefaults:@"haveShowOTCGuidView"] isEqualToString:@"1"] && ugTabbar.selectedIndex == 1 && ! [[UGNewGuidStatusManager shareInstance].OTCStatus isEqualToString:@"1"] && !self.isShow && self.isBuy) {
            if (![[UIViewController currentViewController] isKindOfClass:[OTCViewController class]]) {
                return;
            }
            @weakify(self);
            self.isShow = YES;
            [self setOTCGuidView:count WithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
                @strongify(self);
                self.maskView = maskView;
            } WithHiden:^{
                @strongify(self);
                [self getOrderWaitingData];
            }];
        }
    }
}

-(void)getOrderWaitingData{
    if (![[UIViewController currentViewController] isKindOfClass:[OTCViewController class]]) {
        return;
    }
    [[UGManager shareInstance] getOrderWaitingDealList:^(BOOL complete, NSMutableArray * _Nonnull object) {
        //显示待办事项
        //待办事项
        if (self.scheduleView) {
            [UGScheduleView hidePopView];
            self.scheduleView = nil;
        }
        if (object.count>0) {
            if ([self isCardVip]) {
                //卡商
                if ( ! self.isBuy && ! self.scheduleView ) {
                    @weakify(self);
                    [UGScheduleView initWithArr:object WithHandle:^(UGOrderWaitingModel * _Nonnull model) {
                        @strongify(self);
                        [self gotoDetail:model];
                    } WithViewHandle:^(UGScheduleView * _Nonnull scheduleView) {
                        @strongify(self);
                        self.scheduleView = scheduleView;
                    } WithCloseHandle:^{
                        
                    }];
                }
            }else{
                if (self.isBuy && ! self.scheduleView ) {
                    @weakify(self);
                    [UGScheduleView initWithArr:object WithHandle:^(UGOrderWaitingModel * _Nonnull model) {
                        @strongify(self);
                        [self gotoDetail:model];
                    }WithViewHandle:^(UGScheduleView * _Nonnull scheduleView) {
                        @strongify(self);
                        self.scheduleView = scheduleView;
                    } WithCloseHandle:^{
                        
                    }];
                }
            }
        }
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGOTCAdModel *model = self.dataSource[indexPath.section];
    OTCOrderCell *orderCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([OTCOrderCell class]) forIndexPath:indexPath];
    orderCell.isBuy = self.isBuy;
    orderCell.model = model;
    @weakify(self);
    orderCell.buyClickHandle = ^(id  _Nonnull sender) {
        @strongify(self);
        [self pushToViewController:model];
    };
    return orderCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGOTCAdModel *model = self.dataSource[indexPath.section];
    [self pushToViewController:model];
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}


-(void)pushToViewController:(UGOTCAdModel *)model{
    //1.先查 禁止操作
    if ([self hasForbidden]) {return;};
  
   //2. 用户交易功能是否被限制
    if ([[UGManager shareInstance] userTransactionDisable]) {return;};
    
    [self buyOrSellClick:model];
    
    
//    //用户交易功能是否被限制
//    if ([[UGManager shareInstance] userTransactionDisable]) {return;};
//    TOCBuyDetailViewController *buyVC =  [TOCBuyDetailViewController new];
//    buyVC.isBuy = self.isBuy;
//    buyVC.model = model;
//    [self.navigationController pushViewController:buyVC animated:YES];
}

#pragma mark -购买、出售
-(void)buyOrSellClick:(UGOTCAdModel *)model{
    
//    //未绑定谷歌验证器   //2.0换手机号
//    if (![self hasBindingGoogleValidator]) {
//        return;
//    }
    
    //购买金额 2000 以上需要检查是否实名认证、高级认证
    if ([self checkMoneyNeedToValidation:[NSString ug_positiveFormatWithDivisor:model.remainAmount dividend:@"1" scale:6]]) {
        return;
    }
    
    //校验是否绑定银行卡
    if ([self checkHadGotoBankBinding]) {
        return;
    }
    
    //检查当前用户的支付方式是否和卖家的匹配
    if (![self checkPayModeMatch:model]) {
        return;
    }
    
    NSString *title = self.isBuy ? @"确认购买" : @"确认出售";
    NSString *message = self.isBuy ? [self upDataMessage:@"forbidTips" WithMessage:@"下单后，请于30分钟内进行付款，否则订单将会自动取消。当日累两笔取消，将禁止交易24小时！"]  : [self upDataMessage:@"creditTips" WithMessage:@"下单后，注意查收订单信息，请于买家付款后120分钟内进行放币，否则将影响您的信用值！"] ;
    @weakify(self);
    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:title message:message cancle:@"我知道了" others:@[title] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
        @strongify(self);
        if (buttonIndex == 1) {
            //购买接口
            [self sendRequest:model];
        }
    }];
}

//检查支付方式是否匹配
- (BOOL)checkPayModeMatch:(UGOTCAdModel *)model {
    if (!self.isBuy && ![model checkPayModeMatch] ) {
        @weakify(self);
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"绑定支付方式" message:[NSString stringWithFormat:@"您的支付方式与买家不匹配（%@），请前往绑定！",[model machPayModelStr]] cancle:@"取消" others:@[@"确定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            if (buttonIndex == 1) {
                @strongify(self);
                UGPayWaySettingViewController *vc = [UGPayWaySettingViewController new];
                vc.topVC = [UIViewController currentViewController];
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
        return NO;
    }
    return YES;
}

#pragma mark - 网络请求
- (void)sendRequest:(UGOTCAdModel *)model {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOTCBuyApi *api = [UGOTCBuyApi new];
    api.isBuy = self.isBuy;
    api.advertisingId = model.ID;
//    api.coinId = self.model.coinId;
    api.amount =  [NSString ug_positiveFormatWithDivisor:model.remainAmount dividend:@"1" scale:6];
    api.money = [NSString ug_positiveFormatWithDivisor:model.remainAmount dividend:@"1" scale:6];
//    api.price = self.model.price;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if ([object isKindOfClass:[NSDictionary class]]) {
            if (object[@"orderNo"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"刷新OTC列表" object:nil];
                if (self.isBuy ) { //购买
                    OTCWaitingForPayVC *buyVC = [OTCWaitingForPayVC new];
                    buyVC.orderSn = object[@"orderNo"];
                    [self.navigationController pushViewController:buyVC animated:YES];
                } else { //出售
                    OTCSellCoinViewController *sell = [OTCSellCoinViewController new];
                    sell.orderSn = object[@"orderNo"];
                    [self.navigationController pushViewController:sell animated:YES];
                }
            }
//            //后台返回改交易剩余数量
//            if (object[@"remainAmount"]) {
//                self.model.remainAmount = [NSString stringWithFormat:@"%@",object[@"remainAmount"]];
//            }
        }  else {
            if ([apiError.desc isEqualToString:@"您绑定的银行卡已达当日收款限额"] && ! self.isBuy) {
                [self showBindingLimit: @"出售提示"];
            }else{
                [self.view ug_showToastWithToast:apiError.desc];
            }
        }
    }];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
