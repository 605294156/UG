//
//  KchatViewController.m
//  CoinWorld
//
//  Created by sunliang on 2018/5/18.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "KchatViewController.h"
#import "Masonry.h"
#import "Y_StockChartView.h"
#import "Y_StockChartView.h"
#import "Y_KLineGroupModel.h"
#import "UIColor+Y_StockChart.h"
#import "AppDelegate.h"
#import "Y_StockChartViewController.h"
#import "KlineCell.h"
#import "KlineHeaderCell.h"
#import "HomeNetManager.h"
#import "symbolModel.h"
#import "marketManager.h"
#import "MarketNetManager.h"
#import "DepthCell.h"
#import "DepthHeader.h"
#import "TradeNumCell.h"
#import "DepthmapCell.h"
#import "plateModel.h"
#import "TradeNumModel.h"
#import "UGTabBarController.h"
#define DataRow 20  //显示的行数

#import "UGNavController.h"

@interface KchatViewController ()<Y_StockChartViewDataSource,SocketDelegate,UITableViewDataSource,UITableViewDelegate>
{
    BOOL _isCollect;//是否收藏了
    symbolModel*_currentmodel;//获取的当前交易对
    BOOL _isDepthMap;//当前显示深度图
    DepthHeader*_headerview;
    double allDepthbuyAmount;
    double allDepthsellAmount;
}
@property (nonatomic, strong) Y_StockChartView *stockChartView;
@property (nonatomic, strong) Y_KLineGroupModel *groupModel;
@property (nonatomic, copy) NSMutableDictionary <NSString*, Y_KLineGroupModel*> *modelsDict;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, copy) NSString *type;
@property (weak, nonatomic) IBOutlet UIButton *buyBtn;//买入
@property (weak, nonatomic) IBOutlet UIButton *sellBtn;//卖出
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property(nonatomic,strong)NSMutableArray*askContentArray;//卖出
@property(nonatomic,strong)NSMutableArray*bidContentArray;//买入
@property(nonatomic,strong)NSMutableArray*tradeNumberArray;//成交记录

@end

@implementation KchatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=self.symbol;
    
//    self.extendedLayoutIncludesOpaqueBars = YES;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _isDepthMap=YES;
    
    NSLog(@"K 线图");
    
    [self setupBarButtonItemWithImageName:@"bigger" type:UGBarImteTypeRight callBack:^(UIBarButtonItem *item) {
        Y_StockChartViewController *stockChartVC = [Y_StockChartViewController new];
        stockChartVC.symbol=self.symbol;
        stockChartVC.DefalutselectedIndex=self.currentIndex;
        stockChartVC.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:stockChartVC animated:YES completion:nil];
    }];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"KlineCell" bundle:nil] forCellReuseIdentifier:@"KlineCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"KlineHeaderCell" bundle:nil] forCellReuseIdentifier:@"KlineHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"DepthCell" bundle:nil] forCellReuseIdentifier:@"DepthCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"TradeNumCell" bundle:nil] forCellReuseIdentifier:@"TradeNumCell"];
     [self.tableView registerNib:[UINib nibWithNibName:@"DepthmapCell" bundle:nil] forCellReuseIdentifier:@"DepthmapCell"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    self.currentIndex = -1;
    self.stockChartView.backgroundColor = [UIColor backgroundColor];
    self.tableView.backgroundColor= [UIColor backgroundColor];
    self.view.backgroundColor=[UIColor backgroundColor];
//    self.topDistance.constant=SafeAreaTopHeight;
    self.bottomDistance.constant=SafeAreaBottomHeight;
    self.buyBtn.backgroundColor=GreenColor;
    self.sellBtn.backgroundColor=RedColor;
    self.backView.backgroundColor=[UIColor backgroundColor];
    NSArray *coinArray = [self.symbol componentsSeparatedByString:@"/"];
    [self.buyBtn setTitle:[NSString stringWithFormat:@"%@%@",LocalizationKey(@"buyDirection"),[coinArray firstObject]] forState:UIControlStateNormal];
    [self.sellBtn setTitle:[NSString stringWithFormat:@"%@%@",LocalizationKey(@"sellDirection"),[coinArray firstObject]] forState:UIControlStateNormal];
//    AdjustsScrollViewInsetNever(self, self.tableView)
    self.collectLabel.text=LocalizationKey(@"addFavo");
    [self getAllCoinData:self.symbol];
    self.askContentArray=[[NSMutableArray alloc]init];
    self.bidContentArray=[[NSMutableArray alloc]init];
    self.tradeNumberArray=[[NSMutableArray alloc]init];
    [self getExchangeNumber];
    [self getplatefull];
       
    self.navigationBarColor = [UIColor backgroundColor];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
    if ([[UGManager shareInstance] hasLogged]) {
        [self getPersonAllCollection];
    }
 
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:self.symbol,@"symbol",nil];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_EXCHANGE_TRADE withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    [SocketManager share].delegate=self;
}

//获取成交记录
-(void)getExchangeNumber{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [HomeNetManager latesttradeWithsymbol:self.symbol withSizeSize:20 CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
       NSLog(@"获取成交记录数据--%@",resPonseObj);
        if ([resPonseObj isKindOfClass:[NSArray class]]) {
           self.tradeNumberArray = [TradeNumModel mj_objectArrayWithKeyValuesArray:resPonseObj];
            if (self.tradeNumberArray.count<DataRow) {
                int amount=DataRow-(int)self.tradeNumberArray.count;
                for (int i=0; i<amount; i++) {
                    TradeNumModel*model=[[TradeNumModel alloc]init];
                    model.price=@"-1";
                    model.amount=@"-1";
                    model.time=@"-1";
                    model.direction=@"-1";
                    [self.tradeNumberArray insertObject:model atIndex:self.tradeNumberArray.count];
                }
            }else{
                self.tradeNumberArray = [NSMutableArray arrayWithArray:[self.tradeNumberArray subarrayWithRange:NSMakeRange(0, DataRow)]];
            }
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
    } ];
}
//获取盘口信息
-(void)getplatefull{
    allDepthsellAmount=0;
    allDepthbuyAmount=0;
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [HomeNetManager platefullWithsymbol:self.symbol CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
         NSLog(@"获取盘口信息数据--%@",resPonseObj);
            self.askContentArray = [plateModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"ask"][@"items"]];
        for (int i=0;i<self.askContentArray.count;i++) {
            plateModel*model=self.askContentArray[i];
            self->allDepthsellAmount=self->allDepthsellAmount+model.amount;
            model.totalAmount=self->allDepthsellAmount;
        }
        
        if (self.askContentArray.count<DataRow) {
            int amount=DataRow-(int)self.askContentArray.count;
            for (int i=0; i<amount; i++) {
                plateModel*model=[[plateModel alloc]init];
                model.price=-1;
                model.amount=-1;
                model.totalAmount=-1;
                [self.askContentArray insertObject:model atIndex:self.askContentArray.count];
            }
        }else{
            self.askContentArray = [NSMutableArray arrayWithArray:[self.askContentArray subarrayWithRange:NSMakeRange(0, DataRow)]];
        }
            self.bidContentArray = [plateModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"bid"][@"items"]];
        for (int i=0;i<self.bidContentArray.count;i++) {
            plateModel*model=self.bidContentArray[i];
            self->allDepthbuyAmount=self->allDepthbuyAmount+model.amount;
            model.totalAmount=self->allDepthbuyAmount;
        }
        if (self.bidContentArray.count<DataRow) {
            int amount=DataRow-(int)self.bidContentArray.count;
            for (int i=0; i<amount; i++) {
                plateModel*model=[[plateModel alloc]init];
                model.price=-1;
                model.amount=-1;
                model.totalAmount=-1;
                [self.bidContentArray insertObject:model atIndex:self.bidContentArray.count];
            }
        }else{
            self.bidContentArray = [NSMutableArray arrayWithArray:[self.bidContentArray subarrayWithRange:NSMakeRange(0, DataRow)]];
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        
    }];
}

//获取所有交易币种缩略行情
-(void)getAllCoinData:(NSString*)symbol {
    
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [HomeNetManager getsymbolthumbCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                NSArray*symbolArray=(NSArray*)resPonseObj;
                for (int i=0; i<symbolArray.count; i++) {
                    symbolModel*model = [symbolModel mj_objectWithKeyValues:symbolArray[i]];
                    if ([model.symbol isEqualToString:symbol]) {
                        self->_currentmodel=model;
                        NSArray *array = [model.closeStr componentsSeparatedByString:@"."]; //从字符.中分
                        if (array.count > 1) {
                            NSString *decimalString= array[1];
                            ((AppDelegate*)[UIApplication sharedApplication].delegate).precisionNum =[decimalString length];
                        }else{
                           ((AppDelegate*)[UIApplication sharedApplication].delegate).precisionNum = 1;
                        }
                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
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
- (NSMutableDictionary<NSString *,Y_KLineGroupModel *> *)modelsDict
{
    if (!_modelsDict) {
        _modelsDict = @{}.mutableCopy;
    }
    return _modelsDict;
}
/*
-(id) stockDatasWithIndex:(NSInteger)index
{
    NSString *type;
    switch (index) {
        case 0:
        {
            type = @"1min";
        }
            break;
        case 1:
        {
            type = @"1min";//分时
        }
            break;
        case 2:
        {
            type = @"1min";//1分
        }
            break;
        case 3:
        {
            type = @"5min";
        }
            break;
        case 4:
        {
            type = @"30min";//默认
        }
            break;
        case 5:
        {
            type = @"1hour";
        }
            break;
        case 6:
        {
            type = @"1day";
        }
            break;
        case 7:
        {
            type = @"1week";
        }
            break;
            
        default:
            break;
    }
    self.currentIndex = index;
    self.type = type;
    [self reloadData:type];
    return nil;
}
 */
-(id) stockDatasWithIndex:(NSInteger)index
{
    NSString *type;
    switch (index) {
        case 0:
        {
            type = @"1min";
        }
            break;
        case 1:
        {
            type = @"1min";//分时
        }
            break;
        case 2:
        {
            type = @"1min";//1分
        }
            break;
        case 3:
        {
            type = @"5min";//5分钟
        }
            break;
        case 4:
        {
            type = @"1hour";//1小时
        }
            break;
        case 5:
        {
            type = @"1day";//1天
        }
            break;
        case 6:
        {
            type = @"15min";//15分钟
            
        }
            break;
        case 7:
        {
            type = @"30min";//30分钟
        }
            break;
        case 8:
        {
            type = @"1week";//1周
        }
            break;
        case 9:
        {
            type = @"1month";//1月
        }
            break;
        default:
            break;
    }
    self.currentIndex = index;
    self.type = type;
    [self reloadData:type];
    return nil;
}
#pragma mark-请求K线数据
- (void)reloadData:(NSString*)type
{
    if ([type isEqualToString:@"1min"]) {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2)]] withResolution:@"1"];
    }
    else if ([type isEqualToString:@"5min"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*5)]] withResolution:@"5"];
    }
    else if ([type isEqualToString:@"30min"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*30)]] withResolution:@"30"];
    }
    else if ([type isEqualToString:@"1hour"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*60)]] withResolution:@"1H"];
    }
    else if ([type isEqualToString:@"1day"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*24*60)]] withResolution:@"1D"];
    }
    else if ([type isEqualToString:@"1week"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*24*60*7)]] withResolution:@"1W"];
    }
    else if ([type isEqualToString:@"15min"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*15)]] withResolution:@"15"];
    }
    else if ([type isEqualToString:@"1month"])
    {
        [self getDatawithSymbol:self.symbol withFromtime:[self getStringWithDate:[NSDate dateWithTimeIntervalSinceNow: -(6*1*60*60*2*24*60)]] withResolution:@"1M"];
    }else{
        
    }
}
#pragma --K线数据
-(void)getDatawithSymbol:(NSString*)symbol withFromtime:(NSString*)time withResolution:(NSString*)resolution{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [HomeNetManager historyKlineWithsymbol:symbol withFrom:time withTo:[self getStringWithDate:[NSDate date]] withResolution:resolution CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            /**时间--开盘价--最高价--最低价--收盘价--成交量**/
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                NSArray*array=(NSArray*)resPonseObj;
                if (array.count<=2) {
                    [self.stockChartView reloadData:[NSArray array]];
                    return ;
                }
                        Y_KLineGroupModel *groupModel = [Y_KLineGroupModel objectWithArray:resPonseObj];
                        self.groupModel = groupModel;
                [self.stockChartView reloadData:self.groupModel.models];
                
            }else{
               [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
           [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
-(NSString*)getStringWithDate:(NSDate*)date{
    NSTimeInterval nowtime = [date timeIntervalSince1970]*1000;
    long long theTime = [[NSNumber numberWithDouble:nowtime] longLongValue];
    return  [NSString stringWithFormat:@"%llu",theTime];//当前时间的毫秒数
}
/*
- (Y_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [Y_StockChartView new];
        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:LocalizationKey(@"index") type:Y_StockChartcenterViewTypeOther],
                                       [Y_StockChartViewItemModel itemModelWithTitle:LocalizationKey(@"line") type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:LocalizationKey(@"min") type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:LocalizationKey(@"fivemin") type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:LocalizationKey(@"thirtymin") type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:LocalizationKey(@"hours") type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:LocalizationKey(@"days") type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:LocalizationKey(@"weeks") type:Y_StockChartcenterViewTypeKline],
                                       
                                       ];
        _stockChartView.backgroundColor = [UIColor orangeColor];
        _stockChartView.DefalutselectedIndex=1;//默认显示分时图
        _stockChartView.dataSource = self;
        
    }
    return _stockChartView;
}
 */
- (Y_StockChartView *)stockChartView
{
    if(!_stockChartView) {
        _stockChartView = [Y_StockChartView new];
        _stockChartView.itemModels = @[
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"指标" type:Y_StockChartcenterViewTypeOther],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"分时" type:Y_StockChartcenterViewTypeTimeLine],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"5分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1小时" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1天" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"15分" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"30分钟" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1周" type:Y_StockChartcenterViewTypeKline],
                                       [Y_StockChartViewItemModel itemModelWithTitle:@"1月" type:Y_StockChartcenterViewTypeKline],
                                       ];
        _stockChartView.backgroundColor = [UIColor orangeColor];
        _stockChartView.DefalutselectedIndex=2;//默认显示1分钟K线图
        _stockChartView.dataSource = self;
    }
    return _stockChartView;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section==0) {
        return 2;
    }else{
        return self.tradeNumberArray.count + 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            return 80;
        }else{
            return  kWindowH-SafeAreaTopHeight-50-SafeAreaBottomHeight-80;
        }
    }else{
        return 30;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) {
        if (indexPath.row==0) {
            KlineHeaderCell*cell=[tableView dequeueReusableCellWithIdentifier:@"KlineHeaderCell" forIndexPath:indexPath];
            cell.contentView.backgroundColor=[UIColor backgroundColor];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell configModel:_currentmodel];
            return cell;
        }else{
            
            KlineCell*cell=[tableView dequeueReusableCellWithIdentifier:@"KlineCell" forIndexPath:indexPath];
            self.stockChartView.frame=CGRectMake(0, 31, kWindowW, cell.frame.size.height-31);
            cell.contentView.backgroundColor=[UIColor backgroundColor];
            [cell.contentView addSubview:self.stockChartView];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            [cell.contentView bringSubviewToFront:cell.moreView];
            [cell.contentView bringSubviewToFront:cell.indView];
            return cell;
        }
    }else{
        if (_isDepthMap) {
            if (indexPath.row==0) {
                NSArray *coinArray = [self.symbol componentsSeparatedByString:@"/"];
                DepthmapCell*cell=[tableView dequeueReusableCellWithIdentifier:@"DepthmapCell" forIndexPath:indexPath];
                cell.depthView.hidden=NO;
                cell.TradeView.hidden=YES;
                cell.DepthNum.text=[NSString stringWithFormat:@"%@ %@(%@)",LocalizationKey(@"buyplate"),LocalizationKey(@"amount"),[coinArray firstObject]];
                 cell.DepthPrice.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"price"),[coinArray lastObject]];
                cell.DepthSellNum.text=[NSString stringWithFormat:@"%@(%@) %@",LocalizationKey(@"amount"),[coinArray firstObject],LocalizationKey(@"sellplate")]; cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
                
            }else{
                plateModel*buymodel =indexPath.row-1 < self.bidContentArray.count ? self.bidContentArray[indexPath.row - 1] : nil;
                plateModel*Sellmodel =indexPath.row-1 < self.askContentArray.count ? self.askContentArray[indexPath.row - 1] : nil;
                if (self.bidContentArray.count>0 && self.askContentArray.count>0 && buymodel && Sellmodel) {
                    DepthCell*cell=[tableView dequeueReusableCellWithIdentifier:@"DepthCell" forIndexPath:indexPath];
                    [cell config:buymodel withmodel:Sellmodel withindexth:indexPath]; cell.selectionStyle=UITableViewCellSelectionStyleNone;
                    if (buymodel.amount>=0) {
                        cell.buyWidth.constant=buymodel.totalAmount/allDepthbuyAmount*kWindowW/2;
                    }else{
                        cell.buyWidth.constant=0;
                    }
                    if (Sellmodel.amount>=0) {
                        cell.sellWidth.constant=Sellmodel.totalAmount/allDepthsellAmount*kWindowW/2;
                    }else{
                        cell.sellWidth.constant=0;
                    }
                    return cell;
                }else if (buymodel && Sellmodel){
                    DepthCell*cell=[tableView dequeueReusableCellWithIdentifier:@"DepthCell" forIndexPath:indexPath];
                    cell.buyWidth.constant=0;
                    cell.sellWidth.constant=0;
                    [cell config:buymodel withmodel:Sellmodel withindexth:indexPath];
                    return cell;
                }
                //根据自己UG钱包项目加的 防止 空白cell 奔溃
                DepthCell*cell=[tableView dequeueReusableCellWithIdentifier:@"DepthCell" forIndexPath:indexPath];
                cell.buyWidth.constant=0;
                cell.sellWidth.constant=0;
                cell.BuyIndex.text=[NSString stringWithFormat:@"%ld",indexPath.row];
                cell.buyNum.text=@"--";
                cell.BuyPrice.text=@"--";
                cell.SellPrice.text=@"--";
                cell.SellNum.text=@"--";
                cell.SellIndex.text=[NSString stringWithFormat:@"%ld",indexPath.row];
                return cell;
            }
        }else{
            if (indexPath.row==0) {
                 NSArray *coinArray = [self.symbol componentsSeparatedByString:@"/"];
                DepthmapCell*cell=[tableView dequeueReusableCellWithIdentifier:@"DepthmapCell" forIndexPath:indexPath];
                cell.depthView.hidden=YES;
                cell.TradeView.hidden=NO;
                cell.tradePrice.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"price"),[coinArray lastObject]];
                cell.tradeNum.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"amount"),[coinArray firstObject]];
                cell.timeLbel.text=LocalizationKey(@"depthtime");
                cell.directionLabel.text=LocalizationKey(@"depthDirection");
                return cell;
            }else{
                  TradeNumCell*cell=[tableView dequeueReusableCellWithIdentifier:@"TradeNumCell" forIndexPath:indexPath];
                if (self.tradeNumberArray.count>0 && indexPath.row-1 < self.tradeNumberArray.count) {
                    TradeNumModel*model=self.tradeNumberArray[indexPath.row-1];
                   [cell configmodel:model];
                }
                cell.selectionStyle=UITableViewCellSelectionStyleNone;
                return cell;
            }
        }
    }
    return  [UITableViewCell new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section==1) {
        return 0.01;
    }else{
        return 40;
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    if (section==1) {
        return nil;
    }else{
        _headerview=[DepthHeader instancetableHeardViewWithFrame:CGRectMake(0, 0, kWindowW, 40)];
        [_headerview.deepthBtn addTarget:self action:@selector(TouchEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_headerview.tradeBtn addTarget:self action:@selector(TouchEvent:) forControlEvents:UIControlEventTouchUpInside];
        [_headerview.deepthBtn setTitle:LocalizationKey(@"depth") forState:UIControlStateNormal];
        [_headerview.tradeBtn setTitle:LocalizationKey(@"marketTrades") forState:UIControlStateNormal];
        _headerview.backgroundColor=[UIColor backgroundColor];
        _headerview.lineView.backgroundColor=[UIColor ma30Color];
        if (!_isDepthMap) {
           [_headerview.deepthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [_headerview.tradeBtn setTitleColor:[UIColor ma30Color] forState:UIControlStateNormal];
            _headerview.lineView.centerX=_headerview.tradeBtn.centerX;
            
        }else{
            [_headerview.deepthBtn setTitleColor:[UIColor ma30Color] forState:UIControlStateNormal];
             [_headerview.tradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
           _headerview.lineView.centerX=_headerview.deepthBtn.centerX;
        }
        return _headerview;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
      return 0.01;
   }

//点击事件
-(void)TouchEvent:(UIButton*)sender{
    if (sender.tag==0) {
        //深度图
        _isDepthMap=YES;
        [_headerview.deepthBtn setTitleColor:[UIColor ma30Color] forState:UIControlStateNormal];
        [_headerview.tradeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
       // [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
        [self getplatefull];
    }else{
        //成交量
        _isDepthMap=NO;
        [_headerview.deepthBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_headerview.tradeBtn setTitleColor:[UIColor ma30Color] forState:UIControlStateNormal];
        //[EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
        [self getExchangeNumber];
    }

}
#pragma mark-买入/卖出
- (IBAction)btnClick:(UIButton *)sender {
    //判断用户是否已经登录
    if(!([[UGManager shareInstance] hasLogged])){
        [self showLoginViewController];
        return;
    }
    [self.navigationController popViewControllerAnimated:NO];
    [marketManager shareInstance].symbol=self.symbol;
    NSArray *array = [self.symbol componentsSeparatedByString:@"/"];
    NSDictionary * dict;
    switch (sender.tag) {
        case 0:
        {
            dict =[[NSDictionary alloc]initWithObjectsAndKeys:[array firstObject],@"object",[array lastObject],@"base",@"buy",@"kind",nil];
        }
            break;
        case 1:
        {
            dict =[[NSDictionary alloc]initWithObjectsAndKeys:[array firstObject],@"object",[array lastObject],@"base",@"sell",@"kind",nil];
        }
            break;
        default:
            break;
    }
    NSNotification *notification =[NSNotification notificationWithName:CURRENTSELECTED_SYMBOL object:nil userInfo:dict];
    [[NSNotificationCenter defaultCenter] postNotification:notification];
#warning Need To Fix 需要修改，需要放到UGTabBarController里面处理
    UGTabBarController*tabVC=(UGTabBarController*)APPLICATION.window.rootViewController;
    tabVC.selectedIndex=1;
    
}

- (IBAction)collect:(UIButton *)sender {
    if (!([[UGManager shareInstance] hasLogged])) {//未登录
        [self showLoginViewController];
        return;
    }
    if (_isCollect) {
        [self deleteCollectionWithsymbol:self.symbol];
    }else{
        [self addCollectionWithsymbol:self.symbol];
    }
}

#pragma mark - SocketDelegate Delegate
- (void)delegateSocket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag{
    
     NSData *endData = [data subdataWithRange:NSMakeRange(SOCKETRESPONSE_LENGTH, data.length -SOCKETRESPONSE_LENGTH)];
    NSString *endStr= [[NSString alloc] initWithData:endData encoding:NSUTF8StringEncoding];
    NSData *cmdData = [data subdataWithRange:NSMakeRange(12,2)];
    uint16_t cmd=[SocketUtils uint16FromBytes:cmdData];

    //缩略行情
    if (cmd==PUSH_SYMBOL_THUMB) {
        NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
        symbolModel*model = [symbolModel mj_objectWithKeyValues:dic];
        if ([model.symbol isEqualToString:self.symbol]) {
            _currentmodel=model;
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];

        }
    }else if (cmd==UNSUBSCRIBE_SYMBOL_THUMB){
        NSLog(@"取消订阅K线缩略行情消息");
        
    }else if (cmd==PUSH_EXCHANGE_KLINE){
        NSLog(@"订阅K线消息");
        
    }
    else if (cmd==PUSH_EXCHANGE_TRADE){
        NSLog(@"成交记录");
        if (self.tradeNumberArray.count==DataRow) {
            NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
            if (![dic[@"symbol"] isEqualToString:self.symbol]) {
                return;//如果新消息非当前的交易对
            }
            TradeNumModel*model = [TradeNumModel mj_objectWithKeyValues:dic];
            [self.tradeNumberArray insertObject:model atIndex:0];
            self.tradeNumberArray = [NSMutableArray arrayWithArray:[self.tradeNumberArray subarrayWithRange:NSMakeRange(0, DataRow)]];
            NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
            [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
        }
    }
    else if (cmd==PUSH_EXCHANGE_DEPTH){
        NSDictionary*dic=[SocketUtils dictionaryWithJsonString:endStr];
        if (![dic[@"symbol"] isEqualToString:self.symbol]) {
            return;//如果新消息非当前的交易对
        }
        NSLog(@"深度图--%@",dic);
        if ([dic[@"direction"] isEqualToString:@"SELL"]) {
            allDepthsellAmount=0;
            self.askContentArray = [plateModel mj_objectArrayWithKeyValuesArray:dic[@"items"]];
            for (int i=0;i<self.askContentArray.count;i++) {
                plateModel*model=self.askContentArray[i];
                allDepthsellAmount=allDepthsellAmount+model.amount;
                model.totalAmount=allDepthsellAmount;
            }
            
            if (self.askContentArray.count<DataRow) {
                int amount=DataRow-(int)self.askContentArray.count;
                for (int i=0; i<amount; i++) {
                    plateModel*model=[[plateModel alloc]init];
                    model.price=-1;
                    model.amount=-1;
                    model.totalAmount=-1;
                    [self.askContentArray insertObject:model atIndex:self.askContentArray.count];
                }
            }else{
                self.askContentArray = [NSMutableArray arrayWithArray:[self.askContentArray subarrayWithRange:NSMakeRange(0, DataRow)]];
            }
        }else{
            allDepthbuyAmount=0;
            self.bidContentArray = [plateModel mj_objectArrayWithKeyValuesArray:dic[@"items"]];
            for (int i=0;i<self.bidContentArray.count;i++) {
                plateModel*model=self.bidContentArray[i];
                allDepthbuyAmount=allDepthbuyAmount+model.amount;
                model.totalAmount=allDepthbuyAmount;
            }
            if (self.bidContentArray.count<DataRow) {
                int amount=DataRow-(int)self.bidContentArray.count;
                for (int i=0; i<amount; i++) {
                    plateModel*model=[[plateModel alloc]init];
                    model.price=-1;
                    model.amount=-1;
                    model.totalAmount=-1;
                    [self.bidContentArray insertObject:model atIndex:self.bidContentArray.count];
                }
            }else{
                self.bidContentArray = [NSMutableArray arrayWithArray:[self.bidContentArray subarrayWithRange:NSMakeRange(0, DataRow)]];
            }
        }
        NSIndexSet *indexSet=[[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
      }
    else if (cmd==UNSUBSCRIBE_EXCHANGE_TRADE){
        NSLog(@"取消K线消息");
        
    }else{
        
    }
    NSLog(@"K线消息-%@--%d",endStr,cmd);
}

#pragma mark-获取个人全部自选
-(void)getPersonAllCollection{
    [MarketNetManager queryAboutMyCollectionCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"code = %d resPonseObj = %@",code,resPonseObj);
        
        
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                NSArray*symbolArray=(NSArray*)resPonseObj;
                NSArray *dataArr = [symbolModel mj_objectArrayWithKeyValuesArray:symbolArray];
                [dataArr enumerateObjectsUsingBlock:^(symbolModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.symbol isEqualToString:self.symbol]) {
                        self.collectIamgeV.image=UIIMAGE(@"collect");
                        self.collectLabel.text=LocalizationKey(@"deleteFavo");
                        self->_isCollect=YES;
                        *stop = YES;
                    }
                }];
            }
            else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [[UGManager shareInstance] signout:nil];
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    } ];
}
/*添加
 */
-(void)addCollectionWithsymbol:(NSString*)symbol{
    [MarketNetManager addMyCollectionWithsymbol:symbol CompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.collectIamgeV.image=UIIMAGE(@"collect");
                self.collectLabel.text=LocalizationKey(@"deleteFavo");
                self->_isCollect=YES;
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
/*删除
 */
-(void)deleteCollectionWithsymbol:(NSString*)symbol{
    [MarketNetManager deleteMyCollectionWithsymbol:symbol CompleteHandle:^(id resPonseObj, int code) {
        
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.collectIamgeV.image=UIIMAGE(@"uncollect");
                self.collectLabel.text=LocalizationKey(@"addFavo");
                self->_isCollect=NO;
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}


- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    NSDictionary*dic=[NSDictionary dictionaryWithObjectsAndKeys:self.symbol,@"symbol",nil];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_EXCHANGE_TRADE withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
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
