//
//  EditPhotoVC.m
//  OriginalTools
//
//  Created by keniu on 2019/8/12.
//  Copyright © 2019 NickSun. All rights reserved.
//

#import "EditPhotoVC.h"
#import <AudioToolbox/AudioToolbox.h>
#import <Photos/Photos.h>
//1108 相机快门声音
#define SOUNDID  1108
#define EditPhotoVC_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define EditPhotoVC_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define EditPhotoVC_IS_iPhoneX ({\
int tmp = 0;\
if (@available(iOS 11.0, *)) {\
if ([UIApplication sharedApplication].delegate.window.safeAreaInsets.top > 20) {\
tmp = 1;\
}else{\
tmp = 0;\
}\
}else{\
tmp = 0;\
}\
tmp;\
})

@interface EditPhotoVC ()<AVCaptureMetadataOutputObjectsDelegate>
@property (weak, nonatomic) IBOutlet UIButton *PhotoButton;
@property (weak, nonatomic) IBOutlet UIButton *FlashButton;
@property (weak, nonatomic) IBOutlet UIButton *CancelButton;
@property (weak, nonatomic) IBOutlet UIButton *PhotoDenyButton;
@property (weak, nonatomic) IBOutlet UIButton *PhotoOKButton;

//记录闪光状态
@property(nonatomic,assign)BOOL isTurnON;
//底部按钮！
@property (weak, nonatomic) IBOutlet UIView *downButtonsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dowmViewBottomLayout;
@property (weak, nonatomic) IBOutlet UIImageView *photoFrameImageView;
//@property (nonatomic, strong) UILabel *tittleLabel;//提示字

//捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）
@property(nonatomic)AVCaptureDevice *device;
//AVCaptureDeviceInput 代表输入设备，他使用AVCaptureDevice 来初始化
@property(nonatomic)AVCaptureDeviceInput *input;
//当启动摄像头开始捕获输入
@property(nonatomic)AVCaptureMetadataOutput *output;
//输出
@property (nonatomic)AVCaptureStillImageOutput *ImageOutPut;
//session：由他把输入输出结合在一起，并开始启动捕获设备（摄像头）
@property(nonatomic)AVCaptureSession *session;
//图像预览层，实时显示捕获的图像
@property(nonatomic)AVCaptureVideoPreviewLayer *previewLayer;
//照片加载视图
@property (nonatomic, strong) UIImageView *imageView;
//拍到的照片
@property (nonatomic, strong) UIImage *image;

//遮挡View
@property (weak, nonatomic) IBOutlet UIView *maskview1;
@property (weak, nonatomic) IBOutlet UIView *maskview2;
@property (weak, nonatomic) IBOutlet UIView *maskview3;
@property (weak, nonatomic) IBOutlet UIView *maskview4;



@end

@implementation EditPhotoVC
#pragma mark - 加载照片的视图
-(UIImageView *)imageView{
    if (_imageView == nil) {
        _imageView = [[UIImageView alloc]initWithFrame:self.previewLayer.frame];
        
        //这里要注意，图片填充方式的选择让图片不要变形了
        
        [_imageView setContentMode:UIViewContentModeScaleAspectFill];
        
        _imageView.clipsToBounds = YES;
    }
    return _imageView;
}

#pragma mark - 引导提示
//- (UILabel *)tittleLabel {
//    if (_tittleLabel == nil) {
//        _tittleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, EditPhotoVC_WIDTH*0.5, 50)];
//        _tittleLabel.center = self.view.center;
//        _tittleLabel.text = @"请将身份证置于此区域\n尝试对其边缘";
//        _tittleLabel.textColor = [UIColor whiteColor];
//        _tittleLabel.numberOfLines = 0;
//        _tittleLabel.textAlignment = NSTextAlignmentCenter;
//        _tittleLabel.font = [UIFont systemFontOfSize:16];
//        _tittleLabel.transform = CGAffineTransformMakeRotation(M_PI/2);
//    }
//    return _tittleLabel;
//}


#pragma mark - 使用self.session，初始化预览层，self.session负责驱动input进行信息的采集，layer负责把图像渲染显示
- (AVCaptureVideoPreviewLayer *)previewLayer{
    if (_previewLayer == nil) {
        _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
        _previewLayer.frame = CGRectMake(0, 0, EditPhotoVC_WIDTH, EditPhotoVC_HEIGHT);
        _previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return  _previewLayer;
}
-(AVCaptureStillImageOutput *)ImageOutPut{
    if (_ImageOutPut == nil) {
        _ImageOutPut = [[AVCaptureStillImageOutput alloc] init];
    }
    return _ImageOutPut;
}
#pragma mark - 初始化输入
-(AVCaptureDeviceInput *)input{
    if (_input == nil) {
        
        _input = [[AVCaptureDeviceInput alloc]initWithDevice:self.device error:nil];
    }
    return _input;
}
#pragma mark - 初始化输出
-(AVCaptureMetadataOutput *)output{
    if (_output == nil) {
        
        _output = [[AVCaptureMetadataOutput alloc]init];
    }
    return  _output;
}
#pragma mark - 使用AVMediaTypeVideo 指明self.device代表视频，默认使用后置摄像头进行初始化
-(AVCaptureDevice *)device{
    if (_device == nil) {
        _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    return _device;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self toSetVCUI];
    [self startCaptureOption];
}


-(void)toSetVCUI
{
    self.isTurnON  = NO;
    self.title = _isIDCard ? @"身份证":@"银行卡";
    self.photoFrameImageView.image = _isIDCard ?[UIImage imageNamed:@"IDCardFrame"]:[UIImage imageNamed:@"BankCardFrame"];
    if (EditPhotoVC_IS_iPhoneX)     {
        self.dowmViewBottomLayout.constant = 33;
    }
    else
    {
        self.dowmViewBottomLayout.constant = 0;
    }
    
    [self.PhotoButton setBackgroundImage:[UIImage imageNamed:@"photograph_Select"] forState:UIControlStateSelected];
    [self.PhotoButton setBackgroundImage:[UIImage imageNamed:@"photograph"] forState:UIControlStateNormal];
}



#pragma mark - 开始捕获
-(void)startCaptureOption
{
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        //判断是否有相机权限
        NSString *mediaType = AVMediaTypeVideo;//读取媒体类型
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];//读取设备授权状态
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied){
            NSString *errorStr;
            NSString *okStr;
            errorStr =@"应用相机权限受限,请您前往设置中启用。";
            okStr = @"我知道了";
            UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            }];
            [alertCtl addAction:cancelAction];
            [self presentViewController:alertCtl animated:YES completion:nil];
        }
        else
        {
         //操作
            [self customCamera];
            [self aboutUI];
        }
    }
    else
    {
        NSString *errorStr;
        NSString *okStr;
        errorStr =@"您的设备相机不可用。";
        okStr = @"我知道了";
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertCtl addAction:cancelAction];
        [self presentViewController:alertCtl animated:YES completion:nil];
    }
    
}

#pragma mark - 自定义相机
- (void)customCamera{
    
    //生成会话，用来结合输入输出
    self.session = [[AVCaptureSession alloc]init];
    if ([self.session canSetSessionPreset:AVCaptureSessionPresetPhoto]) {
        self.session.sessionPreset = AVCaptureSessionPresetPhoto;
    }
    if ([self.session canAddInput:self.input]) {
        [self.session addInput:self.input];
    }
    
    if ([self.session canAddOutput:self.ImageOutPut]) {
        [self.session addOutput:self.ImageOutPut];
    }
    
    [self.view.layer addSublayer:self.previewLayer];
    //开始启动
    [self.session startRunning];
    if ([self.device lockForConfiguration:nil]) {
        if ([self.device isFlashModeSupported:AVCaptureFlashModeAuto]) {
            [self.device setFlashMode:AVCaptureFlashModeAuto];
        }
        //自动白平衡
        if ([self.device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
            [self.device setWhiteBalanceMode:AVCaptureWhiteBalanceModeAutoWhiteBalance];
        }
        
        [self.device unlockForConfiguration];
    }
    
}

#pragma mark - 扫描层加载完成后设置控制器UI
-(void)aboutUI
{
    //还原UI
//    [self.view bringSubviewToFront:_tittleLabel];
    [self.view bringSubviewToFront:_photoFrameImageView];
    [self.view bringSubviewToFront:_maskview1];
    [self.view bringSubviewToFront:_maskview2];
    [self.view bringSubviewToFront:_maskview3];
    [self.view bringSubviewToFront:_maskview4];
    [self.view bringSubviewToFront:_downButtonsView];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - 底部按钮事件
//打开或关闭闪光灯
- (IBAction)openOrCloseFlashLight:(id)sender {
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        if (self.isTurnON)
        {
            self.isTurnON = NO;
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOff];//关
            [device unlockForConfiguration];
            [_FlashButton setBackgroundImage:[UIImage imageNamed:@"camera_flash_off"] forState:UIControlStateNormal];
        }
        else
        {
            self.isTurnON = YES;
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOn];//开
            [device unlockForConfiguration];
            [_FlashButton setBackgroundImage:[UIImage imageNamed:@"camera_flash_on"] forState:UIControlStateNormal];
        }
    }
    else
    {
        NSString *errorStr;
        NSString *okStr;
        errorStr =@"检测到您的闪光灯不可用，无法打开闪光灯。";
        okStr = @"我知道了";
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertCtl addAction:cancelAction];
        [self presentViewController:alertCtl animated:YES completion:nil];
    }
}

//取消退出
- (IBAction)cancelButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

//拍照
- (IBAction)takePhotoAction:(id)sender {
    
    self.PhotoButton.enabled = NO;
    AVCaptureConnection * videoConnection = [self.ImageOutPut connectionWithMediaType:AVMediaTypeVideo];
    if (!videoConnection) {
        NSLog(@"take photo failed!");
        self.PhotoButton.enabled = YES;
        return;
    }
    
    [self.ImageOutPut captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (imageDataSampleBuffer == NULL) {
            self.PhotoButton.enabled = YES;
            return;
        }
        NSData * imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        self.image = [UIImage imageWithData:imageData];
        NSLog(@"imageInfo = %@",self.image);
        self.imageView.image = [UIImage imageWithData:imageData];
        [self.view insertSubview:self.imageView belowSubview:self.photoFrameImageView];
        [self.session stopRunning];
        [self changeUI];
        self.PhotoButton.enabled = YES;
     }];
        
        
}


#pragma mark- 截取取景框内的图片
-(void)changeUI
{
//    UIImage *image1 = self.image;
//    CGImageRef cgRef = image1.CGImage;
//    CGFloat widthScale = image1.size.width / EditPhotoVC_WIDTH;
//    CGFloat heightScale = image1.size.height / EditPhotoVC_HEIGHT;
//    CGFloat orignWidth = 250;//226
//    CGFloat orginHeight = 398;//360
//    if (EditPhotoVC_IS_iPhoneX) {
//        orignWidth = 250-88;
//        orginHeight = 398;
//    }
//    else
//    {
//        orignWidth = 250-30;
//        orginHeight = 398;
//    }
//    CGFloat x = (EditPhotoVC_HEIGHT - orginHeight) * 0.5 * heightScale;
//    CGFloat y = (EditPhotoVC_WIDTH - orignWidth) * 0.5 * widthScale;
//    CGFloat width = orginHeight * heightScale;
//    CGFloat height = orignWidth * widthScale;
//    CGRect r = CGRectMake(x, y, width, height);
//    CGImageRef imageRef = CGImageCreateWithImageInRect(cgRef, r);
//    UIImage *thumbScale = [UIImage imageWithCGImage:imageRef];
//    image1 = thumbScale;
    self.PhotoButton.hidden = YES;
    self.FlashButton.hidden = YES;
    self.CancelButton.hidden = YES;
    self.PhotoOKButton.hidden = NO;
    self.PhotoDenyButton.hidden = NO;
    


}

#pragma mark - 获取指定区域内的图片
- (UIImage *)newImageFromImageinRect:(CGRect)rect{
    
    CGRect newFrame =self.imageView.frame;
    UIGraphicsBeginImageContext(newFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self.imageView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImage * newImage = [UIImage imageWithCGImage:CGImageCreateWithImageInRect([img CGImage], rect)];
    return newImage;
    
}

-(UIImage *)image:(UIImage *)image rotation:(UIImageOrientation)orientation
{
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    return newPic;
}

- (IBAction)PhotoDenyAction:(id)sender {

    self.PhotoButton.hidden = NO;
    self.FlashButton.hidden = NO;
    self.CancelButton.hidden = NO;
    self.PhotoOKButton.hidden = YES;
    self.PhotoDenyButton.hidden = YES;
    [self.imageView removeFromSuperview];
    [self.session startRunning];
    
}

- (IBAction)PhtotOKAction:(id)sender {
    
    self.photoFrameImageView.hidden = YES;
    self.image = [self newImageFromImageinRect:self.photoFrameImageView.frame];
    self.image = [self image:self.image rotation:UIImageOrientationLeft];
    self.photoFrameImageView.hidden = NO;
    
     self.imageblock(self.image);
     [self.navigationController popViewControllerAnimated:YES];
}


//-(void)viewWillAppear:(BOOL)animated
//{
//    self.tabBarController.tabBar.hidden = YES;
//}
//
//-(void)viewWillDisappear:(BOOL)animated
//{
//    self.tabBarController.tabBar.hidden = NO;
//}


@end
