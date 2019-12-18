//
//  OTCViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/16.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCViewController.h"
#import "OTCContentViewController.h"
#import "TransactionRecordViewController.h"
#import "UGReleaseAdViewController.h"
#import "UGOTCHeadView.h"
#import "UGGeneralCertificationVC.h"

@interface OTCViewController ()<UGOTCHeadViewDelegate>

@property(nonatomic, strong) UGOTCHeadView *headView;

@end

@implementation OTCViewController

- (void)viewDidLoad {@weakify(self);
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.filterModel = [OTCFilterModel new];
    
//    [self setupBarButtonItemWithImageName:@"OT_record" type:UGBarImteTypeRight callBack:^(UIBarButtonItem * _Nonnull item) {
//        @strongify(self);
//        [self.navigationController pushViewController:[TransactionRecordViewController new] animated:YES];
//    }];
    
    [self setupBarButtonItemsWithImageList:@[@"OT_sx_sx",@"OT_record"] type:UGBarImteTypeRight callBack:^(UIBarButtonItem * _Nonnull item, NSInteger index, UIButton * _Nonnull btn) {@strongify(self)
        if (index==1) {
            [self.navigationController pushViewController:[TransactionRecordViewController new] animated:YES];
        }else if (index==0){
            [self.headView clickFilter:nil];
        }
    }];
    
    [self setupFillterView];
    self.delegate = self;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginsucces) name:@"LOGINSUCCES" object:nil];
    
    [self changeModelUI];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//    [self changeModelUI];
//}

-(void)changeModelUI{
    [self reloadData];
    @weakify(self);
    [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        [self reloadData];
    }];
}

#pragma mark -登录成功
-(void)loginsucces{
    [self changeModelUI];
}

- (void)setupFillterView {
    [self.view addSubview:self.headView];
    [self.headView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.view);
        make.height.mas_equalTo(40);
    }];
}

-(BOOL)isCardVip{
    return [[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString:@"1"];
}

#pragma mark - WMPageControllerDataSource

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    if ([self isCardVip]) {
        //卡商
        return 1;
    }
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {@weakify(self)
    [UIView animateWithDuration:.2 animations:^{@strongify(self)
        self.headView.line2.mj_x = index == 0 ? 17 : (17+34+32);
    }];
    if ([self isCardVip]) {
        //卡商
        return @"出售";
    }
    
    return index == 0 ? @"购买" : @"出售";
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if ([self isCardVip]) {
        //卡商
        OTCContentViewController *contentVC = [OTCContentViewController new];
        contentVC.isBuy = NO;
        return contentVC;
    }
    OTCContentViewController *contentVC = [OTCContentViewController new];
    contentVC.isBuy = index == 0;
    return contentVC;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 40, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 40);
}


#pragma mark - WMPageControllerDelegate

//- (void)pageController:(WMPageController *)pageController willEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
//}
//
- (void)pageController:(WMPageController *)pageController didEnterViewController:(__kindof UIViewController *)viewController withInfo:(NSDictionary *)info {
    if ([self isCardVip]) {
       //卡商
        self.headView.buttonTitle = @"我要出售";
    }else{
        self.headView.buttonTitle = pageController.selectIndex == 0 ? @"我要购买" : @"我要出售";
    }
}


#pragma mark - UGOTCHeadViewDelegate

/**
 筛选切换
 
 @param fileterModel 筛选后的条件模型
 */
- (void)headViewFilterWithFilerModel:(OTCFilterModel *)fileterModel {
    self.filterModel = fileterModel;
    ((OTCContentViewController *)self.currentViewController).filterModel = self.filterModel;
//    [(OTCContentViewController *)self.currentViewController refreshData];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"OTC筛选条件更改刷新数据" object:nil];
}

/**
 点击发布我的出售
 */
- (void)headViewReleseToSell {
    //禁止操作
    if ([[UGManager shareInstance].hostInfo.userInfoModel.member.forbiddenOpt isEqualToString:@"1"]) {
      [self.view ug_showToastWithToast:@"您的账号已被禁止操作，请联系客服处理。"];
        return;
    }

    //用户交易功能是否被限制
    if ([[UGManager shareInstance] userTransactionDisable]) {return;};
    
//    //检查是否绑定了谷歌验证器  //2.0换手机号
//    if (![self hasBindingGoogleValidator]) {
//        return;
//    }
    
    //用户交易功能是否被限制    //用户实名认证
    if ([self gotoRealNameAuthentications]) {return;}
    
    UGReleaseAdViewController *adViewController = [UGReleaseAdViewController new];
    if ([self isCardVip]) {
        //卡商
         adViewController.mIndex = 0;
    }else{
         adViewController.mIndex = 1;
    }
    [self.navigationController pushViewController:adViewController animated:YES];
}

/**
 点击发布的购买
 */
- (void)headViewReleseToBuy {
    //禁止操作
    if ([[UGManager shareInstance].hostInfo.userInfoModel.member.forbiddenOpt isEqualToString:@"1"]) {
        [self.view ug_showToastWithToast:@"您的账号已被禁止操作，请联系客服处理。"];
        return;
    }
    //用户交易功能是否被限制
    if ([[UGManager shareInstance] userTransactionDisable]) {return;};
    
//    //检查是否绑定了谷歌验证器  //2.0换手机号
//    if (![self hasBindingGoogleValidator]) {
//        return;
//    }
    
    //用户实名认证
    if ([self gotoRealNameAuthentications]) {return;}
    
    UGReleaseAdViewController *adViewController = [UGReleaseAdViewController new];
    adViewController.mIndex = 0;
    [self.navigationController pushViewController:adViewController animated:YES];
}



#pragma mark - Getter Method

- (UGOTCHeadView *)headView {
    if (!_headView) {
        _headView = [UGOTCHeadView new];
        _headView.delegate = self;
    }
    return _headView;
}

-(BOOL)gotoRealNameAuthentications{
    if (![UGManager shareInstance].hostInfo.userInfoModel.hasRealnameValidation) {
        @weakify(self);
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"认证提醒" message:@"为了您的资产安全，请您先进行实名认证！" cancle:@"取消" others:@[@"去认证"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            if (buttonIndex == 1) {
                @strongify(self);
                //实名认证
                [self.navigationController pushViewController:[UGGeneralCertificationVC new] animated:YES];
            }
        }];
        return YES;
    }else{
        return NO;
    }
}

@end
