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
@property (weak, nonatomic) IBOutlet UILabel *userIdLabel;
@property (weak, nonatomic) IBOutlet UIView *backContentView;
@property (weak, nonatomic) IBOutlet UILabel *rateLabel;
@property (weak, nonatomic) IBOutlet UILabel *saveLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navTopLayout;

@end

@implementation UGInvitationCardVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self aboutUI];
    [self getInvitationCardQrcodeInfo];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


- (IBAction)goBackAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark-UI 设置
-(void)aboutUI
{
    self.title = @"邀请注册";
    self.navigationBarHidden = YES;
    self.view.backgroundColor = [UIColor colorWithHexString:@"3f5994"];
//    self.rateLabel.text = self.rate;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UGManager shareInstance].hostInfo.userInfoModel.member.avatar] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    UGMember *memberModel = [UGManager shareInstance].hostInfo.userInfoModel.member;
    self.usernameLabel.text = memberModel.registername;
    self.userIdLabel.text = [NSString stringWithFormat:@"ID %@",memberModel.username];
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longTapAction:)];
    longPress.minimumPressDuration = 0.5;
    [self.backContentView addGestureRecognizer:longPress];
    
    NSString *rateStr = [NSString stringWithFormat:@"%@‰",self.rate];
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"您的分红费率 %@",rateStr]];
    [attributedStr addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"ec5c54"] range:NSMakeRange(6, rateStr.length+1)];
//    [attributedStr addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:24] range:NSMakeRange(0 , 4)];
    self.rateLabel.attributedText = attributedStr;
    if (IS_IPHONE_X) {
        self.navTopLayout.constant = 46;
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
        self.saveLab.text = @"扫描图中二维码，一起拿分红";
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
        self.saveLab.text = @"长按图片保存到相册";
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
