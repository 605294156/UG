//
//  UGBaseNavController.m
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGNavController.h"
#import "UIImage+Expand.h"
#import "UGBaseViewController.h"
#import "WMPageController.h"

@interface UGNavController ()<UINavigationControllerDelegate,UIGestureRecognizerDelegate>

@end

@implementation UGNavController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;
    // 为self创建弱引用对象
    __weak typeof (self) weakSelf = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = weakSelf;
    }
//    //设置返回按钮颜色
    self.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationBar.barTintColor = [UIColor whiteColor];
    
    //背景色
    [self.navigationBar setBackgroundImage:[UIImage imageWithColor:UG_MainColor] forBarPosition:UIBarPositionAny
                                barMetrics:UIBarMetricsDefault];
    [self.navigationBar setShadowImage:[UIImage new]];

    //4.可以设置标题文字的垂直位置
    [self.navigationBar setTitleVerticalPositionAdjustment:0 forBarMetrics:UIBarMetricsDefault];
    //设置字体大小、颜色
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor blackColor], NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}


#pragma mark - Public Mehod
- (void)setupImage:(UIImage *)image selectedImage:(UIImage *)selectedImage title:(NSString *)title {
    self.tabBarItem.image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.tabBarItem.title = title;
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"a4a4a4"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:10]} forState:UIControlStateNormal];
    [self.tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHexString:@"4264b8"],NSFontAttributeName:[UIFont fontWithName:@"PingFangSC-Medium" size:10]} forState:UIControlStateSelected];
    
}

#pragma mark - 状态栏相关

- (UIViewController *)childViewControllerForStatusBarStyle {
    return [self.viewControllers lastObject];
}

- (UIViewController *)childViewControllerForStatusBarHidden {
    return [self.viewControllers lastObject];
}

#pragma mark - 控制屏幕旋转方法
- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return [self.topViewController supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}


- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (self.viewControllers.count > 0) { // 如果现在push的不是栈底控制器(最先push进来的那个控制器)
        viewController.hidesBottomBarWhenPushed = YES;
    }
    //取消左边返回按钮文字
    viewController.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:self.navigationItem.backBarButtonItem.style target:nil action:nil];
    
    [super pushViewController:viewController animated:animated];
}



#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
//    if ([viewController isKindOfClass:[UGBaseViewController class]]) {
//        UGBaseViewController *baseVC = (UGBaseViewController *)viewController;
//        [self setNavigationBarHidden:baseVC.isNavigationBarHidden animated:YES];
//    }
}

- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if ([viewController isKindOfClass:[UGBaseViewController class]]) {
        UGBaseViewController *baseVC = (UGBaseViewController *)viewController;
        //修改导航栏的颜色
        [self.navigationBar setBackgroundImage:[UIImage imageWithColor:baseVC.navigationBarColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        //animated 传入YES，如果传入NO则效果很奇怪
        [self setNavigationBarHidden:baseVC.isNavigationBarHidden animated:YES];
    } else if ([viewController isKindOfClass:[WMPageController  class]]){
        [self setNavigationBarHidden:NO animated:YES];
    }
}

#pragma mark - UIGestureRecognizerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if (self.viewControllers.count <= 1 ) {
        return NO;
    }
    return YES;
}

// 允许同时响应多个手势
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return [gestureRecognizer isKindOfClass:UIScreenEdgePanGestureRecognizer.class];
}

//在iOS13中modalPresentationStyle的默认改为UIModalPresentationAutomatic,而在之前默认是UIModalPresentationFullScreen。所以这里加上返回UIModalPresentationFullScreen 不然present 出来的页面显示不全
-(UIModalPresentationStyle)modalPresentationStyle{
    return UIModalPresentationFullScreen;
}

@end
