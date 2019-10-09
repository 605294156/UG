//
//  TOCBuyDetailViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "TOCBuyDetailViewController.h"
#import "OTCWaitingForPayVC.h"
#import "OTCSellCoinViewController.h"
#import "UGButton.h"
#import "TXLimitedTextField.h"
#import "UGPayMethodView.h"
#import "UGOTCBuyApi.h"
#import "UGOTCPreApi.h"
#import "UGPayWaySettingViewController.h"
#import "UGBaseViewController+UGGuidMaskView.h"
#import "MXRGuideMaskView.h"
#import "UGNewGuidStatusManager.h"

@interface TOCBuyDetailViewController ()
@property (weak, nonatomic) IBOutlet TXLimitedTextField *inputTextField;
@property (weak, nonatomic) IBOutlet UGButton *confirmBtn;
@property (weak, nonatomic) IBOutlet UIButton *allButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *confirmConstraint;


@property (weak, nonatomic) IBOutlet UIImageView *headImageView;//头像
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//用户名
@property (weak, nonatomic) IBOutlet UGPayMethodView *payModeView;//支付方式
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;//总价UG
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;//单价 例如：单价：￥46,900.00
@property (weak, nonatomic) IBOutlet UILabel *topLimitedLabel;//限量 例如：限量：500.00—1000.00 CNY
@property (weak, nonatomic) IBOutlet UILabel *behaviorLabel;//例如：出售数量 、购买数量

@property (weak, nonatomic) IBOutlet UILabel *limitedLabel;//限量 例如：限量：500.00—1000.00 CNY 暂不显示

@property (weak, nonatomic) IBOutlet UILabel *cnyTotalPriceLabel;//人民币总价 例如：1000000.00 CNY
@property (weak, nonatomic) IBOutlet UILabel *coinTotalPriceLabel;//数字货币总价 例如：0.11111111 BTC

@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;//备注 例如：我是卖家哦，请注意转账安全事宜！


@property(nonatomic ,strong) NSString *money;//计算出来的法币总金额
@property(nonatomic ,strong) NSString *amount;//计算出来的数字货币总金额

@property(nonatomic, strong) NSString *maxTradableAmount;//最大可购买的数量。后台返回

@property (nonatomic,strong) MXRGuideMaskView *maskView1;
@property (nonatomic,strong) MXRGuideMaskView *maskView2;

@property (nonatomic,assign) BOOL isShow;

@end

@implementation TOCBuyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = self.isBuy ? @"购买" : @"出售";
    self.behaviorLabel.text = self.isBuy ? @"出售数量" : @"购买数量";
    [self setupeEmptyView];
    [self sendMaxTradableAmountRequest];
    self.confirmBtn.buttonStyle = UGButtonStyleBlue;
    self.confirmConstraint.constant += UG_SafeAreaBottomHeight;
    [self.confirmBtn setTitle:self.isBuy ? @"确认购买" : @"确认卖出" forState:UIControlStateNormal];
    [self.allButton setTitle:self.isBuy ? @"全部买入" : @"全部卖出" forState:UIControlStateNormal];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(inputTextChange:) name:UITextFieldTextDidChangeNotification object:self.inputTextField];
    self.money = @"0";
    self.amount = @"0";
    [self.inputTextField addTarget:self action:@selector(textfieldAction:) forControlEvents:UIControlEventEditingDidEnd];
    [self.inputTextField addTarget:self action:@selector(textfieldValueChange:) forControlEvents:UIControlEventEditingChanged];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
}

#pragma mark -隐藏新手指引
-(void)hidenShowGuideView{
    if (self.maskView1) {
        [self.maskView1 dismissMaskView];
        self.maskView1 = nil;
    }
    
    if (self.maskView2) {
        [self.maskView2 dismissMaskView];
        self.maskView2 = nil;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [self hidenShowGuideView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (![[UIViewController currentViewController] isKindOfClass:[TOCBuyDetailViewController class]]) {
        return;
    }
    if (self.isBuy && ![[NSUserDefaultUtil GetDefaults:@"haveIsBuyGuidView"] isEqualToString:@"1"] && ![[UGNewGuidStatusManager shareInstance].OTCBuyStatus isEqualToString:@"1"] && !self.isShow) {
        //完成显示记录状态
        @weakify(self);
        self.isShow = YES;
        [self setupOTCBuyOrSellNewGuideView:self.isBuy WithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
            @strongify(self);
            self.maskView1 = maskView;
        }];
    }
    
    if(!self.isBuy && ![[NSUserDefaultUtil GetDefaults:@"haveIsSellGuidView"] isEqualToString:@"1"] && ![[UGNewGuidStatusManager shareInstance].OTCSellStatus isEqualToString:@"1"] && !self.isShow){
        //完成显示记录状态
        @weakify(self);
        self.isShow = YES;
        [self setupOTCBuyOrSellNewGuideView:self.isBuy WithBlock:^(MXRGuideMaskView * _Nonnull maskView) {
            @strongify(self);
            self.maskView2 = maskView;
        }];
    }
}

- (void)setupeEmptyView {
    UIView *view = [UIView new];
    view.backgroundColor = self.view.backgroundColor;
    LYEmptyView*emptyView = [LYEmptyView emptyViewWithCustomView:view];
    emptyView.emptyViewIsCompleteCoverSuperView = YES;
    self.view.ly_emptyView = emptyView;
    [self.view ly_showEmptyView];
}

#pragma mark - 获取最大可购买量
- (void)sendMaxTradableAmountRequest {
    [MBProgressHUD ug_showHUDToView:self.view];
    UGOTCPreApi *api = [UGOTCPreApi new];
    api.advertiseId = self.model.ID;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDForView:self.view];
        [self.view ly_hideEmptyView];
        if ([object isKindOfClass:[NSDictionary class]]) {
            if (object[@"maxTradableAmount"]) {
                self.maxTradableAmount = [NSString stringWithFormat:@"%@",object[@"maxTradableAmount"]];
            }
        }
        //更新UI数据
        [self updateViewsData];
    }];
}

//更新UI数据
- (void)updateViewsData {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.model.avatar]];
    self.nameLabel.text = self.model.username;
    self.payModeView.payWays = [self.model.payMode componentsSeparatedByString:@","];
    self.totalLabel.text = [NSString stringWithFormat:@"%@ UG",self.model.remainAmount];
    self.priceLabel.text = [NSString stringWithFormat:@"单价：1 UG = %@ 元", [self.model.price ug_amountFormat]];
    self.topLimitedLabel.text = [NSString stringWithFormat:@"限量：%@ - %@ 元", self.model.minLimit, self.model.maxLimit];
    self.limitedLabel.text = [NSString stringWithFormat:@"限量：%@ - %@ 元", self.model.minLimit, self.model.maxLimit];
    self.remarksLabel.text = self.model.remark.length > 0 ? self.model.remark : @"无";

    //设置右边显示
    self.inputTextField.rightViewMode = UITextFieldViewModeAlways;
    UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 12)];
    rightLabel.textAlignment = NSTextAlignmentLeft;
    rightLabel.font = [UIFont systemFontOfSize:12];
    rightLabel.text = @"元";
    
    self.inputTextField.placeholder = [NSString stringWithFormat:@"最大可%@%@ CNY", self.isBuy ? @"买入"  : @"卖出" , [self maxInput]];

    rightLabel.mj_w = [rightLabel sizeThatFits:CGSizeMake(100, 12)].width +10;
    self.inputTextField.rightView = rightLabel;

    self.cnyTotalPriceLabel.text =  [NSString stringWithFormat:@"%@ 元", self.money];
    self.coinTotalPriceLabel.text =  [NSString stringWithFormat:@"%@ %@", self.amount, self.model.coinName];
}

- (IBAction)clickConfirm:(UGButton *)sender {

    if ([self.inputTextField.text doubleValue] < [[self minInput] doubleValue]) {
        [self.view ug_showToastWithToast:[NSString stringWithFormat:@"最低购买金额不能低于%@",[self minInput]]];
        return;
        
    } else if ([self.money doubleValue] <= 0 && [self.amount doubleValue] <= 0) {
        [self.view ug_showToastWithToast: self.isBuy ? @"请输入购买金额" : @"请输入出售个数"];
        return;
    }
    
    //未绑定谷歌验证器   //2.0换手机号
//    if (![self hasBindingGoogleValidator]) {
//        return;
//    }

    
    //购买金额 200 以上需要检查是否实名认证、高级认证
    if ([self checkMoneyNeedToValidation:self.money]) {
        return;
    }
    
    //检查当前用户的支付方式是否和卖家的匹配
    if (![self checkPayModeMatch]) {
        return;
    }
    
    NSString *title = self.isBuy ? @"确认购买" : @"确认出售";
    NSString *message = self.isBuy ? [self upDataMessage:@"forbidTips" WithMessage:@"下单后，请于30分钟内进行付款，否则订单将会自动取消。当日累两笔取消，将禁止交易24小时！"]  : [self upDataMessage:@"creditTips" WithMessage:@"下单后，注意查收订单信息，请于买家付款后120分钟内进行放币，否则将影响您的信用值！"] ;
    @weakify(self);
    [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:title message:message cancle:@"我知道了" others:nil handle:^(NSInteger buttonIndex, UIAlertAction *action) {
        @strongify(self);
        //购买接口
        [self sendRequest];
    }];
}

//检查支付方式是否匹配
- (BOOL)checkPayModeMatch {
    if (!self.isBuy && ![self.model checkPayModeMatch] ) {
        @weakify(self);
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:@"绑定支付方式" message:[NSString stringWithFormat:@"您的支付方式与买家不匹配（%@），请前往绑定！",[self.model machPayModelStr]]  cancle:@"取消" others:@[@"确定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            if (buttonIndex == 1) {
                @strongify(self);
                [self.navigationController pushViewController:[UGPayWaySettingViewController new] animated:YES];
            }
        }];
        return NO;
    }
    return YES;
}

#pragma mark - 网络请求
- (void)sendRequest {
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOTCBuyApi *api = [UGOTCBuyApi new];
    api.isBuy = self.isBuy;
    api.advertisingId = self.model.ID;
    api.coinId = self.model.coinId;
    api.amount =  self.amount;
    api.money = self.money;
    api.price = self.model.price;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if ([object isKindOfClass:[NSDictionary class]]) {
            if (object[@"orderNo"]) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"刷新OTC列表" object:nil];
                if (self.isBuy ) { //购买
                    OTCWaitingForPayVC *buyVC = [OTCWaitingForPayVC new];
                    buyVC.orderSn = object[@"orderNo"];
                    [self.navigationController pushViewController:buyVC animated:YES];
                } else { //出售
                    OTCSellCoinViewController *sell = [OTCSellCoinViewController new];
                    sell.orderSn = object[@"orderNo"];
                    [self.navigationController pushViewController:sell animated:YES];
                }
            }
            //后台返回改交易剩余数量
            if (object[@"remainAmount"]) {
                self.model.remainAmount = [NSString stringWithFormat:@"%@",object[@"remainAmount"]];
            }
        }  else {
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

- (IBAction)clickBuyAll:(UIButton *)sender {
    //最大值
    self.inputTextField.text = [self maxInput];
    [self updateTotalText:self.inputTextField.text];
}


#pragma mark - 输入文本变化
- (void)inputTextChange:(NSNotification *)sender {
    UITextField *textFiled = sender.object;
    if (textFiled == self.inputTextField) {
        //最大值
        NSString *maxInput = [self maxInput];
        NSDecimalNumber *inuputNumber = [NSDecimalNumber decimalNumberWithString:textFiled.text];
        NSDecimalNumber *maxNumber = [NSDecimalNumber decimalNumberWithString:maxInput];
        NSComparisonResult result = [inuputNumber compare:maxNumber];
        
//        //最小值
//        NSString *minInPut = [self minInput];
//        NSComparisonResult minResult = [inuputNumber compare:[NSDecimalNumber decimalNumberWithString:minInPut]];
        
        if (result == NSOrderedDescending ) {//输入框大于最大值
            self.inputTextField.text = maxInput;
        }
//        else if (minResult == NSOrderedAscending) {//小于
//            self.inputTextField.text = minInPut;
//        }
        
        [self updateTotalText:textFiled.text];
    }
}

#pragma mark - 显示总价
- (void)updateTotalText:(NSString *)inputText {
    if ([inputText floatValue] > 0) {
        self.money = [NSString ug_positiveFormatWithDivisor:inputText dividend:@"1" scale:6];
        self.amount =  [NSString ug_positiveFormatWithDivisor:inputText dividend:self.model.price scale:6];
    } else {
        self.money = @"0";
        self.amount = @"0";
    }
    self.cnyTotalPriceLabel.text =  [NSString stringWithFormat:@"%@ 元", [self.money ug_amountFormat]];
    self.coinTotalPriceLabel.text =  [NSString stringWithFormat:@"%@ %@",[self.amount ug_amountFormat], self.model.coinName];
}

- (IBAction)tap:(UITapGestureRecognizer *)sender {
    [self.view endEditing:YES];
}

- (NSString *)maxInput {
    
    //最大可购买数量，后台获取到就取后台的。取不到就用剩余数量
    NSString *maxAmount = self.maxTradableAmount != nil ? self.maxTradableAmount : self.model.remainAmount;
    
    //剩余数量*单价 = 最大可购买CNY  结果只舍不入
    NSString *maxString =  [NSString ug_positiveFormatWithMultiplier:maxAmount multiplicand:self.model.price scale:6 roundingMode:NSRoundDown];
    
    NSDecimalNumber *inuputNumber = [NSDecimalNumber decimalNumberWithString:maxString];
    
    //卖家限制单笔最大可购买CNY
    NSDecimalNumber *maxNumber = [NSDecimalNumber decimalNumberWithString:self.model.maxLimit];

    NSComparisonResult result = [inuputNumber compare:maxNumber];
    //可购买 > 限制单笔购买
    if (result == NSOrderedDescending ) {
        maxString = [maxNumber stringValue];
    }
    return [NSString stringWithFormat:@"%@", [maxString ug_amountFormat]];
}


- (NSString *)minInput {
    //单笔限制最低CNY
    return self.model.minLimit;
}


- (void)textfieldValueChange:(UITextField *)textField {
    //第一位数是.
    if (textField.text.length > 0) {
        NSString *firstStr = [textField.text substringToIndex:1];
        if ([firstStr isEqualToString:@"."]) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
}

- (void)textfieldAction:(UITextField *)textField {
    //最后一位数是.
    NSString *lastStr = [textField.text substringWithRange:NSMakeRange(textField.text.length - 1, 1)];
    if ([lastStr isEqualToString:@"."]) {
        textField.text = [textField.text substringToIndex:textField.text.length - 1];
    }
}


- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
