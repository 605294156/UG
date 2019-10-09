//
//  UGTabBarController.m
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGTabBarController.h"
#import "UIImage+Expand.h"
#import "UGNavController.h"
#import "UGHomeVC.h"
#import "MarketViewController.h"
#import "TradeViewController.h"
#import "OTCViewController.h"
#import "UGMineViewController.h"
#import "UIViewController+Utils.h"
#import "UGCustomTarBar.h"
#import "UGHomeMessageVC.h"

@interface UGTabBarController ()<UITabBarDelegate>

@property(nonatomic,readonly,strong) NSArray *controllerTitles;

@end

@implementation UGTabBarController

- (instancetype)init {
    self = [super init];
    if (self) {
        //使用自定义的TarBar 解决在iPhone X上的bug
        [self setValue:[UGCustomTarBar new] forKeyPath:@"tabBar"];
        //设置子控制器
        [self setupViewControllers];
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //切换语言
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:LanguageChange object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userSignOut:) name:@"用户点击退出登录" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(buyOrSell:) name:@"OTC接收购买或出售" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiptMessage) name:@"收到系统推送消息" object:nil];
}

#pragma mark - 收到推送消息
-(void)receiptMessage{
    [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
        
    }];
}

#pragma mark - OTC接收购买或出售
- (void)buyOrSell:(NSNotification *)notification {
    NSDictionary *dict = notification.userInfo;
    if ([[UIViewController currentViewController] isKindOfClass:[OTCViewController class]]) {
        OTCViewController *vc = (OTCViewController *)[UIViewController currentViewController] ;
        NSString *str = dict[@"index"];
        if ([str isEqualToString:@"0"]) {
            vc.selectIndex =0;
        }else if([str isEqualToString:@"1"]){
            vc.selectIndex =1;
        }
    }
}

//重置tabBarItem.title
- (void)languageChange {
    [self.tabBar.items enumerateObjectsUsingBlock:^(__kindof UITabBarItem * _Nonnull barItem, NSUInteger idx, BOOL * _Nonnull stop) {
        if (idx < self.controllerTitles.count ) {
            barItem.title = self.controllerTitles[idx];
        }
    }];
}

#pragma mark - 用户点击退出登录消息
- (void)userSignOut:(NSNotification *)sender {
    self.selectedViewController = self.viewControllers[0];
    UGBaseViewController *vc = (UGBaseViewController *)[UIViewController currentViewController];
    if (vc && [vc respondsToSelector:@selector(showLoginViewController)]) {
        [vc showLoginViewController];
    }
}


- (void)setupViewControllers {
    
    NSArray *viewControllers = @[[UGHomeVC new],[OTCViewController new],[UGHomeMessageVC new], [UGMineViewController new]];
    NSArray *images = @[@"wallettab", @"OTC", @"tab_meaasge",@"mytab"];
    NSArray *selectedImags = @[@"wallettab_selected",@"OTC_selected", @"tab_meaasge__selected", @"mytab_selected"];
    NSMutableArray *rootControlles = @[].mutableCopy;
    
    [self.controllerTitles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImage *image = [UIImage imageNamed:images[idx]];
        UIImage *selectedImag = [UIImage imageNamed:selectedImags[idx]];
        UGNavController *nav = [[UGNavController alloc] initWithRootViewController:viewControllers[idx]];
        [nav setupImage:image selectedImage:selectedImag title:title];
        [rootControlles addObject:nav];
        
    }];
    
    self.viewControllers = rootControlles;
}


#pragma mark - 控制屏幕旋转方法
- (BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.selectedViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.selectedViewController preferredInterfaceOrientationForPresentation];
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//需要每次实时获取当前语言，所以用getter每次都去读取
- (NSArray *)controllerTitles {
    return @[LocalizationKey(@"tabbar1"),@"交易", LocalizationKey(@"tabbar3"), LocalizationKey(@"tabbar5")];
}

#pragma mark - UITabBarDelegate
- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item {
    NSInteger index =  [tabBar.items indexOfObject:item];
    //交易item
    if (index == 1) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"刷新OTC列表" object:nil];
    } else if (index == 2) {
        //消息item
        [[NSNotificationCenter defaultCenter] postNotificationName:@"刷新消息列表" object:nil];
    }
}


@end
