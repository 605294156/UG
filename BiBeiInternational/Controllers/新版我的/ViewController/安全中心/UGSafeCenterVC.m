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

@interface UGSafeCenterVC ()
@property (nonatomic,assign)BOOL hasSettingFaceID;
@property (nonatomic,strong)NSArray *titleArray;
@property (nonatomic,strong)NSArray *imageArray;
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
        self.imageArray = @[@"mine_passwordlog.png",@"mine_password.png",@"mine_name.png",@"mine_touchid_icon.png"];
    }
    else
    {
        self.titleArray = @[@"登录密码重置",@"UG钱包支付密码重置",@"开启Touch ID、Face ID"];
        self.imageArray = @[@"mine_passwordlog.png",@"mine_password.png",@"mine_touchid_icon.png"];
    }

}

- (UITableViewStyle)getTableViewSytle {
    return UITableViewStyleGrouped;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titleArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGSafeCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGSafeCenterCell class]) forIndexPath:indexPath];
    cell.title.text =self.titleArray[indexPath.section];
    cell.icon.image = [UIImage imageNamed:self.imageArray[indexPath.section]];
    if ([self.titleArray[indexPath.section] isEqualToString:@"开启Touch ID、Face ID"]) {
        cell.arrowIcon.hidden = YES;
        cell.switchOpen.hidden = NO;
        [cell.switchOpen setOn:self.hasSettingFaceID animated:NO];
        @weakify(self);
        cell.isOpenSwitchBlock = ^(BOOL isopen) {
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
    }
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.titleArray[indexPath.section] isEqualToString:@"登录密码重置"]) {
        UGReSettingPasswordVC *vc = [UGReSettingPasswordVC new];
        vc.topVC = self;
        [self.navigationController pushViewController:vc animated:YES];
    } else if ([self.titleArray[indexPath.section] isEqualToString:@"UG钱包支付密码重置"]) {
        UGReviseWalletWithGoogleAndFaceVC *vc = [UGReviseWalletWithGoogleAndFaceVC new];
        vc.topVC = self;
        [self.navigationController pushViewController:vc animated:YES];
    }else if ([self.titleArray[indexPath.section] isEqualToString:@"谷歌验证器换绑"])
    {
        if ([self alerterHasBindingGoogleValidator]) {
            UGGoogleUnboundVC *vc = [UGGoogleUnboundVC new];
            vc.topVC = self;
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    else if ([self.titleArray[indexPath.section] isEqualToString:@"修改手机号码"]) {
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

@end
