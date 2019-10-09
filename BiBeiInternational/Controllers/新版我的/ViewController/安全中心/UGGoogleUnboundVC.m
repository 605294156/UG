//
//  UGGoogleUnboundVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/20.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGGoogleUnboundVC.h"
#import "UGAuthenticationViewController.h"
#import "UGMGFaceTool.h"
#import "UGShowGoogleVerifyVC.h"

@interface UGGoogleUnboundVC ()
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *stateImg;
@property (weak, nonatomic) IBOutlet UIButton *bingBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *stateW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTopC;

@end

@implementation UGGoogleUnboundVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self languageChange];
    
    self.topCons.constant = UG_AutoSize(40);
    self.userTop.constant = UG_AutoSize(15);
    self.stateCons.constant = UG_AutoSize(45);
    self.stateW.constant = UG_AutoSize(153);
    self.stateH.constant = UG_AutoSize(119);
    self.btnTopC.constant = UG_AutoSize(100);
}

-(void)languageChange{
    self.title = @"谷歌验证器换绑";
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:[UGManager shareInstance].hostInfo.userInfoModel.member.avatar] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    self.userName.text = [UGManager shareInstance].hostInfo.username;
}

#pragma mark -重新绑定
- (IBAction)reBind:(id)sender {
    //首先判断是否进行了人脸认证
    if (![self hasFaceValidation]) {
        //跳到认证页面
        @weakify(self);
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"认证提醒" message:@"为了您的资产安全，操作前，请您先完成所有身份认证！" cancle:@"取消" others:@[@"去认证"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            @strongify(self);
            if (buttonIndex == 1) {
                [self.navigationController pushViewController:[UGAuthenticationViewController new] animated:YES];
            }
        }];
    }else{
        [self faceVerify];
    }
}

-(void)faceVerify{
    @weakify(self);
    [UGMGFaceTool ug_mgFaceVerifyWith:self WithTypeStr:@"UPDATE_GOOGLE" WithUserName:[UGManager shareInstance].hostInfo.username callback:^(NSUInteger Code, NSString * _Nonnull Message, NSString * _Nonnull key) {
        @strongify(self);
        if (Code == 51000) {
            [UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus = @"1";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //跳转到谷歌验证码绑定页面
                UGShowGoogleVerifyVC *vc=[UGShowGoogleVerifyVC new];
                vc.baseVC = self.topVC;
                vc.key = key;
                vc.isReSet = YES;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showFaceAlterView:Message];
            });
        }
    }];
}

//是否人脸识别认证
-(BOOL)hasFaceValidation {
    return [[UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus isEqualToString:@"1"];
}

//是否绑定谷歌验证器
-(BOOL)hasBindingGoogle{
   return [UGManager shareInstance].hostInfo.userInfoModel.hasGoogleValidation;
}
@end
