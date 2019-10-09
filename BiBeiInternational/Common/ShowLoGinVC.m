//
//  ShowLoGinVC.m
//  BaseProject
//
//  Created by YLCai on 2017/6/15.
//  Copyright © 2017年 YLCai. All rights reserved.
//

#import "ShowLoGinVC.h"
#import "UGNavController.h"

@implementation ShowLoGinVC

//显示登录控制器  //登录失效，重新登录
+(void)showLoginVc:(UIViewController *)vc withTipMessage:(NSString *)tipMessage{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:tipMessage message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        UGLoginVC *loginVC = [[UGLoginVC alloc] init];
        UGNavController *logNavi = [[UGNavController alloc] initWithRootViewController:loginVC];
        [vc presentViewController:logNavi animated:YES completion:nil];

    }];

    [alert addAction:action1];
    [vc presentViewController:alert animated:YES completion:nil];
}

@end
