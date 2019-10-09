//
//  UGTouchLoginVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/18.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGTouchLoginVC.h"
#import "UGSettingPayPassWordVC.h"
#import "UGNavController.h"

@interface UGTouchLoginVC ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIButton *accountBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accoutCons;
@end

@implementation UGTouchLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    
    self.topCons.constant = UG_AutoSize(64)+[UG_MethodsTool statusBarHeight];
    self.imagCons.constant = UG_AutoSize(40);
    self.btnCons.constant = UG_AutoSize(100);
    self.accoutCons.constant = UG_AutoSize(60);
    [self.view bringSubviewToFront:self.accountBtn];
    
    self.iconImg.image = [[UGManager shareInstance] checkIsSupportFaceIDOrTouchID] == UGSupportFaceID ? [UIImage imageNamed:@"faceIcon.png"] : [UIImage imageNamed:@"touchIcon.png"];
    [self.faceBtn setTitle:[[UGManager shareInstance] checkIsSupportFaceIDOrTouchID] == UGSupportFaceID ? @"面容登录" : @"指纹登录" forState:UIControlStateNormal];
    
    @weakify(self);
    [keychianTool getUserName:^(NSString *userName) {
        @strongify(self);
        self.userName.text = userName;
    }];
    
    if ([[UGManager shareInstance] getTouchIDOrFaceIDVerifyValue] && [[UGManager shareInstance] checkIsSupportFaceIDOrTouchID] == UGSupportTouchID) {
        [self openVerify];
    }
}

-(void)openVerify{
    @weakify(self);
    [self verifyTouchOrFaceID:^(UGTouchIDState state, NSError * _Nonnull error) {
        @strongify(self);
        if (state == UGTouchIDStateSuccess) {
            [[UGManager shareInstance] autoLoginCompletionBlock:^(UGApiError *apiError, id object) {
                if (!apiError) {
                    if (self.faceLoginBlock) {
                        self.faceLoginBlock();
                    }
                } else {
                    [self.view ug_showToastWithToast:apiError.desc];
                }
            }];
        }
    }];
}

#pragma mark -指纹登录
- (IBAction)faceLogin:(id)sender {
    [self openVerify];
}

#pragma mark - 账号密码登录
- (IBAction)accountLogin:(id)sender {
    if (self.accountLoginBlock) {
        self.accountLoginBlock();
    }
}

@end
