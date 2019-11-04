//
//  UGRegisterVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/29.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGRegisterVC.h"
#import "CustomButton.h"
#import "TXLimitedTextField.h"
#import "UGNewRegisterApi.h"
#import "UGSettingPayPassWordVC.h"
#import "UGPopTableView.h"
#import "UGGetAreaCodeApi.h"
#import "UGAreaModel.h"
#import "UGCountryPopView.h"
#import "UGRegisterSendCodeApi.h"
#import "UGGetRegisterTypeApi.h"
#import "UGRegisterApi.h"
//网易七鱼
#import "QYPOPSDK.h"
#import "UGNavController.h"
#import "UGQYSDKManager.h"
#import "UGSelectStateViewController.h"

@interface UGRegisterVC ()<CaptchaButtonDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logH;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *logW;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *userTextFild;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *passWordTextFild;
@property (strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@property (weak, nonatomic) IBOutlet TXLimitedTextField *verifyTextFild;//验证码输入框
@property (weak, nonatomic) IBOutlet CustomButton *verifyBtn;//发送验证码按钮
@property (weak, nonatomic) IBOutlet UILabel *verfyLabe;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *countryTestFiled;//国家显示框
@property (weak, nonatomic) IBOutlet UIButton *selectedCounteyBtn;//国家选择按钮
@property (weak, nonatomic) IBOutlet UILabel *countryLabel;//手机区号显示
@property (nonatomic, assign) BOOL isverify;//是否获取验证码按钮
@property(nonatomic,assign)NSInteger popSelectedIndex;
@property(nonatomic,copy)NSString *popSelectedTitle;
@property(nonatomic,strong)NSArray *areaArray;//区号数组
@property(nonatomic,strong)NSMutableArray *areaTitles;
@property(nonatomic,strong)UGCountryPopView *countryPopView;
@property (weak, nonatomic) IBOutlet UILabel *countryLine;
@property(nonatomic,assign)BOOL hasShow;

//2019.6.24 新增用户名注册方式
@property (weak, nonatomic) IBOutlet UIButton *usernameRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *phoneRegisterButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *usernameLineWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneButtonWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *phoneLineWidth;
//用户名注册View
@property (weak, nonatomic) IBOutlet UIView *usernameRegisterView;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *usernameTextField;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *usernamePasswordTextFiled;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *usernameRePasswordTextField;
//手机注册View
@property (weak, nonatomic) IBOutlet UIView *phoneRegisterView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceLayout;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *registerButtonTop;

//yes 为用户名注册 ，no为手机号注册
@property(nonatomic,assign)BOOL isUsernameRegister;
// key值  1 用户名注册  0 手机号注册 2 两者都有
@property(nonatomic,assign)NSInteger registerType;

@end

@implementation UGRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self languageChange];
    self.top.constant = UG_AutoSize(40);
    self.logH.constant = UG_AutoSize(120);
    self.logW.constant = UG_AutoSize(120);
    [self.view bringSubviewToFront:self.registerBtn];
    [self.countryTestFiled setEnabled:NO];
    _isUsernameRegister = YES;
    _registerType = 1;
    [self changeShowUI];
    //验证码按钮
    [self.verifyBtn setOriginaStyle];
    self.verifyBtn.delegate = self;
    __weak typeof(self)weakself = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [weakself.userTextFild resignFirstResponder];
        [weakself.passWordTextFild resignFirstResponder];
        [weakself.verifyTextFild resignFirstResponder];
    }];
    [self.view addGestureRecognizer:tap];
    @weakify(self);
    UGGetRegisterTypeApi *api = [UGGetRegisterTypeApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
    @strongify(self);
        NSLog(@"object = %@",object);
        if (object) {
            self.registerType = [object[@"dicValue"] integerValue];
            [self changeShowUI];
        }
    }];
    [self getAreaRequest];
    self.popSelectedIndex = 0;
    self.popSelectedTitle = @"";
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    [self hideCountryView];

}

-(void)languageChange{
    self.title = @"注册";
}

-(void)hidenTextField{
    [self.userTextFild resignFirstResponder];
    [self.verifyTextFild resignFirstResponder];
    [self.passWordTextFild resignFirstResponder];
}

#pragma mark -选择国家
- (IBAction)selectedCountry:(id)sender {
//    [self hidenTextField];
    if (self.areaTitles.count>0) {
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
//                    self.hasShow = NO;
//                    [self.selectedCounteyBtn setImage:[UIImage imageNamed:@"ug_selectedcountry"] forState:UIControlStateNormal];
//                }];
//                [[UIApplication sharedApplication].keyWindow addSubview:self.countryPopView];
//            }else{
//                [self.countryPopView showDropDownMenuWithBtnFrame:frame];
//            }
//            self.countryPopView.index = self.popSelectedIndex;
//            [self.selectedCounteyBtn setImage:[UIImage imageNamed:@"selectedcountry"] forState:UIControlStateNormal];
//            self.hasShow = YES;
//        }else{
//            [self.countryPopView hideDropDownMenuWithBtnFrame:frame];
//            [self.selectedCounteyBtn setImage:[UIImage imageNamed:@"ug_selectedcountry"] forState:UIControlStateNormal];
//            self.hasShow = NO;
//        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSelectStateViewController" bundle:nil];
        UGSelectStateViewController *vc = [storyboard instantiateInitialViewController];
        vc.areaTitles = self.areaArray;@weakify(self)
        [RACObserve(vc, model) subscribeNext:^(UGAreaModel *model) {@strongify(self)
            if (model) {
                self.popSelectedTitle = model.zhName;
                self.countryTestFiled.text = self.popSelectedTitle;
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

-(void)getAreaRequest{
    
    [self loadAreaDataFromCache];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        UGGetAreaCodeApi *api = [[UGGetAreaCodeApi alloc] init];
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
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
            self.popSelectedTitle = model.zhName;
            self.countryTestFiled.text = self.popSelectedTitle;
            self.countryLabel.text = [NSString stringWithFormat:@"+%@",[self returenAreaCode:self.popSelectedTitle]];
        }
        self.areaTitles = [[NSMutableArray alloc] init];
        if (self.areaArray.count>0) {
            for (UGAreaModel *item in self.areaArray) {
                [self.areaTitles addObject:item.zhName];
            }
        }
    });

}

-(NSString *)returenAreaCode:(NSString *)country{
    for (UGAreaModel *item in self.areaArray) {
        if ([item.zhName isEqualToString:country]) {
            return item.areaCode;
        }
    }
    return @"86";
}

#pragma mark -重新获取验证码
-(void)reGetVerify{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        if (timeout<=0) {
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
                self.verfyLabe.hidden = YES;
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
//                self.verifyBtn.backgroundColor = UG_MainColor;
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else {
            int seconds = timeout;
            NSString *sStr =[NSString stringWithFormat:seconds<10? @"（0%ds）重新获取" : @"（%ds）重新获取",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.verfyLabe.hidden = NO;
                [self.verifyBtn setTitle:@"" forState:UIControlStateNormal];
                self.verfyLabe.text = sStr;
//                self.verifyBtn.backgroundColor = [UIColor color      WithHexString:@"C5C5C5"];
                self.verifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(self.timer);
}

#pragma mark - 注册
- (IBAction)registerSender:(id)sender {
    
    if (_isUsernameRegister) {
    
        //用户名注册相关
        if (self.usernameTextField.text.length <6 || self.usernameTextField.text.length>12) {
            [self.view ug_showToastWithToast:@"请输6-12位的用户名"];
            return;
        }
        
        if (![self isChineseCharacterAndLettersAndNumbersAndUnderScore:self.usernameTextField.text]) {
            [self.view ug_showToastWithToast:@"用户名由6-12位字母、数字组成"];
            return;
        }
        
        if (self.usernamePasswordTextFiled.text.length <8 || self.usernamePasswordTextFiled.text.length>20) {
            [self.view ug_showToastWithToast:@"请输8-20位的登录密码"];
            return;
        }
        if (![self judgePassWordLegal:self.usernamePasswordTextFiled.text]) {
            [self.view ug_showToastWithToast:@"密码必须包含字母、数字"];
            return;
        }
        if (![self.usernamePasswordTextFiled.text isEqualToString:self.usernameRePasswordTextField.text]) {
            
            [self.view ug_showToastWithToast:@"两次密码不一致，请重新输入"];
            return;
        }

        if (self.usernameRePasswordTextField.text.length <8 || self.usernameRePasswordTextField.text.length>20) {
            [self.view ug_showToastWithToast:@"重新输入不正确，请输8-20位的登录密码"];
            return;
        }
        
        if (![self judgePassWordLegal:self.usernameRePasswordTextField.text]) {
            [self.view ug_showToastWithToast:@"重新输入不正确，密码必须包含字母、数字"];
            return;
        }

        
    }
    else
    {
        if ([NSString stringIsNull:self.countryTestFiled.text]) {
            [self.view ug_showToastWithToast:@"请选择国家"];
            return;
        }
        if ([NSString stringIsNull:self.userTextFild.text]) {
            [self.view ug_showToastWithToast:@"请输入手机号"];
            return;
        }
        if ([NSString stringIsNull:self.verifyTextFild.text]) {
            [self.view ug_showToastWithToast:@"请输入验证码"];
            return;
        }
        if ([NSString stringIsNull:self.passWordTextFild.text]) {
            [self.view ug_showToastWithToast:@"请输入登录密码"];
            return;
        }
        if (self.passWordTextFild.text.length <8 || self.passWordTextFild.text.length>20) {
            [self.view ug_showToastWithToast:@"请输8-20位的登录密码"];
            return;
        }
        if (![self judgePassWordLegal:self.passWordTextFild.text]) {
            [self.view ug_showToastWithToast:@"登录密码必须包含字母、数字"];
            return;
        }
        
    }
    [self registerEvent];
}

-(void)requestCode:(NSDictionary *)dict{
    UGRegisterSendCodeApi *api = [[UGRegisterSendCodeApi alloc] init];
    api.phone = self.userTextFild.text;
    api.areaCode = [self returenAreaCode:self.popSelectedTitle];
    if ([dict.allKeys containsObject:@"geetest_challenge"]) {
         api.  geetest_challenge = [dict objectForKey:@"geetest_challenge"];
    }
    if ([dict.allKeys containsObject:@"geetest_validate"]) {
         api.geetest_validate = [dict objectForKey:@"geetest_validate"];
    }
    if ([dict.allKeys containsObject:@"geetest_seccode"]) {
        api.geetest_seccode = [dict objectForKey:@"geetest_seccode"];
    }
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!object) {
            [self.view  ug_showToastWithToast:apiError.desc];
                dispatch_source_cancel(self.timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"计时结束");
                    self.verfyLabe.hidden = YES;
                    [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
//                    self.verifyBtn.backgroundColor = UG_MainColor;
                    self.verifyBtn.userInteractionEnabled = YES;
                });
        }else{
            [self.view ug_showToastWithToast:@"短信发送成功 ！"];
        }
    }];
}

#pragma mark - 注册
-(void)registerEvent{
    if (_isUsernameRegister) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UGRegisterApi *api = [[UGRegisterApi alloc]init];
        api.username = self.usernameTextField.text;
        api.password = self.usernameRePasswordTextField.text;
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!apiError) {
                [self.view ug_showToastWithToast:@"注册成功 !"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REGISTERKEYSUCCSE" object:nil userInfo:@{@"userName":self.usernameTextField.text , @"type" : @"1"}];
                //回到登录页面    /*延迟执行时间0.5秒*/
                __weak typeof(self)weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    //注册后自动登录
                    [weakSelf loginApp];
                });
            }else {
                [self.view ug_showToastWithToast:apiError.desc];
            }
        }];
    }else {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        UGNewRegisterApi *api = [[UGNewRegisterApi alloc] init];
        api.mobilePhone = self.userTextFild.text;
        api.areaCode = [self returenAreaCode:self.popSelectedTitle];
        api.password = self.passWordTextFild.text;
        api.country = self.popSelectedTitle;
        api.code = self.verifyTextFild.text;
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!apiError) {
                [self.view ug_showToastWithToast:@"注册成功 !"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"REGISTERKEYSUCCSE" object:nil userInfo:@{@"userName":self.userTextFild.text, @"type" : @"0"}];
                //回到登录页面    /*延迟执行时间0.5秒*/
                __weak typeof(self)weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    //注册后自动登录
                    [weakSelf loginApp];
                });
            } else {
                [self.view ug_showToastWithToast:apiError.desc];
            }
        }];
    }
}

-(void)loginApp{
    if (_isUsernameRegister) {
        [[UGManager shareInstance] loginWithUserName:self.usernameTextField.text password:self.usernameRePasswordTextField.text country:@"" areaCode:@"" completionBlock:^(UGApiError *apiError, id object) {
            if (!apiError.errorNumber) {
                //判断有没有设置支付密码
                if (![UGManager shareInstance].hostInfo.userInfoModel.hasJypassword && [[UGManager shareInstance] hasLogged]) {
                    //登录成功 进行支付密码设置
                    UGSettingPayPassWordVC *vc =[UGSettingPayPassWordVC new];
                    vc.isRegister = YES;
                    vc.isUserName = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                [self.view ug_showToastWithToast:apiError.desc];
                __weak typeof(self)weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    //登录失败返回登录页面
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    } else{
        [[UGManager shareInstance] loginWithUserName:self.userTextFild.text password:self.passWordTextFild.text country:self.countryTestFiled.text areaCode:[self returenAreaCode:self.popSelectedTitle] completionBlock:^(UGApiError *apiError, id object) {
            if (!apiError.errorNumber) {
                //判断有没有设置支付密码
                if (![UGManager shareInstance].hostInfo.userInfoModel.hasJypassword && [[UGManager shareInstance] hasLogged]) {
                    //登录成功 进行支付密码设置
                    UGSettingPayPassWordVC *vc =[UGSettingPayPassWordVC new];
                    vc.isRegister = YES;
                    [self.navigationController pushViewController:vc animated:YES];
                }
            } else {
                [self.view ug_showToastWithToast:apiError.desc];
                __weak typeof(self)weakSelf = self;
                dispatch_time_t delayTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC));
                dispatch_after(delayTime, dispatch_get_main_queue(), ^{
                    //登录失败返回登录页面
                    [weakSelf.navigationController popViewControllerAnimated:YES];
                });
            }
        }];
    }
}

#pragma mark - CaptchaButtonDelegate
-(void)captchaButtonWillShouldBeginTapAction:(CustomButton *)button{
    if (![NSString stringIsNull:self.userTextFild.text]) {
         self.verifyBtn.phone = self.userTextFild.text;
    }
}

- (BOOL)captchaButtonShouldBeginTapAction:(CustomButton *)button {
    [self hidenTextField];
    if ([NSString stringIsNull:self.countryTestFiled.text]) {
        [self.view ug_showToastWithToast:@"请选择国家"];
        return NO;
    }
    if ([NSString stringIsNull:self.userTextFild.text]) {
        [self.view ug_showToastWithToast:@"请输入手机号"];
        return NO;
    }
    return YES;
}

#pragma mark-二次验证返回数据
- (void)delegateGtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message{
//    NSString *successState = [result objectForKey:@"success"];
//    if (UG_CheckStrIsEmpty(successState) || ! [successState isEqualToString:@"1"]) {
//        [self.view ug_showToastWithToast:@"验证失败"];
//        return;
//    }
    [self requestCode:result];
    [self reGetVerify];
}

/**
 1. 长度大于8位
 2. 密码中必须同时包含数字和字母
 **/
-(BOOL)judgePassWordLegal:(NSString *)pass{
    NSUInteger len = [pass length];
    BOOL isal = NO,isnum = NO,isxx = NO;
    for(int i=0;i<len;i++)
    {
        unichar a=[pass characterAtIndex:i];
        if (islower(a)) {//小写字母
            isal = YES;
        }
        if ((isupper(a))) {//大写字母
            isxx = YES;
        }
        if (isdigit(a)) {
            isnum = YES;
        }

    }
    return (isal || isxx) && isnum;
}

#pragma mark- 判断字符串 字母 数字
-(BOOL)isChineseCharacterAndLettersAndNumbersAndUnderScore:(NSString *)string
{
    NSUInteger len = [string length];
    BOOL isok = NO, isnum = NO;
    for(int i=0;i<len;i++)
    {
        unichar a=[string characterAtIndex:i];
        if (isalpha(a)) {//字母
            isok = YES;
        }
        if (isdigit(a)) {//数字
            isnum = YES;
        }
    }
    if(isnum){
        if(isok){
            return YES;
        }else{
            return NO;
        }
    }else{
        if(isok){
            return YES;
        }
    }
    return NO;
}

//#pragma mark - 隐藏弹出的泡泡
//-(void)hideCountryView
//{
//    UIWindow * window=[[[UIApplication sharedApplication] delegate] window];
//    CGRect startRact = [self.countryLine convertRect:self.countryLine.bounds toView:window];
//    CGRect frame = CGRectMake(startRact.origin.x+14, startRact.origin.y, startRact.size.width-28, startRact.size.height);
//    [self.countryPopView hideDropDownMenuWithBtnFrame:frame];
//    [self.selectedCounteyBtn setImage:[UIImage imageNamed:@"ug_selectedcountry"] forState:UIControlStateNormal];
//    self.hasShow = NO;
//}


#pragma mark - 注册方式的切换

- (IBAction)usernameButtonAction:(id)sender {
     _isUsernameRegister = YES;
//    [self hideCountryView];
    [self changeShowUI];
   
}

- (IBAction)phoneButtonAction:(id)sender {
    _isUsernameRegister = [[sender titleForState:UIControlStateNormal] isEqualToString:@"用户名注册"];
//    [self hideCountryView];
    [self changeShowUI];
}

-(void)changeShowUI
{
    switch (_registerType)
    {
        //手机号注册
        case 0:
        {
            self.phoneRegisterButton.hidden = YES;
            self.usernameRegisterButton.hidden = YES;
            self.usernameRegisterView.hidden = YES;
            self.phoneRegisterView.hidden = NO;
            self.spaceLayout.constant = 16.0f;
            _isUsernameRegister = NO;
        }
        break;
        //用户名注册
        case 1:
        {
            self.phoneRegisterButton.hidden = YES;
            self.usernameRegisterButton.hidden = YES;
            self.usernameRegisterView.hidden = NO;
            self.phoneRegisterView.hidden = YES;
            self.spaceLayout.constant = 16.0f;
            _isUsernameRegister = YES;
            
        }
        break;
        //两者都有
        default:
        {
            self.phoneRegisterButton.hidden = NO;
            self.usernameRegisterButton.hidden = NO;
            self.phoneButtonWidth.constant = (UG_SCREEN_WIDTH - 50.0f)/2;
            self.phoneLineWidth.constant = (UG_SCREEN_WIDTH - 50.0f)/2;
            self.usernameLineWidth.constant = (UG_SCREEN_WIDTH - 50.0f)/2;
            self.usernameButtonWidth.constant = (UG_SCREEN_WIDTH - 50.0f)/2;
             self.spaceLayout.constant = 40.0f;
            if (_isUsernameRegister)
            {
                self.usernameRegisterView.hidden = NO;
                self.phoneRegisterView.hidden = YES;
                [self.usernameRegisterButton setTitleColor:UG_MainColor forState:UIControlStateNormal];
                [self.phoneRegisterButton setTitle:@"手机号注册" forState:UIControlStateNormal];
            }
            else
            {
                self.usernameRegisterView.hidden = YES;
                self.phoneRegisterView.hidden = NO;
                [self.usernameRegisterButton setTitleColor:[UIColor colorWithHexString:@"FF999999"] forState:UIControlStateNormal];
                [self.phoneRegisterButton setTitle:@"用户名注册" forState:UIControlStateNormal];
    
            }
            
        }
        break;
    }
    if ([UG_MethodsTool is4InchesScreen]) {
        self.spaceLayout.constant = 8.0f;
        self.registerButtonTop.constant = 16.0f;
    }
}
- (IBAction)kefuChat:(id)sender {
//    [self hideCountryView];
    [self.userTextFild resignFirstResponder];
    [self.passWordTextFild resignFirstResponder];
    [self.verifyTextFild resignFirstResponder];
    [self.usernameTextField resignFirstResponder];
    [self.usernamePasswordTextFiled resignFirstResponder];
    [self.usernameRePasswordTextField resignFirstResponder];
    [self onChat];
}

- (void)onChat{
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"UG钱包";
    
    [[UGQYSDKManager shareInstance] updateDateQYUserInfo:@"" isLogin:YES];
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"在线客服";
    sessionViewController.source = source;
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"]  style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
    sessionViewController.navigationItem.leftBarButtonItem = leftItem;
    UGNavController* navi = [[UGNavController alloc]initWithRootViewController:sessionViewController];
    [self presentViewController:navi animated:YES completion:nil];
}

- (void)onBack:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

@end
