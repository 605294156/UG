//
//  UGHomeTransferVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/18.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeTransferVC.h"
#import "UGPopTableView.h"
//#import "UGQRScanVC.h"
#import "AppDelegate.h"
#import "UGHomeTransPayVC.h"
#import "UGWalletAllModel.h"
#import "UGGeneralCertificationVC.h"
#import "UGAdancedCertificationVC.h"
#import "UGManager.h"
#import "UGExchangeRateApi.h"
#import "UGPayRateModel.h"
#import "UGPayRateApi.h"
#import "UGBaseViewController+UGGuidMaskView.h"
#import "MXRGuideMaskView.h"
#import "UGNewGuidStatusManager.h"
#import "UGGetOpenC2cApi.h"
#import "UGPayQRModel.h"
#import "QRCodeScanVC.h"
#import "UGCheckAloginNameRealNameApi.h"

@interface UGHomeTransferVC ()<UITextViewDelegate>
@property (nonatomic,strong)UGPopTableView *walletSelectedPopView;
@property (nonatomic,copy)NSString *walletName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *ugcConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (nonatomic,assign)BOOL showPopView;
@property (nonatomic,assign) BOOL isHaveBinding;
@property (nonatomic,strong)UGWalletAllModel *model;
//未输入时显示余额 @“可用余额 777 UG” 输入后显示 手续费 @“扣除1UG手续费（费率0.1%）”
@property (weak, nonatomic) IBOutlet UILabel *balanceAndServiceChargeLabel;
@property (nonatomic,strong)UGPayRateModel *payRateModel;

@property (nonatomic,copy)NSString *address;//UG钱包地址
@property (nonatomic,copy)NSString *username;//用户名

@property(nonatomic,copy)NSString *merchNo;//商户号
@property(nonatomic,copy)NSString *orderSn;//订单号
@property(nonatomic,copy)NSString *extra;//其他信息
@property(nonatomic,copy)NSString *availableBalance;//最大可转出数额
@property(nonatomic,copy)NSString *rateStrs;

@property (nonatomic,strong) MXRGuideMaskView *maskView;

@property (nonatomic,assign)BOOL isShow;

@property(nonatomic,strong)NSArray *listData;
@end

@implementation UGHomeTransferVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.availableBalance = @"0";
    
    [self initUI];
    
    [self request];
    
    if ([UGManager shareInstance].hostInfo.userInfoModel.list.count>0) {
        self.listData = [UGManager shareInstance].hostInfo.userInfoModel.list;
        self.model = self.listData[0];
        self.availableBalance = self.model.balance;
        [self loadData];
    }
    
    [self getWalletData];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
}

#pragma mark -隐藏新手指引
-(void)hidenShowGuideView{
    if (self.maskView) {
        [self.maskView dismissMaskView];
        self.maskView = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self hidenShowGuideView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUGTOCny];
    [self request];
    
    if (![[NSUserDefaultUtil GetDefaults:@"haveTransfer"] isEqualToString:@"1"] && ![[UGNewGuidStatusManager shareInstance].TransferStatus isEqualToString:@"1"] && !self.isShow) {
        if (![[UIViewController currentViewController] isKindOfClass:[UGHomeTransferVC class]]) {
            return;
        }
        @weakify(self);
        self.isShow = YES;
        [self setupTransferNewGuideViewWithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
            @strongify(self);
            self.maskView = maskView;
        }];
    }
    
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : HEXCOLOR(0x333333),
    NSFontAttributeName : [UIFont systemFontOfSize:18]}];
}

-(void)loadData{
    NSString *walletName = self.model.name;
    self.selectedwallet.text = ! UG_CheckStrIsEmpty(walletName)?walletName:@" ";
    if (self.qrModel) {
         [self apendaddressAndName:self.qrModel];
    }
    [self textFieldEditChanged:self.acceptTextFiled];
}

-(void)languageChange{
     self.title = @"转币";
}

-(void)initUI{
    self.textView.delegate = self;
    
    self.showPopView = NO;

    self.ugcConstraint.constant=UG_AutoSize(10);
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(walletSelected:)];
    [self.view1 addGestureRecognizer:tapGes];
    
    [_sendNumTextFiled  addTarget:self action:@selector(textFieldEditChangeMoney:)forControlEvents:UIControlEventEditingChanged];
    
    [self.view2 addSubview:self.backScrollVew];
    
    self.backScrollVew.frame = CGRectMake(14+10+58, 0, kWindowW-(14+10+58)-(14+10+55), 48);
    
    self.acceptTextFiled.frame = CGRectMake(9, 16, kWindowW-(14+10+58)-(14+10+55), 16);
    
    [self.backScrollVew addSubview:self.acceptTextFiled];
    
    [self languageChange];
}

-(UIScrollView *)backScrollVew{
    if (!_backScrollVew) {
        _backScrollVew = [[UIScrollView alloc]init];
        _backScrollVew.showsHorizontalScrollIndicator = NO;
        _backScrollVew.showsHorizontalScrollIndicator = NO;
        _backScrollVew.bounces = NO;
    }
    return _backScrollVew;
}

-(TXLimitedTextField *)acceptTextFiled{
    if (!_acceptTextFiled) {
        _acceptTextFiled = [[TXLimitedTextField alloc] init];
        _acceptTextFiled.limitedType = TXLimitedTextFieldTypeCustom;
        _acceptTextFiled.limitedRegEx = @"^[A-Za-z0-9]+$";
        _acceptTextFiled.limitedNumber = 10000;
        _acceptTextFiled.limitedPrefix = 10000;
        _acceptTextFiled.limitedSuffix = 10000;
        _acceptTextFiled.placeholder = @"请输入UG钱包地址";
        _acceptTextFiled.textAlignment = NSTextAlignmentLeft;
        _acceptTextFiled.text = @"";
        _acceptTextFiled.tintColor = UG_MainColor;
        _acceptTextFiled.font = [UIFont systemFontOfSize:14];
        [_acceptTextFiled addTarget:self action:@selector(textFieldEditChanged:)forControlEvents:UIControlEventEditingChanged];
    }
    return _acceptTextFiled;
}

#pragma mark - 输入计算
-(void)textFieldEditChangeMoney:(UITextField *)textField{
    NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG;
    NSString *cnyStr =  [NSString ug_positiveFormatWithMultiplier:textField.text multiplicand:cnyRate scale:6 roundingMode:NSRoundDown];
    self.cny.text=[NSString stringWithFormat:@"= %@ 元",[cnyStr ug_amountFormat]];
    if (self.payRateModel) {
        NSString *rateStr =  [NSString ug_positiveFormatWithMultiplier:! UG_CheckStrIsEmpty(textField.text) ? self.sendNumTextFiled.text : @"0" multiplicand:self.payRateModel.payRate scale:6 roundingMode:NSRoundDown];
        self.balanceAndServiceChargeLabel.text = [NSString stringWithFormat:@"手续费: %@ %@（费率%@）", [rateStr ug_amountFormat],!UG_CheckStrIsEmpty(self.model.coinId) ? self.model.coinId : @"UG",self.payRateModel.payRateStr];
    }else {
        self.balanceAndServiceChargeLabel.text = [NSString stringWithFormat:@"手续费: %@ %@（费率%@）",@"0",!UG_CheckStrIsEmpty(self.model.coinId) ? self.model.coinId : @"UG",@"0%"];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(nonnull NSString *)text{
    if ([textView isFirstResponder]) {
        //限制输入emoji表情
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
        //判断键盘是不是九宫格键盘
        if ([NSString isNineKeyBoard:text] ){
            return YES;
        }else{
            if ([NSString hasEmoji:text] || [NSString stringContainsEmoji:text]){
                return NO;
            }
        }
        
        //限制输入235个字符
        NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
        NSInteger caninputlen = 235 - comcatstr.length;
        if (caninputlen >= 0)
        {
            return YES;
        }
        else
        {
            NSInteger len = text.length + caninputlen;
            //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
            NSRange rg = {0,MAX(len,0)};
            
            if (rg.length > 0)
            {
                NSString *s = [text substringWithRange:rg];
                
                [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            }
            return NO;
        }
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    //获得textView的初始尺寸
    CGFloat width = CGRectGetWidth(textView.frame);
    CGSize newSize = [textView sizeThatFits:CGSizeMake(width,MAXFLOAT)];
    if(newSize.height>220.0f){
        self.textViewHeight.constant = 220.0f;
    }else if (newSize.height>=100.0f ) {
        self.textViewHeight.constant = newSize.height;
    }else{
        self.textViewHeight.constant = 100.0f;
    }
}

#pragma mark- 监听键盘变化
- (void)textFieldEditChanged:(UITextField *)textField
{
       [_acceptTextFiled sizeToFit];
     if (CGRectGetWidth(_acceptTextFiled.bounds)>=kWindowW-(14+10+58)-(14+10+55)) {
        _backScrollVew.contentSize =CGSizeMake(CGRectGetWidth(_acceptTextFiled.bounds),48);
        if (_indextext != _acceptTextFiled.text.length) {
            [_backScrollVew setContentOffset:CGPointMake(_backScrollVew.contentSize.width-(kWindowW-(14+10+58)-(14+10+55)), 0) animated:NO];
            _indextext = _acceptTextFiled.text.length;
        }
    }else
    {
        _indextext = _acceptTextFiled.text.length;
    }
    
    if (_acceptTextFiled.text.length > 42) {
        _acceptTextFiled.text = [_acceptTextFiled.text substringToIndex:42];
        [self.view ug_showToastWithToast:@"UG钱包地址不能超过42位"];
    }
}

-(void)hidePopView{
    if(_walletSelectedPopView)
        [_walletSelectedPopView removeFromSuperview];
}

#pragma mark -币种选择按钮 （暂时只有一种UGC）
- (IBAction)UGCSelected:(id)sender {
}

#pragma mark -UG钱包选择
- (IBAction)walletSelected:(id)sender {
    if (self.showPopView) {
        [_walletSelectedPopView removeFromSuperview];
         self.showPopView = NO;
    }else{
        [self.view addSubview:self.walletSelectedPopView];
    }
}

-(void)apendaddressAndName:(UGPayQRModel *)model{
    if ([model isKindOfClass:[UGPayQRModel class]]) {
        self.address=!UG_CheckStrIsEmpty(model.merchCardNo) ? model.merchCardNo : @"";
        self.username=!UG_CheckStrIsEmpty(model.loginName) ? model.loginName : @"";
        self.acceptTextFiled.text = self.address;
        self.acceptUserTextFiled.text = self.username;
        if ([self.username isEqualToString:[UGManager shareInstance].hostInfo.username]) {
            [self.view ug_showToastWithToast:@"不能给自己转账"];
        }
        [self textFieldEditChanged:self.acceptTextFiled];
        if ([model.orderType isEqualToString:@"1"]) {
            self.sendNumTextFiled.text = !UG_CheckStrIsEmpty(model.amount) ? model.amount : @"0";
            self.sendNumTextFiled.textColor = [UIColor colorWithHexString:@"717171"];
            self.sendNumTextFiled.enabled = NO;
            self.acceptTextFiled.enabled = NO;
            self.acceptUserTextFiled.enabled = NO;
            self.textView.hidden = YES;
            self.balanceAndServiceChargeLabel.hidden = YES;
        }else{
            self.sendNumTextFiled.textColor = [UIColor blackColor];
            self.sendNumTextFiled.enabled = YES;
            self.textView.hidden = NO;
            self.acceptTextFiled.enabled = YES;
            self.acceptUserTextFiled.enabled = YES;
             self.balanceAndServiceChargeLabel.hidden = NO;
        }
    }else{
        [self.view ug_showToastWithToast:@"不符合规则的二维码,无法转账！"];
    }
}


#pragma mark- 扫一扫
- (IBAction)scanClick:(id)sender {
//    UGQRScanVC *qrVC = [[UGQRScanVC alloc] init];
//    qrVC.scanResult = ^(UGQRScanVC * _Nonnull scanVC, LBXScanResult * _Nonnull result) {
//        if (!UG_CheckStrIsEmpty(result.strScanned)) {
//        NSDictionary *dict = [UG_MethodsTool dictWithJsonString:[UG_MethodsTool decodeString:result.strScanned]];
//        UGPayQRModel *qrM= [UGPayQRModel mj_objectWithKeyValues:dict];
//        self.qrModel = qrM;
//        [self apendaddressAndName:qrM];
//        [self.navigationController popViewControllerAnimated:YES];
//        }
//    };
//    [self.navigationController pushViewController:qrVC animated:YES];
    
    QRCodeScanVC *qrVC = [[QRCodeScanVC alloc]init];
    @weakify(self);
    qrVC.QrcodeScanResult = ^(NSString * _Nonnull resultString) {
    @strongify(self);
        NSLog(@"二维码信息：%@",resultString);
        if (!UG_CheckStrIsEmpty(resultString))
        {
            NSDictionary *dict = [UG_MethodsTool dictWithJsonString:[UG_MethodsTool decodeString:resultString]];
            UGPayQRModel *qrM= [UGPayQRModel mj_objectWithKeyValues:dict];
            self.qrModel = qrM;
            [self apendaddressAndName:qrM];
        }
    };
    [self.navigationController pushViewController:qrVC animated:YES];
}

#pragma mark -立即发送
- (IBAction)sendClick:(id)sender {
    if (self.qrModel && !UG_CheckStrIsEmpty(self.qrModel.orderType) && [self.qrModel.orderType isEqualToString:@"1"] && [self isCardVip]) {
        //c2b  承兑商 不能给 商户转币
        [self.view ug_showToastWithToast:@"承兑商禁止向商户支付！"];
        return;
    }
    
    if (UG_CheckStrIsEmpty(self.sendNumTextFiled.text)){
        [self.view ug_showToastWithToast:@"请输入金额"];
        return;
    }
    if ([self.sendNumTextFiled.text doubleValue]==0)
    {
       [self.view ug_showToastWithToast:@"请您确认转币金额不能为0"];
       return;
    }
    if(UG_CheckStrIsEmpty(self.acceptTextFiled.text)) {
        [self.view ug_showToastWithToast:@"请输入收币UG钱包地址"];
        return;
    }
    if(UG_CheckStrIsEmpty(self.acceptUserTextFiled.text)) {
        [self.view ug_showToastWithToast:@"请输入收币用户名"];
        return;
    }
    if ([self.acceptUserTextFiled.text isEqualToString:[UGManager shareInstance].hostInfo.username]) {
        [self.view ug_showToastWithToast:@"不能给自己转账"];
        return;
    }
    if (self.qrModel && !UG_CheckStrIsEmpty(self.qrModel.orderType) && [self.qrModel.orderType isEqualToString:@"1"]) {
        //c2b
        [self verifyOpration];
    }else{
        //c2c
        [self.view ug_showMBProgressHudOnKeyWindow];
        UGGetOpenC2cApi *api = [UGGetOpenC2cApi new];
        @weakify(self);
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            @strongify(self);
             [self.view ug_hiddenMBProgressHudOnKeyWindow];
            //false 不能c2c转币，只能收币； true 可以c2c转币和收币
            BOOL isCan = [object boolValue];
            if ( ! isCan) {
                [self.view  ug_showToastWithToast:[self upDataMessage:@"openC2c" WithMessage:@"您的支付额度未达5万UG，还不能进行个人转币哦！"]];
            }else{
                [self verifyOpration];
            }
        }];
    }
}

-(void)verifyOpration{
    if (!UG_CheckStrIsEmpty(self.sendNumTextFiled.text)) {
        NSString *str = [NSString ug_bySubtractFormatWithMultiplier:self.availableBalance multiplicand:self.sendNumTextFiled.text];
        if ([str floatValue]<0) {
            [self.view ug_showToastWithToast:@"您的余额不足，请前往【交易】获取更多UG币！"];
            return;
        }
    }
    NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG;
    NSString *cnyStr =  [NSString ug_positiveFormatWithMultiplier:self.sendNumTextFiled.text multiplicand:cnyRate scale:6 roundingMode:NSRoundDown];
    NSString *cnyCost=[cnyStr ug_amountFormat];
    //检查是否需要实名或高级认证
    if (![self checkMoneyNeedToValidation:cnyCost]) {
        [self checkAloginNameReal];
    }
}

-(void)checkAloginNameReal{
    [self.view ug_showMBProgressHudOnKeyWindow];
    @weakify(self);
    UGCheckAloginNameRealNameApi *api = [[UGCheckAloginNameRealNameApi alloc] init];
    api.aloginName = self.acceptUserTextFiled.text;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        [self.view ug_hiddenMBProgressHudOnKeyWindow];
        BOOL isCan = [object boolValue];
        if(object){
            if ( ! isCan) {
                [self.view ug_showToastWithToast:@"接收方用户未进行实名，暂无法收币"];
            }else {
                [self commision];
            }
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark- 符合条件提交转币
-(void)commision{
    //发送
    UGHomeTransPayVC *pay = [[UGHomeTransPayVC alloc] init];
    pay.aloginName =self.acceptUserTextFiled.text;
    pay.apayCardNo = self.acceptTextFiled.text;
    pay.tradeAmount= self.sendNumTextFiled.text;
    pay.tradeUgNumber = self.sendNumTextFiled.text;
    pay.remark = self.textView.text;
    pay.chengePay =  [[NSString stringWithFormat:@"%f",[self.payRateModel.payRate doubleValue]*[self.sendNumTextFiled.text doubleValue]] ug_amountFormat];
    BOOL  isCtoB = self.qrModel && !UG_CheckStrIsEmpty(self.qrModel.orderType) && [self.qrModel.orderType isEqualToString:@"1"];
     pay.orderType= isCtoB ? self.qrModel.orderType : @"0";
    //商户
    if (isCtoB) {
        pay.merchNo=!UG_CheckStrIsEmpty(self.qrModel.merchNo) ? self.qrModel.merchNo : @"";
        pay.orderSn=!UG_CheckStrIsEmpty(self.qrModel.orderSn) ? self.qrModel.orderSn : @"";
        pay.extra=!UG_CheckStrIsEmpty(self.qrModel.extra) ? self.qrModel.extra : @"";
    }
    [self.navigationController pushViewController:pay animated:YES];
}

#pragma amrk - 人民币对UG的汇率
-(void)getUGTOCny{
   if(UG_CheckStrIsEmpty(((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG))
   {
        UGExchangeRateApi *api = [[UGExchangeRateApi alloc] init];
        api.urlArm = @"cny/ug";
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            if(!apiError)
                ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG=(NSString *)object;
            else {
                [self.view ug_showToastWithToast:apiError.desc];
            }
        }];
    }
}

- (void)getWalletData {
    @weakify(self);
    [self getWalletData:^(UGApiError *apiError, id object) {
        @strongify(self);
        if (object){
            self.listData = [UGWalletAllModel mj_objectArrayWithKeyValuesArray:object];
            if (self.listData.count>0) {
                self.model = self.listData[0];
                self.availableBalance = self.model.balance;
                [self loadData];
            }
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark -暂时用到的请求方式 获取转币费率
-(void)request{
    UGPayRateApi *api = [[UGPayRateApi alloc] init];
    api.rateType = @"0";
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if(!apiError){
             self.payRateModel = [UGPayRateModel mj_objectWithKeyValues:object];
            if (self.payRateModel) {
                self.rateStrs = [NSString ug_addFormatWithMultiplier:self.payRateModel.payRate multiplicand:@"1"];
            }
        }
        else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
        [self updateUI];
    }];
}

-(void)updateUI{
    if (self.listData.count>0) {
        BOOL  isCtoB = self.qrModel && !UG_CheckStrIsEmpty(self.qrModel.orderType) && [self.qrModel.orderType isEqualToString:@"1"];
        if (!UG_CheckStrIsEmpty(self.rateStrs) &&  ! isCtoB) {
            UGWalletAllModel *walletModel = self.listData.firstObject;
            self.availableBalance = [NSString ug_positiveFormatWithDivisor:walletModel.balance dividend:self.rateStrs scale:6];
            self.sendNumTextFiled.placeholder =[NSString stringWithFormat:@"最多可转出 %@ %@",self.availableBalance, !UG_CheckStrIsEmpty(self.model.coinId) ? self.model.coinId : @"UG" ];
            if (self.payRateModel) {
                NSString *rateStr =  [NSString ug_positiveFormatWithMultiplier:! UG_CheckStrIsEmpty(self.sendNumTextFiled.text) ? self.sendNumTextFiled.text : @"0" multiplicand:self.payRateModel.payRate scale:6 roundingMode:NSRoundDown];
                self.balanceAndServiceChargeLabel.text = [NSString stringWithFormat:@"手续费: %@ %@（费率%@）", [rateStr ug_amountFormat],!UG_CheckStrIsEmpty(self.model.coinId) ? self.model.coinId : @"UG",self.payRateModel.payRateStr];
            }else {
                self.balanceAndServiceChargeLabel.text = [NSString stringWithFormat:@"手续费: %@ %@（费率%@）",@"0",!UG_CheckStrIsEmpty(self.model.coinId) ? self.model.coinId : @"UG",@"0%"];
            }
        }else{
            if (self.model) {
                self.availableBalance = self.model.balance;
            }
        }
    }
}

@end
