//
//  UGSettingPayPassWordVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGSettingPayPassWordVC.h"
#import "UGReviseJYpasswordApi.h"
#import "UGFingerprintVC.h"
#import "UGMakeTrueMnemonnicVC.h"
#import "UGTipsView.h"

@interface UGSettingPayPassWordVC ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btn;
@property (weak, nonatomic) IBOutlet UILabel *walletName;
@property (nonatomic,assign)BOOL isback;
@property (nonatomic,assign)BOOL isSetting;
@property (nonatomic,assign)UGCheckFaceIDOrTouchID ugCheckFaceIDOrTouchID;
@end

@implementation UGSettingPayPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.top.constant = UG_AutoSize(25);
    self.btn.constant = UG_AutoSize(60);
    
    @weakify(self);
   [self setupBarButtonItemWithImageName:@"goback" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
        @strongify(self);
        [self retruns];
    }];
    
    self.haveReadBtn.selected = NO;
    [self languageChange];
    
    __weak typeof(self)weakself = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [weakself.passWord resignFirstResponder];
        [weakself.rePassWord resignFirstResponder];
    }];
    [self.view addGestureRecognizer:tap];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(settingSuccse) name:@"SETTINGTOUCHIDORFACEIDSUCCSE" object:nil];
    
    //获取当前设备是否支持 FaceID 和 TouchID
    self.ugCheckFaceIDOrTouchID = [[UGManager shareInstance] getTouchIDOrFaceIDVerifyValue];
}

-(void)settingSuccse{
    if (self.isRegister) {
        self.isSetting = YES;
        [self.navigationController popToRootViewControllerAnimated:NO];
    } else {
        if(self.isHome){
            //回到首页
            self.isSetting = NO;
            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
        }else{
            self.isSetting = NO;
            [self.navigationController dismissViewControllerAnimated:NO completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:@"设置支付密码成功" object:nil];
            }];
        }
    }
}

-(void)retruns{
    self.isback = YES;
    if (self.isRegister) {
        [self.navigationController popToRootViewControllerAnimated:NO];
    } else {
        [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    }
}

-(void)languageChange{
    self.title = @"设置支付密码";
    if ([UGManager shareInstance].hostInfo.userInfoModel.list.count>0) {
        UGWalletAllModel *model =[UGManager shareInstance].hostInfo.userInfoModel.list[0];
        self.walletName.text = !UG_CheckStrIsEmpty(model.name)?model.name:@" ";
    }
}

#pragma mark- 确认密码
- (IBAction)tureBtn:(id)sender {@weakify(self)
    if (!self.haveReadBtn.selected) {
        if (!UG_CheckStrIsEmpty(self.passWord.text) && !UG_CheckStrIsEmpty(self.rePassWord.text)) {
            [self.view ug_showToastWithToast:@"请仔细阅读服务协议！"];
        }
        return;
    } else {
        if (UG_CheckStrIsEmpty(self.passWord.text) || self.passWord.text.length != 6) {
            [self.view ug_showToastWithToast:@"请您确认输入6位数字支付密码"];
            return;
        }else if (UG_CheckStrIsEmpty(self.rePassWord.text)) {
            [self.view ug_showToastWithToast:@"请确认密码"];
            return;
        }else if(![self.passWord.text isEqualToString:self.rePassWord.text]){
            [self.view ug_showToastWithToast:@"请您确认两次输入密码一致！"];
            return;
        }
    }
    UGReviseJYpasswordApi *api = [[UGReviseJYpasswordApi alloc] init];
    api.nPassword = self.passWord.text;
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!apiError) {
//            [self.view ug_showToastWithToast:@"设置支付密码成功！"];
//            __weak typeof(self)weakSelf = self;
//            dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
//            dispatch_after(delayTime, dispatch_get_main_queue(), ^{
//                if ([UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone) {
//                    BOOL hasSettingFaceID = [[UGManager shareInstance] getTouchIDOrFaceIDVerifyValue];
//                    if (!hasSettingFaceID && self.isRegister) {
//                        UGFingerprintVC *printVC = [UGFingerprintVC new];
//                        [weakSelf.navigationController pushViewController:printVC animated:NO];
//                    }else{
//                        if (weakSelf.isRegister) {
//                            weakSelf.isSetting = YES;
//                            [weakSelf.navigationController popToRootViewControllerAnimated:NO];
//                        } else {
//                            if(self.isHome){
//                                //回到首页
//                                weakSelf.isSetting = NO;
//                            }else{
//                                weakSelf.isSetting = YES;
//                            }
//                            [weakSelf.navigationController dismissViewControllerAnimated:NO completion:nil];
//                        }
//                    }
//                }else{
//                    UGMakeTrueMnemonnicVC *makeTreVC = [[UGMakeTrueMnemonnicVC alloc] init];
//                    makeTreVC.isfromRegister = YES;
//                    makeTreVC.isRegister = self.isRegister;
//                    makeTreVC.isUserName = self.isUserName;
//                    [weakSelf.navigationController pushViewController:makeTreVC animated:NO];
//                    makeTreVC.backlClick = ^{
//                        BOOL hasSettingFaceID = [[UGManager shareInstance] getTouchIDOrFaceIDVerifyValue];
//                        if (!hasSettingFaceID && self.isRegister) {
//                            UGFingerprintVC *printVC = [UGFingerprintVC new];
//                            [weakSelf.navigationController pushViewController:printVC animated:NO];
//                        }else{
//                            if (weakSelf.isRegister) {
//                                weakSelf.isSetting = YES;
//                                [weakSelf.navigationController popToRootViewControllerAnimated:NO];
//                            } else {
//                                if(self.isHome){
//                                    //回到首页
//                                    weakSelf.isSetting = NO;
//                                }else{
//                                    weakSelf.isSetting = YES;
//                                }
//                                [weakSelf.navigationController dismissViewControllerAnimated:NO completion:nil];
//                            }
//                        }
//                    };
//                }
//            });
            
            UGTipsView *tipsView = [[UGTipsView alloc]initWithFrame:CGRectZero];
            tipsView.subTitle.text = @"请牢记您的新密码";
            [APPLICATION.window addSubview:tipsView];
            [[tipsView.submitBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {@strongify(self)
                [tipsView removeFromSuperview];
                
                if ([UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone) {
                    BOOL hasSettingFaceID = [[UGManager shareInstance] getTouchIDOrFaceIDVerifyValue];
                    if (!hasSettingFaceID && self.isRegister) {
                        UGFingerprintVC *printVC = [UGFingerprintVC new];
                        [self.navigationController pushViewController:printVC animated:NO];
                    }else{
                        if (self.isRegister) {
                            self.isSetting = YES;
                            [self.navigationController popToRootViewControllerAnimated:NO];
                        } else {
                            if(self.isHome){
                                //回到首页
                                self.isSetting = NO;
                            }else{
                                self.isSetting = YES;
                            }
                            [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                        }
                    }
                }else{
                    UGMakeTrueMnemonnicVC *makeTreVC = [[UGMakeTrueMnemonnicVC alloc] init];
                    makeTreVC.isfromRegister = YES;
                    makeTreVC.isRegister = self.isRegister;
                    makeTreVC.isUserName = self.isUserName;
                    [self.navigationController pushViewController:makeTreVC animated:NO];
                    makeTreVC.backlClick = ^{
                        BOOL hasSettingFaceID = [[UGManager shareInstance] getTouchIDOrFaceIDVerifyValue];
                        if (!hasSettingFaceID && self.isRegister) {
                            UGFingerprintVC *printVC = [UGFingerprintVC new];
                            [self.navigationController pushViewController:printVC animated:NO];
                        }else{
                            if (self.isRegister) {
                                self.isSetting = YES;
                                [self.navigationController popToRootViewControllerAnimated:NO];
                            } else {
                                if(self.isHome){
                                    //回到首页
                                    self.isSetting = NO;
                                }else{
                                    self.isSetting = YES;
                                }
                                [self.navigationController dismissViewControllerAnimated:NO completion:nil];
                            }
                        }
                    };
                }
            }];
        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark- 我已仔细阅读并同意
- (IBAction)haveRead:(id)sender {
    self.haveReadBtn.selected = !self.haveReadBtn.selected;
        if (self.haveReadBtn.selected) {
            self.tureBtn.backgroundColor = UG_MainColor;
        } else {
            self.tureBtn.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
        }
}

#pragma mark- 隐私条款
- (IBAction)serverBtn:(id)sender {
    [self gotoWebView:@"服务与隐私条款" htmlUrl:[UGURLConfig serveApi]];
}

-(void)dealloc{
    if (self.isback) {
        [[UGManager shareInstance] signout:^{
        }];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"注册返回成功" object:nil userInfo: self.isUserName ?  @{@"type" : @"1"} : @{@"type" : @"0"}];
    }
    
    if (self.isSetting) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"设置支付密码成功" object:nil];
    }
}

@end
