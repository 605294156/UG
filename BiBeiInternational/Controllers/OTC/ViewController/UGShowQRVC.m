//
//  UGShowQRVC.m
//  BiBeiInternational
//
//  Created by conew on 2019/5/7.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGShowQRVC.h"

@interface UGShowQRVC ()
@property (weak, nonatomic) IBOutlet UIImageView *qrImage;
@end

@implementation UGShowQRVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"二维码";
    
    if ( ! UG_CheckStrIsEmpty(self.qrCodeUrl)) {
        [self.qrImage sd_setImageWithURL:[NSURL URLWithString:self.qrCodeUrl] placeholderImage:[UIImage imageNamed:@"qr_defult"]];
    }
}

#pragma mark-保存二维码到相册
- (IBAction)saveImage:(id)sender {
    if ( ! UG_CheckStrIsEmpty(self.qrCodeUrl) && self.qrImage.image) {
        UIImageWriteToSavedPhotosAlbum(self.qrImage.image, self, @selector(savedPhotoImage:didFinishSavingWithError:contextInfo:), nil);
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

@end
