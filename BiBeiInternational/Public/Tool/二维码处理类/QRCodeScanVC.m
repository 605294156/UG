//
//  QRCodeScanVC.m
//  BiBeiInternational
//
//  Created by keniu on 2019/7/23.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//
#import <Photos/Photos.h>
#import "QRCodeScanVC.h"
#import "QRCodeViewModel.h"
#import <AudioToolbox/AudioToolbox.h>
//1108 相机快门声音  1057 滴的一声
#define SOUNDID  1057
#define QRCCODE_WIDTH  ([UIScreen mainScreen].bounds.size.width)
#define QRCCODE_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define QRCCODE_IS_iPhoneX ([UIDevice isIphoneXSeries])

@interface QRCodeScanVC ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate,AVCaptureMetadataOutputObjectsDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *dowmViewBottomLayout;
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;
@property (weak, nonatomic) IBOutlet UIView *downView;
@property (weak, nonatomic) IBOutlet UIButton *btnFlash;
@property (weak, nonatomic) IBOutlet UIButton *btnPhoto;
//记录闪光状态
@property(nonatomic,assign)BOOL isTurnON;
//扫描的滚动横线
@property (nonatomic, strong) UIImageView *lineImageView;
//扫描滚动横线动画计时器
@property (nonatomic, strong) NSTimer *timer;
//扫描相机输出加载时loading显示
@property(nonatomic,strong)UIActivityIndicatorView *alertActivityView;
@property (nonatomic,strong) AVCaptureSession * session;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *previewLayer;
//防止重复识别，导致页面重复跳转
@property (nonatomic, assign) BOOL isReading;
@end
@implementation QRCodeScanVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    //控制器初始设置
    [self vcDefaultSetting];
    //开始二维码扫描
    [self scanQrcodeStarting];
    
    
    @weakify(self)
    [self setupBarButtonItemWithImageName:@"back_icon" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {@strongify(self)
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
#define XXXXXXC_GAP     70.f
#pragma mark - 初始设置
-(void)vcDefaultSetting
{
    self.title = @"扫一扫";
    self.isTurnON  = NO;
    //蒙板
    UIView * maskView = [[UIView alloc]init];
    if (QRCCODE_IS_iPhoneX)
    {
        self.dowmViewBottomLayout.constant = 33;
        maskView.frame = CGRectMake(0, 0, QRCCODE_WIDTH, QRCCODE_HEIGHT-88);
    }
    else
    {
        self.dowmViewBottomLayout.constant = 0;
        maskView.frame = CGRectMake(0, 0, QRCCODE_WIDTH, QRCCODE_HEIGHT-64);
    }
    maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    //取景框显示蒙板切割
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, QRCCODE_WIDTH, QRCCODE_HEIGHT)];
    [maskPath appendPath:[[UIBezierPath bezierPathWithRoundedRect:CGRectMake(QRCCODE_WIDTH/5, QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6+XXXXXXC_GAP, QRCCODE_WIDTH*0.6, QRCCODE_WIDTH*0.6) cornerRadius:1] bezierPathByReversingPath]];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.path = maskPath.CGPath;
    maskView.layer.mask = maskLayer;
    [self.view addSubview:maskView];
    [self toSetFourCornerAndActivityView];
}

#pragma mark - 开始扫描
-(void)scanQrcodeStarting
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
            [self loadScanView];
            [self aboutUI];
            [self startRunning];
        }
    }
    else
    {
        //相机不可用时，提示用户
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

#pragma mark - 扫描层加载完成后设置控制器UI
-(void)aboutUI
{
    [self.alertActivityView stopAnimating];
    [self.view bringSubviewToFront:_tittleLabel];
    [self.view bringSubviewToFront:_downView];
    self.lineImageView = [[UIImageView alloc]initWithFrame:CGRectMake(QRCCODE_WIDTH/5+4, QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6+4+XXXXXXC_GAP, QRCCODE_WIDTH*0.6-8, 4)];
    self.lineImageView.image = [UIImage imageNamed:@"Qrcode_scanner_line"];
    [self.view addSubview:self.lineImageView];
    _timer=[NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(moveUpAndDownLine) userInfo:nil repeats: YES];
}

#pragma mark - 底部按钮事件
//打开或关闭闪光灯
- (IBAction)openOrCloseFlashLight:(UIButton *)sender{
    
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        if (self.isTurnON)
        {
            self.isTurnON = NO;
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOff];//关
            [device unlockForConfiguration];
            [_btnFlash setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
        }
        else
        {
            self.isTurnON = YES;
            [device lockForConfiguration:nil];
            [device setTorchMode:AVCaptureTorchModeOn];//开
            [device unlockForConfiguration];
            [_btnFlash setBackgroundImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
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

//从相册打开图片
- (IBAction)selectPictureFromAlbum:(id)sender {
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        NSString *errorStr;
        NSString *okStr;
        errorStr =@"应用访问相册权限受限,请您前往设置中启用。";
        okStr = @"我知道了";
        UIAlertController *alertCtl = [UIAlertController alertControllerWithTitle:@"温馨提示" message:errorStr preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:okStr style:UIAlertActionStyleCancel handler:nil];
        [alertCtl addAction:cancelAction];
        [self presentViewController:alertCtl animated:YES completion:nil];
    }
    else
    {
        UIImagePickerController *vc = [[UIImagePickerController alloc] init];
        vc.delegate = self;
        vc.allowsEditing = NO;
        vc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        vc.modalPresentationStyle = UIModalPresentationFullScreen;
        [self presentViewController:vc animated:YES completion:nil];
    }
}

#pragma mark - 从相册识别二维码图片
-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    @weakify(self);
    __weak QRCodeViewModel * VM = [QRCodeViewModel sharedInstance];
    [VM GetQrcodeInfoFromAPicture:image SuccessBlock:^(NSString *resultString) {
        [picker dismissViewControllerAnimated:YES completion:nil];
        NSLog(@"识别成功！ =  %@",resultString);
        @strongify(self);
        //声音提示
        AudioServicesPlaySystemSound(SOUNDID);
        [self.navigationController popViewControllerAnimated:NO];
        if (self.QrcodeScanResult) {
            self.QrcodeScanResult(resultString);
        }
        
    } FailureBlock:^{
        NSLog(@"不是二维码图片");
        return ;
    }];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma 绘制取景框四个角
-(void)toSetFourCornerAndActivityView
{
    CGFloat w = 2.f;
    CGFloat xc_gap = XXXXXXC_GAP;
    //  设置左上角
    UIBezierPath *linePathA = [UIBezierPath bezierPath];
    CGPoint pointA = CGPointMake(QRCCODE_WIDTH/5+20,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6)-5+xc_gap);
    CGPoint pointA1 = CGPointMake(QRCCODE_WIDTH/5-5,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6)-5+xc_gap);
    CGPoint pointA2 = CGPointMake(QRCCODE_WIDTH/5-5,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6)+20+xc_gap);
    //起点
    [linePathA moveToPoint:pointA];
    [linePathA addLineToPoint:pointA1];
    [linePathA addLineToPoint:pointA2];
    CAShapeLayer *lineLayerA = [CAShapeLayer layer];
    lineLayerA.lineWidth = w;
    lineLayerA.strokeColor = [UIColor colorWithHexString:@"6684c7"].CGColor;
    lineLayerA.path = linePathA.CGPath;
    lineLayerA.fillColor = nil;
    [self.view.layer addSublayer:lineLayerA];
    //设置右上角
    UIBezierPath *linePathB = [UIBezierPath bezierPath];
    CGPoint pointB = CGPointMake(QRCCODE_WIDTH/5+QRCCODE_WIDTH*0.6-20,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6)-5+xc_gap);
    CGPoint pointB1 = CGPointMake(QRCCODE_WIDTH/5+QRCCODE_WIDTH*0.6+5,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6)-5+xc_gap);
    CGPoint pointB2 = CGPointMake(QRCCODE_WIDTH/5+QRCCODE_WIDTH*0.6+5,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6)+20+xc_gap);
    //起点
    [linePathB moveToPoint:pointB];
    [linePathB addLineToPoint:pointB1];
    [linePathB addLineToPoint:pointB2];
    CAShapeLayer *lineLayerB = [CAShapeLayer layer];
    lineLayerB.lineWidth = w;
    lineLayerB.strokeColor = [UIColor colorWithHexString:@"6684c7"].CGColor;
    lineLayerB.path = linePathB.CGPath;
    lineLayerB.fillColor = nil;
    [self.view.layer addSublayer:lineLayerB];
    
    // 设置左下角
    UIBezierPath *linePathC = [UIBezierPath bezierPath];
    CGPoint pointC = CGPointMake(QRCCODE_WIDTH/5-5,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6+QRCCODE_WIDTH*0.6)-20+xc_gap);
    CGPoint pointC1 = CGPointMake(QRCCODE_WIDTH/5-5,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6+QRCCODE_WIDTH*0.6)+5+xc_gap);
    CGPoint pointC2 = CGPointMake(QRCCODE_WIDTH/5+20,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6+QRCCODE_WIDTH*0.6)+5+xc_gap);
    //起点
    [linePathC moveToPoint:pointC];
    [linePathC addLineToPoint:pointC1];
    [linePathC addLineToPoint:pointC2];
    CAShapeLayer *lineLayerC = [CAShapeLayer layer];
    lineLayerC.lineWidth = w;
    lineLayerC.strokeColor = [UIColor colorWithHexString:@"6684c7"].CGColor;
    lineLayerC.path = linePathC.CGPath;
    lineLayerC.fillColor = nil;
    [self.view.layer addSublayer:lineLayerC];
    
    //设置右下角
    UIBezierPath *linePathD = [UIBezierPath bezierPath];
    CGPoint pointD = CGPointMake(QRCCODE_WIDTH/5+QRCCODE_WIDTH*0.6-20,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6+QRCCODE_WIDTH*0.6)+5+xc_gap);
    CGPoint pointD1 = CGPointMake(QRCCODE_WIDTH/5+QRCCODE_WIDTH*0.6+5,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6+QRCCODE_WIDTH*0.6)+5+xc_gap);
    CGPoint pointD2 = CGPointMake(QRCCODE_WIDTH/5+QRCCODE_WIDTH*0.6+5,(QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6+QRCCODE_WIDTH*0.6)-20+xc_gap);
    //起点
    [linePathD moveToPoint:pointD];
    [linePathD addLineToPoint:pointD1];
    [linePathD addLineToPoint:pointD2];
    CAShapeLayer *lineLayerD = [CAShapeLayer layer];
    lineLayerD.lineWidth = w;
    lineLayerD.strokeColor = [UIColor colorWithHexString:@"6684c7"].CGColor;
    lineLayerD.path = linePathD.CGPath;
    lineLayerD.fillColor = nil;
    [self.view.layer addSublayer:lineLayerD];
    self.alertActivityView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    self.alertActivityView.center = CGPointMake(QRCCODE_WIDTH/2, (QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6)+QRCCODE_WIDTH*0.3);
    [self.alertActivityView startAnimating];
    [self.view addSubview:self.alertActivityView];
    
}


#pragma mark - 扫描动画相关
//二维码的横线移动
- (void)moveUpAndDownLine {
    CGFloat Y = self.lineImageView.frame.origin.y;
    CGFloat height = QRCCODE_WIDTH*0.6-15;
    if (QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6+5 == Y)
    {
        [UIView beginAnimations: @"asa" context:nil];
        [UIView setAnimationDuration:1.5];
        CGRect frame = self.lineImageView.frame;
        frame.origin.y += height;
        self.lineImageView.frame = frame;
        [UIView commitAnimations];
    } else if (QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6+5+height== Y){
        [UIView beginAnimations: @"asa" context:nil];
        [UIView setAnimationDuration:1.5];
        CGRect frame = self.lineImageView.frame;
        frame.origin.y = QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6+5;
        self.lineImageView.frame = frame;
        [UIView commitAnimations];
    }
}

-(void)dealloc
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil ;
    }
    _session = nil;
    
}

#pragma mark - 加载扫描框
-(void)loadScanView
{
    //获取摄像设备
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    //创建输入流
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:nil];
    //创建输出流
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc]init];
    //设置代理 在主线程里刷新
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //初始化链接对象
    self.session = [[AVCaptureSession alloc]init];
    //高质量采集率
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    //新增是否能添加此输入流的判断
    if ([self.session canAddInput:input])
    {
        [self.session addInput:input];
    }
    //新增是否能添加此输出流的判断
    if ([self.session canAddOutput:output])
    {
        [self.session addOutput:output];
    }
    output.metadataObjectTypes=@[AVMetadataObjectTypeQRCode];
    _previewLayer =[AVCaptureVideoPreviewLayer layerWithSession:_session];
    _previewLayer.videoGravity =AVLayerVideoGravityResizeAspectFill;
    if(QRCCODE_IS_iPhoneX)
    {
        _previewLayer.frame =CGRectMake(0, 0, QRCCODE_WIDTH, QRCCODE_HEIGHT-88);
    }
    else
    {
        _previewLayer.frame =CGRectMake(0, 0, QRCCODE_WIDTH, QRCCODE_HEIGHT-64);
    }
    //设置可识别的区域
    CGRect intertRect = [self coverToMetadataOutputRectOfInterestForRect:CGRectMake(QRCCODE_WIDTH/5,QRCCODE_HEIGHT/2-QRCCODE_WIDTH*0.6, QRCCODE_WIDTH*0.6, QRCCODE_WIDTH*0.6)];
    //设置扫描区域
    output.rectOfInterest = intertRect;
    [self.view.layer insertSublayer:_previewLayer atIndex:0];
}

#pragma mark - 扫描区域返回
// 该方法中，_preViewLayer指的是AVCaptureVideoPreviewLayer的实例对象，_session是会话对象
- (CGRect)coverToMetadataOutputRectOfInterestForRect:(CGRect)cropRect {
    CGSize size = _previewLayer.bounds.size;
    CGFloat p1 = size.height/size.width;
    CGFloat p2 = 0.0;
    if ([_session.sessionPreset isEqualToString:AVCaptureSessionPreset1920x1080]) {
        p2 = 1920./1080.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPreset352x288]) {
        p2 = 352./288.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPreset1280x720]) {
        p2 = 1280./720.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetiFrame960x540]) {
        p2 = 960./540.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetiFrame1280x720]) {
        p2 = 1280./720.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetHigh]) {
        p2 = 1920./1080.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetMedium]) {
        p2 = 480./360.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetLow]) {
        p2 = 192./144.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetPhoto]) { // 暂时未查到具体分辨率，但是可以推导出分辨率的比例为4/3
        p2 = 4./3.;
    }
    else if ([_session.sessionPreset isEqualToString:AVCaptureSessionPresetInputPriority]) {
        p2 = 1920./1080.;
    }
    else if (@available(iOS 9.0, *)) {
        if ([_session.sessionPreset isEqualToString:AVCaptureSessionPreset3840x2160]) {
            p2 = 3840./2160.;
        }
    } else {
        
    }
    if ([_previewLayer.videoGravity isEqualToString:AVLayerVideoGravityResize]) {
        
        return CGRectMake((cropRect.origin.y)/size.height,(size.width-(cropRect.size.width+cropRect.origin.x))/size.width, cropRect.size.height/size.height,cropRect.size.width/size.width);
        
    } else if ([_previewLayer.videoGravity isEqualToString:AVLayerVideoGravityResizeAspectFill]) {
        if (p1 < p2) {
            CGFloat fixHeight = size.width * p2;
            CGFloat fixPadding = (fixHeight - size.height)/2;
            return CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                        (size.width-(cropRect.size.width+cropRect.origin.x))/size.width,
                                                        cropRect.size.height/fixHeight,
                                                        cropRect.size.width/size.width);
        } else {
            CGFloat fixWidth = size.height * (1/p2);
            CGFloat fixPadding = (fixWidth - size.width)/2;
            return CGRectMake(cropRect.origin.y/size.height,
                                                        (size.width-(cropRect.size.width+cropRect.origin.x)+fixPadding)/fixWidth,
                                                        cropRect.size.height/size.height,
                                                        cropRect.size.width/fixWidth);
        }
    } else
    {
        if (p1 > p2) {
            CGFloat fixHeight = size.width * p2;
            CGFloat fixPadding = (fixHeight - size.height)/2;
            return CGRectMake((cropRect.origin.y + fixPadding)/fixHeight,
                                                        (size.width-(cropRect.size.width+cropRect.origin.x))/size.width,
                                                        cropRect.size.height/fixHeight,
                                                        cropRect.size.width/size.width);
        } else {
            CGFloat fixWidth = size.height * (1/p2);
            CGFloat fixPadding = (fixWidth - size.width)/2;
            return CGRectMake(cropRect.origin.y/size.height,
                                                        (size.width-(cropRect.size.width+cropRect.origin.x)+fixPadding)/fixWidth,
                                                        cropRect.size.height/size.height,
                                                        cropRect.size.width/fixWidth);
        }
    }
}

#pragma mark - 开始捕获
- (void)startRunning {
    if (self.session) {
        _isReading = YES;
        [self.session startRunning];
    }
}

#pragma mark - 停止捕获
- (void)stopRunning
{
    if ([_timer isValid])
    {
        [_timer invalidate];
        _timer = nil ;
    }
    
    [self.session stopRunning];
}



#pragma mark - AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    
    if (!_isReading) {
        return;
    }
    
    if (metadataObjects.count > 0)
    {
        _isReading = NO;
        //声音提示
        AudioServicesPlaySystemSound(SOUNDID);
        NSLog(@"metadataObjects = %@",metadataObjects);
        AVMetadataMachineReadableCodeObject *metadataObject = metadataObjects[0];
        NSString *result = metadataObject.stringValue;
        [self.navigationController popViewControllerAnimated:NO];
        if (self.QrcodeScanResult) {
            self.QrcodeScanResult(result);
        }
    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
     [self startRunning];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
    NSFontAttributeName : [UIFont systemFontOfSize:18]}];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self stopRunning];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:nil];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : HEXCOLOR(0x333333),
    NSFontAttributeName : [UIFont systemFontOfSize:18]}];
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
