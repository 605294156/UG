//
//  UGBindingGoogleCoceVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBindingGoogleCoceVC.h"
#import "UGCodeInputView.h"
#import "UGbindingGoogleApi.h"
#import "UGReBindingApi.h"
#import "UGGeneralCertificationVC.h"

@interface UGBindingGoogleCoceVC ()<GLCodeInputViewDelegate>
@property (weak, nonatomic) IBOutlet UGCodeInputView *passWordInputView;
@property (weak, nonatomic) IBOutlet UIButton *tureBtn;

@end

@implementation UGBindingGoogleCoceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self languageChange];
}

-(void)languageChange{
    self.title = @"谷歌验证码";
}

-(void)codeCompleteInput:(UGCodeInputView *)code{
    [self tureBtn:nil];
}

#pragma MARK - 确定
- (IBAction)tureBtn:(id)sender {
    if (!UG_CheckStrIsEmpty(self.passWordInputView.textStore)&& self.passWordInputView.textStore.length==6) {
        if (self.isReSet) {
            [self reRequest];
        }else{
           [self request];
        }
    }else {
        [self.view ug_showToastWithToast:@"请输入6位谷歌验证码！"];
    }
}

#pragma mark -换绑谷歌验证器
-(void)reRequest{
    UGReBindingApi *api = [[UGReBindingApi alloc] init];
    api.code =self.passWordInputView.textStore;
    self.tureBtn.userInteractionEnabled = NO;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!apiError) {
            [self.view ug_showToastWithToast:@"谷歌验证码换绑成功！"];
            //先本地修改绑定状态
            [UGManager shareInstance].hostInfo.userInfoModel.hasGoogleValidation = YES;
            //刷新用户信息
            [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
            }];
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //发送绑定谷歌验证码成功消息
                [[NSNotificationCenter defaultCenter] postNotificationName:@"谷歌验证码绑定成功" object:nil];
                [weakSelf.navigationController popToViewController:weakSelf.baseVC animated:YES];
            });
        }else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
        self.tureBtn.userInteractionEnabled = YES;
    }];
}

#pragma mark- 绑定谷歌验证器
-(void)request{
    UGbindingGoogleApi *api = [[UGbindingGoogleApi alloc] init];
    api.code =self.passWordInputView.textStore;
    self.tureBtn.userInteractionEnabled = NO;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!apiError) {
            [self.view ug_showToastWithToast:@"谷歌验证码绑定成功！"];
            //先本地修改绑定状态
            [UGManager shareInstance].hostInfo.userInfoModel.hasGoogleValidation = YES;
            //刷新用户信息
            [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
            }];
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (self.isCarvip) {
                    //承兑商 绑定谷歌验证码
                     UGGeneralCertificationVC *vc = [UGGeneralCertificationVC new];
                     vc.isCarvip = self.isCarvip;
                    vc.baseVC = self.baseVC;
                    [weakSelf.navigationController pushViewController: vc animated:YES];
                }else{
                    //发送绑定谷歌验证码成功消息
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"谷歌验证码绑定成功" object:nil];
                    [weakSelf.navigationController popToViewController:weakSelf.baseVC animated:YES];
                }
            });
        }else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
        self.tureBtn.userInteractionEnabled = YES;
    }];
}

#pragma mark - 收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}
@end
