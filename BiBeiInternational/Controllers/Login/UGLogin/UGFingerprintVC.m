//
//  UGFingerprintVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGFingerprintVC.h"
#import "UGTouchIDTool.h"
#import "UGRevisePasswordVC.h"

@interface UGFingerprintVC ()<UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *Title;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@end

@implementation UGFingerprintVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topConstraint.constant =UG_AutoSize(30)+[UG_MethodsTool statusBarHeight];;

    [self languageChange];
    
    self.navigationBarHidden = YES;
}

-(void)languageChange{
    self.Title.text = [[UGManager shareInstance] checkIsSupportFaceIDOrTouchID] == UGSupportFaceID ? @"面容登录" : @"指纹登录";
    self.titleLabel.text = [[UGManager shareInstance] checkIsSupportFaceIDOrTouchID] == UGSupportFaceID ? @"请开启面容解锁功能" : @"请开启指纹解锁功能";
    self.iconImage.image = [[UGManager shareInstance] checkIsSupportFaceIDOrTouchID] == UGSupportFaceID ? [UIImage imageNamed:@"faceIcon.png"] : [UIImage imageNamed:@"touchIcon.png"];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark - 现在开启
- (IBAction)startFinger:(id)sender {
    @weakify(self);
    [self verifyTouchOrFaceID:^(UGTouchIDState state, NSError * _Nonnull error) {
        @strongify(self);
        if (state == UGTouchIDStateSuccess) {
            [self.view ug_showToastWithToast:@"验证成功！"];
            //回到设置页面  /*延迟执行时间0.5秒*/
            __weak typeof(self)weakSelf = self;
            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                [self setState:@"1"];
                [weakSelf.navigationController popViewControllerAnimated:NO];
            });
        }
    }];
}

#pragma mark - 稍后再说
- (IBAction)laterToken:(id)sender {
    [self setState:@"0"];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)setState:(NSString *)state{
    [[UGManager shareInstance] hasTouchIDOrFaceIDVerifyValue:state];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SETTINGTOUCHIDORFACEIDSUCCSE" object:nil userInfo:@{@"state" : state}];
}

@end

