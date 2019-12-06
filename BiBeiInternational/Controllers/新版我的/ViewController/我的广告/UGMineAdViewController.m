//
//  UGMineAdViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGMineAdViewController.h"
#import "UGRelaseButton.h"
#import "UGAdTableViewCell.h"
#import "UGReleaseAdViewController.h"
#import "UGMineAdListApi.h"
#import "UGOTCAdModel.h"
#import "UGDeleteADApi.h"
#import "UGShelvesAdApi.h"
#import "UGAdDetailApi.h"
#import "UGAdDetailModel.h"
#import "AdvertisingBuyViewController.h"
#import "AdvertisingSellViewController.h"
#import "UGAdDetailVC.h"
#import "UGBaseViewController+UGGuidMaskView.h"
#import "MXRGuideMaskView.h"
#import "UGNewGuidStatusManager.h"
#import "UGShareManager.h"

@interface UGMineAdViewController ()

@property(nonatomic, strong) UGRelaseButton *releaseButton;

@property (nonatomic,strong) MXRGuideMaskView *maskView;

@property (nonatomic,assign)BOOL isShow;

@property (nonatomic,assign)BOOL isKnow;
@end

@implementation UGMineAdViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.popGestureRecognizerEnabled = YES;
    }
    return self;
}

- (void)viewDidLoad {@weakify(self);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的发布";
//    [self setupReleaseButton];
    [self setupBarButtonItemWithImageName:@"fabugg_add" type:UGBarImteTypeRight callBack:^(UIBarButtonItem * _Nonnull item) {
        @strongify(self);
          //用户操作功能是否被限制
        if ([self hasForbidden]) {return;};
        
        //用户交易功能是否被限制
        if ([[UGManager shareInstance] userTransactionDisable]) {return;};
        
        //检查是否绑定了谷歌验证器  //2.0换手机号
//            if (![self hasBindingGoogleValidator]) {return;};
        
        //未实名认证
        if ( [self gotoRealNameAuthentication]) {return;}
        
        [self.navigationController pushViewController:[UGReleaseAdViewController new] animated:YES];
    }];
    
    
    self.noNetworkTipImage = @"ug_advertising_defult";
    self.noDataTipText = @"您还没有发布交易哦！ 快去发布交易吧！";
    self.tableView.rowHeight = 121.0f;
    [self.tableView ug_registerNibCellWithCellClass:[UGAdTableViewCell class]];
    [self headerBeginRefresh];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createTradeSuccess:) name :@"创建交易成功" object:nil];
    
    if (!self.popGestureRecognizerEnabled) {
        [self setupBarButtonItemWithImageName:@"goback" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
            @strongify(self);
            //打开侧滑返回
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            [self.navigationController popToRootViewControllerAnimated:YES];
        }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
}

-(void)createTradeSuccess:(NSNotification *)notification{
    NSDictionary *dict = notification.userInfo;
    if (dict) {
        self.isBuyOrSell = !UG_CheckStrIsEmpty([dict objectForKey:@"buyOrSell"]) ? [dict objectForKey:@"buyOrSell"] : @"";
    }
    [self headerBeginRefresh];
    
    self.isKnow = NO;
}
#pragma mark -隐藏新手指引
-(void)hidenShowGuideView{
    if (self.maskView) {
        [self.maskView dismissMaskView];
        self.maskView = nil;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (!self.popGestureRecognizerEnabled) {
        //关闭侧滑返回
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
    if (!self.maskView) {
        [self showBuyOrSell];
    }
}

-(void)showBuyOrSell{
    if (!self.isKnow) {
        self.isKnow = YES;
        if ([self.isBuyOrSell isEqualToString:@"0"]) {
            NSString *messageStr = [self upDataMessage:@"buyTips" WithMessage:@"交易发布后，注意查收订单信息，请于卖家下单后30分钟内进行付款！"];
            [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"确认发布" message:messageStr cancle:@"知道了" others:nil handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            }];
        }else if([self.isBuyOrSell isEqualToString:@"1"]){
            NSString *messageStr = [self upDataMessage:@"sellTips" WithMessage:@"交易发布后，注意查收订单信息，请于买家付款后120分钟内进行放币！"];
            [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"确认发布" message:messageStr cancle:@"我知道了" others:nil handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            }];
        }
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hidenShowGuideView];
}

- (UGBaseRequest *)getRequestApiAppend:(BOOL)append {
    UGMineAdListApi *api = [UGMineAdListApi new];
    api.currentPage = @(self.minseq);
//    api.marketPrice = @"1";
    return api;
}

- (NSArray *)getDataFromDictionary:(NSDictionary *)object isAppend:(BOOL)append {
    if (object[@"rows"]) {
        NSArray *array = [UGOTCAdModel mj_objectArrayWithKeyValuesArray:object[@"rows"]];
        [self showGuid:array];
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

-(void)showGuid:(NSArray *)dataArray{
    if (![[NSUserDefaultUtil GetDefaults:@"haveMineAd"] isEqualToString:@"1"] && dataArray.count>0 && ![ [UGNewGuidStatusManager shareInstance].AdStatus isEqualToString:@"1"] && !self.isShow) {
        if (![[UIViewController currentViewController] isKindOfClass:[UGMineAdViewController class]]) {
            return;
        }
        @weakify(self);
        self.isShow = YES;
        [self setupMineAdNewGuideViewWithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
            @strongify(self);
            self.maskView = maskView;
        } WithHiden:^{
            [self showBuyOrSell];
        }];
    }
}

- (void)setupReleaseButton {
    [self.view addSubview:self.releaseButton];
    [self.releaseButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).mas_offset(-137);
        make.size.mas_equalTo(CGSizeMake(54, 54));
        make.right.equalTo(self.view).mas_offset(-15);
    }];
    [self.view bringSubviewToFront:self.releaseButton];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGAdTableViewCell *cell = [tableView ug_dequeueReusableNibCellWithCellClass:[UGAdTableViewCell class] forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.section];
    cell.showShadow = NO;
    @weakify(self);
    cell.clickButtonHandle = ^(NSString * _Nonnull status, UGOTCAdModel * _Nonnull model) {
        @strongify(self);
        
        //用户操作功能是否被限制
        if ([self hasForbidden]) {return;};
        
        //用户交易功能是否被限制
        if ([[UGManager shareInstance] userTransactionDisable]) {return;};

        if ([status containsString:@"架"]) {
            //上架、下架
            [self sendShelfOrObtainedAdRequestWithModel:model];
            
        } else if ([status containsString:@"删除"]) {
            [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"确认删除" message:@"交易删除后将无法恢复，请您确认后进行删除！" cancle:@"取消" others:@[@"确定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                if (buttonIndex == 1) {
                    //删除
                    [self sendDeleteAdRequestWithModel:model];
                }
            }];
        } else if ([status containsString:@"修改"]) {
            //修改交易，先获取交易详情再进去修改
            [self senddvertiseDetailRequestWithModel:model];
        }else if ([status containsString:@"分享"]){
            //分享
            [self showShareManager:model.ID];
        }
    };
    return cell;
}

#pragma mark -分享广告
-(void)showShareManager:(NSString *)adId{
    NSString *baseUrl = [UGURLConfig shareADApi];
    NSString *meberId = adId;
    NSString *titleStr = [NSString stringWithFormat:@"您的好友%@发布了交易，邀请您进行交易",[UGManager shareInstance].hostInfo.username];
    if (meberId.length > 0) {
        NSString *appendUrl = [NSString stringWithFormat:@"%@%@",baseUrl,meberId];
        UIActivityViewController *activityVC =[[UGShareManager shareManager] createWithTitie: titleStr withActivityImage:[UIImage imageNamed:@"AppIcon"] withUrl:[NSURL URLWithString:appendUrl] withType:@"customActivity"];
        [self presentViewController:activityVC animated:YES completion:nil];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UGOTCAdModel *model = self.dataSource[indexPath.section];
    UGAdDetailVC *vc = [UGAdDetailVC new];
    vc.advertiseId = model.ID;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - 删除交易

- (void)sendDeleteAdRequestWithModel:(UGOTCAdModel *)model {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGDeleteADApi *deleteApi = [UGDeleteADApi new];
    deleteApi.advertiseId = model.ID;
    [deleteApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        [self.view ug_showToastWithToast:apiError ? apiError.desc : @"删除该交易成功"];
        if (!apiError) {
            NSInteger index = [self.dataSource indexOfObject:model];
            NSMutableArray *array = [[NSMutableArray alloc] initWithArray:self.dataSource];
            [array removeObject:model];
            self.dataSource = array.copy;
            if (index != NSNotFound) {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:index] withRowAnimation:UITableViewRowAnimationNone];
            } else {
                [self.tableView reloadData];
            }
        }
    }];
}

#pragma mark - 下架、上架交易

- (void)sendShelfOrObtainedAdRequestWithModel:(UGOTCAdModel *)model {
    //0 上架
    BOOL isShell = [model.status isEqualToString:@"0"];
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGShelvesAdApi *api = [UGShelvesAdApi new];
    api.advertiseId = model.ID;
    api.isOn = isShell;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (! isShell && apiError && [apiError.desc isEqualToString:@"您绑定的银行卡已达当日收款限额"]) {
            [self showBindingLimit: @"上架提示"];
        }else{
            [self.view ug_showToastWithToast:apiError ? apiError.desc : isShell ? @"下架成功" : @"上架成功"];
            if (!apiError) {
                //修改本地状态,用了KVO所以不需要刷新
                //            model.remainAmount =   isShell ? @"0" : model.remainAmount;
                model.status = isShell ? @"1" : @"0";
            }
        }
    }];
}

#pragma mark - 获取交易详情后跳转修改页面
- (void)senddvertiseDetailRequestWithModel:(UGOTCAdModel *)model {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGAdDetailApi *api = [UGAdDetailApi new];
    api.ID = model.ID;
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (!apiError) {
            UGAdDetailModel  *detailModel = [UGAdDetailModel mj_objectWithKeyValues:object];
//            MyAdvertisingDetailModel *detailModel  = [MyAdvertisingDetailModel mj_objectWithKeyValues:object];
            if ([detailModel.advertiseType isEqualToString:@"0" ]) {
                //购买交易  进入购买交易编辑界面
                AdvertisingBuyViewController *buyVC = [[AdvertisingBuyViewController alloc] init];
                buyVC.index = 1;
                buyVC.detailModel = detailModel;
                //修改交易完成
                buyVC.reviseCompleteHandle = ^(NSDictionary *dict) {
                    //修改该交易的值
                    @strongify(self);
                    [self changeModelValueWithDict:dict withModel:model];
                };
                [self.navigationController pushViewController:buyVC animated:YES];
            } else {
                //出售交易  进入出售交易编辑界面
                AdvertisingSellViewController *sellVC = [[AdvertisingSellViewController alloc] init];
                sellVC.index = 1;
                sellVC.detailModel = detailModel;
                //修改交易完成
                sellVC.reviseCompleteHandle = ^(NSDictionary *dict) {
                    //修改该交易的值
                    @strongify(self);
                    [self changeModelValueWithDict:dict withModel:model];
                };
                [self.navigationController pushViewController:sellVC animated:YES];
            }

        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

- (void)changeModelValueWithDict:(NSDictionary *)dict withModel:(UGOTCAdModel *)model {
    model.number = dict[@"number"];
    model.minLimit = dict[@"minLimit"];
    model.maxLimit = dict[@"maxLimit"];
    model.remainAmount = model.number;
    model.payWays = dict[@"payWays"];
    model.status = @"0";
}

#pragma mark - Getter Method

- (UGRelaseButton *)releaseButton {
    if (!_releaseButton) {
        _releaseButton = [UGRelaseButton new];
        _releaseButton.freeRect = CGRectMake(14, 14, CGRectGetWidth(self.view.frame) -14*2, CGRectGetHeight(self.view.frame) - 14 - UG_StatusBarAndNavigationBarHeight - UG_TabBarBottomHeight - 20);
        @weakify(self);
        _releaseButton.clickDragViewBlock = ^(WMDragView *dragView){
            @strongify(self);
              //用户操作功能是否被限制
            if ([self hasForbidden]) {return;};
            
            //用户交易功能是否被限制
            if ([[UGManager shareInstance] userTransactionDisable]) {return;};
            
            //检查是否绑定了谷歌验证器  //2.0换手机号
//            if (![self hasBindingGoogleValidator]) {return;};
            
            //未实名认证
            if ( [self gotoRealNameAuthentication]) {return;}
            
            [self.navigationController pushViewController:[UGReleaseAdViewController new] animated:YES];
        };
    }
    return _releaseButton;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
