//
//  UGSafeCenterVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/12.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGSafeCenterVC.h"
#import "UGSafeCenterCell.h"
#import "UGReSettingPasswordVC.h"
#import "UGReviseWalletPasswordVC.h"
#import "UGGoogleUnboundVC.h"
#import "UGReviseWalletWithGoogleAndFaceVC.h"
#import "UGMineChangePhoneVC.h"
#import "UGMakeTrueMnemonnicVC.h"
#import "UGMGFaceTool.h"
#import "UGAuthenticationViewController.h"

@interface UGSafeCenterVC ()
@property (nonatomic,assign)BOOL hasSettingFaceID;
@property (nonatomic,strong)NSArray *titleArray;
//@property (nonatomic,strong)NSArray *imageArray;
@end

@implementation UGSafeCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self languageChange];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGSafeCenterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGSafeCenterCell class])];
    self.tableView.bounces = NO;
    
    self.hasSettingFaceID = [[UGManager shareInstance] getTouchIDOrFaceIDVerifyValue];
}

-(void)languageChange{
    self.title = @"安全中心";
//    self.titleArray = @[@"登录密码重置",@"UG钱包支付密码重置",@"修改手机号码",@"谷歌验证器换绑",@"开启Touch ID、Face ID"];
//    self.imageArray = @[@"mine_passwordlog.png",@"mine_password.png",@"mine_name.png",@"change_Google_VerifyCode",@"mine_touchid_icon.png"];
    //2019.6.25 个人中心注册登陆改版
    if([UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone)
    {
        self.titleArray = @[@"登录密码重置",@"UG钱包支付密码重置",@"修改手机号码",@"开启Touch ID、Face ID"];
//        self.imageArray = @[@"mine_passwordlog.png",@"mine_password.png",@"mine_name.png",@"mine_touchid_icon.png"];
    }
    else
    {
        self.titleArray = @[@"登录密码重置",@"UG钱包支付密码重置",@"开启Touch ID、Face ID"];
//        self.imageArray = @[@"mine_passwordlog.png",@"mine_password.png",@"mine_touchid_icon.png"];
    }

}

- (UITableViewStyle)getTableViewSytle {
    return UITableViewStyleGrouped;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGSafeCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGSafeCenterCell class]) forIndexPath:indexPath];
    cell.title.text =self.titleArray[indexPath.row];
//    cell.icon.image = [UIImage imageNamed:self.imageArray[indexPath.section]];
    if ([self.titleArray[indexPath.row] isEqualToString:@"开启Touch ID、Face ID"]) {
        cell.arrowIcon.hidden = YES;

        @weakify(self);
        cell.mySwitchOpne.block = ^(BOOL isopen) {
            @strongify(self);
            [self verifyTouchOrFaceID:^(UGTouchIDState state, NSError * _Nonnull error) {
                if (state == UGTouchIDStateSuccess) {
                    [self.view ug_showToastWithToast:isopen ? [NSString stringWithFormat:@"已开启"] :  [NSString stringWithFormat:@"已关闭"]];
                     [[UGManager shareInstance] hasTouchIDOrFaceIDVerifyValue:isopen ? @"1" : @"0"];
                     self.hasSettingFaceID = [[UGManager shareInstance] getTouchIDOrFaceIDVerifyValue];
                }
                [self.tableView reloadData];
            }];
        };
        cell.mySwitchOpne.hidden = NO;
        cell.mySwitchOpne.OnStatus = self.hasSettingFaceID;
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.titleArray[indexPath.row] isEqualToString:@"登录密码重置"]) {
        UGReSettingPasswordVC *vc = [UGReSettingPasswordVC new];
        vc.topVC = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleArray[indexPath.row] isEqualToString:@"UG钱包支付密码重置"]) {
//        UGReviseWalletWithGoogleAndFaceVC *vc = [UGReviseWalletWithGoogleAndFaceVC new];
//        vc.topVC = self;
//        [self.navigationController pushViewController:vc animated:YES];
        
        @weakify(self)
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleActionSheet title:nil message:nil cancle:@"取消" others:@[@"助记词重置", @"人脸识别重置"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            @strongify(self);
            if (buttonIndex == 2) {
                if (![self hasRealnameValidation] || ![self hasHighValidation] ||  ![self hasFaceValidation]) {
                    @weakify(self);
                    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"认证提醒" message:@"为了您的资产安全，操作前，请您先完成所有身份认证！" cancle:@"取消" others:@[@"去认证"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                        @strongify(self);
                        if (buttonIndex == 1) {
                            [self.navigationController pushViewController:[UGAuthenticationViewController new] animated:YES];
                        }
                    }];
                    return;
                }
                [self faceSend];
            } else if (buttonIndex == 1) {
                UGMakeTrueMnemonnicVC *vc = [[UGMakeTrueMnemonnicVC alloc] init];
                vc.isfromRegister = NO;
                vc.isPayPassword = YES;
                vc.topVC = self;
                vc.username = [UGManager shareInstance].hostInfo.userInfoModel.member.registername;
                [self.navigationController pushViewController:vc animated:YES];
            }
        }];
    }else if ([self.titleArray[indexPath.row] isEqualToString:@"谷歌验证器换绑"])
    {
        if ([self alerterHasBindingGoogleValidator]) {
            UGGoogleUnboundVC *vc = [UGGoogleUnboundVC new];
            vc.topVC = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([self.titleArray[indexPath.row] isEqualToString:@"修改手机号码"]) {
        UGMineChangePhoneVC *vc = [UGMineChangePhoneVC new];
        vc.topVC = self;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(BOOL)hasHeadRefresh{
    return NO;
}

-(BOOL)hasFooterRefresh{
    return NO;
}

-(void)faceSend{
    @weakify(self);
    [UGMGFaceTool ug_mgFaceVerifyWith:self WithTypeStr:@"UPDATE_JYPASSWORD" WithUserName:[UGManager shareInstance].hostInfo.username callback:^(NSUInteger Code, NSString * _Nonnull Message, NSString * _Nonnull key) {
        @strongify(self);
        if (Code == 51000) {
            [UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus = @"1";
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //跳转到修改支付密码页面
                UGReviseWalletPasswordVC *vc = [UGReviseWalletPasswordVC new];
                vc.isFace = YES;
                vc.token = key;
                vc.topVC = self;
                [self.navigationController pushViewController:vc animated:YES];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showFaceAlterView:Message];
            });
        }
    }];
}


//是否实名认证
- (BOOL)hasRealnameValidation {
    return [UGManager shareInstance].hostInfo.userInfoModel.hasRealnameValidation;
}

//是否高级认证
- (BOOL)hasHighValidation {
    return [UGManager shareInstance].hostInfo.userInfoModel.hasHighValidation;
    
}

//是否人脸识别认证
-(BOOL)hasFaceValidation {
    return [[UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus isEqualToString:@"1"];
}

@end
