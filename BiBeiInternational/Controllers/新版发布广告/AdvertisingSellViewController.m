//
//  AdvertisingSellViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "AdvertisingSellViewController.h"
#import "AccountSettingTableViewCell.h"
#import "Advertising1TableViewCell.h"
#import "Adversiting2TableViewCell.h"
#import "C2CNetManager.h"
#import "SelectCoinTypeModel.h"
#import "countryViewController.h"
#import "Adversiting3TableViewCell.h"
#import "Adversiting4TableViewCell.h"
#import "MyAdvertisingViewController.h"
#import "UGCenterPopView.h"
#import "UGAdvertiseApi.h"
#import "UGAdvertisingPayModeVC.h"
#import "UGPayWaySettingViewController.h"
#import "UGMineAdViewController.h"
#import "UITextView+Placeholder.h"
#import "UGAdRateCell.h"
#import "UGUGJyRateApi.h"
#import "UGBuyOrSellPopView.h"
#import "UGExchangeRateApi.h"
#import "AppDelegate.h"
#import "UGGetUGSellFeeApi.h"

@interface AdvertisingSellViewController ()<UITableViewDelegate,UITableViewDataSource,Advertising1TableViewCellDelegate,Adversiting2TableViewCellDelegate,UITextFieldDelegate>{
    NSString*_actualPrice;//实时价格
    NSString *_limitMax;
    NSString *_limitMin;
    NSString *_currentString;
    BOOL _isCurrentStringUsed;
    
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property(nonatomic,strong)NSMutableArray *contentArr;
@property(nonatomic,strong)NSMutableArray *getPlaceHoldArr2;
@property (weak, nonatomic) IBOutlet UIButton *certainButton;
@property (nonatomic,strong)NSMutableArray *selectCoinTypeArr;
@property(nonatomic,copy)NSString *coinId;//选择货币的id
@property(nonatomic,copy)NSMutableArray *payWays; //支付方式ID
@property(nonatomic,assign)NSInteger enterWays;//进入方式 1 选择币种 2收款方式
@property(nonatomic,copy)NSString *zhCountryName; //传入后台的国家名称
@property(nonatomic,strong)UGAdRateCell *adRateCell;
@property(nonatomic,strong)Advertising1TableViewCell *advertising1;
@property(nonatomic,copy)NSString *rateStr;
@property(nonatomic,copy)NSString *availableBalance;//可用余额
//随机数的数组
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tbHeight;
@property(nonatomic,strong)NSMutableArray *randomNumbeArray;
@end

@implementation AdvertisingSellViewController

-(NSMutableArray *)randomNumbeArray
{
    if (!_randomNumbeArray) {
        
        _randomNumbeArray = [[NSMutableArray alloc]init];
    }
    return _randomNumbeArray;
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    //获取UG币的市场价格
    if (self.index != 1) {
        [self selectCoinTypeData];
    }
    //OTC获取UG交易费率
    self.availableBalance = @"0";
    
    [self initData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _limitMax = [self upDataMessage:@"otcLimit" WithMessage:@"50000"];
    _limitMin = [self upDataMessage:@"minDealAmount" WithMessage:@"1"];
    self.title = self.index == 1 ? @"修改出售交易" : @"发布出售交易";

    [self.certainButton setTitle:LocalizationKey(@"release") forState:UIControlStateNormal];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.bottomViewHeight.constant = SafeAreaBottomHeight+20;
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.mainTableView registerNib:[UINib nibWithNibName:@"AccountSettingTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([AccountSettingTableViewCell class])];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"Advertising1TableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([Advertising1TableViewCell class])];
    [self.mainTableView registerNib:[UINib nibWithNibName:@"Adversiting2TableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([Adversiting2TableViewCell class])];
     [self.mainTableView registerNib:[UINib nibWithNibName:@"Adversiting3TableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([Adversiting3TableViewCell class])];
     [self.mainTableView registerNib:[UINib nibWithNibName:@"UGAdRateCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGAdRateCell class])];
    
    _actualPrice=@"";
    self.zhCountryName = @"--";
    if (_index == 1) {
        [self.certainButton setTitle:LocalizationKey(@"modifiedRelease") forState:UIControlStateNormal];
        [self editorInfo];
    }
    [self initData];
//    #pragma mark- 更新发布广告两位小数的随机数
//    [UG_MethodsTool UGPlaceAnADRandomNumberIsNeedToUpdate];
//    [self toUpdateRandomNumbeArray];
    
    self.tbHeight.constant = 44*5 + 20.f;
}

#pragma mark - 更新随机数数据源
-(void)toUpdateRandomNumbeArray
{
    [self.randomNumbeArray removeAllObjects];
    [self.randomNumbeArray addObjectsFromArray:[UG_MethodsTool GetPlaceAnADRandomNumberFromPlist]];
    NSLog(@"randomNumbeArray cout = %zd",self.randomNumbeArray.count);
    
}


-(void)initData{
     @weakify(self);
    [self getWalletData:^(UGApiError *apiError, id object) {
        @strongify(self);
        if (object){
            NSArray *listData = [UGWalletAllModel mj_objectArrayWithKeyValuesArray:object];
            if (listData.count>0) {
                UGWalletAllModel *walletModel = listData.firstObject;
                if (walletModel) {
                    self.availableBalance = [walletModel.balance ug_amountFormat];
                    //OTC获取UG交易费率
                    [self getUGUGJyRate];
                }
            }
        }
    }];
}

//MARK:--编辑界面过来进行处理
-(void)editorInfo{
    _actualPrice = _detailModel.price;
    
    self.coinId = _detailModel.coinId;

//    [self.contentArr replaceObjectAtIndex:0 withObject:_detailModel.price];
//    [self.contentArr replaceObjectAtIndex:1 withObject:_detailModel.minLimit];
//    [self.contentArr replaceObjectAtIndex:2 withObject:_detailModel.maxLimit];
//    [self.contentArr replaceObjectAtIndex:3 withObject:_detailModel.number];
    
    [self.contentArr replaceObjectAtIndex:0 withObject:!UG_CheckStrIsEmpty(_detailModel.price) ? _detailModel.price : @""];
    [self.contentArr replaceObjectAtIndex:1 withObject: !UG_CheckStrIsEmpty(_detailModel.number) ? [_detailModel.number ug_amountFormat] : @""];
    
    NSArray* array = [_detailModel.payMode componentsSeparatedByString:@","];
    self.payWays = [NSMutableArray arrayWithArray:array];
    NSMutableArray *payWaysArr = [[NSMutableArray alloc] init];
    if (array.count > 0) {
        for (NSString *payStr in array) {
            if ([payStr isEqualToString:@"支付宝"]) {
                [payWaysArr addObject:@"支付宝"];
            }else if ([payStr isEqualToString:@"微信"]){
                [payWaysArr addObject:@"微信"];
            }else if ([payStr isEqualToString:@"云闪付"]){
                [payWaysArr addObject:@"云闪付"];
            }else{
                [payWaysArr addObject:@"银行卡"];
            }
        }
    }
//    [self.contentArr replaceObjectAtIndex:4 withObject:[payWaysArr componentsJoinedByString:@" "]];
//    [self.contentArr replaceObjectAtIndex:5 withObject:_detailModel.timeLimit];
//    [self.contentArr replaceObjectAtIndex:7 withObject:_detailModel.remark];
    [self.contentArr replaceObjectAtIndex:3 withObject:[payWaysArr componentsJoinedByString:@","]];
    [self.contentArr replaceObjectAtIndex:4 withObject:!UG_CheckStrIsEmpty(_detailModel.timeLimit) ? _detailModel.timeLimit : @""];
//    [self.contentArr replaceObjectAtIndex:6 withObject:!UG_CheckStrIsEmpty(_detailModel.remark) ? _detailModel.remark : @""];
    [self.mainTableView reloadData];
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //    return 8;
//    return 7;
    return 6;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //    if (indexPath.row == 7 ) {
    //        return 100;
    //    }else{
    //        return 50;
    //    }
//    if (indexPath.row == 6 ) {
//        return 100;
//    }else
        if(indexPath.row == 2){
            return 20;
        }else{
            return 44;
        }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 2 ){
        UGAdRateCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGAdRateCell class])];
        self.adRateCell = cell;
        [self upDateRate:self.contentArr[1]];
        return cell;
    }
    
    if (indexPath.row == 3 ){
        
        AccountSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AccountSettingTableViewCell class])];
        cell.accessoryType =  indexPath.row == 3 ? UITableViewCellAccessoryDisclosureIndicator : UITableViewCellAccessoryNone;
        cell.rightConstraint.constant = indexPath.row == 3 ? 0.0f : 20.0f;
        cell.leftLabel.text = [self getNameArr][indexPath.row];
        cell.rightLabel.text = self.contentArr[indexPath.row];
        cell.leftLabel.textColor = [UIColor darkGrayColor];
        return cell;
        
//    }else if (indexPath.row == 0 || indexPath.row == 5 ){
    }else if (indexPath.row == 0 || indexPath.row == 4 ){
        
        Adversiting3TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Adversiting3TableViewCell class])];
        cell.leftLabel.text = [self getNameArr][indexPath.row];
        if (indexPath.row == 0) {
            cell.centerLabel.text = self.contentArr[indexPath.row];
            cell.rightLabel.text =  @"元";

        } else {
            cell.centerLabel.text = @"";
            cell.rightLabel.text =  [NSString stringWithFormat:@"%@分钟",self.contentArr[indexPath.row]];
        }

        return cell;
        
//    }else if (indexPath.row == 7) {
    }
//    else if (indexPath.row == 6) {
//        Adversiting2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Adversiting2TableViewCell class])];
//        cell.index = indexPath;
//        cell.textView.placeholder = @"请输入交易留言";
//        cell.leftLabel.text = LocalizationKey(@"messageContent");
//        cell.textView.editable = YES;
//        cell.textView.text = self.contentArr[indexPath.row];
//        cell.delegate = self;
//        return cell;
//
//    }
    else {
        Advertising1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([Advertising1TableViewCell class])];
        if (indexPath.row == 1) {
             self.advertising1 = cell;
        }
//        cell.centerTextFileld.secureTextEntry = indexPath.row == 6;
        cell.centerTextFileld.secureTextEntry = indexPath.row == 5;
        cell.centerTextFileld.enabled = YES;
        cell.index = indexPath;
        cell.leftLabel.text = [self getNameArr][indexPath.row];
        cell.centerTextFileld.placeholder = [self getPlaceHoldArr2][indexPath.row];
        cell.rightLabel.text = [self getAttributeArr2][indexPath.row];
        cell.centerTextFileld.text = self.contentArr[indexPath.row];
        cell.centerTextFileld.keyboardType = UIKeyboardTypeDecimalPad;
        cell.delegate = self;
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    if (indexPath.row == 4){
    //        //选择支付方式
    //        self.enterWays = 2;
    //        [self pushToPayModeController];
    //    }
    if (indexPath.row == 3){
        //选择支付方式
        self.enterWays = 2;
        [self pushToPayModeController];
    }
}

//#pragma mark - 金额温馨提示
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    CGFloat imageHeight = (90.0/375.0)*kWindowW;
//    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, imageHeight+12)];
//    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWindowW,imageHeight)];
//    imageView.image = [UIImage imageNamed:@"AmountReminder"];
//    [headerView addSubview:imageView];
//    return headerView;
//}
//
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    CGFloat imageHeight = (90.0/375.0)*kWindowW;
//    return imageHeight+12;
//}


//MARK:--选择币种的请求数据
-(void)selectCoinTypeData{
    
    if(UG_CheckStrIsEmpty(((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG))
    {
        UGExchangeRateApi *api = [[UGExchangeRateApi alloc] init];
        api.urlArm = @"cny/ug";
        [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            if(object){
                NSString *rate = (NSString *)object;
                ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG= rate ;
                //实时价格
                self->_actualPrice = rate;
                [self.contentArr replaceObjectAtIndex:0 withObject:rate];
                //            self.coinId = selectedModel.ID;
                [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    else
    {
        NSString *rate = ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG;
        //实时价格
        self->_actualPrice = rate;
        [self.contentArr replaceObjectAtIndex:0 withObject:rate];
        //            self.coinId = selectedModel.ID;
        [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        
    }
//    [C2CNetManager selectCoinTypeForCompleteHandle:^(id resPonseObj, int code) {
//        if (code){
//            if ([resPonseObj[@"code"] integerValue]==0) {
//                NSArray <SelectCoinTypeModel*>*array = [SelectCoinTypeModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
//                if (array.count > 0) {
//                    SelectCoinTypeModel *selectedModel = ((SelectCoinTypeModel*)array.firstObject);
//                    //实时价格
//                    self->_actualPrice = selectedModel.marketPrice;
//                    [self.contentArr replaceObjectAtIndex:0 withObject:selectedModel.marketPrice];
//                    self.coinId = selectedModel.ID;
//                    [self.mainTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
//                }
//            }
//        }
//    }];
}

#pragma mark - 支付方式选择
- (void)pushToPayModeController {
    UGPayWaySettingViewController *payModeVc = [UGPayWaySettingViewController new];
    payModeVc.isReleaseAd = YES;
    payModeVc.payWays = self.payWays;
    payModeVc.sellOrBuy = @"1"; //出售
    @weakify(self);
    payModeVc.choosePayModHandle = ^(NSArray <NSString *>*payMode) {
        @strongify(self);
        NSMutableArray *payWaysArrary = [[NSMutableArray alloc] init];
        if (payMode.count > 0) {
            for (NSString *payStr in payMode) {
                if ([payStr containsString:@"支付宝"]) {
                    [payWaysArrary addObject:@"支付宝"];
                }else if ([payStr containsString:@"微信"]){
                    [payWaysArrary addObject:@"微信"];
                }else if ([payStr containsString:@"云闪付"]){
                    [payWaysArrary addObject:@"云闪付"];
                }else{
                    [payWaysArrary addObject:@"银行卡"];
                }
            }
        }
//        [self.contentArr replaceObjectAtIndex:4 withObject:[payWaysArrary componentsJoinedByString:@" "]];
        [self.contentArr replaceObjectAtIndex:3 withObject:[payWaysArrary componentsJoinedByString:@","]];
        self.payWays = payWaysArrary;
        [self.mainTableView reloadData];
    };
    
    [self.navigationController pushViewController:payModeVc animated:YES];
}

//MARK:--输入框的代理方法
-(void)textFieldIndex:(NSIndexPath *)index TextFieldString:(NSString *)textString{

    [self.contentArr replaceObjectAtIndex:index.row withObject:textString];
    
//    //非支付密码 且 输入完成后是0
//    if (index.row != 6 && [textString isEqualToString:@"0"]) {
//        [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:LocalizationKey(@"请输入大于0的整数或小数！")];
//        return;
//    }
    if (index.row != 5 && [textString isEqualToString:@"0"]) {
        [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:LocalizationKey(@"请输入大于0的整数或小数！")];
        return;
    }
    
    //新需求，加随机两位小数
    
//    if (index.row == 1){
//        //最小量
//        if (![self.contentArr[2] isEqualToString:@""]) {
//            if ([textString floatValue]>[self.contentArr[2] floatValue]) {
//
//                [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:LocalizationKey(@"inputMinThanMax")];
//                [self.contentArr replaceObjectAtIndex:index.row withObject:@""];
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
//                [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//            }
//        }
//    }else if (index.row == 2){
//        //最大量
//        if (![self.contentArr[1] isEqualToString:@""]) {
//            if ([textString floatValue]<[self.contentArr[1] floatValue]) {
//
//                [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:LocalizationKey(@"inputMaxThanMin")];
//                [self.contentArr replaceObjectAtIndex:index.row withObject:@""];
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
//                [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//            }
//        }
//    } else if (index.row == 3) {//最多可卖出数量
//        UGWalletAllModel *walletModel = [UGManager shareInstance].hostInfo.userInfoModel.list.firstObject;
//        if ([textString floatValue] > [walletModel.balance floatValue]) {
//            [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:[NSString stringWithFormat:@%@UG",[walletModel.balance ug_amountFormat]]];
//            [self.contentArr replaceObjectAtIndex:index.row withObject:[walletModel.balance ug_amountFormat]];
//            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:3 inSection:0];
//            [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//        }
//    }
    
    if (index.row == 1) {//最多可卖出数量
        //比较
        if (!UG_CheckStrIsEmpty(textString)) {
            NSString *str = [NSString ug_bySubtractFormatWithMultiplier:self.availableBalance multiplicand:textString];
            if ([str floatValue]<0) {
                [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:[NSString stringWithFormat:@"最多可卖出 %@ UG",self.availableBalance]];
                [self.contentArr replaceObjectAtIndex:index.row withObject:self.availableBalance];
                //                [self upDateRate:self.contentArr[1]];
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
                [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }

// 注释随机小数部分的代码
//    if (index.row == 1) {
//
//        if (UG_CheckStrIsEmpty(textString)) {
//            return;
//        }
//
//        NSInteger randomNo = (arc4random() % self.randomNumbeArray.count);
//        _currentString  = self.randomNumbeArray[randomNo];
//        _isCurrentStringUsed = NO;
//
//        //最多可卖出数量
//        //比较
//        if (!UG_CheckStrIsEmpty(textString)) {
//            NSString *str = [NSString ug_bySubtractFormatWithMultiplier:self.availableBalance multiplicand:textString];
//            if ([str floatValue]<0) {
//
//                NSString *showAvailableBalance = self.availableBalance;
//                NSArray *array = [self.availableBalance componentsSeparatedByString:@"."];
//                NSString *decimalStr  = [array lastObject];
//                NSInteger tempNumber = [[array firstObject] integerValue];
//                NSString *tempStr = @"";
//                if (decimalStr.length>2) {
//                    tempStr = [decimalStr substringToIndex:2];
//                    showAvailableBalance = [NSString stringWithFormat:@"%zd.%@",tempNumber,tempStr];
//                    //如果切割出来的卖出值0结尾，则做特殊处理
//                    if ([showAvailableBalance hasSuffix:@"0"])
//                    {
//                        CGFloat floatValue = [showAvailableBalance floatValue];
//                        CGFloat resultValue = 0;
//                        if (floatValue > 1)
//                        {
//                            NSString *tempStr = [NSString stringWithFormat:@"0.%@",_currentString];
//                            resultValue = floatValue - 1.0 +[tempStr floatValue];
//                            showAvailableBalance = [NSString stringWithFormat:@"%.2f",resultValue];
//                            NSLog(@"resultValue = %.2f tempStr = %@",resultValue,tempStr);
//                            _isCurrentStringUsed = YES;
//                        }
//                    }
//                }
//                [self.contentArr replaceObjectAtIndex:index.row withObject:showAvailableBalance];
//                [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:[NSString stringWithFormat:@"最多可卖出 %@ UG",showAvailableBalance]];
////                [self upDateRate:self.contentArr[1]];
//                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
//                [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//            }
//            else
//            {
//
//                NSLog(@"_currentString = %@",_currentString);
//                NSArray *array = [textString componentsSeparatedByString:@"."];
//                NSString *decimalStr  = [array lastObject];
//                if ([textString floatValue]<1) {
//                    return;
//                }
//                if (array.count>1 && (decimalStr.length == 2) && ![decimalStr hasSuffix:@"0"])
//                {
//                    return;
//                }
//                else
//                {
//                    CGFloat floatValue = [textString floatValue];
//                    CGFloat resultValue = 0;
//                    if (floatValue > 1)
//                    {
//                        NSString *tempStr = [NSString stringWithFormat:@"0.%@",_currentString];
//
//                        resultValue = floatValue - 1.0 +[tempStr floatValue];
//
//                        textString = [NSString stringWithFormat:@"%.2f",resultValue];
//
//                        NSLog(@"resultValue = %.2f tempStr = %@",resultValue,tempStr);
//
//                        _isCurrentStringUsed = YES;
//                        //      更新cell数据
//                        [self.contentArr replaceObjectAtIndex:index.row withObject:textString];
//
//                        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
//                        [_mainTableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
//                    }
//                }
//
//            }
//        }
//
//    }
}

-(void)textFieldIndex:(NSIndexPath *)index TextChangeString:(NSString *)textString{
    if (index.row == 1) {
        //修改汇率
        NSLog(@"%@",textString);
//        [self upDateRate:textString];
    }
}

//MARK:--文本框的代理方法
-(void)textViewIndex:(NSIndexPath *)index TextViewString:(NSString *)textString{
    if (textString.length > 100) {
        [[UIApplication sharedApplication].keyWindow ug_showToastWithToast:index.row == self.contentArr.count - 1 ? @"留言内容请少于100字！" : @"回复内容请少于100字！"];
    }
    [self.contentArr replaceObjectAtIndex:index.row withObject:textString.length > 100 ? [textString substringToIndex:100] : textString];
}


//MARK:--发布出售交易点击事件
- (IBAction)submitBtnClick:(UIButton *)sender {

    [self.view endEditing:YES];
    
//    for (int i=0; i<self.contentArr.count - 1; i++) {
//        NSString *contentStr = self.contentArr[i];
//        NSLog(@"--%@",contentStr);
//        if (i == 1 || i == 2 || i == 3) {
//            NSString *toast = [self judgePlaceHoldArr][i];
//            BOOL empty = [contentStr isEqualToString:@""];
//            if ([contentStr doubleValue] == 0  || empty ) {
//                toast = empty ? toast : [toast stringByReplacingOccurrencesOfString:@"请输入" withString:@""];
//                [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast: empty ? toast : [NSString stringWithFormat:@"%@不能为0",toast]];
//                return;
//            }
//        } else if ( [contentStr isEqualToString:@""] || [contentStr isEqualToString:LocalizationKey(@"select")] ) {
//
//            NSString *toast = [self judgePlaceHoldArr][i];
//            if ([toast containsString:@"失败"]) {
//                //获取单价
//                [self selectCoinTypeData];
//                [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:@"需要重新获取单价!"];
//                return;
//            }
//            [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:toast];
//            return;
//        }
//    }
    
    for (int i=0; i<self.contentArr.count - 1; i++) {
        NSString *contentStr = self.contentArr[i];
        NSLog(@"--%@",contentStr);
        if (i == 1) { 
            NSString *toast = [self judgePlaceHoldArr][i];
            BOOL empty = [contentStr isEqualToString:@""];
            if ([contentStr doubleValue] == 0  || empty ) {
                toast = empty ? toast : [toast stringByReplacingOccurrencesOfString:@"请输入" withString:@""];
                [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast: empty ? toast : [NSString stringWithFormat:@"%@不能为0",toast]];
                return;
            }
            NSString *messageMax = [self upDataMessage:@"otcLimit" WithMessage:@"50000"];
            if ([contentStr doubleValue]>[messageMax doubleValue]) {
                [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:[NSString stringWithFormat:@"发布数额不得大于%@UG",messageMax]];
                return;
            }
            NSString *messageMin= [self upDataMessage:@"minDealAmount" WithMessage:@"1"];
            if ([contentStr doubleValue]<[messageMin doubleValue]) {
                [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:[NSString stringWithFormat:@"发布数额不得小于%@UG",messageMin]];
                return;
            }
        } else if(i == 2){
            //手续费 不需要弹提示框
        } else if ( [contentStr isEqualToString:@""] || [contentStr isEqualToString:LocalizationKey(@"select")] ) {
            
            NSString *toast = [self judgePlaceHoldArr][i];
            if ([toast containsString:@"失败"]) {
                //获取单价
                [self selectCoinTypeData];
                [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:@"需要重新获取单价!"];
                return;
            }
            [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:toast];
            return;
        }
    }

    
    //出售总量 CNY
//    NSString *totalCny =  [NSString ug_positiveFormatWithMultiplier:self.contentArr[3] multiplicand:self.contentArr[0] scale:2 roundingMode:NSRoundDown];
    NSString *totalCny =  [NSString ug_positiveFormatWithMultiplier:self.contentArr[1] multiplicand:self.contentArr[0] scale:6 roundingMode:NSRoundDown];

//    //检查出售数量 < 最小量换算成CNY
//    if ([totalCny doubleValue] < [self.contentArr[1] doubleValue]) {
//        [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:@"出售总额不能小于最小限额！"];
//        return;
//    }
    
//    //检查是否绑定了谷歌验证器  //2.0换手机号
//    if (![self hasBindingGoogleValidator]) {
//        return;
//    }

    //检查是否需要实名或高级认证
    if ([self checkMoneyNeedToValidation:totalCny]) {
        return;
    }
    
    //校验是否绑定银行卡
    if ( [self checkHadGotoBankBinding]) {
        return;
    }
    
    NSString *passWord =self.contentArr[5];
    if (UG_CheckStrIsEmpty(passWord) || passWord.length != 6) {
        [self.view ug_showToastWithToast:@"请您确认输入6位数字支付密码"];
        return;
    }
    @weakify(self);
    [UGBuyOrSellPopView initWithTitle:@"我要出售" WithNumber:[NSString stringWithFormat:@"%@ UG",totalCny] WithRate:[NSString stringWithFormat:@"%@ UG",[self.rateStr ug_amountFormat]] WithReal:[NSString stringWithFormat:@"%@ UG",[NSString ug_addFormatWithMultiplier:totalCny multiplicand:self.rateStr]] withType:NO WithHandle:^{
        @strongify(self);
        //上传发布交易数据
        [MBProgressHUD ug_showHUDToKeyWindow];
        
        //发送请求
        UGAdvertiseApi *advertriseApi = [UGAdvertiseApi new];
        advertriseApi.reviseAdvertis = self.index == 1;
        if (advertriseApi.reviseAdvertis) { advertriseApi.ID = self.detailModel.ID;}
        advertriseApi.advertiseType = @"1";//出售1
        advertriseApi.minLimit = self.contentArr[1];
        advertriseApi.maxLimit = self.contentArr[1];
//        advertriseApi.remark = self.contentArr[6];
        advertriseApi.number = self.contentArr[1];
        advertriseApi.payMode = [self.payWays componentsJoinedByString:@","];
        advertriseApi.jyPassword = self.contentArr[5];
        //        advertriseApi.price = self.contentArr[0];
        //        advertriseApi.advertiseType = @"BUY";//出售1
        //        advertriseApi.coinId = self.coinId;
        //        advertriseApi.maxLimit = self.contentArr[2];
        //        advertriseApi.timeLimit = self.contentArr[6];
        //        advertriseApi.countryZhName = self.zhCountryName;
        //        advertriseApi.priceType = @"";
        //        advertriseApi.premiseRate = @"";
        //        advertriseApi.remark = self.contentArr[7];
        //        advertriseApi.number = self.contentArr[3];
        //        advertriseApi.jyPassword = self.contentArr[6];
        //        advertriseApi.isAuto = @"0";
        //        advertriseApi.autoword = @"";
        
        [advertriseApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
            [MBProgressHUD ug_hideHUDFromKeyWindow];
            NSString *desc = apiError.desc;
            if (object) {
               //删除已使用的随机数
//                if (self->_currentString.length && self->_isCurrentStringUsed) {
//                    [self.randomNumbeArray removeObject:self->_currentString];
//                    [UG_MethodsTool toUpdateUGPlaceAnADRandomNumberWith:self.randomNumbeArray];
//                }
                desc = self.index == 1 ? @"修改交易成功" : @"发布交易成功";
                if (self.index != 1) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"创建交易成功" object: nil userInfo:@{@"buyOrSell": @"1"}];
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self pushToMineAdViewController];
                    });
                } else {
                    if (self.reviseCompleteHandle) {
                        self.reviseCompleteHandle(@{
                                                    @"payWays" : self.payWays,
                                                    @"number" : self.contentArr[1],
                                                    @"minLimit" : self.contentArr[1],
                                                    @"maxLimit" : self.contentArr[1]
                                                    });
                    }
                    [self.navigationController popViewControllerAnimated:YES];
                }
                 [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:desc];
            }else{
                if ([apiError.desc isEqualToString:@"您绑定的银行卡已达当日收款限额"]) {
                    [self showBindingLimit: @"发布提示"];
                }else{
                    [[UIApplication sharedApplication].keyWindow  ug_showToastWithToast:desc];
                }
            }
        }];
    }];
}

-(void)getUGUGJyRate{
    UGGetUGSellFeeApi *api = [UGGetUGSellFeeApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if(!UG_CheckStrIsEmpty(object)){
             self.rateStr = object;
            if ([UGManager shareInstance].hostInfo.userInfoModel.list.count>0) {
                //获取当前可用余额
                UGWalletAllModel *walletModel = [UGManager shareInstance].hostInfo.userInfoModel.list.firstObject;
                self.availableBalance = [[NSString ug_bySubtractFormatWithMultiplier:walletModel.balance multiplicand:self.rateStr] ug_amountFormat];
                if ([self.availableBalance floatValue]<0) {
                    self.availableBalance = @"0";
                }
                self.advertising1.centerTextFileld.placeholder = [NSString stringWithFormat:@"最多可卖出 %@ UG",self.availableBalance];
                [self.getPlaceHoldArr2 replaceObjectAtIndex: 1 withObject:[NSString stringWithFormat:@"最多可卖出 %@ UG",self.availableBalance]];
                [self upDateRate:self.contentArr[1]];
            }
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

-(void)upDateRate:(NSString *)textString{
    if (!self.adRateCell) {
        return;
    }
    
    if (!UG_CheckStrIsEmpty(self.rateStr)) {
        self.adRateCell.rateLabel.text = [NSString stringWithFormat:@"手续费 %@ UG",[self.rateStr ug_amountFormat]];
//        NSString *rateP = [NSString ug_positiveFormatWithMultiplier:[self.rateStr ug_amountFormat] multiplicand:@"100" scale:6 roundingMode:NSRoundDown];
//        if (textString.length>0) {
//            NSString *totalCny =  [NSString ug_positiveFormatWithMultiplier:textString multiplicand:self.contentArr[0] scale:6 roundingMode:NSRoundDown];
//            NSString *rate =  [NSString ug_positiveFormatWithMultiplier:totalCny multiplicand:[self.rateStr ug_amountFormat] scale:6 roundingMode:NSRoundDown];
//            self.adRateCell.rateLabel.text = [NSString stringWithFormat:@"手续费 %@ UG (费率%@%@",rate,rateP,@"%)"];
//        }else{
//            self.adRateCell.rateLabel.text = [NSString stringWithFormat:@"手续费 0 UG (费率%@%@",rateP,@"%)"];
//        }
//    }else{
//        self.adRateCell.rateLabel.text = [NSString stringWithFormat:@"手续费 0 UG (费率0%@",@"%)"];
    }
}

- (void)pushToMineAdViewController {
    BOOL find = NO;
    for (UIViewController *viewController in self.navigationController.viewControllers) {
        if ([viewController isKindOfClass:[UGMineAdViewController class]]) {
            find = YES;
            break;
        }
    }
    if (find) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        UGMineAdViewController *adVc = [UGMineAdViewController new];
        adVc.popGestureRecognizerEnabled = NO;
        adVc.isBuyOrSell = @"1";
        [self.navigationController pushViewController:adVc animated:YES];
    }
}

#pragma mark - Getter Method

-(NSArray *)getNameArr{
    return @[
             LocalizationKey(@"Real-timePrice"),
//             LocalizationKey(@"minimum"),
//             LocalizationKey(@"maximum"),
             LocalizationKey(@"sellNum"),
             @"", //加一个 费率
             LocalizationKey(@"payMethods"),
             LocalizationKey(@"放币期限"),
             LocalizationKey(@"moneyPassword"),
//             @""
             ].copy;
}

-(NSMutableArray *)getPlaceHoldArr2{
    if (!_getPlaceHoldArr2) {
        _getPlaceHoldArr2 = [NSMutableArray arrayWithArray:@[
                                                             @"",
                                                             //             LocalizationKey(@"inputTradMin"),
                                                             //             LocalizationKey(@"inputTradMax"),
                                                             [NSString stringWithFormat:@"最多可卖出 %@ UG",self.availableBalance],
                                                             @"", //加一个 费率
                                                             @"",
                                                             @"付款方式",
                                                             LocalizationKey(@"inputMoneyPassword"),
                                                             //             @""
                                                       ]];
    }
    return _getPlaceHoldArr2;
}




-(NSArray *)getAttributeArr2{
    return @[
             @"",
//             @"CNY",
//             @"CNY",
             @"UG",
             @"", //加一个 费率
             @"",
             @"",
             @"",
//             @""
             ].copy;
}

- (NSMutableArray *)contentArr {
    if (!_contentArr) {
        NSString *timeStr = [self upDataMessage:@"sellMin" WithMessage:@"120"];
        _contentArr = [NSMutableArray arrayWithArray:@[
                                                       @"",
//                                                       @"",
//                                                       @"",
                                                       @"",
                                                       @"", //加一个 费率
                                                       LocalizationKey(@"select"),
                                                      timeStr,
                                                       @"",
//                                                       @""
                                                       ]];
    }
    return _contentArr;
}



-(NSArray *)judgePlaceHoldArr{
    NSArray * nameArr = @[
                          @"获取单价失败，请退出后重写发布交易！",
//                          LocalizationKey(@"inputTradMin"),
//                          LocalizationKey(@"inputTradMax"),
                          LocalizationKey(@"inputSellAmount"),
                          @"", //加一个 费率
                          LocalizationKey(@"请选择收款方式"),
                          LocalizationKey(@"inputBuyPayTerm"),
                          LocalizationKey(@"inputMoneyPassword"),
//                          @""
                          ];
    return nameArr;
}

- (NSMutableArray *)selectCoinTypeArr {
    if (!_selectCoinTypeArr) {
        _selectCoinTypeArr = [NSMutableArray array];
    }
    return _selectCoinTypeArr;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
