//
//  UGPayViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/15.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPayViewController.h"
#import "UGPayJYPasswordView.h"
#import "UGPayGoogleVerifyView.h"
#import "UGPaymentCompletedView.h"
//#import "UGPayApi.h"
#import "UGNewPayApi.h"
#import "UGCheckJypasswordExistApi.h"
#import "AppDelegate.h"


@interface UGPayViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
@property (weak, nonatomic) IBOutlet UILabel *namelabel;

@property (nonatomic, strong) UGPayJYPasswordView *jyPassWordView;
@property (nonatomic, strong) UGPayGoogleVerifyView *googleVerifyView;
@property (nonatomic, strong) UGPaymentCompletedView *paymentCompletedView;

/**
 支付密码
 */
@property (nonatomic, strong) NSString *password;

/**
 谷歌验证码
 */
@property (nonatomic, strong) NSString *googleCode;


@property(nonatomic,strong) NSString *verifyCodeType;


/**
 支付返回的结果
 */
@property (nonatomic, strong) NSString *payResult;

@property(strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时

@property (nonatomic, assign) BOOL isNoVerify;

@end

@implementation UGPayViewController



- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //关闭侧滑返回
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self secondsCountDown];
    self.title = @"支付";
    
    NSString *releaseLimit = [self upDataMessage:@"c2bLimit" WithMessage:@"1000"];
    NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG;
    NSString *pricenu =  [NSString ug_positiveFormatWithMultiplier:self.orderModel.tradeUgNumber multiplicand:cnyRate scale:6 roundingMode:NSRoundDown];
    if ( [pricenu doubleValue]  <= [releaseLimit doubleValue]) {
        self.isNoVerify = YES;
    }
    self.namelabel.text = [UGManager shareInstance].hostInfo.username;
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:[UGManager shareInstance].hostInfo.userInfoModel.member.avatar] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    [self showJYPasswordView];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(toAlertUserBindTheGoogleVerification) name:@"toAlertUserBindTheGoogleVerification" object:nil];
}

- (void)showJYPasswordView {
    self.jyPassWordView.orderModel = self.orderModel;
    [self.view addSubview:self.jyPassWordView];
    [self.jyPassWordView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}


#pragma mark - 交易密码

- (void)sendCheckJYPasswordRquest {
    [MBProgressHUD ug_showHUDToKeyWindow];
    self.jyPassWordView.nextBtn.userInteractionEnabled = NO;
    UGCheckJypasswordExistApi *api = [[UGCheckJypasswordExistApi alloc] init];
    api.password = self.password;
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        @strongify(self);
        if ( ! apiError) {
            if ( ! self.isNoVerify) {
                [UIView transitionFromView:self.jyPassWordView toView:self.googleVerifyView duration:0.2f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionShowHideTransitionViews completion:nil];
            }else{
                //限定值以内  不需要短信验证
                [self sendPayRequest];
            }
        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
        self.jyPassWordView.nextBtn.userInteractionEnabled = YES;
    }];
}


#pragma mark - 支付接口

-(void)sendPayRequest {
    UGWalletAllModel *model  = [UGManager shareInstance].hostInfo.userInfoModel.list.firstObject;
    if (!UG_CheckStrIsEmpty(self.orderModel.tradeUgNumber)) {
        NSString *str = [NSString ug_bySubtractFormatWithMultiplier:model.balance multiplicand:self.orderModel.tradeUgNumber];
        if ([str floatValue]<0) {
            [self.view ug_showToastWithToast:@"您的余额不足，请前往【交易】获取更多UG币！"];
            return;
        }
    }
    UGNewPayApi *api = [UGNewPayApi new];
    api.version = @"1.0";//1.0支付接口版本号
    //0 表示手机短信验证  1为谷歌验证
    api.validType = self.verifyCodeType;
    if ([self.verifyCodeType isEqualToString:@"1"]) {
    api.googleCode = self.googleCode;//已绑定  ---谷歌验证码
    }
    else
    {
    api.code = self.googleCode;//已绑定  ---手机验证码
    }
    api.sloginName = [UGManager shareInstance].hostInfo.username;//---用户登录名
    api.payPassword= self.password;//??支付密码
    api.spayCardNo = ((UGWalletAllModel *)[UGManager shareInstance].hostInfo.userInfoModel.list.firstObject).address ;//---支付UG钱包地址
    api.apayCardNo = self.orderModel.apayCardNo;//接收UG钱包地址
    api.tradeAmount = self.orderModel.tradeUgNumber;//交易金额,单位UG
    api.tradeUgNumber = self.orderModel.tradeUgNumber;//交易数量, ==交易金额
    api.orderType = @"1";// 0 订单类型,0个人转帐订单1个人支付订单2商户转帐订单
    api.merchNo = self.orderModel.merchNo;
    api.aloginName = self.orderModel.merchNo;
    api.orderSn = self.orderModel.orderSn;
    api.goodsName = self.orderModel.goodsName;
    api.source = @"30";    
    [MBProgressHUD ug_showHUDToKeyWindow];
    if ( ! self.isNoVerify) {
        self.googleVerifyView.tureBtn.userInteractionEnabled = NO;
    }
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        self.payResult = apiError.desc ? : @"支付成功！";
        //支付成功
        if (!apiError) {
            self.paymentCompletedView.orderModel = self.orderModel;
            if ( ! self.isNoVerify) {
                [UIView transitionFromView:self.googleVerifyView toView:self.paymentCompletedView duration:0.2f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionShowHideTransitionViews completion:nil];
            }else{
                  [UIView transitionFromView:self.jyPassWordView toView:self.paymentCompletedView duration:0.2f options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionShowHideTransitionViews completion:nil];
            }
        } else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
        if ( ! self.isNoVerify) {
             self.googleVerifyView.tureBtn.userInteractionEnabled = YES;
        }
    }];
}

#pragma mark - 收起键盘
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark - 倒计时剩余支付时间，倒计时结束自动关闭页面
- (void)secondsCountDown {
    __block int timeout = 3600;//3分钟
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    @weakify(self);
    dispatch_source_set_event_handler(self.timer, ^{
        @strongify(self);
        if (timeout<0) {
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
                @strongify(self);
                [self  closePayController];
            });
        } else {
            timeout--;
        }
    });
    dispatch_resume(self.timer);
}

- (void)closePayController {
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController popViewControllerAnimated:NO];
}


#pragma mark - 返回第三方APP

- (void)goBackFromAppWithResult:(NSString *)result {
    //ugh5  这个是表示从 h5网页 过来  无法返回  所以直接关闭成功页面就好
    if (![self.fomeScheme isEqualToString:@"ugh5"]) {
        NSDictionary *dict = @{@"result" : result, @"orderSn" : self.orderModel.orderSn};
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        NSString* encodedString = [[NSString stringWithFormat:@"%@://ugpay?result=%@",self.fomeScheme,[dict mj_JSONString]] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
#pragma clang diagnostic pop
        NSURL *url = [NSURL URLWithString:encodedString];
        [[UIApplication sharedApplication] openURL:url];
        [self closePayController];
    }else{
        [self closePayController];
    }
}

#pragma mark - Getter Method

- (UGPayJYPasswordView *)jyPassWordView {
    if (!_jyPassWordView) {
        _jyPassWordView = [UGPayJYPasswordView fromXib];
        @weakify(self);
        _jyPassWordView.clickNextSetpHandle = ^(NSString * _Nonnull passWord) {
            @strongify(self);
            [self.view endEditing:YES];
            self.password = passWord;
            [self sendCheckJYPasswordRquest];
        };
        _jyPassWordView.clickCloseHandle = ^{
            @strongify(self);
            [self closePayController];
        };

    }
    return _jyPassWordView;
}

- (UGPayGoogleVerifyView *)googleVerifyView {
    if (!_googleVerifyView) {
        _googleVerifyView = [UGPayGoogleVerifyView fromXib];
        [self.view addSubview:_googleVerifyView];
        [_googleVerifyView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        @weakify(self);
        _googleVerifyView.determineHanlde = ^(NSString * _Nonnull code,NSString * _Nonnull type) {
            @strongify(self);
            NSLog(@"HHHHHHH code = %@ type = %@",code,type);
            
            [self.view endEditing:YES];
            self.googleCode = code;
            self.verifyCodeType = type;
            [self sendPayRequest];
        };
        _googleVerifyView.clickCloseHandle = ^{
            @strongify(self);
            [self closePayController];
        };

    }
    return _googleVerifyView;

}

-(void)toAlertUserBindTheGoogleVerification
{
    [self hasBindingGoogleValidator];
}

- (UGPaymentCompletedView *)paymentCompletedView {
    if (!_paymentCompletedView) {
        _paymentCompletedView = [UGPaymentCompletedView fromXib];
        [self.view addSubview:_paymentCompletedView];
        [_paymentCompletedView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self.view);
        }];
        @weakify(self);
        _paymentCompletedView.completeHanlde = ^ {
            @strongify(self);
            [self goBackFromAppWithResult:self.payResult];
        };
    }
    return _paymentCompletedView;
}

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}

@end
