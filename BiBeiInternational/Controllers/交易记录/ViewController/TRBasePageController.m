//
//  TRBasePageController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "TRBasePageController.h"
#import "TRContentViewController.h"

@interface TRBasePageController ()

@property (nonatomic, strong) NSArray *otcTitles;//OTC
@property (nonatomic, strong) NSArray *orderTitles;//交易


@end

@implementation TRBasePageController


- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuViewStyle = WMMenuViewStyleDefault;
        self.showOnNavigationBar = NO;
        self.titleColorSelected = UG_MainColor;
        self.titleColorNormal = [UIColor colorWithHexString:@"7EC9FF"];
        self.progressColor = UG_MainColor;
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.titleSizeSelected = 16;
        self.titleSizeNormal = 14;
        self.selectIndex = 0;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
}


- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 40);
    return rect;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = 40;
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.isOTC ? self.otcTitles.count : self.orderTitles.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    NSString *title = self.isOTC ? self.otcTitles[index] : self.orderTitles[index];
    //这里需要注意，不重设当前控制器的判断属性会导致默认第一个控制器传值出现问题。
    ((TRContentViewController*)self.currentViewController).isOTC = self.isOTC;
    return title;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    NSString *title = self.isOTC ?  self.otcTitles[index] : self.orderTitles[index];
    TRContentViewController *contentVC = [TRContentViewController new];
    contentVC.title = title;
    contentVC.orderType = self.orderType;
    contentVC.isOTC = self.isOTC;
    return contentVC;
}

#pragma mark - 状态栏控制
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - 横竖屏控制
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


- (NSArray *)otcTitles {
    return @[@"全部", @"未付款", @"已付款", @"已完成", @"已取消", @"申诉中"];
}

- (NSArray *)orderTitles {
    return @[@"全部", @"交易中", @"已完成", @"已取消", @"已超时"];
}

@end
