//
//  UGShowGoogleVerifyVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGShowGoogleVerifyVC.h"
//#import "UGQRScanVC.h"
#import "UGGenerateGoogleKeyApi.h"
#import "UGGenerateGoogleKeyModel.h"
#import "UGBindingGoogleCoceVC.h"
#import "UGUnbindGoogleApi.h"
#import "QRCodeViewModel.h"

@interface UGShowGoogleVerifyVC ()
@property(nonatomic,strong)UGGenerateGoogleKeyModel *keyModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nextStepButtonDownLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *whiteViewHeightLayout;
@end

@implementation UGShowGoogleVerifyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self languageChange];

    UILongPressGestureRecognizer *longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGesture:)];
    self.qrImage .userInteractionEnabled = YES;
    [self.qrImage addGestureRecognizer:longPressGesture];
    
    if (self.isReSet) {
        [self reRequest];
    }else{
        [self getQrStr];
    }
    
    if ([UG_MethodsTool is4InchesScreen]) {
        self.nextStepButtonDownLayout.constant = 15;
        self.whiteViewHeightLayout.constant = 490;
    }
}


#pragma mark - 换绑获取谷歌验证码
-(void)reRequest{
    UGUnbindGoogleApi *api = [[UGUnbindGoogleApi alloc] init];
    api.key = self.key;
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        if (object) {
            self.keyModel = [UGGenerateGoogleKeyModel mj_objectWithKeyValues:object ];
            if (self.keyModel) {
//                UIImage *imag = [UGQRScanVC createQRImageWithStr:!UG_CheckStrIsEmpty(self.keyModel.link)?self.keyModel.link:@"" withSize:CGSizeMake(172, 172) ];
                UIImage *imag = [QRCodeViewModel createQRimageString:!UG_CheckStrIsEmpty(self.keyModel.link)?self.keyModel.link:@"" sizeWidth:172 fillColor:[UIColor blackColor]];
                self.qrImage.image = imag;
                self.qrContent.text = !UG_CheckStrIsEmpty(self.keyModel.secret)?self.keyModel.secret:@"";
            }
        }else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark- 第一次绑定获取秘钥
-(void)getQrStr{
    UGGenerateGoogleKeyApi *api = [[UGGenerateGoogleKeyApi alloc] init];
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        if (object) {
            self.keyModel = [UGGenerateGoogleKeyModel mj_objectWithKeyValues:object ];
            if (self.keyModel) {
//                UIImage *imag = [UGQRScanVC createQRImageWithStr:!UG_CheckStrIsEmpty(self.keyModel.link)?self.keyModel.link:@"" withSize:CGSizeMake(172, 172) ];
                UIImage *imag = [QRCodeViewModel createQRimageString:!UG_CheckStrIsEmpty(self.keyModel.link)?self.keyModel.link:@"" sizeWidth:172 fillColor:[UIColor blackColor]];
                self.qrImage.image = imag;
                self.qrContent.text = !UG_CheckStrIsEmpty(self.keyModel.secret)?self.keyModel.secret:@"";
            }
        }else {
            [self.view ug_showToastWithToast:apiError.desc];
        }                        
    }];
}

#pragma mark- 保存二维码到相册
-(void)longPressGesture:(UILongPressGestureRecognizer *)gesture{
    if (gesture.state == UIGestureRecognizerStateBegan)
    {
        __weak typeof(self) weakSelf = self;
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"是否保存到手机相册" message:@"绑定谷歌验证器二维码" cancle:@"否" others:@[@"是"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            if (buttonIndex == 1) {
                 UIImageWriteToSavedPhotosAlbum(weakSelf.qrImage.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), NULL);
            }
        }];
    }
}

-(void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if(!error){
        [self.view ug_showToastWithToast:@"保存图片成功！"];
    }else{
        [self.view ug_showToastWithToast:@"保存图片失败！"];
    }
}

-(void)languageChange{
    self.title = @"绑定谷歌验证器";
}

#pragma mark- 复制内容
- (IBAction)copTheCpntent:(id)sender {
    if (UG_CheckStrIsEmpty(self.keyModel.secret))
        return;
    [UIPasteboard generalPasteboard].string =self.keyModel.secret;
    [self.view ug_showToastWithToast:@"复制成功！"];
}

#pragma mark - 下一步
- (IBAction)next:(id)sender {
    UGBindingGoogleCoceVC *vc = [[UGBindingGoogleCoceVC alloc] init];
    vc.baseVC = self.baseVC;
    vc.isReSet = self.isReSet;
    vc.isCarvip = self.isCarvip;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
