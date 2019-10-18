//
//  UGAuthenticationViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAuthenticationViewController.h"
#import "UGAuthenticationCell.h"
#import "UGGeneralCertificationVC.h"
#import "UGAdancedCertificationVC.h"
#import "UGMGFaceTool.h"
#import "UGFaceStatusApi.h"

@interface UGAuthenticationViewController ()

@property(nonatomic, strong) NSString *idCar;
@property(nonatomic, strong) NSString *name;

@end

@implementation UGAuthenticationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"身份认证";
    self.tableView.estimatedRowHeight = 132.0f;
    self.tableView.rowHeight = 132.0f;//UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGAuthenticationCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGAuthenticationCell class]) ];
    [self.tableView.mj_header beginRefreshing];
}

- (void)refreshData {
    [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
        [self.tableView endRefreshingWithNoMoreData:YES];
        [self.tableView reloadData];
    }];
}

- (BOOL)hasFooterRefresh {
    return NO;
}

//- (UITableViewStyle)getTableViewSytle {
//    return UITableViewStyleGrouped;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGAuthenticationCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGAuthenticationCell class]) forIndexPath:indexPath];
    
    UGApplication *application = [UGManager shareInstance].hostInfo.userInfoModel.application;
    
    [cell updateTitle:indexPath.section+1];
    
//    NSString *highAuthentication = [self upDataMessage:@"highAuthentication" WithMessage:@"10000"];
    
    BOOL valication0 = [UGManager shareInstance].hostInfo.userInfoModel.hasRealnameValidation;
    BOOL valication1 = [UGManager shareInstance].hostInfo.userInfoModel.hasHighValidation;
    if (indexPath.section == 0) {
        cell.statusLabel.textType = valication0 ? 4 : 1;
        cell.subtitleLabel.textType = 1;
        cell.subtitleLabel2.textType = 1;
        cell.iconType = valication0 ? 4 : 1;
//        BOOL change = application != nil ;
//        NSString *text = valication ?  [NSString stringWithFormat:@"%@ %@",change ? application.realName : self.name, change ? application.idCard : self.idCar] : [NSString stringWithFormat:@"可进行单笔不大于%@元的交易",highAuthentication];
//        cell.subtitleLabel.text = text;
        
    } else if (indexPath.section == 1){
        
        cell.statusLabel.textType = valication1 ? 4 :([application.auditStatus isEqualToString:@"1"] ? 3 : [application.auditStatus isEqualToString:@"0"] ? 2 : 1);
//        cell.statusLabel.text = valication ? @"已认证" : ([application.auditStatus isEqualToString:@"1"] ?   @"审核失败" : [application.auditStatus isEqualToString:@"0"] ? @"审核中" : @"未认证");
//        cell.subtitleLabel.text =valication ? @"已完成认证，可以安心交易了！" : ([application.auditStatus isEqualToString:@"1"] ?   @"认证失败，请重新进行认证 ！" :  [application.auditStatus isEqualToString:@"0"] ? @"认证已提交，将在1-3个工作日完成审核！" : [NSString stringWithFormat:@"可进行单笔大于%@元的交易",highAuthentication]);
        cell.subtitleLabel.textType = (!valication1 && [application.auditStatus isEqualToString:@"0"]) ? 4 : 2;
        cell.subtitleLabel2.textType = (!valication1 && [application.auditStatus isEqualToString:@"0"]) ? 4 : 2;
        cell.iconType = valication0 ? (valication1 ? 4 :([application.auditStatus isEqualToString:@"1"] ? 3 : [application.auditStatus isEqualToString:@"0"] ? 2 : 1)) : 0;
    } else {
//        cell.subtitleLabel.text = @"可进行单笔大于50000CNY的交易";
//        cell.statusLabel.text = [[UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus isEqualToString:@"1"] ? @"已认证" : @"未认证";
        cell.statusLabel.textType = [[UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus isEqualToString:@"1"] ? 4 : 1;
        cell.subtitleLabel.textType = 3;
        cell.subtitleLabel2.textType = 3;
        cell.iconType = valication1 ? ([[UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus isEqualToString:@"1"] ? 4 : 1) : 0;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
      
        if (![self hasRealnameValidation]) {
            UGGeneralCertificationVC *vc = [UGGeneralCertificationVC new];
            @weakify(self);
            vc.refeshData = ^(NSString * _Nonnull name, NSString * _Nonnull idCar) {
                @strongify(self);
                self.name = name;
                self.idCar = idCar;
                [self.tableView reloadData];
            };
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            if ([self isCardVip]) {
                UGGeneralCertificationVC *vc = [UGGeneralCertificationVC new];
                vc.isChangeVip = YES;
                @weakify(self);
                vc.refeshData = ^(NSString * _Nonnull name, NSString * _Nonnull idCar) {
                    @strongify(self);
                    self.name = name;
                    self.idCar = idCar;
                    [self.tableView reloadData];
                };
                [self.navigationController pushViewController:vc animated:YES];
            }
        }
    } else if (indexPath.section == 1) {
        if (![self hasRealnameValidation]) {
            [self.view ug_showToastWithToast:@"请您先进行实名认证！"];
            return;
        }
        UGAdancedCertificationVC *vc = [UGAdancedCertificationVC new];
        vc.refeshData = ^{
            [self.tableView reloadData];
        };
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if (![self hasFaceValidation]) {
            
            if (![self hasRealnameValidation] || ![self hasHighValidation]) {
                [self.view ug_showToastWithToast:@"请您先进行高级认证！"];
                return;
            }
            [self faceVerify];
        }
    }
}

-(void)faceVerify{
    @weakify(self);
    [UGMGFaceTool ug_mgFaceVerifyWith:self WithTypeStr:@"UPDATE_FACESTATUS" WithUserName:[UGManager shareInstance].hostInfo.username callback:^(NSUInteger Code, NSString * _Nonnull Message, NSString * _Nonnull key) {
        @strongify(self);
        if (Code == 51000) {
            [UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus = @"1";
            [self changeFaceStatus:key];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView reloadData];
            });
        }else{
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showFaceAlterView:Message];
            });
        }
    }];
}

-(void)changeFaceStatus:(NSString *)totken{
    UGFaceStatusApi *api = [UGFaceStatusApi new];
    api.bizToken = totken;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            [self.tableView reloadData];
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
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

/**
 * 是否是承兑商
 */
-(BOOL)isCardVip{
    return [[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString:@"1"];
}

@end
