//
//  UGBasePageViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/30.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBasePageViewController.h"

@interface UGBasePageViewController ()

@end

@implementation UGBasePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (self.navigationController.viewControllers.count>1) {
        @weakify(self)
        [self setupBarButtonItemWithImageName:@"goback" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

#pragma mark - 状态栏控制
- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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

@end
