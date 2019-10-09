//
//  BindAliPayViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/5/2.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BindAliPayViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "MineNetManager.h"

@interface BindAliPayViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *realName;
@property (weak, nonatomic) IBOutlet UITextField *aliPayNum;
@property (weak, nonatomic) IBOutlet UITextField *moneyPassword;
@property (weak, nonatomic) IBOutlet UIButton *QRButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

//相机控制器
@property(nonatomic,strong)UIImagePickerController *imagePickerVC;
@property(nonatomic,copy)NSString *imageString;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *alipayNumLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyPasswordLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectQRCodeLabel;


@end

@implementation BindAliPayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.realName.text = self.model.realName;
    if ([self.model.aliVerified isEqualToString:@"1"]) {
        //已保存，可修改
        self.title = LocalizationKey(@"modifyAliPayNum");
        self.aliPayNum.text = self.model.alipay.aliNo;
        [self.saveButton setTitle:LocalizationKey(@"modify") forState:UIControlStateNormal];
    }else{
        self.title = LocalizationKey(@"setAliPayNum");
        [self.saveButton setTitle:LocalizationKey(@"save") forState:UIControlStateNormal];
    }
    
    self.nameLabel.text = LocalizationKey(@"name");
    self.alipayNumLabel.text = LocalizationKey(@"alipayAccount");
    self.moneyPasswordLabel.text = LocalizationKey(@"moneyPassword");
    self.collectQRCodeLabel.text = LocalizationKey(@"collectionQR");
    self.aliPayNum.placeholder = LocalizationKey(@"inputAliPayNum");
    self.moneyPassword.placeholder = LocalizationKey(@"inputMoneyPassword");
    self.moneyPassword.secureTextEntry = YES;
    
}
//MARK:--点击上传收款二维码
- (IBAction)QRBtnClick:(id)sender {
    [self changeHeaderImage];
}
//MARK:--添加支付宝二维码头像
-(void)changeHeaderImage{
    __block NSUInteger sourceType = 0;
    UIAlertController *sheet =[UIAlertController alertControllerWithTitle:LocalizationKey(@"projectNameTip") message:LocalizationKey(@"inputAliPayAddImage") preferredStyle:UIAlertControllerStyleActionSheet];
    [sheet addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"takingPictures") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否已授权
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
            if (authStatus == ALAuthorizationStatusDenied||authStatus == ALAuthorizationStatusRestricted) {
                [self.view ug_showToastWithToast:LocalizationKey(@"cameraPermissionsTips")];
                return ;
            }
        }
        sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            [self chooseImage:sourceType];
        }else{
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalizationKey(@"tips") message:LocalizationKey(@"unSupportTakePhoto") preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"ok") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"photoAlbumSelect") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        //判断是否已授权
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            ALAuthorizationStatus authStatus = [ALAssetsLibrary authorizationStatus];
            if (authStatus == ALAuthorizationStatusDenied) {
                [self.view ug_showToastWithToast:LocalizationKey(@"cameraPermissionsTips")];
                return;
            }
        }
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self chooseImage:sourceType];
    }]];
    [sheet addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:sheet animated:YES completion:nil];
    });
    
}
//从本地选择照片（拍照或从相册选择）
-(void)chooseImage:(NSInteger)sourceType
{
    //创建对象
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
    self.imagePickerVC = imagePickerController;
    //设置代理
    imagePickerController.delegate = self;
    //是否允许图片进行编辑
    imagePickerController.allowsEditing = YES;
    //选择图片还是开启相机
    imagePickerController.sourceType = sourceType;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark UIImagePickerController代理 已经选择了图片,上传到服务器中,返回上传结果
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //选择图片
    UIImage *headImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
    NSData *imageData = UIImageJPEGRepresentation(headImage, 0.5);
    //将图片上传到服务器
    [EasyShowLodingView showLodingText:LocalizationKey(@"upLoadingHeadPhoto")];
    [MineNetManager uploadImageData:imageData CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        DLog(@"%@",resPonseObj);
        if (code) {
            //
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self.QRButton setBackgroundImage:headImage forState:UIControlStateNormal];
                self.imageString = [NSString stringWithFormat:@"%@",resPonseObj[@"data"]];
                
            }else if ([resPonseObj[@"code"] integerValue]==4000){
//                [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [self showLoginViewController];
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"upLoadPictureFailure")];
        }
    }];
    [self dismissViewControllerAnimated:YES completion:nil];
}
//MARK:--点击保存按钮点击事件
- (IBAction)saveBtnClick:(id)sender {
    if ([self.aliPayNum.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputAliPayNum")];
        return;
    }
    if ([self.moneyPassword.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputMoneyPassword")];
        return;
    }
    if ([self.imageString isEqualToString:@""] || self.imageString == nil) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputCollectionQR")];
        return;
    }
    [EasyShowLodingView showLodingText:LocalizationKey(@"hardUpLoading")];
    NSString *urlStr = @"";
    if ([self.model.aliVerified isEqualToString:@"1"]) {
        //已绑定，可修改
        urlStr = @"uc/approve/update/ali";
    }else{
        urlStr = @"uc/approve/bind/ali";
    }
    [MineNetManager setAliPayForUrlString:urlStr withAli:self.aliPayNum.text withJyPassword:self.moneyPassword.text withRealName:self.realName.text withQrCodeUrl:self.imageString CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //上传成功
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [[UGManager shareInstance] signout:nil];
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
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
