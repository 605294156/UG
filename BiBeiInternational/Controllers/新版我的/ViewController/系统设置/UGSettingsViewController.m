//
//  UGSettingsViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGSettingsViewController.h"
#import "UGButton.h"
#import "UGPickerView.h"
#import <SDImageCache.h>

@interface UGSettingsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *languageLabel;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;
@property (weak, nonatomic) IBOutlet UGButton *signoutButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *changHostH;
@property (weak, nonatomic) IBOutlet UILabel *hostLabel;

@end

@implementation UGSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"系统设置";
    self.cacheLabel.text = [self cacheSizeText];
    self.signoutButton.buttonStyle = UGButtonStyleBlue;

#ifdef DEBUG
    self.changHostH.constant = 50.0f;
#else
    self.changHostH.constant = 0.0f;
#endif
    self.hostLabel.text = [UGURLConfig baseURL];

}

- (NSString *)cacheSizeText {
    float sdcache = [[SDImageCache sharedImageCache] totalDiskSize];
    if (sdcache > 1024 * 1024) {
        return [NSString stringWithFormat:@"%.2fM", sdcache / 1024 / 1024];
    } else {
        return [NSString stringWithFormat:@"%.2fK", sdcache / 1024];
    }
}

- (IBAction)tapLanguageSetting:(UITapGestureRecognizer *)sender {
//    [UGPickerView ug_showPickViewWithTitles:@[@"English", @"简体中文", @"繁体中文"] handle:^(NSString * _Nonnull resultString) {
//        NSLog(@"选择了：%@",resultString);
//    }];

}

- (IBAction)tapSelectedCurrency:(UITapGestureRecognizer *)sender {
//
//    [UGPickerView ug_showPickViewWithTitles:@[@"USD", @"CNY", @"EUR"] handle:^(NSString * _Nonnull resultString) {
//        NSLog(@"选择了：%@",resultString);
//    }];
    
}

- (IBAction)tapChangeHost:(UITapGestureRecognizer *)sender {
    NSString *str = [UGURLConfig changeSettingApi];
    BOOL isRealse = [self.hostLabel.text isEqualToString:str];
    NSString *message = isRealse ? @"当前为 正式 环境" : @"当前为 测试 环境";
    
    @weakify(self);
    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleActionSheet title:@"切换网络环境" message:message cancle:@"取消" others:@[@"正式环境", @"测试环境"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
        @strongify(self);
        if (buttonIndex == 1 && !isRealse) {
            // 切换到 正式环境
            [self changeHostWithRelease:YES];
        } else if (buttonIndex == 2 && isRealse) {
            //切换到 测试环境
            [self changeHostWithRelease:NO];
        }
    }];
}


- (void)changeHostWithRelease:(BOOL)release {
    [UGURLConfig changeToReleaseState:release];
    exit(0);//杀死APP
}

- (IBAction)tapCleanCache:(UITapGestureRecognizer *)sender {
    @weakify(self);
    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:nil message:@"是否确认清除缓存 ?" cancle:@"取消" others:@[@"确定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
        @strongify(self);
        if (buttonIndex == 1) {
            [EasyShowLodingView showLodingText:@"缓存清理中" inView:self.view];
            [[SDImageCache sharedImageCache] clearMemory];
            [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
                [EasyShowLodingView hidenLoingInView:self.view];
                self.cacheLabel.text = [self cacheSizeText];
            }];
        }
    }];
}

- (IBAction)clickSignout:(UIButton *)sender {
    @weakify(self);
    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"" message:@"您确定要退出登录？" cancle:@"取消" others:@[@"确定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
        if (buttonIndex == 1) {
            @strongify(self);
            [self clickOut];
        }
    }];
    
  
}

-(void)clickOut{
    [MBProgressHUD ug_showHUDToKeyWindow];
    [[UGManager shareInstance] signout:^{
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        [[UGManager shareInstance] hasTouchIDOrFaceIDVerifyValue:@"0"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"用户点击退出登录" object:nil];
            [self.navigationController popViewControllerAnimated:NO];
        });
    }];
}

@end
