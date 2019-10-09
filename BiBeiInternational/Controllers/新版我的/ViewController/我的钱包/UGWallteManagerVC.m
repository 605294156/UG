//
//  UGReviseJYPasswordVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/31.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGWallteManagerVC.h"
#import "UGReviseWalletNameVC.h"
#import "UGReviseWalletPasswordVC.h"

@interface UGWallteManagerVC ()

@end

@implementation UGWallteManagerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"钱包管理";

}

//修改交易密码
- (IBAction)reviseJYPassword:(UITapGestureRecognizer *)sender {
//    if ([self hasBindingGoogleValidator]) { //2.0换手机号
        [self.navigationController pushViewController:[UGReviseWalletPasswordVC new] animated:YES];
//    }
}

//修改UG钱包名称
- (IBAction)reviseWalletName:(UITapGestureRecognizer *)sender {
    [self.navigationController pushViewController:[UGReviseWalletNameVC new] animated:YES];
}

@end
