//
//  UGFaceRecognitionVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/1.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGFaceRecognitionVC.h"
#import "UGMediaPicker.h"
#import "UGLipCodeApi.h"
#import "UGUpdateVideoAndImageApi.h"
#import "UGRevisePasswordVC.h"
#import "UGShowGoogleVerifyVC.h"

@interface UGFaceRecognitionVC ()
@property (weak, nonatomic) IBOutlet UILabel *lipCodeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageW;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toph;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lipH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lipBottomH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tip1H;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnframeH;
@property (weak, nonatomic) IBOutlet UIButton *lipBtn;

@property (nonatomic,strong)UGMediaPicker *picker;
@end

@implementation UGFaceRecognitionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imageH.constant = UG_AutoSize(170);
    self.imageW.constant = UG_AutoSize(170);
    self.toph.constant = UG_AutoSize(20);
    self.lipH.constant = UG_AutoSize(30);
    self.lipBottomH.constant = UG_AutoSize(35);
    self.btnH.constant = UG_AutoSize(40);
    self.btnframeH.constant = UG_AutoSize(46);
    self.lipCodeLabel.font = UG_AutoFont(54);
    self.lipBtn.titleLabel.font = UG_AutoFont(16);
    
    [self languageChange];
    
    _picker = [[UGMediaPicker alloc] initWithController:self];

}

-(void)languageChange{
    self.title = @"人脸识别";
}
#pragma mark - 获取唇语验证码
- (IBAction)getLipCode:(id)sender {
    [MBProgressHUD ug_showHUDToKeyWindow];
    self.lipBtn.userInteractionEnabled = NO;
    [self.lipBtn setTitle:@"重新获取" forState:UIControlStateNormal];
    UGLipCodeApi *api = [UGLipCodeApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        self.lipBtn.userInteractionEnabled = YES;
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if ([object isKindOfClass:[NSString class]]) {
            self.lipCodeLabel.text =(NSString *)object;
           
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark - 提交人脸识别
-(void)addFaceVerifyWith:(NSURL *)url{
    [MBProgressHUD ug_showHUDToKeyWindow];
    NSData *data= [NSData dataWithContentsOfURL:url];
    UGUpdateVideoAndImageApi *api = [[UGUpdateVideoAndImageApi alloc] initWithVideoPath:data];
    api.validateData = self.lipCodeLabel.text;
    if (self.isLogin) {
        api.username = self.username;
    }else{
        NSString *userId = [UGManager shareInstance].hostInfo.ID;
        api.userId = userId.length > 0 ? userId : @"";
    }

    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (!apiError) {
            [self.view ug_showToastWithToast:@"人脸识别成功 ！"];
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (weakSelf.faceSuccessBlock) {
                    weakSelf.faceSuccessBlock();
                }
                [UGManager shareInstance].hostInfo.userInfoModel.application.faceStatus = @"1";
                [weakSelf gotoNext:object];
            });
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

-(void)gotoNext:(id)object{
    if (self.isReSettingPassWord) {
        //跳转到密码设置页面
        UGRevisePasswordVC *vc = [UGRevisePasswordVC new];
        vc.fromeFace = YES;
        vc.fromeLogin = self.isLogin;
        vc.username = self.username;
        vc.topVC = self.topVC;
        vc.faceCode = [object isKindOfClass:[NSString class]] ? (NSString *)object : @"";
        [self.navigationController pushViewController: vc animated:YES];
    }else if(self.isGoogle){
        //跳转到谷歌验证码绑定页面
        UGShowGoogleVerifyVC *vc=[UGShowGoogleVerifyVC new];
        vc.baseVC = self.topVC;
        vc.key = object;
        vc.isReSet = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark - 拍摄视频
- (IBAction)takeVideo:(id)sender {
    if([self.lipCodeLabel.text isEqualToString:@"****"])
    {
        [self.view ug_showToastWithToast:@"请先获取唇语验证码"];
        return;
    }
    [_picker videoFromCamera:^(NSURL *fileUrl) {
        [self addFaceVerifyWith:fileUrl];
    }];
}

@end
