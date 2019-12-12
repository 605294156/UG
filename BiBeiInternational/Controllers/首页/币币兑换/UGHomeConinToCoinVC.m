//
//  UGHomeConinToCoinVC.m
//  BiBeiInternational
//
//  Created by conew on 2014/10/19.
//  Copyright © 2014年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeConinToCoinVC.h"
#import "TransactionRecordViewController.h"
#import "AppDelegate.h"
#import "UGCenterPopView.h"
#import "PopView.h"
#import "TradeNetManager.h"
#import "marketManager.h"
#import "UGCoinListApi.h"
#import "UGBaseSymbolMapModel.h"
#import "UGExchangeRateApi.h"
#import "UGGeneralCertificationVC.h"
#import "UGAdancedCertificationVC.h"
#import "UGCommissionPopView.h"
#import "UGCoinToCoinApi.h"
#import "UGSubmissionApi.h"
#import "UGGetSingleWalletAssetApi.h"
#import "UGBaseViewController+UGGuidMaskView.h"
#import "MXRGuideMaskView.h"
#import "UGNewGuidStatusManager.h"

@interface UGHomeConinToCoinVC ()<UITextFieldDelegate>{
    int _baseCoinScale;//精确度(小数点后几位)
    int _coinScale;
}
@property(nonatomic,copy)NSString *changeRate;//币币间的汇率
@property(nonatomic,copy)NSString *serviceCharge; //手续费
@property(nonatomic,assign)BOOL hasChange;//是否转换
@property(nonatomic,copy)NSString *baseCoinName;
@property(nonatomic,copy)NSString *exCoinName;
@property(nonatomic,copy)NSString *sellprice1;
@property(nonatomic,copy)NSString *sellprice2;
@property(nonatomic,strong)UGCenterPopView *sellPopView;
@property(nonatomic,strong)UGCenterPopView *exchangePopView;
@property(nonatomic,copy)NSString *sellStr;//卖出币
@property(nonatomic,copy)NSString *exchangeStr;//兑换币

@property (nonatomic,strong)NSDictionary *dataDict;//获取基础币对列表
@property (nonatomic,strong)NSArray *baseArray;//基础币key列表
@property (nonatomic,strong)NSMutableArray *coinArray;//兑换币key列表
@property (nonatomic,strong)NSMutableArray *currentArray;//当前基础币的 兑换币种列表
@property (nonatomic,strong)UGBaseSymbolMapModel *currentModel;//当前兑换模型
@property (nonatomic,assign)double baseCoinNum;//当前卖出币种UG钱包情况
@property (nonatomic,assign) BOOL isable;//是否可以互换
@property (nonatomic,copy)NSString  *cnyRate;
@property (nonatomic,strong)MXRGuideMaskView *maskView;
@property (nonatomic,assign)BOOL isShow;
@end

@implementation UGHomeConinToCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.isable = NO;
    
    [self languageChange];
    
    [self getBaseCoin];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
}

#pragma mark -隐藏新手指引
-(void)hidenShowGuideView{
    if (self.maskView) {
        [self.maskView dismissMaskView];
        self.maskView = nil;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![[UGManager shareInstance] hasLogged]) {
        [self showLoginViewController];
    }
    if (![[NSUserDefaultUtil GetDefaults:@"haveConinChange"] isEqualToString:@"1"] && ![[UGNewGuidStatusManager shareInstance].CoinToCoinStatus isEqualToString:@"1"] && !self.isShow) {
        if (![[UIViewController currentViewController] isKindOfClass:[UGHomeConinToCoinVC class]]) {
            return;
        }
        @weakify(self);
        self.isShow = YES;
        [self setupConinChangeNewGuideViewWithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
            @strongify(self);
            self.maskView = maskView;
        }];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hidenShowGuideView];
}

-(void)languageChange{
    self.title = @"币币兑换";
    self.hasChange = NO;
    self.sellNumField.delegate = self;
    [self.sellNumField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    self.exchangeNumField.delegate = self;
    [self.exchangeNumField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 获取基本币列表
-(void)getBaseCoin{
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGCoinListApi *api = [[UGCoinListApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)object;
                self.baseArray = [dict allKeys];
                self.dataDict = object;
                 if (self.baseArray.count>0 && self.dataDict)
                 {
                     [self initUIWithBase:self.baseArray[0]];
                 }
            }
        }else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark- 获取对应兑换列表
-(void)initUIWithBase:(NSString *)baseStr{
    self.sellStr= baseStr;
    [self getBasewalletwithcoin:self.sellStr];
    self.currentArray = [UGBaseSymbolMapModel mj_objectArrayWithKeyValuesArray:[self.dataDict objectForKey:self.sellStr]];
    if (self.currentArray.count>0) {
        self.currentModel =self.currentArray[0];
        self.exchangeStr = self.currentModel.coinSymbol;
        [self.coinArray removeAllObjects];
        [self.currentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UGBaseSymbolMapModel *model = (UGBaseSymbolMapModel *)obj;
            [self.coinArray addObject:model.coinSymbol];
        }];
        [self getScale];
    }
}

#pragma mark-查询baseUG钱包情况
-(void)getBasewalletwithcoin:(NSString*)coin  {
    UGGetSingleWalletAssetApi *api = [[UGGetSingleWalletAssetApi alloc] init];
    api.coin = coin;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            NSDictionary*dict=(NSDictionary*)object;
            NSString *balance = [NSString stringWithFormat:@"%.6f",[dict[@"balance"] doubleValue]];
            self.baseCoinNum = [balance  doubleValue];
        }else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark- 获取币币的汇率
-(void)getScale{
     [MBProgressHUD ug_showHUDToKeyWindow];
    UGCoinToCoinApi *api = [[UGCoinToCoinApi alloc] init];
    api.fromUnit =self.sellStr;
    api.toUnit =self.exchangeStr;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (object) {
            NSString *strs = [NSString stringWithFormat:@"%@",object];  //   [ToolUtil stringFromNumber:[(NSString *)object doubleValue] withlimit:8];
            self.changeRate =[strs ug_amountFormat];;
            [self changeUI];
        }else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark- 获取人民币汇率
-(void)getCNYRate:(NSString *)cnyRateStr{
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGExchangeRateApi *api = [[UGExchangeRateApi alloc] init];
    api.urlArm =cnyRateStr;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (object) {
            if ([object isEqualToString:@"0E-8"]) {
                self.cnyRate = @"0.0";
            }else{
                 NSString *strs = [NSString stringWithFormat:@"%@",object];
                self.cnyRate = [strs ug_amountFormat];;
            }
        }else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

#pragma mark- 改变UI 显示
-(void)changeUI{
    self.exchangeRateLabel.text = [NSString stringWithFormat:@"汇率：1%@=%@%@",self.currentModel.baseSymbol,self.changeRate,self.currentModel.coinSymbol];
    [self.UGCBtn setTitle:self.sellStr forState:UIControlStateNormal];
    [self.BTCBtn setTitle:self.exchangeStr forState:UIControlStateNormal];
    if (!UG_CheckStrIsEmpty(self.sellNumField.text)) {
//        self.exchangeNumField.text = [NSString stringWithFormat:@"%.6f",[self.sellNumField.text doubleValue] *_changeRate];
//        self.exchangeNumField.text = [NSString  ug_positiveFormatWithMultiplier:self.exchangeNumField.text multiplicand:self.changeRate scale:6 roundingMode:NSRoundDown];
        self.sellNumField.text = @"";
        self.exchangeNumField.text = @"";
    }
    //获取当前基础币对人民币的汇率
    [self getCNYRate:[NSString stringWithFormat:@"CNY/%@",self.sellStr]];
    //获取当前卖出币钱包金额够不够
    [self getBasewalletwithcoin:self.sellStr];
}

#pragma mark- 获取当前model
-(void)getCurrentModel:(NSString *)str{
    if (self.currentArray.count<=0)
        return;
    [self.currentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UGBaseSymbolMapModel *model = (UGBaseSymbolMapModel *)obj;
        if ([model.coinSymbol isEqualToString:str]) {
            self.currentModel = model;
        }
    }];
    self.exchangeStr = self.currentModel.coinSymbol;
    [self getScale];
}

#pragma mark- 监听键盘的变化
-(void)textFieldDidChange:(UITextField *)textField{
    if (UG_CheckStrIsEmpty(textField.text)) {
         self.exchangeNumField.text = @"";
         self.sellNumField.text = @"";
        return;
    }
    if (textField.tag == 10001) {
        //self.exchangeNumField.text = [NSString stringWithFormat:@"%.6f",[self.sellNumField.text doubleValue] *_changeRate];
         self.exchangeNumField.text = [NSString  ug_positiveFormatWithMultiplier:self.sellNumField.text multiplicand:self.changeRate scale:6 roundingMode:NSRoundDown];
    }else{
        NSString *str = @"0";
        if ([self.changeRate floatValue]>0) {
//          str =  [NSString  ug_positiveFormatWithDivisor:@"1" dividend:self.changeRate scale:6 ];
              self.sellNumField.text = [NSString  ug_positiveFormatWithDivisor:self.exchangeNumField.text dividend:self.changeRate scale:6 ];
        }
//        self.sellNumField.text = [NSString  ug_positiveFormatWithMultiplier:self.exchangeNumField.text multiplicand:str scale:6 roundingMode:NSRoundDown];
    }
}

#pragma mark -卖出币选择
- (IBAction)sellTypeSelecte:(id)sender {
    [self.sellNumField resignFirstResponder];
    [self.exchangeNumField resignFirstResponder];
    if (self.baseArray.count<=0)
        return;
    @weakify(self);
    [UGCenterPopView showPopViewWithTitle:@"请选择币种" Titles:self.baseArray WithSelected:self.sellStr clickItemHandle:^(NSString * _Nonnull obj) {
    @strongify(self);
        [UGCenterPopView hidePopView];
        [self initUIWithBase:obj];
    }];
}
#pragma mark -兑换币选择
- (IBAction)exchengeTypeSelecte:(id)sender {
    if (self.coinArray.count<=0)
        return;
    [self.sellNumField resignFirstResponder];
    [self.exchangeNumField resignFirstResponder];
    @weakify(self);
    [UGCenterPopView showPopViewWithTitle:@"请选择币种" Titles:self.coinArray WithSelected:self.exchangeStr clickItemHandle:^(NSString * _Nonnull obj) {
        @strongify(self);
        [UGCenterPopView hidePopView];
        [self getCurrentModel:obj];
    }];
}

#pragma mark -交换按钮
- (IBAction)exchangeClick:(id)sender {
    self.hasChange = !self.hasChange;
    //1.获取当前兑换币的 兑换列表
       NSMutableArray *list= [UGBaseSymbolMapModel mj_objectArrayWithKeyValuesArray:[self.dataDict objectForKey:self.exchangeStr]];
   //2.判断当前基础币是否在当前兑换币的d可兑换列表中
    __weak typeof(self)weakself = self;
    [list enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UGBaseSymbolMapModel *model = (UGBaseSymbolMapModel *)obj;
        if ([model.coinSymbol isEqualToString:self.sellStr]) {
            weakself.isable = YES;
        }
    }];
    //3.根据isable 决定是否互换
    if(self.isable)
    {
        NSString *curentStr = self.sellStr;
        self.sellStr= self.exchangeStr;
        self.currentArray = [UGBaseSymbolMapModel mj_objectArrayWithKeyValuesArray:[self.dataDict objectForKey:self.sellStr]];
        [self.coinArray removeAllObjects];
        [self.currentArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UGBaseSymbolMapModel *model = (UGBaseSymbolMapModel *)obj;
            [self.coinArray addObject:model.coinSymbol];
        }];
        [self getCurrentModel:curentStr];                                        
    }else {
        [self.view ug_showToastWithToast:@"很抱歉，当前币对不支持互换！"];
    }
    self.isable = NO;
}



#pragma mark -确认兑换
- (IBAction)tureExchangeClick:(id)sender {
    if (UG_CheckStrIsEmpty(self.sellNumField.text) || [self.sellNumField.text doubleValue]==0) {
        [self.view ug_showToastWithToast:@"请输入数量"];
        return;
    }

    if ([self.sellNumField.text doubleValue]>self.baseCoinNum) {
        [self.view ug_showToastWithToast:@"当前币种钱包金额不足"];
        return;
    }
//    NSString *cnyCost =[[NSString stringWithFormat:@"%f",[self.sellNumField.text doubleValue] *self.cnyRate] ug_amountFormat];
    NSString  *cnyCost =[NSString ug_positiveFormatWithMultiplier:self.sellNumField.text multiplicand:self.cnyRate scale:6 roundingMode:NSRoundDown];
    
    //检查是否需要实名或高级认证
    if (![self checkMoneyNeedToValidation:cnyCost]) {
        NSArray *arrConten= @[LocalizationKey(@"Buy"),LocalizationKey(@"marketPrice"),[NSString stringWithFormat:@"%@ %@",@"-- ",self.currentModel.coinSymbol],[NSString stringWithFormat:@"%@ %@",[self.sellNumField.text ug_amountFormat],self.currentModel.baseSymbol]];
        [UGCommissionPopView showPopViewWithTitle:@"委托买入" Titles:arrConten WithTureBtn:@"确认委托"  clickItemHandle:^{
            [self commitBuyCommission:@"BUY"];
        }];
    }
}

#pragma mark - 提交委托
-(void)commitBuyCommission:(NSString*)str{
    UGSubmissionApi *api = [[UGSubmissionApi alloc] init];
    api.symbol =self.currentModel.symbol;
    api.price = @"0";
    api.amount =self.sellNumField.text;
    api.direction = str ;
    api.type =@"MARKET_PRICE";
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!apiError) {
             [self.view  ug_showToastWithToast:@"提交成功！"];
            self.sellNumField.text=@"";
            self.exchangeNumField.text=@"";
            __weak typeof(self)weakSelf = self;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popToRootViewControllerAnimated:YES];
            });
        }else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

-(NSArray *)baseArray{
    if (!_baseArray) {
        _baseArray = [[NSArray alloc] init];
    }
    return _baseArray;
}

-(NSMutableArray *)coinArray{
    if (!_coinArray) {
        _coinArray = [[NSMutableArray alloc] init];
    }
    return _coinArray;
}

-(NSMutableArray *)currentArray{
    if (!_currentArray) {
        _currentArray = [[NSMutableArray alloc] init];
    }
    return _currentArray;
}

- (void)ug_showToastWithToast:(NSString *)toast WithView:(UIView *)view {
    CSToastStyle *toastStyle = [[CSToastStyle alloc] initWithDefaultStyle];
    toastStyle.cornerRadius = 6.0f;
    toastStyle.backgroundColor = [UIColor colorWithHexString:@"000000" andAlpha:0.85f];
    toastStyle.messageFont = UGSystemFont(15);
    toastStyle.horizontalPadding = 13;
    toastStyle.verticalPadding = 13;
    [view ug_showToastWithToast:toast];
}

@end
