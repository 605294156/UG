//
//  UGHomeVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/15.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeVC.h"
#import "UGWalletBanner.h"
#import "PlatformMessageModel.h"
#import "CustomSectionHeader.h"
#import "pageScrollView.h"
#import "PlatformMessageDetailViewController.h"
#import "MineNetManager.h"
#import "UGHomeBtnsCell.h"
#import "UGHomeSecondTwoHeader.h"
#import "UGHomeMarketCell.h"
#import "AppDelegate.h"
#import "UGHomeCreateWalletVC.h"
#import "UGAssetsViewController.h"
//#import "UGQRScanVC.h"
#import "UGHomeTransferVC.h"
#import "UGHomeReceiptCoinVC.h"
#import "UGBillViewController.h"
#import "UGPopView.h"
#import "UGHomeConinToCoinVC.h"
#import "TransactionRecordViewController.h"
#import "UGHomeMessageVC.h"
#import "UGHomeMarketListVC.h"
#import "KchatViewController.h"
#import "HomeNetManager.h"
#import "MarketNetManager.h"
#import "symbolModel.h"
#import "marketManager.h"
#import "UGShareManager.h"
#import "ChatGroupInfoModel.h"
#import "UGWalletAllApi.h"
#import "UGWalletAllModel.h"
#import "ChatGroupFMDBTool.h"
#import "UGSettingPayPassWordVC.h"
#import "UGNavController.h"
#import "UGExchangeRateApi.h"
#import "UGCnyToUsdtApi.h"
#import "UGPlatformMessageApi.h"
#import "UGBindingGoogleVC.h"
#import "UGRemotemessageHandle.h"
#import "UGNotifyModelTool.h"
#import "UGPayQRModel.h"
#import "UGTabBarController.h"
#import "OTCViewController.h"
#import "UGSystemMessageDetailVC.h"
#import "UGLinkmanVC.h"
#import "UGBaseViewController+UGGuidMaskView.h"
#import "MXRGuideMaskView.h"
#import "UGNewGuidStatusManager.h"
#import "UGScheduleView.h"
#import "UGOrderWaitingModel.h"
#import "OTCJpushViewController.h"
#import "UGSymbolThumbApi.h"
#import "UGSymbolThumbModel.h"
#import "OpenReceiveCell.h"
#import "UGOpenReceivePopView.h"
#import "UGOpenCloseDispatchApi.h"
#import "UGGetTaskCountApi.h"
#import "UGGetOpeningOrderStatusaApi.h"
#import "UGPopIntegrationView.h"
#import "UGGeneralCertificationVC.h"
#import "UGPlayCell.h"
#import "UGVideoPlayerVCViewController.h"
#import "bannerCellModel.h"
#import "UGCenterPopView.h"
//#import "UGAnnouncementPopView.h"
#import "UGNoticeFindAlertApi.h"
#import "UGMakeTrueMnemonnicVC.h"
#import "UGSaveOfficialWebsiteGuideController.h"
#import "QRCodeScanVC.h"
#import "UGQYSDKManager.h"
//新版弹窗类
#import "UGAnnouncementNewPopView.h"
#import "UGRegistrationInvitationVC.h"

#define BtnsCellIdentifier @"UGHomeBtnsCell"
#define MarketCellIdentifier @"UGHomeMarketCell"
#define OpenReceiveCellIdentifier @"OpenReceiveCell"
#define PlayCellCellIdentifier @"UGPlayCell"



@interface UGHomeVC ()<UGHomeBthsCellDegate,chatSocketDelegate,SocketDelegate>
@property (nonatomic,copy)NSMutableArray *platformMessageArr;//平台消息数据
@property (nonatomic,strong)NSMutableArray *bannerDataArr;//UG钱包列表数据
@property (nonatomic,strong)NSMutableArray *currentMarketDataArr;//行情列表数据
@property (nonatomic,strong)NSDictionary *marketDict;
@property (nonatomic,strong)NSMutableArray *baseArray;//行情基础币
@property (nonatomic,strong)NSMutableArray *contentArr;//首页推荐、涨幅榜数据  不显示 但是要取到最高的数据
@property (nonatomic,copy)NSArray *popDataArr;//弹框数据
@property (nonatomic,copy)NSArray *popImgDataArr;//弹框图片数据
@property (nonatomic,strong)UGWalletBanner *bannerView;
//@property (nonatomic,strong)UIImageView *tipImageView;
@property (nonatomic,strong)UGHomeSecondTwoHeader *marketSectionView;
@property (nonatomic,assign)BOOL isfrist;
@property (nonatomic,strong)UGPopView *popView;
@property (nonatomic,strong)UIBarButtonItem *rightBarButtomItem;
@property (nonatomic,strong)ChatGroupInfoModel *groupInfoModel;
@property (nonatomic,assign)BOOL isDragging;//手指是否在拖拽tableView
@property (nonatomic, strong) dispatch_queue_t refreshDataQueue;
@property (nonatomic,strong)MXRGuideMaskView *maskView;
@property (nonatomic,assign)BOOL isShow;
@property (nonatomic,copy)NSMutableArray *orderWaitingArr;//平台消息数据
@property (nonatomic,assign)BOOL isShowOrderView;
@property (nonatomic,assign)BOOL isFirstView;
@property (nonatomic,assign)BOOL isGetMaket;//首次获取行情数据
@property (nonatomic,copy)NSString *currentSelectedMarketData;
@property (nonatomic,copy)NSString *openingOrderStatus;//承兑商 是否开启接单
@property (nonatomic,copy)NSString *todayCount;//承兑商 今日接单数
@property (nonatomic,copy)NSString *totalCount;//承兑商 总接单数
@property (nonatomic,assign)BOOL isShowIntergaraion; //是否显示了弹框
@property (nonatomic,assign)BOOL isShowRule; //是否可以弹积分规则
@property(nonatomic,strong)NSMutableArray *bannerCelldataArray;//cell 里面的轮播图数据源

//公告弹窗是否出现
@property(nonatomic,assign)BOOL isAnnouncementShow;
@property(nonatomic,copy)NSString *AnnouncementContent;
@property(nonatomic,copy)NSString *AnnouncementTittle;
//接口是否返回公告内容
@property(nonatomic,assign)BOOL isAnnouncementHaveData;
@property(nonatomic,copy)NSString *CNYRateToUG;


@end 

static const void *BKBarButtonItemBlockKey = &BKBarButtonItemBlockKey;

static const void *CustomItem = &CustomItem;

@implementation UGHomeVC
- (void)viewDidLoad{
    [super viewDidLoad];
    [self initUI];
    self.refreshDataQueue = dispatch_queue_create("com.bibei.refreshDataQueue", DISPATCH_QUEUE_PRIORITY_DEFAULT);

#pragma mark- 判断是否登录
    if (![[UGManager shareInstance] hasLogged]) {
        [self showLoginViewController];
    }

#pragma mark-判断有没有设置支付密码
    [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
        if (![UGManager shareInstance].hostInfo.userInfoModel.hasJypassword && [[UGManager shareInstance] hasLogged]) {
            //登录成功 进行支付密码设置
            UGSettingPayPassWordVC *vc =[UGSettingPayPassWordVC new];
            vc.isHome = YES;
            [self.navigationController presentViewController:[[UGNavController new]initWithRootViewController:vc] animated:NO completion:nil];
        }
        if (![UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone && [[UGManager shareInstance] hasLogged] && ![UGManager shareInstance].hostInfo.userInfoModel.bindAuxiliaries ) {
            //登录成功 进绑定助记词
            UGMakeTrueMnemonnicVC *vc =[UGMakeTrueMnemonnicVC new];
            vc.isfromRegister = YES;
            [self.navigationController presentViewController:[[UGNavController new]initWithRootViewController:vc] animated:NO completion:nil];
        }
    }];
    
    self.AnnouncementContent =@"";
    self.AnnouncementTittle = @"";
    self.isAnnouncementHaveData = NO;

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucess) name:@"LOGINSUCCES" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reShowScheduleView) name:@"发现有待办事项" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignOutS) name:@"用户点击退出登录" object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData) name:@"UGAnnouncementPopViewButtonClick" object:nil];
}

//#pragma mark-公告通知弹窗
//-(void)showAnnouncementPopView
//{
//    [[UGAnnouncementPopView shareInstance] showPopViewWithTitle:self.AnnouncementTittle WithAnnouncement:self.AnnouncementContent];
//
//}

-(void)userSignOutS{
    //承兑商退出登录
    [UGNewGuidStatusManager shareInstance].openCardOrderReceive = @"0";
    self.isShowIntergaraion = NO;
}

-(void)reShowScheduleView{
    self.isShowOrderView = NO;
    [self loadData];
}

#pragma mark -隐藏新手指引
-(void)hidenShowGuideView{
    if (self.maskView) {
        [self.maskView dismissMaskView];
        self.maskView = nil;
    }
    [UGScheduleView hidePopView];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hidenShowGuideView];
}

#pragma mark- 登录后刷新数据
-(void)userLoginSucess{
    [[UGQYSDKManager shareInstance] logoutQYSDK];
    self.isFirstView = NO;
    [self.tableView.mj_header beginRefreshing];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self loadData];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.isShowOrderView = NO;
}

#pragma mark - 请求数据
-(void)loadData{

    dispatch_async(self.refreshDataQueue, ^{

        dispatch_group_t uploadGroup = dispatch_group_create();
        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
            [self getUSDTToCNYRate:^(BOOL complete) {
                NSLog(@"api--请求人民币美元汇率");
                dispatch_group_leave(uploadGroup);
            }];
        });
        
        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
            [self getUGTOCny:^(BOOL complete) {
                NSLog(@"api--请求UG对人民币汇率");
                dispatch_group_leave(uploadGroup);
            }];
        });
        
//        dispatch_group_enter(uploadGroup);
//        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
//            [self getContentData:^(BOOL complete) {
//                NSLog(@"api--请求涨幅榜推荐");
//                dispatch_group_leave(uploadGroup);
//            }];
//        });
        
        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
            [self getBanaData:^(BOOL complete) {
                NSLog(@"api--请求UG钱包");
                dispatch_group_leave(uploadGroup);
            }];
        });
        
        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
            [self getNotice:^(BOOL complete) {
                NSLog(@"api--请求平台消息");
                dispatch_group_leave(uploadGroup);
            }];
        });
        
        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
            [self getMarketDatas:^(BOOL complete) {
                NSLog(@"api--请求行情");
                dispatch_group_leave(uploadGroup);
            }];
        });
        
        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
            [[UGManager shareInstance] getOrderWaitingDealList:^(BOOL complete, NSMutableArray * _Nonnull object) {
                NSLog(@"api--请求待办事项");
                self.orderWaitingArr  =[object mutableCopy];
                dispatch_group_leave(uploadGroup);
            }];
        });
        
        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
            [self getOpeningOrderStatus:^(BOOL complete) {
                NSLog(@"api--获取接单状态");
                dispatch_group_leave(uploadGroup);
            }];
        });
        
        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
            [self getTaskCount:^(BOOL complete) {
                NSLog(@"api--获取接单数");
                dispatch_group_leave(uploadGroup);
            }];
        });
        
        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
            [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
                NSLog(@"api--请求个人信息");
                if ([self isCardVip]) {
                    self.popDataArr = @[@"扫一扫",@"邀请注册",@"消息"];
                }
                dispatch_group_leave(uploadGroup);
            }];
        });
        
        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
            [self getHomeBannerContentData:^(BOOL complete) {
                NSLog(@"api--请求首页banner数据");
               dispatch_group_leave(uploadGroup);
            }];
        });
        
        if ([self isCardVip]) {
            dispatch_group_enter(uploadGroup);
            dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
                [self getHomeBannerRegistrationInvitationData:^(BOOL complete) {
                    NSLog(@"api--请承兑商邀请注册banner数据");
                    dispatch_group_leave(uploadGroup);
                }];
            });
        }

        dispatch_group_enter(uploadGroup);
        dispatch_group_async(uploadGroup, self.refreshDataQueue, ^{
            [self getAnnouncementNoticeData:^(BOOL complete) {
                NSLog(@"api--请求公告弹窗数据");
                 dispatch_group_leave(uploadGroup);
            }];
        });
        
        dispatch_group_notify(uploadGroup, self.refreshDataQueue, ^{
            
            NSLog(@"首页所有请求完成，执行刷新数据");
            //2.在这里 进行请求后的方法，回到主线程
            dispatch_async(dispatch_get_main_queue(), ^{
                //3.更新UI操作
                [self.tableView.mj_header endRefreshing];
                [self.tableView reloadData];
                //显示新手指引
                UGTabBarController *ugTabbar=(UGTabBarController *) APPLICATION.window.rootViewController;
                if ([UGManager shareInstance].hostInfo.userInfoModel.hasJypassword && [[UGManager shareInstance] hasLogged]) {
                        if (![[UIViewController currentViewController] isKindOfClass:[UGHomeVC class]]) {
                            return;
                        }
                        if (self.isAnnouncementHaveData)
                        {
                            if (![[NSUserDefaultUtil GetDefaults:@"haveShowHomeGuidView"] isEqualToString:@"1"] && ![[UGNewGuidStatusManager shareInstance].homeNewStatus isEqualToString:@"1"] && ugTabbar.selectedIndex == 0 && !self.isShow && [UGNewGuidStatusManager shareInstance].AnnouncementIsViewByUser) {
                                self.isShow = YES;
                                [self setupHomeNewGuideView:self.platformMessageArr.count>0 ? YES : NO WithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
                                    self.maskView = maskView;
                                } WithHiden:^{
                                    [self showUGScheduleView];
                                }];
                            }else{
                                
                                if (![UGNewGuidStatusManager shareInstance].AnnouncementIsViewByUser &&!self.isAnnouncementShow)
                                {
                                    self.isAnnouncementShow = YES;
                                    [UGAnnouncementNewPopView showPopViewWithTitle:self.AnnouncementTittle andAnnouncement:self.AnnouncementContent clickItemHandle:^{
                                        
                                        if(![[NSUserDefaultUtil GetDefaults:@"haveShowHomeGuidView"] isEqualToString:@"1"] && ![[UGNewGuidStatusManager shareInstance].homeNewStatus isEqualToString:@"1"] && ugTabbar.selectedIndex == 0 && !self.isShow && [UGNewGuidStatusManager shareInstance].AnnouncementIsViewByUser)
                                        {
                                            self.isShow = YES;
                                            [self setupHomeNewGuideView:self.platformMessageArr.count>0 ? YES : NO WithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
                                                self.maskView = maskView;
                                            } WithHiden:^{
                                                [self showUGScheduleView];
                                            }];
                                        }
                                        else
                                        {
                                            if (!self.maskView)
                                            {
                                                [self showUGScheduleView];
                                            }
                                        }
                                        
                                    }];
                                }
                                
                                if ([UGNewGuidStatusManager shareInstance].AnnouncementIsViewByUser && self.isAnnouncementShow) {
                                    if (!self.maskView) {
                                        [self showUGScheduleView];
                                    }
                                }
                            }
                        }
                        else
                        {
                            if (![[NSUserDefaultUtil GetDefaults:@"haveShowHomeGuidView"] isEqualToString:@"1"] && ![[UGNewGuidStatusManager shareInstance].homeNewStatus isEqualToString:@"1"] && ugTabbar.selectedIndex == 0 && !self.isShow) {
                                self.isShow = YES;
                                [self setupHomeNewGuideView:self.platformMessageArr.count>0 ? YES : NO WithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
                                    self.maskView = maskView;
                                } WithHiden:^{
                                    [self showUGScheduleView];
                                }];
                            }else{
                                if (!self.maskView)
                                {
                                    [self showUGScheduleView];
                                }
                            }
                        }
                    }
            });
        });
    });
}


-(void)showUGScheduleView{
    if (![[UIViewController currentViewController] isKindOfClass:[UGHomeVC class]]) {
        return;
    }
    //显示待办事项
    if (self.orderWaitingArr.count>0) {
        if (!self.isFirstView) {
            self.isFirstView = YES;
            self.isShowOrderView = YES;
            //先隐藏
            [UGScheduleView hidePopView];
            @weakify(self);
            [UGScheduleView initWithArr:self.orderWaitingArr WithHandle:^(UGOrderWaitingModel * _Nonnull model) {
                @strongify(self);
                [self gotoDetail:model];
            }WithViewHandle:^(UGScheduleView * _Nonnull scheduleView) {
                
            }WithCloseHandle:^{
                // 待办事项之后  开启接单
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                      [self showOpenOrderReceiveView];
                });
            }];
        }else{
            if (!self.isShowOrderView) {
                self.isShowOrderView = YES;
                //先隐藏
                [UGScheduleView hidePopView];
                @weakify(self);
                [UGScheduleView initWithArr:self.orderWaitingArr WithHandle:^(UGOrderWaitingModel * _Nonnull model) {
                    @strongify(self);
                    [self gotoDetail:model];
                }WithViewHandle:^(UGScheduleView * _Nonnull scheduleView) {
                }WithCloseHandle:^{
                    // 待办事项之后  开启接单
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self showOpenOrderReceiveView];
                    });
                }];
            }
        }
    }else{
        //开启接单
        [self showOpenOrderReceiveView];
    }
}

#pragma mark - 显示开启订单
-(void)showOpenOrderReceiveView{
    if (![[UIViewController currentViewController] isKindOfClass:[UGHomeVC class]]) {
        return;
    }
    if ([self isCardVip] && ![[UGNewGuidStatusManager shareInstance].openCardOrderReceive isEqualToString:@"1"] && [self.openingOrderStatus isEqualToString:@"0"] && ! self.isShowIntergaraion) {
        self.isShowIntergaraion = YES;
        [UGOpenReceivePopView showOpenPopViewClickItemHandle:^(BOOL isOpen) {
            if (isOpen) {
                //用户操作功能是否被限制
                if ([self hasForbidden]) {return;}
                
                //用户交易功能是否被限制
                if ([[UGManager shareInstance] userTransactionDisable]) { return;};
                
                [UGOpenReceivePopView hidenPopView];
//                //检查是否绑定了谷歌验证器 2.0换成手机
//                if (![self hasBindingGoogle]) {  self.isShowIntergaraion = NO; return;}
                //检查是否需要实名
                if (![self checkMoneyNeedToValidations]) {self.isShowIntergaraion = NO; return;}
                
                //校验是否绑定银行卡
                if ([self checkHadGotoBankBinding]) {return;}
                
                self.isShowRule = YES;
                [UGNewGuidStatusManager shareInstance].openCardOrderReceive = @"1";
                [self openOrderReceiving: [self.openingOrderStatus isEqualToString:@"0"] ? @"1" : @"0"];
            }else{
                self.isShowRule = YES;
                [UGNewGuidStatusManager shareInstance].openCardOrderReceive = @"1";
                [UGOpenReceivePopView hidenPopView];
            }
            // 之后  积分弹框提示
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.isShowRule) {
                    [self showIntegartion];
                }
            });
        }];
    }
} 
#pragma mark - 承兑商验证谷歌绑定-实名认证
- (BOOL)hasBindingGoogle{
    BOOL hasGoogleValidation = [UGManager shareInstance].hostInfo.userInfoModel.hasGoogleValidation;
    if (!hasGoogleValidation) {
        @weakify(self);
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"绑定提醒" message:@"为了您的资产安全，交易前请您先绑定谷歌验证器" cancle:@"我偏不" others:@[@"去绑定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            if (buttonIndex == 1) {
                @strongify(self);
                UGBindingGoogleVC *vc = [[UGBindingGoogleVC alloc] init];
                vc.baseVC = self;
                vc.isCarvip = YES;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }
    return hasGoogleValidation;
}

#pragma mark - 承兑商验证实名认证
- (BOOL)checkMoneyNeedToValidations{
    //实名认证状态
    BOOL hasRealnameValidation = [UGManager shareInstance].hostInfo.userInfoModel.hasRealnameValidation;
    if (!hasRealnameValidation) {
        @weakify(self);
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"认证提醒" message:@"为了您的资产安全，交易前请您先进行实名认证！" cancle:@"取消" others:@[@"去认证"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
             @strongify(self);
            if (buttonIndex == 1) {
                [self.navigationController pushViewController:[UGGeneralCertificationVC new] animated:YES];
            }
        }];
    }
    return hasRealnameValidation;
}

#pragma mark - 积分弹框提示
-(void)showIntegartion{
    [UGPopIntegrationView showIntegrationRuleClickHandle:^{
    }];
}

#pragma mark - 开始刷新数据
-(void)refreshData{
    [self loadData];
}

-(void)initUI{    
//    self.viewType= ChildViewType_USDT;
     self.index= 0;
    
    //主线程中取得AppDelegate中的值，防止报错
    self.CNYRateToUG = ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG;
    
    self.isfrist = YES;
    
    [self rightButton];
    
    [self languageChange];
    
    [self setTableViewHeaderView];
    
    [self.tableView.mj_header beginRefreshing];
    
}

-(void)languageChange{
    self.navigationItem.title=LocalizationKey(@"tabbar1");
    self.popDataArr =@[@"扫一扫",@"邀请好友",@"消息"];
    self.popImgDataArr = @[@"pop_scan.png",@"pop_invite.png",@"pop_message.png"];
//  self.popDataArr =@[@"扫一扫",@"查找联系人",@"邀请好友",@"消息"];
//  self.popImgDataArr = @[@"pop_scan.png",@"pop_search.png",@"pop_invite.png",@"pop_message.png"];
}

-(void)rightButton{
//    @weakify(self);
    [self setupBarButtonItemWithImageName:@"home_add" type:UGBarImteTypeRight callBack:^(UIBarButtonItem * _Nonnull item) {
//        @strongify(self);
//        [self righttouchEvent:item.customView];
        
        AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
        [tabViewController setSelectedIndex:2];
    }];
//    self.tipImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 10, 10)];
//    self.tipImageView.hidden = YES;
//    self.tipImageView.image = [UIImage imageNamed:@"chatTipImage"];
//    [rightButton addSubview:self.tipImageView];
}

-(void)setTableViewHeaderView{
    self.tableView.tableHeaderView=self.bannerView;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGHomeBtnsCell" bundle:nil] forCellReuseIdentifier:BtnsCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"UGHomeMarketCell" bundle:nil] forCellReuseIdentifier:MarketCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"OpenReceiveCell" bundle:nil] forCellReuseIdentifier:OpenReceiveCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"UGPlayCell" bundle:nil] forCellReuseIdentifier:PlayCellCellIdentifier];
}

#pragma mark -懒加载

-(NSMutableArray*)bannerCelldataArray
{
    if (!_bannerCelldataArray) {
        
        _bannerCelldataArray = [NSMutableArray array];
    }
    
    return _bannerCelldataArray;
}

- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}

- (NSMutableArray *)platformMessageArr {
    if (!_platformMessageArr) {
        _platformMessageArr = [NSMutableArray array];
    }
    return _platformMessageArr;
}

- (NSMutableArray *)bannerDataArr {
    if (!_bannerDataArr) {
        _bannerDataArr = [NSMutableArray array];
    }
    return _bannerDataArr;
}

- (NSMutableArray *)currentMarketDataArr {
    if (!_currentMarketDataArr) {
        _currentMarketDataArr = [NSMutableArray array];
    }
    return _currentMarketDataArr;
}

- (NSMutableArray *)orderWaitingArr {
    if (!_orderWaitingArr) {
        _orderWaitingArr = [NSMutableArray array];
    }
    return _orderWaitingArr;
}

- (NSMutableArray*)baseArray {
    if (!_baseArray) {
        _baseArray = [NSMutableArray array];
    }
    return _baseArray;
}

-(UGWalletBanner *)bannerView{
    if (!_bannerView) {
        _bannerView =[[UGWalletBanner alloc]initWithFrame:CGRectMake(0, 0, kWindowW, UG_AutoSize(180)) viewSize:CGSizeMake(kWindowW,UG_AutoSize(180))];
        @weakify(self);
        _bannerView.cellClick = ^(UGWalletBanner *barnerview, NSInteger index) {
            @strongify(self);
            if (self.bannerDataArr.count>0) {
                UGAssetsViewController *vc = [[UGAssetsViewController alloc] init];
                vc.listData = self.bannerDataArr;
                [self.navigationController pushViewController:vc animated:YES];
            }
        };
        _bannerView.buyClick = ^(UGWalletBanner *barnerview, NSInteger index) {
            @strongify(self);
            if ([self isCardVip]) {
                //卡商
                NSString *message = [self upDataMessage:@"rechargeTips" WithMessage:[UGURLConfig cardVipMessage]];
                [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"温馨提示" message:message cancle:@"知道了" others:nil handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                }];
            }else{
                [self postNotiChangeBuyOrSell:[NSString stringWithFormat:@"%ld",index]];
            }
        };
        _bannerView.sellClick = ^(UGWalletBanner *barnerview, NSInteger index) {
            @strongify(self);
            [self postNotiChangeBuyOrSell:[NSString stringWithFormat:@"%ld",index]];
        };
        _bannerView.idLongClick = ^(UILongPressGestureRecognizer *longPress) {
                @strongify(self);
            [self longClick:longPress];
        };
    }
    return _bannerView;
}

#pragma mark -长按复制
-(void)longClick:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSString *qrstring =  [UGManager shareInstance].hostInfo.username;
        [UIPasteboard generalPasteboard].string = !UG_CheckStrIsEmpty(qrstring)?qrstring:@"";
        [self.view ug_showToastWithToast:@"复制成功！"];
    }
}

-(void)postNotiChangeBuyOrSell:(NSString *)index{
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
    [tabViewController setSelectedIndex:1];
    if ([self isCardVip]) {
        //卡商  只有出售
         [[NSNotificationCenter defaultCenter]postNotificationName:@"OTC接收购买或出售" object:nil userInfo: @{@"index":@"0"}];
    }else{
         [[NSNotificationCenter defaultCenter]postNotificationName:@"OTC接收购买或出售" object:nil userInfo: @{@"index":index}];
    }
}

//#pragma mark - 右边按钮点击
//-(void)righttouchEvent:(UIView *)buttonItem{
//    @weakify(self);
//    [UGPopView showPopViewWithTitles:self.popDataArr imgNames:self.popImgDataArr onView:buttonItem clickItemHandle:^(NSInteger index) {
//        @strongify(self);
//        switch (index) {//扫一扫
//            case 0:
//            {
//                if (![self hasForbidden]) {
////                    if ([self hasBindingGoogleValidator]) { //2.0换手机号
//                        [self qrScan];
////                    }
//                }
//            }
//                break;
////            case 1://查找联系人
////                [self.navigationController pushViewController:[UGLinkmanVC new] animated:YES];
////                break;
//            case 1://邀请好友
//                [self showShareManager];
//                break;
//            case 2://消息
//                [self.navigationController pushViewController:[UGHomeMessageVC new] animated:YES];
//                break;
//            default:
//                break;
//        }
//    }];
//}

#pragma mark UGHomeBtnsDelegate
-(void)clickWithIndex:(int)index{
    switch (index) {
        case 0:
        {//扫一扫
            if (![self hasForbidden]) {
//                if ([self hasBindingGoogleValidator]) { //2.0换手机号
                    [self qrScan];
//                }
            }
        }
            break;
        case 1:
        {//转币
            if (![self hasForbidden]) {
//                if ([self hasBindingGoogleValidator]) {//2.0换手机号
                    [self.navigationController pushViewController:[UGHomeTransferVC new] animated:YES];
//                }
            }
        }
            break;
        case 2:
        {//收币
            if (![self hasForbidden]) {
//                if ([self hasBindingGoogleValidator]) {//2.0换手机号
                //检查是否需要实名
                if ([self checkMoneyNeedToValidations]) {
                      [self.navigationController pushViewController:[UGHomeReceiptCoinVC new] animated:YES];
                }
//                }
            }
        }
            break;
        case 3://UG钱包记录
            [self.navigationController pushViewController:[UGBillViewController new] animated:YES];
            break;
        case 4://UG邀请好友
        [self showShareManager];
        break;
        case 5:{//UG交易
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            UITabBarController *tabViewController = (UITabBarController *) appDelegate.window.rootViewController;
            [tabViewController setSelectedIndex:1];
        }
        break;
        case 6:
        {//币币兑换
            if (![self hasForbidden]) {
//                if ([self hasBindingGoogleValidator]) {//2.0换手机号
                    [self.navigationController pushViewController:[UGHomeConinToCoinVC new] animated:YES];
//                }
            }
        }
            break;
        case 7://法币订单
            [self.navigationController pushViewController:[TransactionRecordViewController new] animated:YES];
            break;
        default:
            break;
    }
}

#pragma mark -扫一扫
-(void)qrScan{
    QRCodeScanVC *vc = [[QRCodeScanVC alloc]init];
    @weakify(self);
    vc.QrcodeScanResult = ^(NSString * _Nonnull resultStr) {
     @strongify(self);
        NSLog(@"二维码信息：%@",resultStr);
        if (!UG_CheckStrIsEmpty(resultStr))
      {
         NSDictionary *dict = [UG_MethodsTool dictWithJsonString:[UG_MethodsTool decodeString:resultStr]];
         UGPayQRModel *qrModel = [UGPayQRModel mj_objectWithKeyValues:dict];
        [self gotoTransVC:qrModel];
      }
     };
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark -跳转到转币页面
-(void)gotoTransVC:(UGPayQRModel *)model{
    if ([model isKindOfClass:[UGPayQRModel class]]) {
        UGHomeTransferVC *vc = [[UGHomeTransferVC alloc] init];
        vc.qrModel = model;
        [self.navigationController pushViewController:vc animated:NO];
    }else{
        [self.view ug_showToastWithToast:@"不符合规则的二维码,无法转账！"];
    }
}

#pragma mark -邀请好友
-(void)showShareManager{
    if ([self isCardVip]) {
        //承兑商邀请注册 todo
        UGRegistrationInvitationVC *vc = [[UGRegistrationInvitationVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
        
    }else{
        NSString *baseUrl =[UGURLConfig invitationApi];
        NSString *meberId = [UGManager shareInstance].hostInfo.userInfoModel.member.ID;
        if (meberId.length > 0) {
            NSString *appendUrl = [NSString stringWithFormat:@"%@%@",baseUrl,meberId];
            UIActivityViewController *activityVC =[[UGShareManager shareManager] createWithTitie:@"UG钱包注册" withActivityImage:[UIImage imageNamed:@"AppIcon"] withUrl:[NSURL URLWithString:appendUrl] withType:@"customActivity"];
            [self presentViewController:activityVC animated:YES completion:nil];
        }
    }
}

#pragma mark -delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    } else {
        if ([[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString :@"1"]) {
            return 1;
        }
        return self.currentMarketDataArr .count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath{
    if (indexPath.section==0) {
        if (indexPath.row == 1) {
             return 100;
        }
        return 170;
    }else{
        if ([[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString :@"1"]) {
            return 41;
        }
        return 55;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row == 1) {
            
            UGPlayCell * cell = [tableView dequeueReusableCellWithIdentifier:PlayCellCellIdentifier forIndexPath:indexPath];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            if (self.bannerCelldataArray.count) {
                [cell refreshUGPlayCellWithArray:self.bannerCelldataArray];
            }
            @weakify(self);
            cell.backToHomeVCBlock = ^(bannerCellModel *model) {
            @strongify(self);
                switch (model.type) {
                    case 0:
//                     不跳转
                        break;
                    case 1:
//                      网页跳转
                        [self gotoWebView:model.title htmlUrl:model.url];
                        break;
                    case 2:
//                      播放视频
                        [self playVideoWithUrl:model.url];
                        break;
                    case 3:
                    {
//                      将官网添加到桌面快捷方式
                        [self addDesktopShortcut];
                    }
                    break;
                    case 4:
                    {
                        if ([self isCardVip])
                        {
                            //承兑商分红，注册邀请
                            UGRegistrationInvitationVC *vc = [[UGRegistrationInvitationVC alloc] init];
                            [self.navigationController pushViewController:vc animated:YES];
                        }
                    }
                    break;
                    default:
//                 其他，暂时不做处理
                        break;
                }
                NSLog(@"ItemModel = %@",model);
            };
            return cell;
        }
        UGHomeBtnsCell * cell = [tableView dequeueReusableCellWithIdentifier:BtnsCellIdentifier forIndexPath:indexPath];
        cell.delegate=self;
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        return cell;
      }else{
          if ([[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString :@"1"]) {
              OpenReceiveCell * cell = [tableView dequeueReusableCellWithIdentifier:OpenReceiveCellIdentifier forIndexPath:indexPath];
              NSString *todayStr =  ! UG_CheckStrIsEmpty(self.todayCount) ? [NSString stringWithFormat:@"今日接单 %@ 单",self.todayCount] : @"今日接单 0 单";
              NSString *rangeStr =  ! UG_CheckStrIsEmpty(self.todayCount) ? self.todayCount : @"0";
              cell.todayLabel.attributedText = [self attributedStringWith:todayStr WithRangeStr:rangeStr WithColor:UG_MainColor];
              cell.totalLabel.text = ! UG_CheckStrIsEmpty(self.totalCount) ? self.totalCount : @" 0 ";
              cell.selectionStyle=UITableViewCellSelectionStyleNone;
              return cell;
          }
          UGHomeMarketCell * cell = [tableView dequeueReusableCellWithIdentifier:MarketCellIdentifier forIndexPath:indexPath];
          UGSymbolThumbModel *model =  self.currentMarketDataArr[indexPath.row];
           [cell configDataWithModel:model];
          cell.selectionStyle=UITableViewCellSelectionStyleNone;
          return cell;
    }
}

-(NSMutableAttributedString *)attributedStringWith:(NSString *)attributedString WithRangeStr:(NSString *)rangeStr WithColor:(UIColor *)color{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attributedString];
    NSRange range1 = [[str string] rangeOfString:rangeStr];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range1];
    return str;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==0 && indexPath.row == 1) {
        [self playVideo];
    }else if (indexPath.section ==1) {
        if ([[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString :@"1"]) {
            return;
        }
        UGSymbolThumbModel *model =  self.currentMarketDataArr[indexPath.row];
        KchatViewController*klineVC=[[KchatViewController alloc]init];
        klineVC.symbol=model.symbol;
        [self.navigationController pushViewController:klineVC animated:YES];
    }
}

#pragma mark -headerVew
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return self.platformMessageArr.count>0 ? UG_AutoSize(40) : 0;
    } else {
        if ([[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString :@"1"]) {
            return UG_AutoSize(110);
        }
        return UG_AutoSize(75);
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
   if (section==0) {
       return [self PlatformMessageView];
    }else {
        if ([[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString :@"1"]) {
            return [self OpenOrderReceivingView];
        }
        return self.marketSectionView;
    }
}

-(UIView *)OpenOrderReceivingView{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, UG_AutoSize(110))];
    view.backgroundColor = [UIColor clearColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(UG_AutoSize(30), UG_AutoSize(10), UG_SCREEN_WIDTH-2*UG_AutoSize(30), UG_AutoSize(20))];
    label.font = [UIFont systemFontOfSize:13];
    label.textColor = [UIColor colorWithHexString:@"666666"];
    label.text = @"当前账号已停止接单";
    NSString *todayStr =  [self.openingOrderStatus isEqualToString:@"0"] ? @"当前账号已停止接单" : @"当前账号正在接单";
    NSString *rangeStr =  [self.openingOrderStatus isEqualToString:@"0"] ? @"停止接单" : @"正在接单";
    UIColor *color =  [UIColor colorWithHexString:@"108BE4"];
    if ([self.openingOrderStatus isEqualToString:@"0"]) {
        color = [UIColor colorWithHexString:@"FF6978"];
    }
    label.attributedText = [self attributedStringWith:todayStr WithRangeStr:rangeStr WithColor:color];
    [view addSubview:label];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(UG_AutoSize(40), UG_AutoSize(30)+(UG_AutoSize(80)-UG_AutoSize(44))/2.0, UG_SCREEN_WIDTH-2*UG_AutoSize(40), UG_AutoSize(44))];
    [btn setTitle: [self.openingOrderStatus isEqualToString:@"0"] ? @"开启接单" : @"停止接单" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:16];
    [btn setBackgroundImage:[UIImage imageNamed:@"open_reveiving_btn"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(openReceiveOrder) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return view;
}

-(void)openReceiveOrder{
    
    //用户操作功能是否被限制
    if ([self hasForbidden]) {return;}
    
    //用户交易功能是否被限制
    if ([[UGManager shareInstance] userTransactionDisable]) {return;};
    
//        //检查是否绑定了谷歌验证器
//    if (![self hasBindingGoogle]) { return;}
    
    //检查是否需要实名
    if (![self checkMoneyNeedToValidations]) {return;}
    
    //校验是否绑定银行卡
    if ([self checkHadGotoBankBinding]) {return;}
    
    NSString *des = [self.openingOrderStatus isEqualToString:@"0"] ? @"开启接单后，请您及时处理平台派单，否则将会影响您的积分。" : @"停止接单时间过久，将会影响您的积分哦！";
    @weakify(self);
    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"" message: des cancle:@"取消" others:@[ [self.openingOrderStatus isEqualToString:@"0"] ? @"开启" : @"停止"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
        @strongify(self);
        if (buttonIndex == 1) {
            [self openOrderReceiving: [self.openingOrderStatus isEqualToString:@"0"] ? @"1" : @"0"];
        }
    }];
}

-(void)openOrderReceiving:(NSString *)status{
    [self.view ug_showMBProgressHudOnKeyWindow];
    UGOpenCloseDispatchApi *api = [UGOpenCloseDispatchApi new];
    api.openingOrderStatus = status;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
           [self.view ug_hiddenMBProgressHudOnKeyWindow];
        if (object) {
            [self loadData];
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}


#pragma mark- 平台消息显示
-(UIView *)PlatformMessageView{
    UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, UG_AutoSize(40))];
    view.backgroundColor = [UIColor clearColor];
    UIView *backView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, UG_AutoSize(30))];
    backView.backgroundColor = [UIColor whiteColor];
    [view addSubview:backView];
    if (self.platformMessageArr.count>0) {
        NSMutableArray*titleArray=[[NSMutableArray alloc]init];
        [self.platformMessageArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            PlatformMessageModel*model=self.platformMessageArr[idx];
            [titleArray addObject:model.title];
        }];
        CustomSectionHeader*sectionView=[CustomSectionHeader instancesectionHeaderViewWithFrame:CGRectMake(UG_AutoSize(14),0, kWindowW-2*UG_AutoSize(14), UG_AutoSize(30))];
        pageScrollView *noticeView = [[pageScrollView alloc] initWithFrame:CGRectMake(40, 0, kWindowW-UG_AutoSize(60), UG_AutoSize(30))];
        noticeView.BGColor = [UIColor clearColor];
        noticeView.titleArray =titleArray;
        noticeView.titleColor = HEXCOLOR(0x1f1f1f);
        __weak UGHomeVC *weakSelf=self;
        [noticeView clickTitleLabel:^(NSInteger index,NSString *titleString) {
            if (self.platformMessageArr.count>0) {
                PlatformMessageModel*model=self.platformMessageArr[index-100];
                UGSystemMessageDetailVC *detailVC = [[UGSystemMessageDetailVC alloc] init];
                detailVC.content = model.content;
                detailVC.titleStr = model.title;
                detailVC.createTime = model.updateDate;
                detailVC.isProclamation = YES;
                [weakSelf.navigationController pushViewController:detailVC animated:YES];
            }
        }];
        [sectionView addSubview:noticeView];
        [backView addSubview:sectionView];
        return view;
    }else{
        UIView*view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, UG_AutoSize(0))];
        view.backgroundColor = [UIColor whiteColor];
        return view;
    }
    return view;
}

#pragma mark- 行情选择显示
-(UGHomeSecondTwoHeader *)marketSectionView{
    if (!_marketSectionView) {@weakify(self)
//       _marketSectionView= [[UGHomeMarketSecondHeader alloc] initWithFrame:CGRectMake(0, 0, kWindowW, UG_AutoSize(75))];
//
//        @weakify(self)
//        _marketSectionView.btnClickBlock = ^(NSInteger index) {
//            @strongify(self);
//            self.index = index;
//            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
//            [self getMarketDatas:^(BOOL complete) {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
////                [self.tableView reloadData];
//            }];
//        };
//        _marketSectionView.clickBlock = ^(id obj) {
//           //跳到详情页面
//            @strongify(self);
//            [self.navigationController pushViewController:[UGHomeMarketListVC new] animated:YES];
//        };
        
        _marketSectionView= [UGHomeSecondTwoHeader instanceUGHomeSecondTwoHeaderWithFrame:CGRectMake(0, 0, kWindowW, 50)];
        _marketSectionView.btnClickBlock = ^(NSInteger index) {@strongify(self);
            self.index = index;
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            [self getMarketDatas:^(BOOL complete) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
            }];
        };
    }
    return _marketSectionView;
}

#pragma mark ---------------------获取数据

#pragma mark - 获取UG钱包列表数据
-(void)getBanaData:(void(^)(BOOL complete))completeHandle{
        UGWalletAllApi *api = [[UGWalletAllApi alloc] init];
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            if (object){
                self.bannerDataArr = [UGWalletAllModel mj_objectArrayWithKeyValuesArray:object];
                if (self.bannerDataArr.count>0) {
                    self.bannerView.items = self.bannerDataArr;
                }
            }
            completeHandle(YES);
        }];
}

#pragma mark-获取平台消息
-(void)getNotice:(void(^)(BOOL complete))completeHandle{
    UGPlatformMessageApi *api = [[UGPlatformMessageApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
              [self.platformMessageArr removeAllObjects];
             NSArray *dataArr = [PlatformMessageModel mj_objectArrayWithKeyValuesArray:object[@"rows"]];
            [self.platformMessageArr addObjectsFromArray:dataArr];
        }
        completeHandle(YES);
    }];
}

#pragma mark - 获取所有交易币种缩略行情
-(void)getMarketDatas:(void(^)(BOOL complete))completeHandle{
    UGSymbolThumbApi *api = [UGSymbolThumbApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            [self.baseArray removeAllObjects];
            if ([object isKindOfClass:[NSDictionary class]]) {
                self.marketDict  = (NSDictionary *)object;
                [self opRationMarketData];
                
                static int home__kk = 0;
                if (home__kk != 0) {
                    NSMutableArray *indexPaths = [NSMutableArray array];
                    for (int i=0; i<self.currentMarketDataArr.count; i++) {
                        [indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:1]];
                    }
                    
                    [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
                }
                home__kk ++;
            }
        }
        completeHandle(YES);
    }];
}

#pragma mark -处理行情数据
-(void)opRationMarketData{
    self.baseArray = [NSMutableArray arrayWithArray:[self.marketDict allKeys]];
    [self.currentMarketDataArr removeAllObjects];
    if (self.baseArray.count>0 && self.marketDict)
    {
        self.currentSelectedMarketData = self.baseArray[self.index];
//        _marketSectionView.titlesArray = self.baseArray;
//        _marketSectionView.index = self.index;
        self.currentMarketDataArr = [NSMutableArray arrayWithArray:[UGSymbolThumbModel mj_objectArrayWithKeyValuesArray:[self.marketDict objectForKey:self.currentSelectedMarketData]]];
    }
}
#pragma mark-获取USDT对CNY汇率
-(void)getUSDTToCNYRate:(void(^)(BOOL complete))completeHandle{
    UGCnyToUsdtApi *api = [[UGCnyToUsdtApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate= [NSString stringWithFormat:@"%@",object];
        }
        completeHandle(YES);
    }];
}

#pragma amrk - 人民币对UG的汇率
-(void)getUGTOCny:(void(^)(BOOL complete))completeHandle{
    if (UG_CheckStrIsEmpty(self.CNYRateToUG))
    {
        UGExchangeRateApi *api = [[UGExchangeRateApi alloc] init];
        api.urlArm = @"cny/ug";
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            if(object){
                ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG=(NSString *)object;
                self.CNYRateToUG =(NSString *)object;
            }
            completeHandle(YES);
        }];
    }
    else
    {
        completeHandle(YES);
    }
}

//#pragma mark-获取首页推荐信息
//-(void)getContentData:(void(^)(BOOL complete))completeHandle{
//    [HomeNetManager HomeDataCompleteHandle:^(id resPonseObj, int code) {
//        [self.contentArr removeAllObjects];
//        if ([resPonseObj isKindOfClass:[NSDictionary class]]) {
//            NSArray *recommendArr = [symbolModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"recommend"]];
//            NSArray *changeRankArr = [symbolModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"changeRank"]];
//            if (changeRankArr&&recommendArr) {
//                [self.contentArr addObject:recommendArr];//推荐
//                [self.contentArr addObject:changeRankArr];//涨幅榜
//                [self getfirstData];
//            }
//        }else{
//
//        }
//        completeHandle(YES);
//    }];
//}

#pragma mark - 承兑商获取接单数
-(void)getTaskCount:(void(^)(BOOL complete))completeHandle{
    UGGetTaskCountApi *api = [[UGGetTaskCountApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if(object){
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)object;
                self.todayCount = [dic objectForKey:@"todayCount"];
                self.totalCount = [dic objectForKey:@"totalCount"];
            }
        }
        completeHandle(YES);
    }];
}

#pragma mark - 获取接单状态
-(void)getOpeningOrderStatus:(void(^)(BOOL complete))completeHandle{
    UGGetOpeningOrderStatusaApi *api = [[UGGetOpeningOrderStatusaApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if(object){
          self.openingOrderStatus = [NSString stringWithFormat:@"%@",object];
            if ([self.openingOrderStatus isEqualToString:@"1"]) {
                [UGNewGuidStatusManager shareInstance].openCardOrderReceive = @"1";
            }
        }
        completeHandle(YES);
    }];
}

#pragma mark - 获取首页banner内容
-(void)getHomeBannerContentData:(void(^)(BOOL complete))completeHandle{
    NSString *bannerStr  = [self upDataMessage:@"pictureCarousel" WithMessage:@""];
    NSDictionary *bannerDic = [UG_MethodsTool dictWithJsonString:bannerStr];
    if ([bannerDic[@"code"] integerValue] == 0)
    {
        NSMutableArray *bannerArray = [[NSMutableArray alloc] initWithArray:bannerDic[@"data"]];
        for (NSDictionary *dic in bannerArray.reverseObjectEnumerator)
        {
        if (![self isCardVip] && [dic[@"type"] integerValue] == 4)
        {
        [bannerArray removeObject:dic];
        }
        }
        self.bannerCelldataArray = [bannerCellModel mj_objectArrayWithKeyValuesArray:bannerArray];
    }
    completeHandle(YES);
}

#pragma mark - 获取承兑商邀请注册banner
-(void)getHomeBannerRegistrationInvitationData:(void(^)(BOOL complete))completeHandle{
    
    NSString *bannerStr  = [self upDataMessage:@"acceptanceBanner" WithMessage:@""];
    NSDictionary *bannerDic = [UG_MethodsTool dictWithJsonString:bannerStr];
    if ([bannerDic[@"code"] integerValue] == 0)
     {
        NSMutableArray *bannerArray = [[NSMutableArray alloc] initWithArray:bannerDic[@"data"]];
        NSDictionary * dic = [bannerArray firstObject];
        bannerCellModel *model = [bannerCellModel mj_objectWithKeyValues:dic];
        [self.bannerCelldataArray addObject:model];
         
     }
    completeHandle(YES);
}


#pragma mark - 获取公告弹窗数据
-(void)getAnnouncementNoticeData:(void(^)(BOOL complete))completeHandle{
    UGNoticeFindAlertApi *api = [[UGNoticeFindAlertApi alloc]init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        NSDictionary *dic = object;
        NSArray * rows = [NSArray arrayWithArray:dic[@"rows"]];
        if (rows.count) {
            NSDictionary *rowsDic = [rows firstObject];
            self.AnnouncementContent = rowsDic[@"content"];
            self.AnnouncementTittle = rowsDic[@"title"];
            self.isAnnouncementHaveData = YES;
        }
        else
        {
            self.AnnouncementContent = @"";
            self.AnnouncementTittle = @"";
            self.isAnnouncementHaveData = NO;
        }
         completeHandle(YES);
    }];
    
}

//-(void)getfirstData{
//    if (self.contentArr.count>0) {
//        NSArray *array = self.contentArr[0];
//        if ( !UG_CheckArrayIsEmpty(array) && array.count>0 ) {
//            symbolModel *model = array[0];//取第一个
//            if (![marketManager shareInstance].symbol) {
//                [marketManager shareInstance].symbol=model.symbol;//默认第一个
//            }
//        }
//    }
//}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - 将官网添加到桌面引导页
-(void)addDesktopShortcut
{
    UGSaveOfficialWebsiteGuideController *vc = [UGSaveOfficialWebsiteGuideController new];
    [self.navigationController pushViewController:vc animated:YES];
    
}

#pragma mark - 是否数据加载
-(BOOL)hasHeadRefresh{
    return YES;
}

-(BOOL)hasFooterRefresh{
    return NO;
}
//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _isDragging=YES;
}
//结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    _isDragging=NO;
}

@end
