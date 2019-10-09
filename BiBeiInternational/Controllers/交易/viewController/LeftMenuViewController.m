//
//  LeftMenuViewController.m
//  BitMira
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "UIViewController+LeftSlide.h"
#import "UGHomeMarketCell.h"
#import "marketManager.h"
#import "HomeNetManager.h"
#import "symbolModel.h"
#import "MarketNetManager.h"
#import "UGSymbolThumbModel.h"

#define UGHomeMarketCellIdentifier @"UGHomeMarketCell"

@interface LeftMenuViewController ()<SocketDelegate>
{
    UIButton*_currentBtn;//当前选中的按钮
    BOOL  _isDragging;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeight;
@property (weak, nonatomic) IBOutlet UIButton *defalutBtn;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *indicatorView;
@property (nonatomic,strong)NSMutableArray *contentArr;
@property (weak, nonatomic) IBOutlet UIButton *collectionBtn;
@property (weak, nonatomic) IBOutlet UILabel *marketsLabel;
@property (weak, nonatomic) IBOutlet UIButton *rightBtnView;
@property (weak, nonatomic) IBOutlet UIView *BottomView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHieght;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineleading;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navHeight.constant=SafeAreaTopHeight;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGHomeMarketCell" bundle:nil] forCellReuseIdentifier:UGHomeMarketCellIdentifier];
    self.tableView.rowHeight=60;
    self.tableView.separatorColor=[UIColor groupTableViewBackgroundColor];
    self.tableView.tableFooterView=[UIView new];
    // 添加从左划入的功能
//    [self initSlideFoundation];
    self.view.backgroundColor = [UIColor colorWithRed:0.184 green:0.184 blue:0.216 alpha:0.40];
    _currentBtn=self.defalutBtn;
    self.indicatorView.hidesWhenStopped=YES;
    [self languageChange];
    [self changeFrame];
}

//MARK:--国际化通知处理事件
- (void)languageChange {
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"noDada") detailStr:nil];
    self.tableView.ly_emptyView = emptyView;
}

#pragma mark - 数据源方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.viewType==ChildViewType_USDT) {
        return [marketManager shareInstance].USDTArray.count;
    }else if (self.viewType==ChildViewType_UG){
        return [marketManager shareInstance].UGArray.count;
    }else if (self.viewType==ChildViewType_BTC){
        return [marketManager shareInstance].BTCArray.count;
    }else if (self.viewType==ChildViewType_ETH){
        return [marketManager shareInstance].ETHArray.count;
    }else{
        return [marketManager shareInstance].CollectionArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGHomeMarketCell * cell = [tableView dequeueReusableCellWithIdentifier:UGHomeMarketCellIdentifier forIndexPath:indexPath];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    if (self.viewType==ChildViewType_USDT && [marketManager shareInstance].USDTArray.count>0) {
        symbolModel*model=[marketManager shareInstance].USDTArray[indexPath.row];
        [cell configDataWithModel:[self changeToModel:model]];
    }else if (self.viewType==ChildViewType_UG && [marketManager shareInstance].UGArray.count>0){
        symbolModel*model=[marketManager shareInstance].UGArray[indexPath.row];
        [cell configDataWithModel:[self changeToModel:model]];
    }else if (self.viewType==ChildViewType_BTC  && [marketManager shareInstance].BTCArray.count>0){
        symbolModel*model=[marketManager shareInstance].BTCArray[indexPath.row];
        [cell configDataWithModel:[self changeToModel:model]];
    }else if (self.viewType==ChildViewType_ETH  && [marketManager shareInstance].ETHArray.count>0){
        symbolModel*model=[marketManager shareInstance].ETHArray[indexPath.row];
        [cell configDataWithModel:[self changeToModel:model]];
    }else if([marketManager shareInstance].CollectionArray.count>0){
        symbolModel*model=[marketManager shareInstance].CollectionArray[indexPath.row];
         [cell configDataWithModel:[self changeToModel:model]];
    }
     return cell;
}

-(UGSymbolThumbModel *)changeToModel:(symbolModel *)thumbmodel{
    UGSymbolThumbModel *model = [UGSymbolThumbModel new];
    model.chg = [NSString stringWithFormat:@"%f",thumbmodel.chg];
    model.volume = [NSString stringWithFormat:@"%f",thumbmodel.volume];
    model.high = [NSString stringWithFormat:@"%f",thumbmodel.high];
    model.symbol = thumbmodel.symbol;
    model.close = [NSString stringWithFormat:@"%f",thumbmodel.close];
    model.baseUsdRate = [NSString stringWithFormat:@"%f",thumbmodel.baseUsdRate];
    model.change = [NSString stringWithFormat:@"%f",thumbmodel.change];
    model.lastDayClose = [NSString stringWithFormat:@"%f",thumbmodel.lastDayClose];
    model.open = [NSString stringWithFormat:@"%f",thumbmodel.open];
    model.low = [NSString stringWithFormat:@"%f",thumbmodel.low];
    model.usdRate = [NSString stringWithFormat:@"%f",thumbmodel.usdRate];
    model.turnover = [NSString stringWithFormat:@"%f",thumbmodel.turnover];
    model.closeStr = thumbmodel.closeStr;
    return model;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dict;
    symbolModel*model;
    if (self.viewType==ChildViewType_USDT && [marketManager shareInstance].USDTArray.count>0) {
        model=[marketManager shareInstance].USDTArray[indexPath.row];
    }else if (self.viewType==ChildViewType_UG && [marketManager shareInstance].UGArray.count>0){
        model=[marketManager shareInstance].UGArray[indexPath.row];
    }else if (self.viewType==ChildViewType_BTC  && [marketManager shareInstance].BTCArray.count>0){
        model=[marketManager shareInstance].BTCArray[indexPath.row];
    }else if (self.viewType==ChildViewType_ETH  && [marketManager shareInstance].ETHArray.count>0){
        model=[marketManager shareInstance].ETHArray[indexPath.row];
    }else if([marketManager shareInstance].CollectionArray.count>0){
        model=[marketManager shareInstance].CollectionArray[indexPath.row];
    }
    NSArray *array = [model.symbol componentsSeparatedByString:@"/"];
    NSString*baseSymbol=[array lastObject];
    NSString*coinSymbol=[array firstObject];
    dict =[[NSDictionary alloc]initWithObjectsAndKeys:coinSymbol,@"object",baseSymbol,@"base",nil];
    NSDictionary*dic;
    if (([[UGManager shareInstance] hasLogged])) {
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",[UGManager shareInstance].hostInfo.ID,@"uid",nil];
    }else{
        dic=[NSDictionary dictionaryWithObjectsAndKeys:[marketManager shareInstance].symbol,@"symbol",nil];
    }
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_EXCHANGE_TRADE withVersion:COMMANDS_VERSION withRequestId: 0 withbody:dic];
    
    [marketManager shareInstance].symbol=[NSString stringWithFormat:@"%@/%@",dict[@"object"],dict[@"base"]];
    //创建通知
    NSNotification *notification =[NSNotification notificationWithName:CURRENTSELECTED_SYMBOL object:nil userInfo:dict];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
    [self hide];
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewType == ChildViewType_Collection)
        return YES;
    return NO;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete && self.viewType == ChildViewType_Collection) {
        //删除自选
        if ([marketManager shareInstance].CollectionArray.count>0){
            symbolModel *model =[marketManager shareInstance].CollectionArray[indexPath.row];
            [self deleteCollectionWithsymbol:model.symbol];
        }
    }
}
/*删除
 */
-(void)deleteCollectionWithsymbol:(NSString*)symbol{
    [MBProgressHUD ug_showHUDToKeyWindow];
    [MarketNetManager deleteMyCollectionWithsymbol:symbol CompleteHandle:^(id resPonseObj, int code) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                [self getData];
                [self.view ug_showToastWithToast:@"删除成功"];
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
//开始拖拽
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _isDragging=YES;
}
//结束拖拽
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset{
    
    _isDragging=NO;
}
//点击切换数据
- (IBAction)changeData:(UIButton *)sender {
     self.viewType=(ChildViewType)sender.tag;
    if (sender!=_currentBtn) {
        [_currentBtn setTitleColor:[UIColor colorWithHexString:@"7EC9FF"] forState:UIControlStateNormal];
        _currentBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [sender setTitleColor:UG_MainColor forState:UIControlStateNormal];
        sender.titleLabel.font = [UIFont systemFontOfSize:15];
        _currentBtn=sender;
        [UIView animateWithDuration:0.3 animations:^{
            self.lineleading.constant = sender.mj_x;
        } completion:^(BOOL finished) {
            [self getData];
        }];
        [self changeFrame];
    }
}

-(void)changeFrame{
    self.bottomHieght.constant = self.viewType == ChildViewType_Collection ? 80 : 0;
}

#pragma mark -- show or hide
- (void)showFromLeft
{
    [self.collectionBtn setTitle:LocalizationKey(@"collect") forState:UIControlStateNormal];
    self.marketsLabel.text=LocalizationKey(@"tabbar2");
    [self changeFrame];
    [self show];
    [self getData];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:SUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
    [SocketManager share].delegate=self;
}

#pragma mar - 添加自选
- (IBAction)addSelected:(id)sender {
    [self hide];
    if (self.selectedClick) {
        self.selectedClick();
    }
}

- (IBAction)hideToLeft:(id)sender {
    [self hide];
    [[SocketManager share] sendMsgWithLength:SOCKETREQUEST_LENGTH withsequenceId:0 withcmd:UNSUBSCRIBE_SYMBOL_THUMB withVersion:COMMANDS_VERSION withRequestId: 0 withbody:nil];
}
kRemoveCellSeparator

//获取所有交易币种缩略行情
-(void)getData{
    [self removeAllArray];
    [self.indicatorView startAnimating];
    [HomeNetManager getsymbolthumbCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                [self.contentArr removeAllObjects];
                NSArray*symbolArray=(NSArray*)resPonseObj;
                for (int i=0; i<symbolArray.count; i++) {
                    symbolModel*model = [symbolModel mj_objectWithKeyValues:symbolArray[i]];
                    [self.contentArr addObject:model];
                    NSArray *array = [model.symbol componentsSeparatedByString:@"/"];
                    NSString*baseSymbol=[array lastObject];
                    if ([baseSymbol isEqualToString:@"USDT"]) {
                        [[marketManager shareInstance].USDTArray addObject:model];
                    }else if ([baseSymbol isEqualToString:@"UG"])
                    {
                        [[marketManager shareInstance].UGArray addObject:model];
                    }else if ([baseSymbol isEqualToString:@"BTC"])
                    {
                        [[marketManager shareInstance].BTCArray addObject:model];
                    }else if ([baseSymbol isEqualToString:@"ETH"])
                    {
                        [[marketManager shareInstance].ETHArray addObject:model];
                    }
                }
                [marketManager shareInstance].AllCoinArray=self.contentArr;
                if (([[UGManager shareInstance] hasLogged])) {
                    if (self->_currentBtn.tag==4) {
                        [self getPersonAllCollection];//获取全部自选
                    }else{
                        [self.tableView reloadData];
                        [self.indicatorView stopAnimating];
                        }
               
                }else{
                    [self.tableView reloadData];
                    [self.indicatorView stopAnimating];
                }
            }else{
                [self.indicatorView stopAnimating];
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.indicatorView stopAnimating];
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
//获取个人全部自选
-(void)getPersonAllCollection{
    [MarketNetManager queryAboutMyCollectionCompleteHandle:^(id resPonseObj, int code) {
        if (code) {
            if ([resPonseObj isKindOfClass:[NSArray class]]) {
                [self.indicatorView stopAnimating];
                NSArray*symbolArray=(NSArray*)resPonseObj;
                for (int i=0; i<symbolArray.count; i++) {
                    NSDictionary*dict=symbolArray[i];
                    [[marketManager shareInstance].AllCoinArray enumerateObjectsUsingBlock:^(symbolModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
                        if ([obj.symbol isEqualToString:dict[@"symbol"]]) {
                            [[marketManager shareInstance].CollectionArray addObject:obj];
                        }
                    }];
                }
                [self.tableView reloadData];
                
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    } ];
}

- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
-(void)removeAllArray{
    [[marketManager shareInstance].USDTArray removeAllObjects];
    [[marketManager shareInstance].UGArray removeAllObjects];
    [[marketManager shareInstance].CollectionArray removeAllObjects];
    [[marketManager shareInstance].BTCArray removeAllObjects];
    [[marketManager shareInstance].ETHArray removeAllObjects];
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
            NSLog(@"收到消息-%@--%@",endStr,dic);
            symbolModel*model = [symbolModel mj_objectWithKeyValues:dic];
            if (_isDragging) {
                return;
            }
            if (self.viewType==ChildViewType_USDT) {
                [[marketManager shareInstance].USDTArray enumerateObjectsUsingBlock:^(symbolModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.symbol isEqualToString:model.symbol]) {
                        [[marketManager shareInstance].USDTArray  replaceObjectAtIndex:idx withObject:model];
                        *stop = YES;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem: idx inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
            }
            else if (self.viewType==ChildViewType_UG)
            {
                [[marketManager shareInstance].UGArray enumerateObjectsUsingBlock:^(symbolModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.symbol isEqualToString:model.symbol]) {
                        [[marketManager shareInstance].UGArray  replaceObjectAtIndex:idx withObject:model];
                        *stop = YES;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem: idx inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
            }else if (self.viewType==ChildViewType_BTC)
            {
                [[marketManager shareInstance].BTCArray enumerateObjectsUsingBlock:^(symbolModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.symbol isEqualToString:model.symbol]) {
                        [[marketManager shareInstance].BTCArray  replaceObjectAtIndex:idx withObject:model];
                        *stop = YES;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem: idx inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
            } else if (self.viewType==ChildViewType_ETH)
            {
                [[marketManager shareInstance].ETHArray enumerateObjectsUsingBlock:^(symbolModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.symbol isEqualToString:model.symbol]) {
                        [[marketManager shareInstance].ETHArray  replaceObjectAtIndex:idx withObject:model];
                        *stop = YES;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem: idx inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
            }
            else{
                [[marketManager shareInstance].CollectionArray enumerateObjectsUsingBlock:^(symbolModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    if ([obj.symbol isEqualToString:model.symbol]) {
                        [[marketManager shareInstance].CollectionArray  replaceObjectAtIndex:idx withObject:model];
                        *stop = YES;
                        NSIndexPath *indexPath = [NSIndexPath indexPathForItem: idx inSection:0];
                        [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }];
            }
        }
    }
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
