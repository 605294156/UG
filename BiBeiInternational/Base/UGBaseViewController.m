//
//  UGBaseViewController.m
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGNavController.h"
#import "UGImagePickerController.h"
#import <objc/runtime.h>
#import "UGGeneralCertificationVC.h"
#import "UGAdancedCertificationVC.h"
#import "UGTouchLoginVC.h"
#import "PlatformMessageDetailViewController.h"
#import "OTCJpushViewController.h"
#import "UGMessageDictionary.h"
#import "UGGetPlayUrlApi.h"
#import "UGBankPaySettingViewController.h"
#import "UGVideoPlayerVCViewController.h"
#import "UGWalletAllApi.h"
#import "OTCWaitingForPayVC.h"
#import "OTCCancelledDetailsVC.h"
#import "OTCBuyPaidViewController.h"
#import "OTCSellCoinViewController.h"

static const void *TakePhotoBlockKey = &TakePhotoBlockKey;

@interface UGBaseViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic,assign,readonly) BOOL statusBarHidden;/**<当前状态栏是否隐藏*/
@property (nonatomic,assign,readonly)  BOOL tempBarStatus;/**<存储当前状态状态*/

@end

@implementation UGBaseViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        _statusBarHidden = NO;
        _navigationBarHidden = NO;
        _navigationBarColor = [UIColor whiteColor];//导航颜色
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //背景色
    if ([self isMemberOfClass:OTCWaitingForPayVC.class] || [self isMemberOfClass:OTCJpushViewController.class] || [self isMemberOfClass:OTCCancelledDetailsVC.class] || [self isMemberOfClass:OTCBuyPaidViewController.class] || [self isMemberOfClass:OTCSellCoinViewController.class]) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTranslucent:true];
    }else{
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:self.navigationBarColor] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
        [self.navigationController.navigationBar setTranslucent:false];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    //接收语言切换消息
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChange) name:LanguageChange object:nil];
    
//    //调用一次
//    [self languageChange];
    
    //MJPhotoBrowser显示隐藏状态，退出则返回控制的状态栏效果
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshStatusBarState:) name:@"ShowPhotoBrowser" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showLoginViewController) name:@"登录失效" object:nil];
    
    if (self.navigationController.viewControllers.count>1) {
        @weakify(self)
        [self setupBarButtonItemWithImageName:@"goback2" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
            @strongify(self);
            [self.navigationController popViewControllerAnimated:YES];
        }];
    }
}

//刷新状态栏
- (void)refreshStatusBarState:(NSNotification *)sender {
    BOOL show = [[sender object] boolValue];
    if (show) { //显示图片浏览
        _tempBarStatus = self.statusBarHidden;
        _statusBarHidden = show;
    } else { //退出图片浏览
        _statusBarHidden = self.tempBarStatus;
    }
    //更新状态栏效果
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - APP内语言切换
- (void)languageChange {
    
}


#pragma mark - 状态栏控制
- (BOOL)prefersStatusBarHidden {
    return self.statusBarHidden;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationFade;
}

#pragma mark - 横竖屏控制
- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}


- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}


#pragma mark - 为了兼容以前的代码

-(void)addUIAlertControlWithString:(NSString *)string withActionBlock:(void(^)(void))actionBlock andCancel:(void(^)(void))cancelBlock{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:LocalizationKey(@"warmPrompt") message:string preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"ok") style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        actionBlock();
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:LocalizationKey(@"cancel") style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        cancelBlock();
    }]];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController: alert animated: YES completion: nil];
    });
}

-(void)addAlterViewWithTitle:(NSString *)title withMessage:(NSString *)message withCertainBtnTitle:(NSString *)certainBtnTilte withCancelBtnTitle:(NSString *)cancelBtnTitle withActionBlock:(void(^)(void))actionBlock andCancel:(void(^)(void))cancelBlock{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:certainBtnTilte style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              //响应事件
                                                              actionBlock();
                                                          }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:cancelBtnTitle style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                             //响应事件
                                                             cancelBlock();
                                                         }];
    
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];
}

//MARK -- 跳转登录页面
-(void)showLoginViewController {
    
    if ([self isShowLoginViewController]) {
        return;
    }
    
    [self.navigationController presentViewController:[[UGNavController new]initWithRootViewController:[UGLoginVC new]] animated:NO completion:nil];
}

//已经弹出了登录窗口
- (BOOL)isShowLoginViewController {
    for (UIViewController *viewController  in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[UGLoginVC class]]) {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - 相册、拍照
- (void)showTakePhotoChooseWithMaxCount:(NSInteger)maxCount WithPoto:(BOOL)isPoto handle:(void(^)(NSArray <UIImage *>*imageList))handle {
    
    objc_setAssociatedObject(self, TakePhotoBlockKey, handle, OBJC_ASSOCIATION_COPY_NONATOMIC);
    @weakify(self);
    if(!isPoto){
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleActionSheet title:nil message:nil cancle:@"取消" others:@[@"拍照"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            @strongify(self);
            //        [self chooseAvatarImageWithSourceType:buttonIndex == 1 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary];
            //可更改
//            if (buttonIndex == 2) {
//                [self showImagePickerControllerWithMaxCount:maxCount];
//            } else
            if (buttonIndex == 1) {
                [self chooseAvatarImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }
        }];
    }else{
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleActionSheet title:nil message:nil cancle:@"取消" others:@[@"拍照", @"从手机相册选择"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            @strongify(self);
            //        [self chooseAvatarImageWithSourceType:buttonIndex == 1 ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary];
            //可更改
            if (buttonIndex == 2) {
                [self showImagePickerControllerWithMaxCount:maxCount];
            } else if (buttonIndex == 1) {
                [self chooseAvatarImageWithSourceType:UIImagePickerControllerSourceTypeCamera];
            }
        }];
    }
}

/**
 选择用户头像
 */
- (void)chooseAvatarImageWithSourceType:(UIImagePickerControllerSourceType)sourceType {

    //项目名
    NSString *projectName = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleExecutableKey];

    if (sourceType == UIImagePickerControllerSourceTypeCamera) {
        AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        if (status == AVAuthorizationStatusRestricted  || status == AVAuthorizationStatusDenied) {
            [self showTipsWithTitle:@"无法访问相机" message:[NSString stringWithFormat:@"请在“设置-隐私-相机”选项中，允许%@访问您的相机。",projectName]];
            return;
        }
    } else if (sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        PHAuthorizationStatus authorStatus = [PHPhotoLibrary authorizationStatus];
        if (authorStatus == PHAuthorizationStatusRestricted || authorStatus == PHAuthorizationStatusDenied) {
            [self showTipsWithTitle:@"无法访问相册" message:[NSString stringWithFormat:@"请在“设置-隐私-相册”选项中，允许%@访问您的相册。",projectName]];
            return;
        }
    }
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    imagePickerController.modalPresentationStyle = UIModalPresentationFullScreen;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)showTipsWithTitle:(NSString *)title message:(NSString *)message {
    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:title message:message  cancle:@"好" others:nil handle:^(NSInteger buttonIndex, UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
}

#pragma mark - UIImagePickerControllerDelegate<NSObject>
- (UIImage *)editImageAutoIfNotWidthEqualToHeight:(UIImage *)image {
    
    CGSize orignalSize = image.size;
    if (orignalSize.height == orignalSize.width) return image;
    
    // 如果图片宽高不一致，就以最短的进行裁切
    if (orignalSize.height > orignalSize.width) {
        CGFloat y = (orignalSize.height - orignalSize.width)*0.5;
        CGRect rect = CGRectMake(0, y, orignalSize.width, orignalSize.height);
        CGSize size = CGSizeMake(orignalSize.width, orignalSize.width);
        
        return  [self cutImageWithSize:size cutRect:rect image:image];
    } else {
        CGFloat x = (orignalSize.width - orignalSize.height)*0.5;
        CGRect rect = CGRectMake(-x, 0, orignalSize.width, orignalSize.height);
        CGSize size = CGSizeMake(orignalSize.height, orignalSize.height);
        
        return [self cutImageWithSize:size cutRect:rect image:image];
    }
}

- (UIImage *)cutImageWithSize:(CGSize)size cutRect:(CGRect)cutrect image:(UIImage *)image{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    [image drawInRect:cutrect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    void(^callBack)(NSArray <UIImage *>*imageList) = objc_getAssociatedObject(self, TakePhotoBlockKey);
    if (callBack) {
        callBack(@[selectedImage]);
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}


//第三方相册选取、暂时没调用
- (void)showImagePickerControllerWithMaxCount:(NSInteger)maxCount {
    UGImagePickerController *imagePockerController = [[UGImagePickerController alloc] initWithMaxImagesCount:maxCount delegate:nil];
    @weakify(self);
    [imagePockerController setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        @strongify(self);
        void(^callBack)(NSArray <UIImage *>*imageList) = objc_getAssociatedObject(self, TakePhotoBlockKey);
        if (callBack) {
            callBack(photos);
        }
    }];
    [self presentViewController:imagePockerController animated:YES completion:nil];
}


/**
 * 购买金额、出售金额需要实名、高级认证
 */
- (BOOL)checkMoneyNeedToValidation:(NSString *)moneyString {
    //购买金额
    double money = [moneyString doubleValue];
    //实名认证状态
    BOOL hasRealnameValidation = [UGManager shareInstance].hostInfo.userInfoModel.hasRealnameValidation;
    //高级认证状态
    BOOL hasHighValidation = [UGManager shareInstance].hostInfo.userInfoModel.hasHighValidation;
    
     NSString *highAuthentication = [self upDataMessage:@"highAuthentication" WithMessage:@"10000"];
    //小于等于2000 必须实名认证
    if (money <= [highAuthentication doubleValue] && !hasRealnameValidation) {
        
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"认证提醒" message:@"为了您的资产安全，交易前请您先进行实名认证！" cancle:@"取消" others:@[@"去认证"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            if (buttonIndex == 1) {
                [self.navigationController pushViewController:[UGGeneralCertificationVC new] animated:YES];
            }
        }];
        return YES;
    }
    
    //大于2000 必须高级认证
    if (money > [highAuthentication doubleValue] && !hasHighValidation) {
        
        //没实名先实名认证
        if (!hasRealnameValidation) {
            [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"认证提醒" message:@"为了您的资产安全，交易前请您先进行实名认证！" cancle:@"取消" others:@[@"去认证"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                if (buttonIndex == 1) {
                    [self.navigationController pushViewController:[UGGeneralCertificationVC new] animated:YES];
                }
            }];
            return YES;
        }

        UGApplication *appplicationModel = [UGManager shareInstance].hostInfo.userInfoModel.application;
        
        NSString *message = [appplicationModel.auditStatus isEqualToString:@"1"]  ? @"已提交的高级认证失败，请重新认证！" : [appplicationModel.auditStatus isEqualToString:@"2"] ||  appplicationModel.auditStatus == nil ?  [NSString stringWithFormat:@"为了您的资产安全，交易超过%@UG,请您先进行高级认证！",highAuthentication]  : @"高级认证审核中，请耐心等待！";
        
        if ([message containsString:@"审核中"]) {
            
            [self.view ug_showToastWithToast:message];
            
            return YES;
        }
        
        //高级认证
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"认证提醒" message:message cancle:@"取消" others:@[@"去认证"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            if (buttonIndex == 1) {
                [self.navigationController pushViewController:[UGAdancedCertificationVC new] animated:YES];
            }
        }];
        return YES;
    }
    return NO;
}

/**
 * 人脸识别调起   View
 */
-(void)verifyTouchOrFaceID:(void (^)(UGTouchIDState, NSError * _Nonnull))handle{
    UGTouchIDTool *touchID = [[UGTouchIDTool alloc] init];
    [touchID ug_showTouchIDWithDescribe:nil BlockState:^(UGTouchIDState state, NSError *error) {
        if (state == UGTouchIDStateNotSupport) {    //不支持TouchID
            if(UG_Is_iPhoneXSeries){
                 [self.view ug_showToastWithToast:@"设备未启用Face ID"];
            }else{
                [self.view ug_showToastWithToast:@"设备未启用Touch ID"];
            }
        }else if(state == UGTouchIDStatePasswordNotSet){
            [self.view ug_showToastWithToast:@"无法启动,因为用户没有设置设备密码"];
        }else if(state == UGTouchIDStateTouchIDNotSet){
            if(UG_Is_iPhoneXSeries){
                [self.view ug_showToastWithToast:@"无法启动,因为用户没有设置Face ID"];
            }else{
                [self.view ug_showToastWithToast:@"无法启动,因为用户没有设置Touch ID"];
            }
        }else if(state == UGTouchIDStateTouchIDLockout){
            if(UG_Is_iPhoneXSeries){
                [self.view ug_showToastWithToast:@"Face ID被锁定,请前往系统设置启用"];
            }else{
                [self.view ug_showToastWithToast:@"Touch ID被锁定,请前往系统设置启用"];
            }
        }
        handle(state,error);
    }];
}

/**
 * web页跳转
 */
-(void)gotoWebView:(NSString *)title htmlUrl:(NSString *)url{
    PlatformMessageDetailViewController *detailVC = [[PlatformMessageDetailViewController alloc] init];
    detailVC.navtitle = title;
    detailVC.url = url;
    [self.navigationController pushViewController:detailVC animated:YES];
}

#pragma mark - UIViewEmptyView or UIViewErrorView


/**
 数据没回来之前挡住self.view
 */
- (void)showEmptyView {
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    LYEmptyView*emptyView = [LYEmptyView emptyViewWithCustomView:view];
    emptyView.emptyViewIsCompleteCoverSuperView = YES;
    self.view.ly_emptyView = emptyView;
    [self.view ly_showEmptyView];
}


- (void)showErrorEmptyView:(NSString *)desc clickRelodRequestHandle:(void(^)(void))reloadHandle {
    [self.view ly_hideEmptyView];
    LYEmptyView*emptyView = [LYEmptyView emptyActionViewWithImageStr:@"emptyData" titleStr:@"获取数据时发生错误" detailStr:desc btnTitleStr:@"点击重新获取数据" btnClickBlock:^{
        if (reloadHandle) {
            reloadHandle();
        }
    }];
    emptyView.emptyViewIsCompleteCoverSuperView = YES;
    self.view.ly_emptyView = emptyView;
    [self.view ly_showEmptyView];
}

/**
 * 人脸识别提示
 */
-(void)showFaceAlterView:(NSString *)message{
    NSString *messageStr = nil;
    if ([message isEqualToString:@"PASS_LIVING_NOT_THE_SAME"]) {
        messageStr = @"请您确认您与高级认证中用户为同一人";
    }else if ([message isEqualToString:@"NO_FACE_FOUND"]) {
        messageStr = @"您的高级认证疑不符合规范，请联系客服";
    }else if ([message isEqualToString:@"PHOTO_FORMAT_ERROR"]) {
        messageStr = @"您的高级认证疑不符合规范，请联系客服";
    }else if ([message isEqualToString:@"DATA_SOURCE_ERROR"]) {
        messageStr = @"您的高级认证疑不符合规范，请联系客服";
    }else if ([message isEqualToString:@"FAIL_LIVING_FACE_ATTACK"]) {
        messageStr = @"请确认是用户本人操作";
    }else if ([message isEqualToString:@"REPLACED_FACE_ATTACK"]) {
        messageStr = @"请确认是用户本人操作";
    }else if ([message isEqualToString:@"MOBILE_PHONE_NOT_SUPPORT"]) {
        messageStr = @"设备不支持该操作";
    }else if ([message isEqualToString:@"USER_CANCELLATION"]) {
        messageStr = @"用户已取消";
    }else if ([message isEqualToString:@"USER_TIMEOUT"]) {
        messageStr = @"验证超时";
    }else if ([message isEqualToString:@"VERIFICATION_FAILURE"]) {
        messageStr = @"验证失败";
    }else if ([message isEqualToString:@"UNDETECTED_FACE"]) {
        messageStr = @"未检测到人脸";
    }else if ([message isEqualToString:@"ACTION_ERROR"]) {
        messageStr = @"动作错误";
    }else if ([message isEqualToString:@"MORE_RETRY_TIMES"]) {
        messageStr = @"超过重试次数";
    }else if ([message isEqualToString:@"DEVICE_NOT_SUPPORT"]) {
        messageStr = @"无法启动相机，请确认摄像头功能完好";
    }else if ([message isEqualToString:@"INVALID_BUNDLE_ID"]) {
        messageStr = @"信息验证失败，请重启程序或设备后重试";
    }else if ([message isEqualToString:@"NETWORK_ERROR"]) {
        messageStr = @"请连接上互联网后重试";
    }else if ([message isEqualToString:@"FACE_INIT_FAIL"]) {
        messageStr = @"无法启动人脸识别，请稍后重试";
    }else if ([message isEqualToString:@"LIVENESS_DETECT_FAILED"]) {
        messageStr = @"识别失败";
    }else if ([message isEqualToString:@"INIT_FAILED"]) {
        messageStr = @"初始化失败";
    }else if ([message isEqualToString:@"LIVING_NOT_START"]) {
        messageStr = @"活体验证没有开始";
    }else if ([message isEqualToString:@"LIVING_IN_PROGRESS"]) {
        messageStr = @"正在进行验证";
    }else if ([message isEqualToString:@"LIVING_OVERTIME"]) {
        messageStr = @"操作超时，由于用户在长时间没有进行操作";
    }else if ([message isEqualToString:@"UNKOWN_ERROR"]) {
        messageStr = @"未知错误";
    }
    if (!UG_CheckStrIsEmpty(messageStr)) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"人脸识别失败" message:messageStr delegate:nil cancelButtonTitle:@"我知道了" otherButtonTitles:nil];
        [alert show];
    }
}

/**
 * 去到放币或者 付款页面
 */
-(void)gotoDetail:(UGOrderWaitingModel *)model{
    OTCJpushViewController *vc = [OTCJpushViewController new];
    vc.orderSn = model.orderSn;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 * 判断有几个必须强制的待办事项
 */
-(int)forceNum:(NSArray *)orderWaitingArr{
    int num = 0;
    for (UGOrderWaitingModel *model in orderWaitingArr) {
        if ([model.force isEqualToString:@"1"]) {
            num ++ ;
        }
    }
    return num;
}

/**
 * 查看是否被禁用
 */
-(BOOL)hasForbidden{
    BOOL hasfor = [[UGManager shareInstance].hostInfo.userInfoModel.member.forbiddenOpt isEqualToString:@"1"];
    if (hasfor) {
          [[UIApplication sharedApplication].keyWindow ug_showToastWithToast:@"您的账号已被禁止操作，请联系客服处理。"];
        return YES;
    }else{
        return NO;
    }
}

/**
 * 提示语更新
 */
-(NSString *)upDataMessage:(NSString *)dickey  WithMessage:(NSString *)msg{
    NSString *msgStr = msg;
    if ( ![UGManager shareInstance].hostInfo ||  ![UGManager shareInstance].hostInfo.userInfoModel || UG_CheckArrayIsEmpty([UGManager shareInstance].hostInfo.userInfoModel.ugDictionaryList) || [UGManager shareInstance].hostInfo.userInfoModel.ugDictionaryList.count<0 ) {
        return msgStr;
    }
    for (UGMessageDictionary *item in [UGManager shareInstance].hostInfo.userInfoModel.ugDictionaryList){
        if ([item.dicKey isEqualToString:dickey]) {
            msgStr = item.dicValue;
            break;
        }
    }
    return  msgStr;
}

/**
 * 是否是承兑商
 */
-(BOOL)isCardVip{
    return [[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString:@"1"];
}

/**
 * 播放视频
 */
-(void)playVideo{
    NSString *videourl = [NSUserDefaultUtil GetDefaults:@"videoUrl"];
    if( ! UG_CheckStrIsEmpty(videourl)){
        UGVideoPlayerVCViewController *playerVC = [[UGVideoPlayerVCViewController alloc]init];
        playerVC.ugVideoUrl = videourl;
        [self.navigationController pushViewController:playerVC animated:YES];
    }else{
        [MBProgressHUD ug_showHUDToKeyWindow];
        UGGetPlayUrlApi *api = [UGGetPlayUrlApi new];
        @weakify(self);
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            [MBProgressHUD ug_hideHUDFromKeyWindow];
            @strongify(self);
            if (object) {
                if ([object isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *dict = (NSDictionary *)object;
                    if ([[dict allKeys] containsObject:@"dicValue"]) {
                        NSString *videoStr = [dict objectForKey:@"dicValue"];
                        if (UG_CheckStrIsEmpty(videoStr)) {
                            videoStr = [UGURLConfig videoHttpApi];
                        }else{
                            [NSUserDefaultUtil PutDefaults:@"videoUrl" Value:videoStr];
                        }
                        UGVideoPlayerVCViewController *playerVC = [[UGVideoPlayerVCViewController alloc]init];
                        playerVC.ugVideoUrl = videoStr;
                        [self.navigationController pushViewController:playerVC animated:YES];
                    }
                }
            }else{
                [self.view ug_showToastWithToast:apiError.desc];
            }
        }];
    }
}

/**
 * 根据地址播放视频
 */
-(void)playVideoWithUrl:(NSString *)videoUrl
{
    if( ! UG_CheckStrIsEmpty(videoUrl)){
        
        UGVideoPlayerVCViewController *playerVC = [[UGVideoPlayerVCViewController alloc]init];
        playerVC.ugVideoUrl = videoUrl;
        [self.navigationController pushViewController:playerVC animated:YES];
    }
    else
    {
        NSLog(@"地址为空！");
        
    }
    
}

/**
 * 检测是否需要去绑定银行
 */
- (BOOL)checkHadGotoBankBinding{
    BOOL hasBankBinding = [UGManager shareInstance].hostInfo.userInfoModel.hasBankBinding;
    if ( ! hasBankBinding) {
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"" message:@"为保证您的交易顺利进行，请您先绑定银行卡！" cancle:@"取消" others:@[@"去绑定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            if (buttonIndex == 1) {
               [self.navigationController pushViewController:[UGBankPaySettingViewController new] animated:YES];
            }
        }];
        return YES;
    }
    return NO;
}

/**
 * 查看实名认证
 */
-(BOOL)gotoRealNameAuthentication{
    if (![UGManager shareInstance].hostInfo.userInfoModel.hasRealnameValidation) {
        @weakify(self);
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"认证提醒" message:@"为了您的资产安全，请您先进行实名认证！" cancle:@"取消" others:@[@"去认证"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            if (buttonIndex == 1) {
                @strongify(self);
                //实名认证
                [self.navigationController pushViewController:[UGGeneralCertificationVC new] animated:YES];
            }
        }];
        return YES;
    }else{
        return NO;
    }
}

//获取钱包信息接口
- (void)getWalletData:(UGRequestCompletionBlock)completionBlock {
    UGWalletAllApi *api = [[UGWalletAllApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (completionBlock) {
            completionBlock(apiError,object);
        }
    }];
}

//检测当前银行卡是否到达限额弹框
-(void)showBindingLimit:(NSString *)title{
    @weakify(self);
    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:title message:[NSString stringWithFormat:@"您绑定的银行卡已达当日收款限额，请您先前往换绑或明日进行出售!"] cancle:@"取消" others:@[@"去绑定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
        if (buttonIndex == 1) {
            @strongify(self);
            UGBankPaySettingViewController *bankSettingVC = [UGBankPaySettingViewController new];
            bankSettingVC.updateBind = YES;
            [self.navigationController pushViewController:bankSettingVC animated:YES];
        }
    }];
}

@end
