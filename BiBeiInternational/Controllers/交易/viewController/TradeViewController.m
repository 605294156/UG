//
//  TradeViewController.m
//  bit123
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "TradeViewController.h"
#import "commissionViewController.h"
#import "LeftMenuViewController.h"
#import "marketManager.h"
#import "KchatViewController.h"
#import "symbolModel.h"
#import "tradeCell.h"
#import "EntrustCell.h"
#import "UIView+LLXAlertPop.h"
#import "HomeNetManager.h"
#import "TradeNetManager.h"
#import "commissionModel.h"
#import "plateModel.h"
#import "MarketNetManager.h"
#import "AppDelegate.h"
#import "UGAddSelfSelectedVC.h"
#import "UGCommissionPopView.h"
#import "UGCnyToUsdtApi.h"
#import "UGSubmissionApi.h"
#import "UGGetSingleWalletAssetApi.h"
#import "UGOrderCancelApi.h"

#define Handicap 5  //买入卖出显示数量
@interface TradeViewController ()<UITextFieldDelegate,SocketDelegate>
{
    BOOL _IsMarketprice;//按市价交易;
    BOOL _IsSell;//卖出;
    double _usdRate;
    NSString* _baseCoinName;
    NSString* _ObjectCoinName;
    int _baseCoinScale;//精确度(小数点后几位)
    int _coinScale;
}
@property (nonatomic,strong) LeftMenuViewController *menu;
@property (weak, nonatomic) IBOutlet UITextField *PriceTF;
@property (weak, nonatomic) IBOutlet UILabel *CNYPrice;
@property (weak, nonatomic) IBOutlet UITextField *AmountTF;
@property (weak, nonatomic) IBOutlet UILabel *Useable;//可用
@property (weak, nonatomic) IBOutlet UILabel *TradeNumber;//委托额
@property (weak, nonatomic) IBOutlet UILabel *nowPrice;//现价
@property (weak, nonatomic) IBOutlet UILabel *nowCNY;
@property (weak, nonatomic) IBOutlet UIButton *TradeBtn;
@property (weak, nonatomic) IBOutlet UILabel *objectCoin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstant;
@property (nonatomic,strong)NSMutableArray *contentArr;
@property (nonatomic,strong)NSMutableArray *askcontentArr;//卖出数组
@property (nonatomic,strong)NSMutableArray *bidcontentArr;//买入数组
@property (weak, nonatomic) IBOutlet UIView *line1;
@property (weak, nonatomic) IBOutlet UIView *line2;
@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;
@property (weak, nonatomic) IBOutlet UILabel *plateLabel;
@property (weak, nonatomic) IBOutlet UILabel *pricelabel;
@property (weak, nonatomic) IBOutlet UILabel *amountlabel;
@property (weak, nonatomic) IBOutlet UILabel *currentLabel;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property (weak, nonatomic) IBOutlet UIButton *typeBtn;
@property (weak, nonatomic) IBOutlet UILabel *noDataLab;
@property (weak, nonatomic) IBOutlet UIScrollView *bgScrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@end

@implementation TradeViewController

- (NSMutableArray *)askcontentArr
{
    if (!_askcontentArr) {
        _askcontentArr = [NSMutableArray array];
    }
    return _askcontentArr;
}
- (NSMutableArray *)bidcontentArr
{
    if (!_bidcontentArr) {
        _bidcontentArr = [NSMutableArray array];
    }
    return _bidcontentArr;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.PriceTF setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
    [self.AmountTF setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
    [self getUSDTToCNYRate];
    self.edgesForExtendedLayout = UIRectEdgeNone;
//    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    self.navigationItem.title=!UG_CheckStrIsEmpty([marketManager shareInstance].symbol)?  [marketManager shareInstance].symbol:@"交易";
    
    [self setupNavItem];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadShowData:)name:CURRENTSELECTED_SYMBOL object:nil];
    [self setTablewViewHeard];
    NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
    _baseCoinName=[coinArray lastObject];
    _ObjectCoinName=[coinArray firstObject];
    [self.TradeBtn setTitle:[NSString stringWithFormat:@"%@%@",LocalizationKey(@"Buy"),!UG_CheckStrIsEmpty(_ObjectCoinName)? _ObjectCoinName:@""]forState:UIControlStateNormal];
    self.noDataLab.text = LocalizationKey(@"noTrustData");
    self.objectCoin.text=_ObjectCoinName;
    self.PriceTF.delegate=self;
    self.AmountTF.delegate=self;
    _IsMarketprice=NO;
    _IsSell=NO;
    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];//默认
    
    //现价的手势设置
    UITapGestureRecognizer *tapRecognizerNowPrice=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nowPriceTapClick)];
    self.nowPrice.userInteractionEnabled=YES;
    [self.nowPrice addGestureRecognizer:tapRecognizerNowPrice];
    [self makeUI];
    
      [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loginIn) name:@"LOGINSUCCES" object:nil];
}

#pragma mark- 登录后刷新数据
-(void)loginIn{
    [self getSingleAccuracy:[marketManager shareInstance].symbol];
    self.logBtn.hidden=YES;
    [self getCommissionData:[marketManager shareInstance].symbol];
}

#pragma mark - 导航栏左右按钮
- (void)setupNavItem {
    
    @weakify(self);
    [self setupBarButtonItemWithImageName:@"tradeLeft" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem *item) {
        @strongify(self);
        [self LefttouchEvent];
    }];
    
    [self setupBarButtonItemWithImageName:@"tradeRight" type:UGBarImteTypeRight callBack:^(UIBarButtonItem *item) {
        @strongify(self);
        [self RighttouchEvent];
    }];
    
}

//MARK:--添加滑动视图
-(void)makeUI{
    CGRect rect = self.bgView.frame;
    rect.size.width=kWindowW;
    rect.size.height = kWindowH;
    self.bgView.frame=rect;
    [self.bgScrollView addSubview:self.bgView];
    self.bgScrollView.contentSize=self.bgView.frame.size;
    self.buyBtn.selected = YES;
    self.buyBtn.layer.borderColor = UG_MainColor.CGColor;
}


//MARK:---现价的手势设置
-(void)nowPriceTapClick{
    if ([self.nowPrice.text floatValue] > 0) {
        self.PriceTF.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:[self.nowPrice.text floatValue] withlimit:_baseCoinScale]];
        NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
        self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f 元",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
    }
}

-(void)setTablewViewHeard{
    [self.asktableView registerNib:[UINib nibWithNibName:@"tradeCell" bundle:nil] forCellReuseIdentifier:@"tradeCell"];
    self.asktableView.tableFooterView=[UIView new];
    [self.bidtableView registerNib:[UINib nibWithNibName:@"tradeCell" bundle:nil] forCellReuseIdentifier:@"tradeCell"];
    self.bidtableView.tableFooterView=[UIView new];
    [self.entrusttableView registerNib:[UINib nibWithNibName:@"EntrustCell" bundle:nil] forCellReuseIdentifier:@"EntrustCell"];
    self.entrusttableView.tableFooterView=[UIView new];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    [self getSingleAccuracy:[marketManager shareInstance].symbol];
    if(!([[UGManager shareInstance] hasLogged])){
        self.logBtn.hidden=NO;
        self.noDataLabel.hidden=YES;
    }else{
        self.logBtn.hidden=YES;
        [self getCommissionData:[marketManager shareInstance].symbol];
    }
    
}

//MARK:--国际化通知处理事件
- (void)languageChange {
    [self.buyBtn setTitle:LocalizationKey(@"Buy") forState:UIControlStateNormal];
    [self.sellBtn setTitle:LocalizationKey(@"Sell") forState:UIControlStateNormal];
    [self.allBtn setTitle:LocalizationKey(@"all") forState:UIControlStateNormal];
    [self.logBtn setTitle:LocalizationKey(@"login") forState:UIControlStateNormal];
    self.plateLabel.text=LocalizationKey(@"plate");
    self.pricelabel.text=LocalizationKey(@"price");
    self.amountlabel.text=LocalizationKey(@"amount");
    self.currentLabel.text=LocalizationKey(@"Current");
    self.noDataLabel.text=LocalizationKey(@"noDada");
    if (_IsMarketprice) {
        [self.typeBtn setTitle:LocalizationKey(@"marketPrice") forState:UIControlStateNormal];
    }else{
        [self.typeBtn setTitle:LocalizationKey(@"limitPrice") forState:UIControlStateNormal];
    }
    self.PriceTF.placeholder=LocalizationKey(@"enterPrice");
    self.AmountTF.placeholder=LocalizationKey(@"commissionamount");
    self.Useable.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"usabel")];
    double tradeNumberDou = [self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue];
    NSString * tradeNumber = [ToolUtil removeFloatAllZeroByString:[NSString stringWithFormat:@"%.6f",tradeNumberDou]];
    self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"entrustment"),tradeNumber,_baseCoinName];
    [self.TradeBtn setTitle:[NSString stringWithFormat:@"%@%@",LocalizationKey(@"Buy"),!UG_CheckStrIsEmpty(_ObjectCoinName)? _ObjectCoinName:@"" ]forState:UIControlStateNormal];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    NSDictionary*dic;
    if (([[UGManager shareInstance] hasLogged])) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",[UGManager shareInstance].hostInfo.ID,@"uid",nil];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",nil];
    }
     [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_EXCHANGE_TRADE withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
     [SocketManager share].delegate=self;
}
#pragma mark-左侧弹出菜单
-(void)LefttouchEvent{
    if (!self.menu) {
        self.menu = [[LeftMenuViewController alloc]initWithNibName:@"LeftMenuViewController" bundle:nil];
        @weakify(self);
        self.menu.selectedClick = ^{
            @strongify(self);
            [self.navigationController pushViewController:[UGAddSelfSelectedVC new] animated:YES];
        };
        CGRect frame = self.menu.view.frame;
        frame.origin.x = - CGRectGetWidth(self.view.frame);
        self.menu.view.frame = CGRectMake(- CGRectGetWidth(self.view.frame), 0,  kWindowW, kWindowH);
        [[UIApplication sharedApplication].keyWindow addSubview:self.menu.view];
    }
    [self.menu showFromLeft];
}

#pragma mark-查看行情
-(void)RighttouchEvent{
    KchatViewController*klineVC=[[KchatViewController alloc]init];
    klineVC.symbol=[marketManager shareInstance].symbol;
    [self.navigationController pushViewController:klineVC animated:YES];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.asktableView]) {
        return self.askcontentArr.count;
    }else  if ([tableView isEqual:self.bidtableView]) {
        return self.bidcontentArr.count;
    }else{
        return self.contentArr.count;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:self.asktableView]) {
        tradeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tradeCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (self.askcontentArr.count>0 ) {
            plateModel*bidplatemodel=[[self.askcontentArr reverseObjectEnumerator] allObjects][indexPath.row];
            cell.kindName.text=[NSString stringWithFormat:@"%@%lu",LocalizationKey(@"sellplate"),self.askcontentArr.count-indexPath.row];
            if (bidplatemodel.price<0) {
                cell.priceLabel.text=@"--";
                cell.amountLabel.text=@"--";
                cell.amountLabel.textColor=[UIColor colorWithHexString:@"999999"];
                cell.priceLabel.textColor=[UIColor colorWithHexString:@"F86776"];;
            }else{
        
                cell.priceLabel.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:bidplatemodel.price withlimit:_baseCoinScale]];
                cell.amountLabel.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:bidplatemodel.amount withlimit:_coinScale]];
                cell.amountLabel.textColor=[UIColor colorWithHexString:@"999999"];
                cell.priceLabel.textColor=[UIColor colorWithHexString:@"F86776"];;
            }
        }
        return cell;
    }else if ([tableView isEqual:self.bidtableView]){
        tradeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"tradeCell" forIndexPath:indexPath];
        
        plateModel*askplatemodel=self.bidcontentArr[indexPath.row];
        cell.kindName.text=[NSString stringWithFormat:@"%@%ld",LocalizationKey(@"buyplate"),indexPath.row+1];
        if (askplatemodel.price<=0) {
            cell.priceLabel.text=@"--";
            cell.amountLabel.text=@"--";
            cell.amountLabel.textColor=[UIColor colorWithHexString:@"999999"];
            cell.priceLabel.textColor=[UIColor colorWithHexString:@"00C087"];;
        }else{
            cell.priceLabel.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:askplatemodel.price withlimit:_baseCoinScale]];
            cell.amountLabel.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:askplatemodel.amount withlimit:_coinScale]];
            
            cell.amountLabel.textColor=[UIColor colorWithHexString:@"999999"];
            cell.priceLabel.textColor=[UIColor colorWithHexString:@"00C087"];
        }
   
        return cell;
    }
    else{
        EntrustCell * cell = [tableView dequeueReusableCellWithIdentifier:@"EntrustCell" forIndexPath:indexPath];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        if (_contentArr.count>0) {
            [cell configModel:_contentArr[indexPath.row] withBaseCoinScale:_baseCoinScale withCoinScale:_coinScale];
        }
        cell.withDraw.tag=indexPath.row;
        [cell.withDraw addTarget:self action:@selector(withDraw:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if ([tableView isEqual:self.asktableView]||[tableView isEqual:self.bidtableView]) {
        return 23;
    }else{
        return 115;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_IsMarketprice) {
        //限价
        if ([tableView isEqual:self.asktableView]) {
            
            plateModel*bidplatemodel=[[self.askcontentArr reverseObjectEnumerator] allObjects][indexPath.row];
            if (bidplatemodel.price>=0) {
                self.PriceTF.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:bidplatemodel.price withlimit:_baseCoinScale]];
                NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
                self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f 元",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
            }
            
        }else if ([tableView isEqual:self.bidtableView]){
            if (self.bidcontentArr.count >0) {
                plateModel*askplatemodel=self.bidcontentArr[indexPath.row];
                if (askplatemodel.price>=0) {
                    self.PriceTF.text=[NSString stringWithFormat:@"%@",[ToolUtil stringFromNumber:askplatemodel.price withlimit:_baseCoinScale]];
                    NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
                    self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f 元",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
                }
            }
            
        }else{
            
        }
    }
}
#pragma mark-撤销
-(void)withDraw:(UIButton*)sender{
    commissionModel*model=self.contentArr[sender.tag];
    __weak TradeViewController*weakSelf=self;
    NSString*price;//委托价
    NSString*commissionAmount;//委托量
    NSString*commissionTotal;//委托总额
    if ([model.type isEqualToString:@"LIMIT_PRICE"]) {
        price=[NSString stringWithFormat:@"%.2f %@",[model.price doubleValue],model.baseSymbol];
        commissionAmount=[NSString stringWithFormat:@"%.2f %@",[model.amount doubleValue],model.coinSymbol];
        commissionTotal=[NSString stringWithFormat:@"%.2f %@",[model.price doubleValue]*[model.amount doubleValue],model.baseSymbol];
    }else{
        price=LocalizationKey(@"marketPrice");
        if ([model.direction isEqualToString:@"SELL"]) {
            commissionAmount=[NSString stringWithFormat:@"%.2f %@",[model.amount doubleValue],model.coinSymbol];
            commissionTotal=[NSString stringWithFormat:@"%@ %@",@"--",model.baseSymbol];
        }else{
            commissionAmount=[NSString stringWithFormat:@"%@ %@",@"--",model.coinSymbol];
            commissionTotal=[NSString stringWithFormat:@"%.2f %@",[model.amount doubleValue],model.coinSymbol];
        }
    }
    NSArray *contentArr= @[[model.direction isEqualToString:@"BUY"]==YES?LocalizationKey(@"Buy"):LocalizationKey(@"Sell"),price,commissionAmount,commissionTotal];

    [UGCommissionPopView showPopViewWithTitle:LocalizationKey(@"Confirmation") Titles:contentArr WithTureBtn:@"撤单"  clickItemHandle:^{
        [weakSelf cancelCommissionwithOrderID:model.orderId];//撤单
    }];
}

-(void)cancelCommissionwithOrderID:(NSString*)orderId{

    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOrderCancelApi *api= [[UGOrderCancelApi alloc] init];
    api.orderId = orderId;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (!apiError) {
            [self.view ug_showToastWithToast:@"撤单成功！"];
            [self getCommissionData:[marketManager shareInstance].symbol];
        }else
            [self.view ug_showToastWithToast:apiError.desc];
    }];
    
//    [TradeNetManager cancelCommissionwithOrderID:orderId CompleteHandle:^(id resPonseObj, int code) {
//        [EasyShowLodingView hidenLoding];
//        if (code) {
//            if ([resPonseObj[@"code"] integerValue] == 0) {
//                [self.view ug_showToastWithToast:resPonseObj[MESSAGE] ];
////                [self.contentArr enumerateObjectsUsingBlock:^(commissionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
////                    if ([obj.orderId isEqualToString:orderId]) {
////                        *stop = YES;
////                        [self.contentArr removeObject:obj];
////                        [self.entrusttableView reloadData];
////                    }
////                }];
//                [self getCommissionData:[marketManager shareInstance].symbol];
//            }else{
//                [self.view ug_showToastWithToast:resPonseObj[MESSAGE] ];
//            }
//        }else{
//            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus") ];
//        }
//
//    }];
}
#pragma mark-按钮点击事件
- (IBAction)touchEvents:(UIButton *)sender {
    switch (sender.tag) {
        case 100://买入
            {
                _IsSell=NO;
                self.AmountTF.text=@"";
                self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
                [self.TradeBtn setTitle:[NSString stringWithFormat:@"%@%@",LocalizationKey(@"Buy"),!UG_CheckStrIsEmpty(_ObjectCoinName)? _ObjectCoinName:@""] forState:UIControlStateNormal];
//                self.TradeBtn.backgroundColor=GreenColor;
                self.buyBtn.selected = YES;
                self.buyBtn.layer.borderColor = UG_MainColor.CGColor;
                self.sellBtn.selected = NO;
                self.sellBtn.layer.borderColor = [UIColor colorWithHexString:@"7EC9FF"].CGColor;
                NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                if (([[UGManager shareInstance] hasLogged])) {
               [self getBasewalletwithcoin:[coinArray lastObject]];
            }
            if (_IsMarketprice) {
                self.heightConstant.constant=0;
                self.PriceTF.text=LocalizationKey(@"Optimal");
                self.PriceTF.enabled=NO;
                self.AmountTF.placeholder=LocalizationKey(@"entrustment");
                self.objectCoin.text=_baseCoinName;
            }else{
                self.heightConstant.constant=45;
                self.PriceTF.text=self.nowPrice.text;
                self.PriceTF.enabled=YES;
                self.AmountTF.placeholder=LocalizationKey(@"amount");
                self.objectCoin.text=_ObjectCoinName;
            }
                NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
                self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f 元",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
            }
            break;
        case 101://卖出
        {
            _IsSell=YES;
            self.AmountTF.text=@"";
            self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
            [self.TradeBtn setTitle:[NSString stringWithFormat:@"%@%@",LocalizationKey(@"Sell"),!UG_CheckStrIsEmpty(_ObjectCoinName)? _ObjectCoinName:@""] forState:UIControlStateNormal];
//            self.TradeBtn.backgroundColor=RedColor;
            self.buyBtn.selected = NO;
            self.buyBtn.layer.borderColor = [UIColor colorWithHexString:@"7EC9FF"].CGColor;
            self.sellBtn.selected = YES;
            self.sellBtn.layer.borderColor = UG_MainColor.CGColor;
            NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
            if (([[UGManager shareInstance] hasLogged])) {
                [self getCoinwalletwithcoin:[coinArray firstObject]];
            }
            if (_IsMarketprice) {
                self.heightConstant.constant=0;
                self.PriceTF.text=LocalizationKey(@"Optimal");
                self.PriceTF.enabled=NO;
                self.AmountTF.placeholder=LocalizationKey(@"amount");
                self.objectCoin.text=_ObjectCoinName;
            }else{
                self.heightConstant.constant=45;
                self.PriceTF.text=self.nowPrice.text;
                self.PriceTF.enabled=YES;
                self.AmountTF.placeholder=LocalizationKey(@"amount");
                self.objectCoin.text=_ObjectCoinName;
            }
            NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
            self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f 元",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
        }
            break;
        case 102://限价Or市价
        {
            [self.PriceTF resignFirstResponder];
            [self.AmountTF resignFirstResponder];
            NSArray *arrayTitle = @[LocalizationKey(@"limitPrice"),LocalizationKey(@"marketPrice")];
            NSArray *colors = [NSArray new];
            if ([sender.currentTitle isEqualToString:LocalizationKey(@"limitPrice")])
                colors = @[UG_MainColor,[UIColor blackColor]];
            else
                colors = @[[UIColor blackColor],UG_MainColor];
            @weakify(self);
            [self.view createAlertViewTitleArray:arrayTitle textColor:colors font:[UIFont systemFontOfSize:16] type:0 actionBlock:^(UIButton * _Nullable button, NSInteger didRow) {
                [sender setTitle:button.currentTitle forState:UIControlStateNormal];
                @strongify(self);
                if (didRow==0) {
                    //限价
                    self.heightConstant.constant=45;
                    self->_IsMarketprice=NO;
                    self.PriceTF.text=self.nowPrice.text;
                    self.PriceTF.enabled=YES;
                    self.AmountTF.placeholder=LocalizationKey(@"amount");
                    self.objectCoin.text=self->_ObjectCoinName;
                    self.CNYPrice.hidden=NO;
                    self.TradeNumber.hidden=NO;
                    self.TradeNumber.hidden=NO;
                    self.line1.hidden=NO;
                    self.line2.hidden=NO;
                    self.AmountTF.text=@"";
                    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
                }else if (didRow==1){
                    //市价
                    self->_IsMarketprice=YES;
                    self.heightConstant.constant=0;
                    self.PriceTF.text=LocalizationKey(@"Optimal");
                    self.PriceTF.enabled=NO;
                    self.CNYPrice.hidden=YES;
                    self.TradeNumber.hidden=YES;
                    self.TradeNumber.hidden=YES;
                    self.line1.hidden=YES;
                    self.line2.hidden=YES;
                    self.AmountTF.text=@"";
                    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
                    if (!self->_IsSell) {
                        //买入
                        self.AmountTF.placeholder=LocalizationKey(@"entrustment");
                        self.objectCoin.text=self->_baseCoinName;
                    }else{
                        //卖出
                        self.AmountTF.placeholder=LocalizationKey(@"amount");
                        self.objectCoin.text=self->_ObjectCoinName;
                    }
                }
            }];
        }
            break;
        case 103://价格-
        {
            if ([self.PriceTF.text doubleValue]>0) {
             
                self.PriceTF.text=[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]-(1/(double)pow(10, _baseCoinScale)) withlimit:_baseCoinScale];//10的N次幂
                NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
                self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f 元",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
                double tradeNumberDou = [self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue];
                NSString * tradeNumber = [ToolUtil removeFloatAllZeroByString:[NSString stringWithFormat:@"%.6f",tradeNumberDou]];
                self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"entrustment"),tradeNumber,_baseCoinName];
            }
        }
            break;
        case 104://价格+
        {
            if ([self.PriceTF.text doubleValue]>=0) {
               self.PriceTF.text= [ToolUtil stringFromNumber:[self.PriceTF.text doubleValue]+(1/(double)pow(10, _baseCoinScale)) withlimit:_baseCoinScale];//10的N次幂
                NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
                self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f 元",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
                double tradeNumberDou = [self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue];
                NSString * tradeNumber = [ToolUtil removeFloatAllZeroByString:[NSString stringWithFormat:@"%.6f",tradeNumberDou]];
                self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"entrustment"),tradeNumber,_baseCoinName];
            }
        }
            break;
        case 105: //下单
        {
//            //没有做谷歌验证  先进行谷歌验证 //2.0换手机号
//            if (![self hasBindingGoogleValidator]) {
//                return;
//            }
            
            [self.PriceTF resignFirstResponder];
            [self.AmountTF resignFirstResponder];
            if (!_IsSell) { /*买入*/
                if (!_IsMarketprice) {
                    //限价买入
                    if ( [NSString stringIsNull:self.PriceTF.text]) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"enterprice")];
                        return;
                    }
                    if ([self.PriceTF.text doubleValue]<=0) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"commissionPricezero")];
                        return;
                    }
                    if ( [NSString stringIsNull:self.AmountTF.text]) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"pleasecommissionamount")];
                        return;
                    }
                    if ([self.AmountTF.text doubleValue]<=0) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"commissionamountzero")];
                        return;
                    }
                    if(!([[UGManager shareInstance] hasLogged])){
                        [self showLoginViewController];
                        return;
                    }
                    __weak typeof(self)weakSelf = self;
                    NSArray *contentArr= @[LocalizationKey(@"buyDirection"),[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName],[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[self.AmountTF.text doubleValue] withlimit:_coinScale],_objectCoin.text],[NSString stringWithFormat:@"%.6f %@",[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue],_baseCoinName]];
                    
                    [UGCommissionPopView showPopViewWithTitle:LocalizationKey(@"commissionbuy") Titles:contentArr WithTureBtn:@"确认委托"  clickItemHandle:^{
                        [weakSelf commitBuyCommission:@"BUY"];
                    }];
                }else{
                    //市价买入
                    if ( [NSString stringIsNull:self.AmountTF.text]) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"commissionmoney")];
                        return;
                    }
                    if ([self.AmountTF.text doubleValue]<=0) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"commissionmoneyzero")];
                        return;
                    }
                    if(!([[UGManager shareInstance] hasLogged])){
                        [self showLoginViewController];
                        return;
                    }
                    __weak typeof(self)weakSelf = self;
                    NSArray *contentArr= @[LocalizationKey(@"Buy"),LocalizationKey(@"marketPrice"),[NSString stringWithFormat:@"%@ %@",@"--",_ObjectCoinName],[NSString stringWithFormat:@"%.6f %@",[self.AmountTF.text doubleValue],_baseCoinName]];
                    
                    [UGCommissionPopView showPopViewWithTitle:LocalizationKey(@"commissionbuy") Titles:contentArr WithTureBtn:@"确认委托"  clickItemHandle:^{
                         [weakSelf commitBuyCommission:@"BUY"];
                    }];
                }
            }
            else{
             /*卖出*/
                if (!_IsMarketprice) {
                    //限价卖出
                    if ( [NSString stringIsNull:self.PriceTF.text]) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"pleaseenterPrice")];
                        return;
                    }
                    if ([self.PriceTF.text doubleValue]<=0) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"commissionPricezero")];
                        return;
                    }
                    if ( [NSString stringIsNull:self.AmountTF.text]) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"pleasecommissionamount")];
                        return;
                    }
                    if ([self.AmountTF.text doubleValue]<=0) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"commissionamountzero")];
                        return;
                    }
                    if(!([[UGManager shareInstance] hasLogged])){
                        [self showLoginViewController];
                        return;
                    }
                    __weak typeof(self)weakSelf = self;
                    NSArray *contentArr= @[LocalizationKey(@"sellDirection"),[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[self.PriceTF.text doubleValue] withlimit:_baseCoinScale],_baseCoinName],[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[self.AmountTF.text doubleValue] withlimit:_coinScale],_ObjectCoinName],[NSString stringWithFormat:@"%.6f %@",[self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue],_baseCoinName]];
                    
                    [UGCommissionPopView showPopViewWithTitle:LocalizationKey(@"commissionsell") Titles:contentArr WithTureBtn:@"确认委托" clickItemHandle:^{
                         [weakSelf commitBuyCommission:@"SELL"];
                    }];
                }
                else{
                    //市价卖出
                    if ( [NSString stringIsNull:self.AmountTF.text]) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"pleasecommissionamount")];
                        return;
                    }
                    if ([self.AmountTF.text doubleValue]<=0) {
                        [self.view ug_showToastWithToast:LocalizationKey(@"commissionamountzero")];
                        return;
                    }
                    if(!([[UGManager shareInstance] hasLogged])){
                        [self showLoginViewController];
                        return;
                    }
                    __weak typeof(self)weakSelf = self;
                    NSArray *contentArr= @[LocalizationKey(@"sellDirection"),LocalizationKey(@"marketPrice"),[NSString stringWithFormat:@"%@ %@",[ToolUtil stringFromNumber:[self.AmountTF.text doubleValue] withlimit:_coinScale],_ObjectCoinName],[NSString stringWithFormat:@"%@ %@",@"--",_baseCoinName]];
                    
                    [UGCommissionPopView showPopViewWithTitle:LocalizationKey(@"commissionsell") Titles:contentArr WithTureBtn:@"确认委托"  clickItemHandle:^{
                        [weakSelf commitBuyCommission:@"SELL"];
                    }];
                }
            }
        }
            break;
        case 106: //查看全部当前委托
        {
            if(!([[UGManager shareInstance] hasLogged])){
                [self showLoginViewController];
                return;
            }
            commissionViewController*commissionVC=[[commissionViewController alloc]init] ;
            commissionVC.coinScale = _coinScale;
            [self.navigationController pushViewController:commissionVC animated:YES];
        }
            break;
        default:
            break;
    }
}


#pragma mark-提交委托
-(void)commitBuyCommission:(NSString*)str{
    if (_IsMarketprice) {
        UGSubmissionApi *api = [[UGSubmissionApi alloc] init];
        api.symbol =[marketManager shareInstance].symbol;
        api.price = @"0";
        api.amount =self.AmountTF.text;
        api.direction = str ;
        api.type =@"MARKET_PRICE";
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            if (!apiError) {
                [self.view  ug_showToastWithToast:@"提交成功！"];
                self.PriceTF.text=LocalizationKey(@"Optimal");
                self.AmountTF.text=@"";
                self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
            }else
                [self.view ug_showToastWithToast:apiError.desc];
        }];
    }else{
        UGSubmissionApi *api = [[UGSubmissionApi alloc] init];
        api.symbol =[marketManager shareInstance].symbol;
        api.price = self.PriceTF.text;
        api.amount =self.AmountTF.text;
        api.direction = str ;
        api.type =@"LIMIT_PRICE";
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            if (!apiError) {
                [self.view  ug_showToastWithToast:@"提交成功！"];
                self.AmountTF.text=@"";
                self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
            }else
                [self.view ug_showToastWithToast:apiError.desc];
        }];
    }
    dispatch_after( dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5/*延迟执行时间*/ * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getCommissionData:[marketManager shareInstance].symbol];//刷新表格
        [self getAllCoinData:[marketManager shareInstance].symbol];//重新获取UG钱包余额
    });
}
#pragma mark-获取所有交易币种缩略行情
-(void)getAllCoinData:(NSString*)symbol {
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    
    @weakify(self);
    [HomeNetManager getsymbolthumbCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        @strongify(self);
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                NSArray*symbolArray=(NSArray*)resPonseObj;
                for (int i=0; i<symbolArray.count; i++) {
                    symbolModel*model = [symbolModel mj_objectWithKeyValues:symbolArray[i]];
                    if ([model.symbol isEqualToString:symbol]) {
                        NSArray *coinArray = [[marketManager shareInstance].symbol componentsSeparatedByString:@"/"];
                        self.nowPrice.text=[ToolUtil stringFromNumber:model.close withlimit:self->_baseCoinScale];
                        NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
                        self.nowCNY.text=[NSString stringWithFormat:@"≈%.2f 元",model.baseUsdRate*model.close*[cnyRate doubleValue]];
                        self->_usdRate=model.baseUsdRate;
                        if (!self->_IsMarketprice) {
                            self.PriceTF.text=[ToolUtil stringFromNumber:model.close withlimit:self->_baseCoinScale];
                            self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f 元",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*self->_usdRate];
                            self.heightConstant.constant=45;
                        }else{
                        self.heightConstant.constant=0;
                            self.PriceTF.text=LocalizationKey(@"Optimal");
                        }
                        if (model.change <0) {
                            self.nowPrice.textColor=RedColor;
                        }else{
                            self.nowPrice.textColor=GreenColor;
                        }
                        if (([[UGManager shareInstance] hasLogged])) {
                            if (!self->_IsSell) {
                                [self getBasewalletwithcoin:[coinArray lastObject]];
                            }else{
                                [self getCoinwalletwithcoin:[coinArray firstObject]];
                            }
                        }else{
                            
                        }
                    }
                }
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
#pragma mark-切换币种
-(void)reloadShowData:(NSNotification *)notif{
    
    self.navigationItem.title=[NSString stringWithFormat:@"%@/%@",notif.userInfo[@"object"],notif.userInfo[@"base"]];
   [self getData:[marketManager shareInstance].symbol];
   [self getSingleAccuracy:[marketManager shareInstance].symbol];
   _baseCoinName=notif.userInfo[@"base"];
   _ObjectCoinName=notif.userInfo[@"object"];
    self.AmountTF.text=@"";
    self.TradeNumber.text=[NSString stringWithFormat:@"%@--",LocalizationKey(@"entrustment")];
    [self.TradeBtn setTitle:[NSString stringWithFormat:@"%@%@",LocalizationKey(_IsSell ? @"Sell" : @"Buy"),!UG_CheckStrIsEmpty(_ObjectCoinName)? _ObjectCoinName:@""]forState:UIControlStateNormal];

    if (!_IsMarketprice) {
        //限价
         self.objectCoin.text=_ObjectCoinName;
    }else{
        //市价
        if (!_IsSell) {
            self.objectCoin.text=_baseCoinName;
        }else{
            self.objectCoin.text=_ObjectCoinName;
        }
    }
    NSDictionary*dic;
    if (([[UGManager shareInstance] hasLogged])) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",[UGManager shareInstance].hostInfo.ID,@"uid",nil];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",nil];
    }
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_EXCHANGE_TRADE withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    [SocketManager share].delegate=self;
    
    NSString*kind=notif.userInfo[@"kind"];
    if ([kind isEqualToString:@"buy"]) {
        //买入
        UIButton*buyBtn=(UIButton*)[self.view viewWithTag:100];
        [self touchEvents:buyBtn];
        
    }else if ([kind isEqualToString:@"sell"]){
        //卖出
        UIButton*sellBtn=(UIButton*)[self.view viewWithTag:101];
        [self touchEvents:sellBtn];
    }else{
        if (([[UGManager shareInstance] hasLogged])) {
            [self getCommissionData:[marketManager shareInstance].symbol];

        }
    }
}
#pragma mark-查询当前委托
-(void)getCommissionData:(NSString*)symbol{
    [self.contentArr removeAllObjects];
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [TradeNetManager Querythecurrentdelegatesymbol:symbol withpageNo:0 withpageSize:10 CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if (resPonseObj[@"content"]) {
                NSArray*contentArray=resPonseObj[@"content"];
                if (contentArray.count==0) {
                    [self.entrusttableView reloadData];
                    if (([[UGManager shareInstance] hasLogged])) {
                         self.noDataLabel.hidden=NO;
                    }
                    return ;
                }
                self.noDataLabel.hidden=YES;
                for (int i=0; i<contentArray.count; i++) {
                    commissionModel*model = [commissionModel mj_objectWithKeyValues:contentArray[i]];
                    [self.contentArr addObject:model];
                }
                [self.entrusttableView reloadData];
                
            }else if ([resPonseObj[@"code"] intValue]==4000){
                [[UGManager shareInstance] signout:nil];
            }
            else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}

#pragma mark-查询盘口信息
-(void)getData:(NSString*)symbol{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [TradeNetManager getexchangeplate:symbol CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            [self.askcontentArr removeAllObjects];
            [self.bidcontentArr removeAllObjects];
//            if (resPonseObj) {
                NSArray*bidArray=resPonseObj[@"bid"];//买入
                for (int i=0; i<bidArray.count; i++) {
                    plateModel*model = [plateModel mj_objectWithKeyValues:bidArray[i]];
                    [self.bidcontentArr addObject:model];
                }
                if (self.bidcontentArr.count>=Handicap) {
                    self.bidcontentArr = [NSMutableArray arrayWithArray:[self.bidcontentArr subarrayWithRange:NSMakeRange(0, Handicap)]];
                }else{
                    int amount=Handicap-(int)self.bidcontentArr.count;
                    for (int i=0; i<amount; i++) {
                        plateModel*model=[[plateModel alloc]init];
                        model.price=-1;
                        model.amount=-1;
                        model.totalAmount=-1;
                        [self.bidcontentArr insertObject:model atIndex:self.bidcontentArr.count];
                    }
                }
                NSArray*askArray=resPonseObj[@"ask"];//卖出
                for (int i=0; i<askArray.count; i++) {
                    plateModel*model = [plateModel mj_objectWithKeyValues:askArray[i]];
                    [self.askcontentArr addObject:model];
                }
                if (self.askcontentArr.count<Handicap) {
                    int amount=Handicap-(int)self.askcontentArr.count;
                    for (int i=0; i<amount; i++) {
                        plateModel*model=[[plateModel alloc]init];
                        model.price=-1;
                        model.amount=-1;
                        model.totalAmount=-1;
                        [self.askcontentArr insertObject:model atIndex:self.askcontentArr.count];
                    }
                }else{
                    self.askcontentArr = [NSMutableArray arrayWithArray:[self.askcontentArr subarrayWithRange:NSMakeRange(0, Handicap)]];
                }
                [self.asktableView reloadData];
                [self.bidtableView reloadData];
//            }else{
//            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
//            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
#pragma mark-获取单个交易对的精确度
-(void)getSingleAccuracy:(NSString*)symbol{
    @weakify(self);
    [TradeNetManager getSingleSymbol:symbol CompleteHandle:^(id resPonseObj, int code) {
        @strongify(self);
        if ([resPonseObj isKindOfClass:[NSDictionary class]]) {
            self->_baseCoinScale=[resPonseObj[@"baseCoinScale"]intValue];
            self->_coinScale=[resPonseObj[@"coinScale"] intValue];
             [self getAllCoinData:[marketManager shareInstance].symbol];
             [self getData:[marketManager shareInstance].symbol];
        }
    }];
  
}
- (IBAction)goLogin:(UIButton *)sender {
    if(!([[UGManager shareInstance] hasLogged])){
        [self showLoginViewController];
    }
}
#pragma mark-编辑输入框
- (IBAction)ValueChange:(UITextField *)sender {
    if (!_IsMarketprice) {
        double tradeNumberDou = [self.PriceTF.text doubleValue]*[self.AmountTF.text doubleValue];
        NSString * tradeNumber = [ToolUtil removeFloatAllZeroByString:[NSString stringWithFormat:@"%.6f",tradeNumberDou]];
        self.TradeNumber.text=[NSString stringWithFormat:@"%@ %@ %@",LocalizationKey(@"entrustment"),tradeNumber,_baseCoinName];
        NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
        self.CNYPrice.text=[NSString stringWithFormat:@"≈%.2f 元",[self.PriceTF.text doubleValue]*[cnyRate doubleValue]*_usdRate];
    }
}
#pragma mark-UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag==10) {
        //委托价格框
        NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
        [futureString  insertString:string atIndex:range.location];
        NSInteger flag=0;
        const NSInteger limited = _baseCoinScale;//小数点后需要限制的个数
        for (int i = (int)futureString.length-1; i>=0; i--) {
            
            if ([futureString characterAtIndex:i] == '.') {
                if (flag > limited) {
                    return NO;
                }
                break;
            }
            flag++;
        }
        return YES;
    }
    else{
     //委托数量框
        if (_IsMarketprice) {
            if (!_IsSell) {
                //市价买入
                NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
                [futureString  insertString:string atIndex:range.location];
                NSInteger flag=0;
                const NSInteger limited = _baseCoinScale;//小数点后需要限制的个数
                for (int i = (int)futureString.length-1; i>=0; i--) {
                    if ([futureString characterAtIndex:i] == '.') {
                        if (flag > limited) {
                            return NO;
                        }
                        break;
                    }
                    flag++;
                }
                return YES;
            }else{
                //市价卖出
                NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
                [futureString  insertString:string atIndex:range.location];
                NSInteger flag=0;
                const NSInteger limited = _coinScale;//小数点后需要限制的个数
                for (int i = (int)futureString.length-1; i>=0; i--) {
                    if ([futureString characterAtIndex:i] == '.') {
                        if (flag > limited) {
                            return NO;
                        }
                        break;
                    }
                    flag++;
                }
                return YES;
                
            }
        }
        else{
            //限价买入或卖出
            NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
            [futureString  insertString:string atIndex:range.location];
            NSInteger flag=0;
            const NSInteger limited = _coinScale;//小数点后需要限制的个数
            for (int i = (int)futureString.length-1; i>=0; i--) {
                if ([futureString characterAtIndex:i] == '.') {
                    if (flag > limited) {
                        return NO;
                    }
                    break;
                }
                flag++;
            }
            return YES;
            
        }
    }
}

#pragma mark-查询baseUG钱包情况
-(void)getBasewalletwithcoin:(NSString*)coin {
    UGGetSingleWalletAssetApi *api = [[UGGetSingleWalletAssetApi alloc] init];
    api.coin = coin;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!apiError) {
            NSDictionary*dict=(NSDictionary*)object;
            self.Useable.text=[NSString stringWithFormat:@"%@%.2f %@",LocalizationKey(@"usabel"),[dict[@"balance"] doubleValue],coin];
        }else
            [self.view ug_showToastWithToast:apiError.desc];
    }];
}
#pragma mark-查询coinUG钱包情况
-(void)getCoinwalletwithcoin:(NSString*)coin {
    UGGetSingleWalletAssetApi *api = [[UGGetSingleWalletAssetApi alloc] init];
    api.coin = coin;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!apiError) {
            NSDictionary*dict=(NSDictionary*)object;
            self.Useable.text=[NSString stringWithFormat:@"%@%.2f %@",LocalizationKey(@"usabelSell"),[dict[@"balance"] doubleValue],coin];
        }else
            [self.view ug_showToastWithToast:apiError.desc];
    }];
}
#pragma mark-获取USDT对CNY汇率
-(void)getUSDTToCNYRate{
    UGCnyToUsdtApi *api = [[UGCnyToUsdtApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (!apiError) {
                ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate= [NSString stringWithFormat:@"%@",object];
        }else
            [self.view ug_showToastWithToast:[NSString stringWithFormat:@"汇率-%@",apiError.desc]];
    }];
}
kRemoveCellSeparator
- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
#pragma mark - SocketDelegate Delegate
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
   
     NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];
    //缩略行情
    if (cmd==PUSH_SYMBOL_THUMB) {
        if (endStr) {
             NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
            symbolModel*model = [symbolModel mj_objectWithKeyValues:dic];
            if ([model.symbol isEqualToString:[marketManager shareInstance].symbol]) {
                self.nowPrice.text=[ToolUtil stringFromNumber:model.close withlimit:_baseCoinScale];
                NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
                self.nowCNY.text=[NSString stringWithFormat:@"≈%.2f 元",model.baseUsdRate*model.close*[cnyRate doubleValue]];
            }
        }
    }
    else if (cmd==PUSH_EXCHANGE_PLATE)
    {
        NSLog(@"盘口信息--%@",endStr);
        
        NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
        if (![dic[@"symbol"] isEqualToString:[marketManager shareInstance].symbol]) {
            return;
        }
        if ([dic[@"direction"] isEqualToString:@"SELL"]) {
          //卖
            NSArray*askArray=dic[@"items"];
            [self.askcontentArr removeAllObjects];
           
            for (int i=0; i<askArray.count; i++) {
                plateModel*model = [plateModel mj_objectWithKeyValues:askArray[i]];
                [self.askcontentArr addObject:model];
            }
            if (self.askcontentArr.count<Handicap) {
                int amount=Handicap-(int)self.askcontentArr.count;
                for (int i=0; i<amount; i++) {
                    plateModel*model=[[plateModel alloc]init];
                    model.price=-1;
                    model.amount=-1;
                    model.totalAmount=-1;
                    [self.askcontentArr insertObject:model atIndex:self.askcontentArr.count];
                }
            }else{
                self.askcontentArr = [NSMutableArray arrayWithArray:[self.askcontentArr subarrayWithRange:NSMakeRange(0, Handicap)]];
            }
            [self.asktableView reloadData];
            
        }else if ([dic[@"direction"] isEqualToString:@"BUY"]){
            
            NSArray*bidArray=dic[@"items"];//买入
            [self.bidcontentArr removeAllObjects];
            
            for (int i=0; i<bidArray.count; i++) {
                plateModel*model = [plateModel mj_objectWithKeyValues:bidArray[i]];
                [self.bidcontentArr addObject:model];
            }
            if (self.bidcontentArr.count<Handicap) {
                int amount=Handicap-(int)self.bidcontentArr.count;
                for (int i=0; i<amount; i++) {
                    plateModel*model=[[plateModel alloc]init];
                    model.price=-1;
                    model.amount=-1;
                    model.totalAmount=-1;
                    [self.bidcontentArr insertObject:model atIndex:self.bidcontentArr.count];
                }
            }else{
                self.bidcontentArr = [NSMutableArray arrayWithArray:[self.bidcontentArr subarrayWithRange:NSMakeRange(0, Handicap)]];
            }
             [self.bidtableView reloadData];
            
        }
    }else if (cmd==PUSH_EXCHANGE_ORDER_COMPLETED||cmd==PUSH_EXCHANGE_ORDER_CANCELED){
        //当前委托数据完成或取消
        NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
        commissionModel*model = [commissionModel mj_objectWithKeyValues:dic];
        [self.contentArr enumerateObjectsUsingBlock:^(commissionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.orderId isEqualToString:model.orderId]) {
                [self.contentArr removeObject:obj];
                 *stop = YES;
                [self.entrusttableView reloadData];
            }
        }];
        
    }else if (cmd==PUSH_EXCHANGE_ORDER_TRADE){
        //当前委托数据变化
        NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
        commissionModel*model = [commissionModel mj_objectWithKeyValues:dic];
        [self.contentArr enumerateObjectsUsingBlock:^(commissionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.orderId isEqualToString:model.orderId]) {
                [self.contentArr replaceObjectAtIndex:idx withObject:model];
                *stop = YES;
                [self.entrusttableView reloadData];
            }
        }];
    }else{
        
        
    }
    NSLog(@"交易消息-%@--%d",endStr,cmd);
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    NSDictionary*dic;
    if (([[UGManager shareInstance] hasLogged])) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",[UGManager shareInstance].hostInfo.ID,@"uid",nil];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",nil];
    }
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
     [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_EXCHANGE_TRADE withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
