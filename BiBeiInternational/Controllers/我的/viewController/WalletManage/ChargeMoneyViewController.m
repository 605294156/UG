//
//  ChargeMoneyViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/7.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "ChargeMoneyViewController.h"

@interface ChargeMoneyViewController ()
@property (weak, nonatomic) IBOutlet UILabel *riskTipLabel;//风险提示
@property (weak, nonatomic) IBOutlet UILabel *coinAddressType;//货币地址类型
@property (weak, nonatomic) IBOutlet UIImageView *QRCodeImage;//二维码图片
@property (weak, nonatomic) IBOutlet UILabel *coinAddress;//地址
@property (weak, nonatomic) IBOutlet UIButton *photoAlbumButton;//相册按钮
@property (weak, nonatomic) IBOutlet UIButton *addressButton;//复制地址按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QrCodeTopViewHeight;//二维码地址向上的高度
@property (weak, nonatomic) IBOutlet UILabel *minimumChargeMoneyLab;//最小充币量
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *photoAlbumTopViewHeight;//保存相册View距离上一个控件高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeViewHeight;//二维码View距离左右的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *QRCodeImageLeftWidth;//二维码图片向左的宽度
@property(nonatomic,strong)UIImage *codeImage;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *savePhotoLabel;
@property (weak, nonatomic) IBOutlet UILabel *AddressLabel;//复制地址

@end

@implementation ChargeMoneyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.unit = [self.unit uppercaseString];
    self.title = [NSString stringWithFormat:@"%@",LocalizationKey(@"chargeMoney")];
    self.minimumChargeMoneyLab.text = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"minimumChargeMoney"),self.mininumChargeamount];

    if (kWindowH == 480) {
        self.QrCodeTopViewHeight.constant = 20;
        self.photoAlbumTopViewHeight.constant = 10;
        self.QRCodeViewHeight.constant = 50;
    }else if(kWindowH == 568){
        self.QrCodeTopViewHeight.constant = 30;
        self.photoAlbumTopViewHeight.constant = 30;
        self.QRCodeViewHeight.constant = 40;
    }else{
        self.QrCodeTopViewHeight.constant = 40;
        self.photoAlbumTopViewHeight.constant = 40;
         self.QRCodeViewHeight.constant = 30;
    }
    if ([self.address isEqualToString:@""] || self.address == nil) {
        self.QRCodeImage.image = [UIImage imageNamed:@"emptyData"];
        self.coinAddress.text = LocalizationKey(@"unChargeMoneyTip1");
        if (kWindowH == 480) {
            self.QRCodeImageLeftWidth.constant = (kWindowW - self.QRCodeViewHeight.constant*2-120)/2;
        }else{
            self.QRCodeImageLeftWidth.constant = (kWindowW - self.QRCodeViewHeight.constant*2-160)/2;
        }        
    }else{
        CIImage *codeCIImage = [self createQRForString:self.address];
        self.codeImage = [self createNonInterpolatedUIImageFormCIImage:codeCIImage withSize:200];
        self.QRCodeImage.image = self.codeImage;
        self.coinAddress.text = self.address;
        self.QRCodeImageLeftWidth.constant = 40;
    }
    
    self.riskTipLabel.text = [NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"chargeMoneyTip1"),self.unit,LocalizationKey(@"chargeMoneyTip2")];
    self.coinAddressType.text = [NSString stringWithFormat:@"%@ Address",self.unit];
    self.savePhotoLabel.text = LocalizationKey(@"savePhoto");
    self.AddressLabel.text = LocalizationKey(@"copyAddress");
   
}
//MARK:--按钮的点击事件
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        //保存相册按钮点击事件
        if ([self.address isEqualToString:@""] || self.address == nil) {
            [self.view ug_showToastWithToast:LocalizationKey(@"unChargeMoneyTip2")];
            return;
        }
        [self saveImage:self.codeImage];
    }else if (sender.tag == 2){
        //复制地址按钮的点击事件
        if ([self.address isEqualToString:@""] || self.address == nil) {
            [self.view ug_showToastWithToast:LocalizationKey(@"unChargeMoneyTip3") ];
            return;
        }
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.address;
        [self.view ug_showToastWithToast:LocalizationKey(@"copyAdressTip")];
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
//    if (error) {
        [self.view ug_showToastWithToast:LocalizationKey(error ? @"savePhotoFailure" : @"savePhotoSuccess")];
//    }
//    else {
//        NSLog(@"保存图片成功");
//        [self.view ug_showToastWithToast:LocalizationKey(@"savePhotoSuccess")];
//    }
}
//MARK:--字符串生成二维码
- (CIImage *)createQRForString:(NSString *)qrString {
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    // 创建filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 设置内容和纠错级别
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
    // 返回CIImage
    return qrFilter.outputImage;
}
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    //原图
    UIImage *outputImage = [UIImage imageWithCGImage:scaledImage];
    UIGraphicsBeginImageContextWithOptions(outputImage.size, NO, [[UIScreen mainScreen] scale]);
    [outputImage drawInRect:CGRectMake(0,0 , size, size)];
    //水印图
    UIImage *waterimage = [UIImage imageNamed:@""];
    [waterimage drawInRect:CGRectMake((size-waterimage.size.width)/2.0, (size-waterimage.size.height)/2.0, waterimage.size.width, waterimage.size.height)];
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newPic;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
