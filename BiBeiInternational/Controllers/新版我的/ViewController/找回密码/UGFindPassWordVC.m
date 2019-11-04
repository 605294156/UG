//
//  UGFindPassWordVC.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/22.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGFindPassWordVC.h"
#import "UGCountryPopView.h"
#import "UGGetAreaCodeApi.h"
#import "UGAreaModel.h"
#import "UGFindPassWordTureVC.h"
#import "UGForgetLoginPwdSendCodeApi.h"
#import "UGForgetLoginPwdAuthApi.h"
#import "CustomButton.h"
#import "UGSelectStateViewController.h"

@interface UGFindPassWordVC ()<CaptchaButtonDelegate>
@property (weak, nonatomic) IBOutlet UITextField *phoneFiled;
@property (weak, nonatomic) IBOutlet UITextField *codeFiled;
@property (weak, nonatomic) IBOutlet CustomButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UILabel *VerfyLabel;
@property (strong, nonatomic) dispatch_source_t timer;//剩余支付时间倒计时
@property (weak, nonatomic) IBOutlet UITextField *countryFiled;
@property(nonatomic,assign)NSInteger popSelectedIndex;
@property(nonatomic,copy)NSString *popSelectedTitle;
@property(nonatomic,strong)NSArray *areaArray;//区号数组
@property(nonatomic,strong)NSMutableArray *areaTitles;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property(nonatomic,strong)UGCountryPopView *countryPopView;
@property (weak, nonatomic) IBOutlet UILabel *countryLine;
@property (weak, nonatomic) IBOutlet UIButton *selectedCountryBtn;
@property(nonatomic,assign)BOOL hasShow;
@end

@implementation UGFindPassWordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重置密码";
    
    [self.countryFiled setEnabled:NO];
    
    self.popSelectedIndex = 0;
    self.popSelectedTitle = @"";

     [self getAreaRequest];
    //验证码按钮
    [self.verifyBtn setOriginaStyle];
    self.verifyBtn.delegate = self;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    CGRect frame = CGRectMake(self.countryLine.origin.x+14, self.countryLine.origin.y+[UG_MethodsTool navigationBarHeight], self.countryLine.size.width-28, self.countryLine.size.height);
    [self.countryPopView hideDropDownMenuWithBtnFrame:frame];
//    [self.selectedCountryBtn setImage:[UIImage imageNamed:@"ug_selectedcountry"] forState:UIControlStateNormal];
    self.hasShow = NO;
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
            self.countryFiled.text = self.popSelectedTitle;
            self.phoneLabel .text = [NSString stringWithFormat:@"+%@",[self returenAreaCode:self.popSelectedTitle]];
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

#pragma mark -选择国家地区
- (IBAction)selectedCountry:(id)sender {
    if (self.areaTitles.count>0) {
//        CGRect frame = CGRectMake(42, 70+[UG_MethodsTool navigationBarHeight], UG_SCREEN_WIDTH-2*42, 1);
//        if (!self.hasShow) {
//            @weakify(self);
//            if (!self.countryPopView) {
//                self.countryPopView = [[UGCountryPopView alloc] initWithFrame:frame WithArr:self.areaTitles WithIndex:self.popSelectedIndex WithHandle:^(NSString * _Nonnull title, NSInteger index){
//                    @strongify(self);
//                    self.popSelectedIndex = index;
//                    self.popSelectedTitle = title;
//                    self.phoneLabel .text = [NSString stringWithFormat:@"+%@",[self returenAreaCode:self.popSelectedTitle]];
//                    self.countryFiled.text = title;
//                    self.hasShow = NO;
////                    [self.selectedCountryBtn setImage:[UIImage imageNamed:@"ug_selectedcountry"] forState:UIControlStateNormal];
//                }];
//                [[UIApplication sharedApplication].keyWindow addSubview:self.countryPopView];
//            }else{
//                [self.countryPopView showDropDownMenuWithBtnFrame:frame];
//            }
//            self.countryPopView.index = self.popSelectedIndex;
////            [self.selectedCountryBtn setImage:[UIImage imageNamed:@"selectedcountry"] forState:UIControlStateNormal];
//            self.hasShow = YES;
//        }else{
//            [self.countryPopView hideDropDownMenuWithBtnFrame:frame];
////            [self.selectedCountryBtn setImage:[UIImage imageNamed:@"ug_selectedcountry"] forState:UIControlStateNormal];
//            self.hasShow = NO;
//        }
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"UGSelectStateViewController" bundle:nil];
        UGSelectStateViewController *vc = [storyboard instantiateInitialViewController];
        vc.areaTitles = self.areaArray;@weakify(self)
        [RACObserve(vc, model) subscribeNext:^(UGAreaModel *model) {@strongify(self)
            if (model) {
                self.popSelectedTitle = model.zhName;
                self.countryFiled.text = self.popSelectedTitle;
                self.phoneLabel.text = [NSString stringWithFormat:@"+%@",model.areaCode];
            }
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    else
    {
        [self getAreaRequest];
    }
}

#pragma mark - CaptchaButtonDelegate
-(void)captchaButtonWillShouldBeginTapAction:(CustomButton *)button{
    if (![NSString stringIsNull:self.phoneFiled.text]) {
        self.verifyBtn.phone = self.phoneFiled.text;
    }
}

- (BOOL)captchaButtonShouldBeginTapAction:(CustomButton *)button {
    [self.phoneFiled resignFirstResponder];
    [self.codeFiled resignFirstResponder];
    if ([NSString stringIsNull:self.countryFiled.text]) {
        [self.view ug_showToastWithToast:@"请选择国家"];
        return NO;
    }
    if ([NSString stringIsNull:self.phoneFiled.text]) {
        [self.view ug_showToastWithToast:@"请输入手机号"];
        return NO;
    }
    return YES;
}

#pragma mark-二次验证返回数据
- (void)delegateGtCaptcha:(GT3CaptchaManager *)manager didReceiveCaptchaCode:(NSString *)code result:(NSDictionary *)result message:(NSString *)message{
    [self getCodeRequest:result];
    [self timeCount];
}

#pragma mark - 获取手机验证码
-(void)getCodeRequest:(NSDictionary *)dict{
    if ([NSString stringIsNull:self.countryFiled.text]) {
        [self.view ug_showToastWithToast:@"请选择国家"];
        return;
    }
    if (UG_CheckStrIsEmpty(self.phoneFiled.text)) {
        [self.view ug_showToastWithToast:@"请输入手机号"];
        return;
    }
    UGForgetLoginPwdSendCodeApi *api = [[UGForgetLoginPwdSendCodeApi alloc] init];
    api.phone = self.phoneFiled.text;
    api.areaCode = [self returenAreaCode:self.popSelectedTitle];
    if ([dict.allKeys containsObject:@"geetest_challenge"]) {
        api.geetest_challenge = [dict objectForKey:@"geetest_challenge"];
    }
    if ([dict.allKeys containsObject:@"geetest_validate"]) {
        api.geetest_validate = [dict objectForKey:@"geetest_validate"];
    }
    if ([dict.allKeys containsObject:@"geetest_seccode"]) {
        api.geetest_seccode = [dict objectForKey:@"geetest_seccode"];
    }
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!object) {
            [self.view ug_showToastWithToast:apiError.desc];
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
                self.VerfyLabel.hidden = YES;
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else{
            [self.view ug_showToastWithToast:@"短信发送成功 ！"];
        }
    }];
}

#pragma mark -下一步
- (IBAction)next:(id)sender {
    if ([NSString stringIsNull:self.countryFiled.text]) {
        [self.view ug_showToastWithToast:@"请选择国家"];
        return;
    }
    if (UG_CheckStrIsEmpty(self.phoneFiled.text)) {
        [self.view ug_showToastWithToast:@"请输入手机号"];
        return;
    }
    if (UG_CheckStrIsEmpty(self.codeFiled.text)) {
        [self.view ug_showToastWithToast:@"请输入验证码"];
        return;
    }
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGForgetLoginPwdAuthApi *api = [[UGForgetLoginPwdAuthApi alloc] init];
    api.phone = self.phoneFiled.text;
    api.code = self.codeFiled.text;
    api.areaCode = [self returenAreaCode:self.popSelectedTitle];
    @weakify(self);
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        @strongify(self);
        if (object) {
            [self.view ug_showToastWithToast:@"验证成功"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                UGFindPassWordTureVC *vc = [[UGFindPassWordTureVC alloc] init];
                vc.phone = self.phoneFiled.text;
                vc.code = self.codeFiled.text;
                vc.topVC = self.topVC;
                [self.navigationController pushViewController: vc animated:YES];
            });
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark -倒计时
-(void)timeCount{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(self.timer, dispatch_walltime(NULL, 0), 1.0*NSEC_PER_SEC, 0);//每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        if (timeout<=0) {
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"计时结束");
                self.VerfyLabel.hidden = YES;
                [self.verifyBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                self.verifyBtn.userInteractionEnabled = YES;
            });
        }else {
            int seconds = timeout;
            NSString *sStr =[NSString stringWithFormat:seconds<10? @"（0%ds）重新获取" : @"（%ds）重新获取",seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.VerfyLabel.hidden = NO;
                [self.verifyBtn setTitle:@"" forState:UIControlStateNormal];
                self.VerfyLabel.text = sStr;
                self.verifyBtn.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(self.timer);
}

- (void)dealloc {
    if (self.timer) {
        dispatch_source_cancel(self.timer);
    }
}


@end
