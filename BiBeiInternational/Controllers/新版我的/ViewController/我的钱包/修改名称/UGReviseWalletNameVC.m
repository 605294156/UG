//
//  UGReviseWalletNameVC.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/24.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGReviseWalletNameVC.h"
#import "UGButton.h"
#import "UGReviseWalletNameApi.h"

@interface UGReviseWalletNameVC ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UGButton *saveButton;

@property (weak, nonatomic) IBOutlet UITextField *reviseWalletNameField;

@end

@implementation UGReviseWalletNameVC

- (void)viewDidLoad {@weakify(self)
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"钱包名称修改";
//    self.saveButton.buttonStyle = UGButtonStyleBlue;
    self.reviseWalletNameField.text = ((UGWalletAllModel *)[UGManager shareInstance].hostInfo.userInfoModel.list.firstObject).name;
    self.reviseWalletNameField.rightViewMode = UITextFieldViewModeWhileEditing;
//    self.reviseWalletNameField.rightView = [[UIImageView alloc] initWithImage: [[UIImage imageNamed:@"my_qb_clear"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"my_qb_clear"] forState:UIControlStateNormal];
    [btn setFrame:CGRectMake(0, 0, 30, 30)];
    self.reviseWalletNameField.rightView = btn;
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {@strongify(self)
        self.reviseWalletNameField.text = @"";
    }];
    
    RACSignal *passwordSignal=[[RACObserve(self.reviseWalletNameField, text) merge: [self.reviseWalletNameField rac_textSignal]] map:^id _Nullable(NSString * _Nullable value) {
            return @(value.length>0);
       }];
     
    RAC(self.saveButton,enabled)= passwordSignal;
}

- (IBAction)clickSave:(UGButton *)sender {
 if( self.reviseWalletNameField.text.length <4 || self.reviseWalletNameField.text.length>20){
        [self.view ug_showToastWithToast:@"请输入4-20位钱包名称"];
    }else{
         [self sendRequest];
    }
}

- (void)sendRequest {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGReviseWalletNameApi *api = [UGReviseWalletNameApi new];
    api.name = self.reviseWalletNameField.text;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (object) {
            [self.view ug_showToastWithToast:@"修改成功"];
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark -delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    //限制输入emoji表情
    if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
        return NO;
    }
    //判断键盘是不是九宫格键盘
    if ([NSString isNineKeyBoard:string] ){
        return YES;
    }else{
        if ([NSString hasEmoji:string] || [NSString stringContainsEmoji:string]){
            return NO;
        }
    }
    return YES;
}

@end
