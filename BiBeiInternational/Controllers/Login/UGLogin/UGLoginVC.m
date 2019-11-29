//
//  UGLoginVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGLoginVC.h"
#import "UGRegisterVC.h"
#import "CustomButton.h"
#import "TXLimitedTextField.h"
#import "UGTabBarController.h"
#import "UGNavController.h"
#import "UGSettingPayPassWordVC.h"
#import "UGReSettingPasswordVC.h"
#import "UGTouchLoginVC.h"
#import "UGGetAreaCodeApi.h"
#import "UGAreaModel.h"
#import "UGCountryPopView.h"
#import "UGFindPassWordVC.h"
#import "UGGetPlayUrlApi.h"
#import "AppDelegate.h"
#import "UGMakeTrueMnemonnicVC.h"
#import "UGReSettingPasswordVC.h"
//网易七鱼
#import "QYPOPSDK.h"
#import "UGNavController.h"
#import "UGQYSDKManager.h"
#import "UGSelectStateViewController.h"

@interface UGLoginVC ()<CaptchaButtonDelegate,UIScrollViewDelegate>
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;//40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top2;  //20
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topBtn;//40
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iphoneViewH;//180
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lopginBtop; //25
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *regester;//15
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forget;//10
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnLeading;//60
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnTraing;//60

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topH;//120
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topW;//120
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginHeight;//注册 40
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passBtn; //40
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imagW;

//@property (weak, nonatomic) IBOutlet UIImageView *backImage;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet UIButton *forgeteBtn;
@property (weak, nonatomic) IBOutlet UIButton *faceBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *containerView;
@property (nonatomic,strong)UGTouchLoginVC *tochLoginVC;
@property (weak, nonatomic) IBOutlet CustomButton *loginBtn;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *userNameTF;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *passwordTF;
@property(nonatomic,assign)int enterType;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property(nonatomic,assign)NSInteger popSelectedIndex;
@property(nonatomic,copy)NSString *popSelectedTitle;
@property(nonatomic,strong)NSArray *areaArray;//区号数组
@property(nonatomic,strong)NSMutableArray *areaTitles;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *countryTestFiled;//国家显示框
@property (weak, nonatomic) IBOutlet UIButton *selectedCounteyBtn;//国家选择按钮
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;//手机区号显示
@property(nonatomic,strong)UGCountryPopView *countryPopView;
@property (weak, nonatomic) IBOutlet UILabel *countryLine;
@property(nonatomic,assign)BOOL hasShow;
//关于播放视频的
@property (weak, nonatomic) IBOutlet UILabel *titlelabel;
@property (weak, nonatomic) IBOutlet UIImageView *playImage;

@property (weak, nonatomic) IBOutlet UIButton *usernameBtn;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabelLne;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabelLne;
@property (weak, nonatomic) IBOutlet UIView *phoneCenterView;

//用户名登录
@property (weak, nonatomic) IBOutlet UIView *userNameView;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *useTF;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *pasTF;
@property (weak, nonatomic) IBOutlet UIButton *eyeImg;

@property (nonatomic,assign)NSInteger btnTag;

@end

@implementation UGLoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationBarHidden = YES;
    
    self.title= @"登录";
    
    [self asyncRequest];
    
    [self setNotify];
    
    [self initUI];
}

#pragma mark-切换登录方式   1010 用户名   1011  手机
- (IBAction)changeStyeBtnClick:(id)sender {
     [self hideCountryView];
    UIButton *btn = (UIButton *)sender;
    NSInteger tags = btn.tag - 1010;
    if (self.btnTag == tags) {
        return;
    }
    self.btnTag = tags;
    if (tags == 0) {
        self.usernameBtn.selected = YES;
        self.userNameLabelLne.backgroundColor = UG_MainColor;
        self.phoneCenterView.hidden = YES;
        self.userNameView.hidden = NO;
        self.phoneBtn.selected = NO;
        self.phoneLabelLne.backgroundColor =  [UIColor colorWithHexString:@"D8D8D8"];
    }else if(tags == 1){
        self.phoneBtn.selected = YES;
        self.phoneLabelLne.backgroundColor = UG_MainColor;
        self.phoneCenterView.hidden = NO;
        self.userNameView.hidden = YES;
        self.usernameBtn.selected = NO;
        self.userNameLabelLne.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    }
    
}

- (IBAction)userEyeClick:(id)sender {
    self.eyeImg.selected = !self.eyeImg.selected;
    if (self.eyeImg.selected) {
        self.pasTF.secureTextEntry = NO;
    }else{
        self.pasTF.secureTextEntry = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hideCountryView];
}

#pragma mark - 隐藏弹出的泡泡
-(void)hideCountryView{
    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
    CGRect startRact = [self.countryLine convertRect:self.countryLine.bounds toView:window];
    CGRect frame = CGRectMake(startRact.origin.x+14, startRact.origin.y, startRact.size.width-28, startRact.size.height);
    [self.countryPopView hideDropDownMenuWithBtnFrame:frame];
    self.hasShow = NO;
}

#pragma mark- 数据请求
-(void)asyncRequest{
//    //开启并发队列
//    dispatch_queue_t queue = dispatch_queue_create("com.conewapi", DISPATCH_QUEUE_CONCURRENT);
//    //执行异步操作
//    dispatch_async(queue, ^{
//        //任务1
//        [self getAreaRequest];
//    });
    [self getAreaRequest];
}
- (IBAction)click_loginWay:(UIButton *)sender {@weakify(self)
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"手机号登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {@strongify(self)
        [self changeStyeBtnClick:self.phoneBtn];
    }];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"用户名登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {@strongify(self)
        [self changeStyeBtnClick:self.usernameBtn];
    }];
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:[[UGManager shareInstance] checkIsSupportFaceIDOrTouchID] == UGSupportFaceID ? @"面容登录" : @"指纹登录" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {@strongify(self)
        [self changeShowContainerView:YES];
    }];
    
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    if (self.phoneCenterView.hidden) {
        [alert addAction:action1];
    }if (self.userNameView.hidden) {
        [alert addAction:action2];
    }if ([[UGManager shareInstance] getTouchIDOrFaceIDVerifyValue]) {
        [alert addAction:action3];
    }
    
    [alert addAction:cancle];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark-自动填充用户名通知
- (void)usernameAction:(NSNotification*)sender{
    NSDictionary *useInfo = [sender userInfo];
    NSString *username = [useInfo objectForKey:@"userName"];
    NSString *type = [useInfo objectForKey:@"type"];
    if (!UG_CheckStrIsEmpty(username)) {
        if ([type isEqualToString:@"0"]) {
            self.userNameTF.text = username;
            self.passwordTF.text = @"";
        }
        
        if ([type isEqualToString:@"1"]) {
            self.useTF.text = username;
            self.pasTF.text = @"";
        }
    }
}
#pragma mark - 发送登录成功的通知
-(void)postNotify{
    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        //发送登录成功消息
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCES" object:nil];
    }];
}

#pragma mark -播放视频
-(void)playbtnClick{
    [self playVideo];
}

#pragma mark -通知
-(void)setNotify{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(usernameAction:) name:@"REGISTERKEYSUCCSE" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postNotify) name:@"设置支付密码成功" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cangeView:) name:@"注册返回成功" object:nil];
}

#pragma mark - 返回登录页  登录方式切换
-(void)cangeView:(NSNotification*)sender{
    NSDictionary *useInfo = [sender userInfo];
    NSString *type = [useInfo objectForKey:@"type"];
    if ([type isEqualToString:@"0"]) {
        self.btnTag = 1;
        self.phoneBtn.selected = YES;
        self.phoneLabelLne.backgroundColor = UG_MainColor;
        self.phoneCenterView.hidden = NO;
        self.userNameView.hidden = YES;
        self.usernameBtn.selected = NO;
        self.userNameLabelLne.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
    }else{
        self.btnTag = 0;
        self.usernameBtn.selected = YES;
        self.userNameLabelLne.backgroundColor = UG_MainColor;
        self.phoneCenterView.hidden = YES;
        self.userNameView.hidden = NO;
        self.phoneBtn.selected = NO;
        self.phoneLabelLne.backgroundColor =  [UIColor colorWithHexString:@"D8D8D8"];
        self.useTF.text = ! [UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone ? [UGManager shareInstance].hostInfo.userInfoModel.member.registername : @"";
    }
}

-(void)initUI{
    [self languageChange];
    self.containerView.delegate = self;
    self.containerView.bounces = NO;
    if ( ! [UG_MethodsTool is4InchesScreen]) {
        self.containerView.scrollEnabled = NO;
    }else{
        self.containerView.scrollEnabled = YES;
    }
//    self.top.constant = UG_AutoSize(40);
    self.top2.constant = UG_AutoSize(20);
    self.topBtn.constant = UG_AutoSize(40);
//    self.iphoneViewH.constant= UG_AutoSize(180);
//    self.lopginBtop.constant = UG_AutoSize(35);
//    self.regester.constant = UG_AutoSize(10);
//    self.topH.constant = UG_AutoSize(120);
//    self.topW.constant = UG_AutoSize(120);
//    self.forget.constant = UG_AutoSize(5);
//    self.btnLeading.constant = UG_AutoSize(60);
//    self.btnTraing.constant = UG_AutoSize(60);
//    self.loginHeight.constant = UG_AutoSize(40);
//    self.passBtn.constant = UG_AutoSize(40);
//    CGFloat imgh =  UG_SCREEN_HEIGHT-UG_AutoSize(40+120+20+40+180+35+46)-(55+50+28);
    CGFloat hei = 342.0*UG_SCREEN_WIDTH/750.0;
    self.imagH.constant = hei;
    self.imagW.constant = UG_SCREEN_WIDTH;
//    self.faceBtn.hidden = ![[UGManager shareInstance] getTouchIDOrFaceIDVerifyValue];
//    [self.faceBtn setTitle:[[UGManager shareInstance] checkIsSupportFaceIDOrTouchID] == UGSupportFaceID ? @"面容登录" : @"指纹登录" forState:UIControlStateNormal];
    //初始化登录按钮
    [self.loginBtn setOriginaStyle];
    self.loginBtn.delegate = self;
    //播放按钮
    [self showgifImage];
    [self.containerView bringSubviewToFront:self.loginBtn];
    [self.containerView bringSubviewToFront:self.registerBtn];
    [self.containerView bringSubviewToFront:self.forgeteBtn];
//    [self.containerView bringSubviewToFront:self.faceBtn];
    [self.containerView bringSubviewToFront:self.playImage];
    [self.containerView bringSubviewToFront:self.titlelabel];
    [self.countryTestFiled setEnabled:NO];
    //初始化
    [self  initLoginStyle];
   
    //键盘回收
    __weak typeof(self)weakself = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [weakself.userNameTF resignFirstResponder];
        [weakself.passwordTF resignFirstResponder];
        [weakself.useTF resignFirstResponder];
        [weakself.pasTF resignFirstResponder];
    }];
    [self.view addGestureRecognizer:tap];
    
    //改变当前页面显示：登录页、指纹登录页
    [self changeShowContainerView: [[UGManager shareInstance] getTouchIDOrFaceIDVerifyValue]];
}

 //初始化国家区域值
-(void)initLoginStyle{
    [keychianTool getUserNameAndPasswordFromKeychain:^(NSString *userName, NSString *password, NSString *country, NSString *areacode) {
        if ( ! UG_CheckStrIsEmpty(areacode) && ! UG_CheckStrIsEmpty(country)) {
            self.userNameTF.text = !UG_CheckStrIsEmpty([UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone)?[UGManager shareInstance].hostInfo.userInfoModel.member.mobilePhone : ! UG_CheckStrIsEmpty(userName) ? userName : @"";
            self.countryLabel.text = ! UG_CheckStrIsEmpty([UGManager shareInstance].hostInfo.userInfoModel.member.areaCode) ? [NSString stringWithFormat:@"+%@",[UGManager shareInstance].hostInfo.userInfoModel.member.areaCode]  : ! UG_CheckStrIsEmpty(areacode) ? [NSString stringWithFormat:@"+%@",areacode] : @"";
            self.countryTestFiled.text = !UG_CheckStrIsEmpty([UGManager shareInstance].hostInfo.userInfoModel.member.country)?[UGManager shareInstance].hostInfo.userInfoModel.member.country : ! UG_CheckStrIsEmpty(country) ? country : @"";
            self.popSelectedTitle = self.countryTestFiled.text;
            self.popSelectedIndex = 0;
            self.btnTag = 1;
            self.phoneBtn.selected = YES;
            self.phoneLabelLne.backgroundColor = UG_MainColor;
            self.phoneCenterView.hidden = NO;
            self.userNameView.hidden = YES;
            self.usernameBtn.selected = NO;
            self.userNameLabelLne.backgroundColor = [UIColor colorWithHexString:@"D8D8D8"];
        }else{
            self.btnTag = 0;
            self.usernameBtn.selected = YES;
            self.userNameLabelLne.backgroundColor = UG_MainColor;
            self.phoneCenterView.hidden = YES;
            self.userNameView.hidden = NO;
            self.phoneBtn.selected = NO;
            self.phoneLabelLne.backgroundColor =  [UIColor colorWithHexString:@"D8D8D8"];
            self.useTF.text = ! UG_CheckStrIsEmpty([UGManager shareInstance].hostInfo.userInfoModel.member.registername) ? [UGManager shareInstance].hostInfo.userInfoModel.member.registername :  ! UG_CheckStrIsEmpty(userName) ? userName : @"";
        }
    }];
}

#pragma mark -获取国家列表数据
-(void)getAreaRequest{
    
    [self loadAreaDataFromCache];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        UGGetAreaCodeApi *api = [[UGGetAreaCodeApi alloc] init];
        @weakify(self);
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            @strongify(self);
            if (object) {
                [UG_MethodsTool toCreateUGAreacodePlistWith:object];
                self.areaArray = [UGAreaModel mj_objectArrayWithKeyValuesArray:object];
                [self reSetAreaArrayData];
            }else{
                [self loadAreaDataFromCache];
            }
        }];
    });
}

#pragma mark - 从缓存读取国家国家列表数据
-(void)loadAreaDataFromCache
{
    if ([UG_MethodsTool GetAreacodeArrayFromPlist].count)
    {
        NSArray *array = [UG_MethodsTool GetAreacodeArrayFromPlist];
        self.areaArray = [UGAreaModel mj_objectArrayWithKeyValuesArray:array];
        [self reSetAreaArrayData];
    }
}

#pragma mark - 设置areaArrays的数据
-(void)reSetAreaArrayData
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.areaArray.count > 0) {
            UGAreaModel *model = self.areaArray[0];
            [keychianTool getUserNameAndPasswordFromKeychain:^(NSString *userName, NSString *password, NSString *country, NSString *areacode) {
                NSString *countryStr = [UGManager shareInstance].hostInfo.userInfoModel.member.country;
                self.popSelectedTitle = ! UG_CheckStrIsEmpty(countryStr) ? countryStr :  ! UG_CheckStrIsEmpty(country)  ? country : model.zhName;
                self.countryTestFiled.text = self.popSelectedTitle;
                self.countryLabel.text = [NSString stringWithFormat:@"+%@",[self returenAreaCode:self.popSelectedTitle]];
            }];
        }
        self.areaTitles = [[NSMutableArray alloc] init];
        for (UGAreaModel *item in self.areaArray) {
            [self.areaTitles addObject:item.zhName];
        }
    });
}

-(NSString *)returenAreaCode:(NSString *)country{
    for (UGAreaModel *item in self.areaArray) {
        if ([item.zhName isEqualToString:country]) {
            return item.areaCode;
        }
    }
    return @"";
}

- (UGTouchLoginVC *)tochLoginVC {
    if (!_tochLoginVC) {
        _tochLoginVC = [UGTouchLoginVC new];
        _tochLoginVC.view.frame = self.view.bounds;
        [self.view addSubview:_tochLoginVC.view];
        [self addChildViewController:_tochLoginVC];
        @weakify(self);
        _tochLoginVC.accountLoginBlock = ^{
            @strongify(self);
            [self changeShowContainerView:NO];
        };
        _tochLoginVC.faceLoginBlock = ^{
            @strongify(self);
            [self hasSettingPassWord];
        };
    }
    return _tochLoginVC;
}

#pragma mark - 是否设置支付密码
-(void)hasSettingPassWord{
    //这里表示面容ID 成功后做接下来的操作 判断有没有设置支付密码
    [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
        if (![UGManager shareInstance].hostInfo.userInfoModel.hasJypassword && [[UGManager shareInstance] hasLogged]) {
            UGSettingPayPassWordVC *vc = [UGSettingPayPassWordVC new];
            vc.isUserName = self.btnTag  == 0 ? YES : NO;
            [self.navigationController presentViewController:[[UGNavController new]initWithRootViewController:vc] animated:NO completion:nil];
        } else if (![UGManager shareInstance].hostInfo.userInfoModel.bindMobilePhone && [[UGManager shareInstance] hasLogged] && ! [UGManager shareInstance].hostInfo.userInfoModel.bindAuxiliaries ) {
            //登录成功 进绑定助记词
            UGMakeTrueMnemonnicVC *vc =[UGMakeTrueMnemonnicVC new];
            vc.isfromRegister = YES;
            vc.isUserName = self.btnTag  == 0 ? YES : NO;
            vc.backlClick = ^{
                [self.navigationController dismissViewControllerAnimated:NO completion:nil];
            };
            [self.navigationController presentViewController:[[UGNavController new]initWithRootViewController:vc] animated:NO completion:nil];
        }
        else{
            [self postNotify];
        }
    }];
}

#pragma mark - 改变当前显示页面  指纹登录 还是 普通登录
- (void)changeShowContainerView:(BOOL)showFaceView {
    // 登录页(No)  指纹登录页(YES)
    UIView *fromView = showFaceView ? self.containerView : self.tochLoginVC.view;
    UIView *toView = showFaceView ? self.tochLoginVC.view : self.containerView;
    [UIView transitionFromView:fromView toView:toView duration:0.2f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionShowHideTransitionViews completion:nil];
}

#pragma mark- 切换明文--密码
- (IBAction)eyeClick:(id)sender {
    self.eyeBtn.selected = !self.eyeBtn.selected;
    if (self.eyeBtn.selected) {
        self.passwordTF.secureTextEntry = NO;
    }else{
        self.passwordTF.secureTextEntry = YES;
    }
}

#pragma mark -返回指纹登录
- (IBAction)backFaceLogin:(id)sender {
    [self changeShowContainerView:YES];
}

#pragma mark- 注册
- (IBAction)register:(id)sender {
    [self.navigationController pushViewController:[UGRegisterVC new] animated:YES];
}

#pragma mark- 忘记密码
- (IBAction)forgetPassWord:(id)sender {

    UGReSettingPasswordVC *vc = [UGReSettingPasswordVC new];
    vc.topVC = self;
    vc.isLogin = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - CaptchaButtonDelegate
-(void)captchaButtonWillShouldBeginTapAction:(CustomButton *)button{
    if (self.btnTag == 0) {
        if (![NSString stringIsNull:self.useTF.text]) {
            self.loginBtn.phone = self.useTF.text;
        }
    }else{
        if (![NSString stringIsNull:self.userNameTF.text]) {
            self.loginBtn.phone = self.userNameTF.text;
        }
    }
}

- (BOOL)captchaButtonShouldBeginTapAction:(CustomButton *)button {
    if (self.btnTag == 0) {
        if ([NSString stringIsNull:self.useTF.text]) {
            [self.view ug_showToastWithToast:@"请输入正确的用户名"];
            return NO;
        }
        if ([NSString stringIsNull:self.pasTF.text]) {
            [self.view ug_showToastWithToast:@"请输入登录密码"];
            return NO;
        }
    }else{
        if ([NSString stringIsNull:self.countryTestFiled.text]) {
            [self.view ug_showToastWithToast:@"请选择国家"];
            return NO;
        }
        if ([NSString stringIsNull:self.userNameTF.text]) {
            [self.view ug_showToastWithToast:@"请输入正确的手机号"];
            return NO;
        }
        if ([NSString stringIsNull:self.passwordTF.text]) {
            [self.view ug_showToastWithToast:@"请输入登录密码"];
            return NO;
        }
    }
    return YES;
}

#pragma mark-二次验证返回数据
- (void)delegateGtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    @weakify(self);
    [[UGManager shareInstance] loginWithUserName: self.btnTag == 0 ? self.useTF.text : self.userNameTF.text password:self.btnTag == 0 ? self.pasTF.text : self.passwordTF.text country:self.btnTag == 0 ? @"" : self.countryTestFiled.text areaCode:self.btnTag == 0 ? @"" : [self returenAreaCode:self.popSelectedTitle] completionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (!apiError) {
            [self.view endEditing:YES];
            [self hasSettingPassWord];
        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}



#pragma mark - 跳到指纹验证
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

#pragma mark -选择国家
- (IBAction)selectedCountry:(id)sender {
    [self.userNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    if (self.areaArray.count>0) {
        if (! UG_CheckStrIsEmpty(self.popSelectedTitle)) {
            for (int i = 0 ; i<self.areaTitles.count ;  i++) {
                if ([self.areaTitles[i] isEqualToString:self.popSelectedTitle]) {
                    self.popSelectedIndex = i;
                }
            }
        }
//        UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//        CGRect startRact = [self.countryLine convertRect:self.countryLine.bounds toView:window];
//        CGRect frame = CGRectMake(startRact.origin.x+14, startRact.origin.y, startRact.size.width-28, startRact.size.height);
//        if (!self.hasShow) {
//            @weakify(self);
//            if (!self.countryPopView) {
//                self.countryPopView = [[UGCountryPopView alloc] initWithFrame:frame WithArr:self.areaTitles WithIndex:self.popSelectedIndex WithHandle:^(NSString * _Nonnull title, NSInteger index){
//                    @strongify(self);
//                    self.popSelectedIndex = index;
//                    self.popSelectedTitle = title;
//                    self.countryLabel.text = [NSString stringWithFormat:@"+%@",[self returenAreaCode:self.popSelectedTitle]];
//                    self.countryTestFiled.text = title;
//                    self.userNameTF.text = @"";
//                    self.hasShow = NO;
//                }];
//                [[UIApplication sharedApplication].keyWindow addSubview:self.countryPopView];
//            }else{
//                [self.countryPopView showDropDownMenuWithBtnFrame:frame];
//            }
//            self.countryPopView.index = self.popSelectedIndex;
//            self.hasShow = YES;
//        }else{
//            [self.countryPopView hideDropDownMenuWithBtnFrame:frame];
//            self.hasShow = NO;
//        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSelectStateViewController" bundle:nil];
        UGSelectStateViewController *vc = [storyboard instantiateInitialViewController];
        vc.areaTitles = self.areaArray;@weakify(self)
        [RACObserve(vc, model) subscribeNext:^(UGAreaModel *model) {@strongify(self)
            if (model) {
                self.popSelectedTitle = model.zhName;
                [self.selectedCounteyBtn setTitle:[NSString stringWithFormat:@"+%@",model.areaCode                                                               ] forState:UIControlStateNormal];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self getAreaRequest];
    }
}

-(void)showgifImage{
    @weakify(self);
    UITapGestureRecognizer *tapplay = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        [self playbtnClick];
    }];
    [self.playImage addGestureRecognizer:tapplay];
    //1.加载Gif图片，转换成Data类型
//    NSString *path = [NSBundle.mainBundle pathForResource:@"play" ofType:@"gif"];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//    //2.将data数据转换成CGImageSource对象
//    CGImageSourceRef imageSource = CGImageSourceCreateWithData(CFBridgingRetain(data), nil);
//    size_t imageCount = CGImageSourceGetCount(imageSource);
//    //3.遍历所有图片
//    NSMutableArray *images = [NSMutableArray array];
//    NSTimeInterval totalDuration = 0;
//    for (int i = 0; i<imageCount; i++) {
//        //取出每一张图片
//        CGImageRef cgImage = CGImageSourceCreateImageAtIndex(imageSource, i, nil);
//        UIImage *image = [UIImage imageWithCGImage:cgImage];
//        [images addObject:image];
//        //持续时间
//        NSDictionary *properties = (__bridge_transfer  NSDictionary*)CGImageSourceCopyPropertiesAtIndex(imageSource, i, nil);
//        NSDictionary *gifDict = [properties objectForKey:(__bridge NSString *)kCGImagePropertyGIFDictionary];
//        NSNumber *frameDuration =
//        [gifDict objectForKey:(__bridge NSString *)kCGImagePropertyGIFDelayTime];
//        totalDuration += frameDuration.doubleValue;
//    }
//    //4.设置imageView属性
//    self.playImage.animationImages = images;
//    self.playImage.animationDuration = totalDuration;
//    self.playImage.animationRepeatCount = 0;
//    //5.开始播放
//    [self.playImage startAnimating];
}

#pragma UIScrollView  delegate
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    if ([UG_MethodsTool is4InchesScreen] && self.countryPopView && self.hasShow) {
        [self hideCountryView];
    }
}
- (IBAction)kefuChat:(id)sender {
    [self hideCountryView];
    [self.userNameTF resignFirstResponder];
    [self.passwordTF resignFirstResponder];
    [self.useTF resignFirstResponder];
    [self.pasTF resignFirstResponder];
    [self onChat];
}

- (void)onChat{
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"UG钱包";
    
   [[UGQYSDKManager shareInstance] updateDateQYUserInfo:@"" isLogin:YES];
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"在线客服";
    sessionViewController.source = source;
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"]  style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
//    sessionViewController.navigationItem.leftBarButtonItem = leftItem;
    UGNavController* navi = [[UGNavController alloc]initWithRootViewController:sessionViewController];
    [sessionViewController setNavigation];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
