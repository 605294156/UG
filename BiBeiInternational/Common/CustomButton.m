//
//  CustomButton.m
//  gt-captcha3-ios-example
//
//  Created by NikoXu on 08/04/2017.
//  Copyright © 2017 Xniko. All rights reserved.
//

#import "CustomButton.h"


//网站主部署的用于验证初始化的接口 (api_1)
#define api_1 [NSString stringWithFormat:@"%@%@",[UGURLConfig baseURL],@"ug/login/captcha"]

@interface CustomButton ()<GT3CaptchaManagerDelegate>

@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

@property (nonatomic, strong) GT3CaptchaManager *manager;

@end

@implementation CustomButton


- (GT3CaptchaManager *)manager {
    if (!_manager) {
        NSString *newURL = api_1;
        if (![NSString stringIsNull:_phone]) {
            newURL = [NSString stringWithFormat:@"%@?phone=%@", api_1,self.phone];
        }
        _manager = [[GT3CaptchaManager alloc] initWithAPI1:newURL API2:nil timeout:10.0];
        _manager.delegate=self;
        [_manager useVisualViewWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    }
    return _manager;
}


- (void)setOriginaStyle{
//    [self _init];
    [self addTarget:self action:@selector(willstartCaptcha) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(startCaptcha) forControlEvents:UIControlEventTouchUpInside];
}

-(void)setPhone:(NSString *)phone{
    if ( ! [_phone isEqualToString:phone]) {
        self.manager = nil;
    }
    _phone = phone;
     [self _init];
}

- (void)_init {
    self.indicatorView = [self createActivityIndicator];
    // 必须调用, 用于注册获取验证初始化数据
    [self.manager registerCaptcha:nil];
    [self.manager disableBackgroundUserInteraction:YES];
}

- (UIActivityIndicatorView *)createActivityIndicator {
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [indicatorView setHidesWhenStopped:YES];
    [indicatorView stopAnimating];
    
    return indicatorView;
}

-(void)willstartCaptcha{
    //点击触摸按下的时候
    if (_delegate && [_delegate respondsToSelector:@selector(captchaButtonWillShouldBeginTapAction:)]) {
        [_delegate captchaButtonWillShouldBeginTapAction:self];
    }
}

- (void)startCaptcha {
    if (_delegate && [_delegate respondsToSelector:@selector(captchaButtonShouldBeginTapAction:)]) {
        if (![_delegate captchaButtonShouldBeginTapAction:self]) {
            return;
        }
    }
      [self.manager startGTCaptchaWithAnimated:YES];
}

- (void)stopCaptcha {
   
    [self.manager stopGTCaptcha];
}

- (void)showIndicator {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUserInteractionEnabled:NO];
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.indicatorView];
        [self centerActivityIndicatorInButton];
        [self.indicatorView startAnimating];
    });
}

- (void)removeIndicator {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setUserInteractionEnabled:YES];
        [self.indicatorView removeFromSuperview];
    });
}

- (void)centerActivityIndicatorInButton {
    NSLayoutConstraint *constraintX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    
    NSLayoutConstraint *constraintY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.indicatorView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    
    [self addConstraints:@[constraintX, constraintY]];
}

#pragma mark GT3CaptchaManagerDelegate
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveSecondaryCaptchaData:(NSData *)data response:(NSURLResponse *)response error:(GT3Error *)error decisionHandler:(void (^)(GT3SecondaryCaptchaPolicy captchaPolicy))decisionHandler{
    
}

- (void)gtCaptcha:(GT3CaptchaManager *)manager errorHandler:(GT3Error *)error {
    //处理验证中返回的错误
    if (error.code == -999) {
        // 请求被意外中断, 一般由用户进行取消操作导致, 可忽略错误
        [APPLICATION.window ug_showToastWithToast:@"请求被意外中断"];
    }
    else if (error.code == -10) {
        // 预判断时被封禁, 不会再进行图形验证
        [APPLICATION.window ug_showToastWithToast:@"预判断时被封禁"];
    }
    else if (error.code == -20) {
        // 尝试过多
        [APPLICATION.window ug_showToastWithToast:@"尝试过多"];
    }
    else {
        // 网络问题或解析失败, 更多错误码参考开发文档
        [APPLICATION.window ug_showToastWithToast:@"网络问题或解析失败"];
    }
    
}

- (void)gtCaptchaUserDidCloseGTView:(GT3CaptchaManager *)manager {
    NSLog(@"用户主动关闭了验证码界面");
 
}

// 不使用默认的二次验证接口
- (void)gtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message {
    
    if (_delegate && [_delegate respondsToSelector:@selector(delegateGtCaptcha: didReceiveCaptchaCode:result: message:)]) {
        [_delegate delegateGtCaptcha:manager didReceiveCaptchaCode:code  result:result message:message];
    }
}

- (BOOL)shouldUseDefaultSecondaryValidate:(GT3CaptchaManager *)manager {
    return NO;
}

#pragma mark GT3CaptchaManagerViewDelegate

- (void)gtCaptcha:(GT3CaptchaManager *)manager updateCaptchaStatus:(GT3CaptchaState)state error:(GT3Error *)error {
    
    switch (state) {
        case GT3CaptchaStateInactive:
        case GT3CaptchaStateActive:
        case GT3CaptchaStateComputing: {
            [self showIndicator];
          
            break;
        }
        case GT3CaptchaStateInitial:
        case GT3CaptchaStateFail:{
            
        }
        case GT3CaptchaStateError:
        case GT3CaptchaStateSuccess:
        case GT3CaptchaStateCancel: {
            [self removeIndicator];
           
            break;
        }
        case GT3CaptchaStateWaiting:{
       
        }
        case GT3CaptchaStateCollecting:
        default: {
            break;
        }
    }
}

@end
