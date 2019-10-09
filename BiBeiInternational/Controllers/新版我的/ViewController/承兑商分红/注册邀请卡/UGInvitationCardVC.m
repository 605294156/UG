//
//  UGInvitationCardVC.m
//  BiBeiInternational
//
//  Created by keniu on 2019/8/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGInvitationCardVC.h"
#import "QRCodeViewModel.h"
#import "UGInviteRegisterApi.h"
@interface UGInvitationCardVC ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UIImageView *InvitationQrcodeImageView;
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UIView *backContentView;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qrcodeWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qrcodeHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tittleLabelLeftLayout;



//四英寸适配相关
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewLeftLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewRightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentViewTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *avatarWidthLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *toRateTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *desLabelHeightLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qrcodeTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonHeightLayout;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *buttonTopLayout;

@end

@implementation UGInvitationCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self aboutUI];
    [self getInvitationCardQrcodeInfo];
}


#pragma mark-UI 设置
-(void)aboutUI
{
    self.title = @"邀请注册";
    self.rateLabel.text = self.rate;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UGManager shareInstance].hostInfo.userInfoModel.member.avatar] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    self.usernameLabel.text =[UGManager shareInstance].hostInfo.userInfoModel.member.username;
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapAction:)];
    longPress.minimumPressDuration = 0.5;
    [self.backContentView addGestureRecognizer:longPress];
    
    self.contentViewLeftLayout.constant = UG_AutoSize(25);
    self.contentViewRightLayout.constant = UG_AutoSize(25);
    self.qrcodeTopLayout.constant = UG_AutoSize(53);
    if (UG_SCREEN_WIDTH == 414) {
        self.qrcodeTopLayout.constant = 65;
        self.avatarTopLayout.constant = 74;
        self.qrcodeHeightLayout.constant = 155;
        self.qrcodeWidthLayout.constant = 155;
        self.tittleLabelLeftLayout.constant = 100;
    }
    //设备四寸屏幕
    if ([UG_MethodsTool is4InchesScreen]) {
        self.contentViewLeftLayout.constant = 8;
        self.contentViewRightLayout.constant = 8;
        self.contentViewTopLayout.constant = 8;
        self.avatarWidthLayout.constant = 60;
        self.avatarHeightLayout.constant = 60;
        self.avatarImageView.layer.cornerRadius = 30;
        self.avatarImageView.layer.masksToBounds = YES;
        self.rateLabel.font = [UIFont systemFontOfSize:32];
        self.toRateTopLayout.constant = 10;
        self.desLabelHeightLayout.constant = 40;
        self.qrcodeTopLayout.constant = 40;
        self.buttonHeightLayout.constant = 40;
        self.saveButton.titleLabel.font = [UIFont systemFontOfSize:15];
        self.buttonTopLayout.constant = 0;
    }

}

#pragma mark - 获取邀请二维码链接
-(void)getInvitationCardQrcodeInfo
{
    UGInviteRegisterApi *api = [[UGInviteRegisterApi alloc]init];
    api.rate = self.rate;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
     if (!apiError.errorNumber)
        {
            NSLog(@"object = %@",object);
            NSString *contentString = (NSString *)object;
            self.qrcodeString = contentString;
            if (self.qrcodeString.length)
            {
                self.InvitationQrcodeImageView.image = [QRCodeViewModel createQRimageString:self.qrcodeString sizeWidth:self.InvitationQrcodeImageView.size.width fillColor:[UIColor blackColor]];
            }
        }
        else
        {
            [self.view ug_showToastWithToast:apiError.desc];
        }

    }];
    
}


#pragma mark- 保存到相册
//MARK:--长按保存图片
- (void) longTapAction:(UILongPressGestureRecognizer *)longPress {
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIImage *contentImage = [UG_MethodsTool getContentImageWithTargetView:self.backContentView];
        NSData * data = UIImagePNGRepresentation(contentImage);
        UIImage * imagePng = [UIImage imageWithData:data];
        if (self.qrcodeString.length) {
             [self saveImage:imagePng];
        }
        else
        {
            [self.view ug_showToastWithToast:@"邀请信息获取失败"];
        }
       
    }
}

//image是要保存的图片
- (void) saveImage:(UIImage *)image{
    if (image) {
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
    };
}
//保存完成后调用的方法
- (void)savedPhotoImage:(UIImage*)image didFinishSavingWithError: (NSError *)error contextInfo: (void *)contextInfo {
    if (error) {
        [self.view ug_showToastWithToast:LocalizationKey(@"savePhotoFailure")];
    }
    else {
        NSLog(@"保存图片成功");
        [self.view ug_showToastWithToast:LocalizationKey(@"savePhotoSuccess") ];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
