//
//  WalletManageDetailViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/5.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "WalletManageDetailViewController.h"
#import "WalletManageDetailTableViewCell.h"
#import "CalendarView.h"
#import "MineNetManager.h"
#import "TradeHistoryModel.h"

@interface WalletManageDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property (nonatomic, weak) CalendarView *calendarView;
@property(nonatomic,strong)NSMutableArray *tradeHistoryArr;
@property(nonatomic,assign)NSInteger pageNo;

@end

@implementation WalletManageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = LocalizationKey(@"detail");
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"WalletManageDetailTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([WalletManageDetailTableViewCell class])];
    [self setupRefesh];
    LYEmptyView *emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"detailTableViewTip") detailStr:nil];
    self.tableView.ly_emptyView = emptyView;
    
    self.pageNo = 0;
    [self getData];
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - 设置刷新头尾
- (void)setupRefesh {
    @weakify(self);
    [self.tableView setupHeaderRefesh:^{
        @strongify(self);
        [self refreshHeaderAction];
    }];
    
    [self.tableView setupNomalFooterRefesh:^{
        @strongify(self);
        [self refreshFooterAction];
    }];
}

//MARK:--上拉加载
- (void)refreshFooterAction{
    [self getData];
}

//MARK:--下拉刷新
- (void)refreshHeaderAction{
    self.pageNo = 0;
    [self getData];
}

//MARK:--获取数据
-(void)getData{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
     NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    [MineNetManager getTradeHistoryForCompleteHandleWithPageNo:pageNoStr withPageSize:@"10" CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"--%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (self.pageNo == 0) {
                    [self.tradeHistoryArr removeAllObjects];
                }
                NSArray *dataArr = [TradeHistoryModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"content"]];
                //结束刷新状态
                [self.tableView endRefreshingWithNoMoreData: self.pageNo == 0 ? NO : ( dataArr.count >0 ?  : NO)];
                [self.tradeHistoryArr addObjectsFromArray:dataArr];
                [self.tableView reloadData];
                //更改页码数
                self.pageNo ++;
            }else if ([resPonseObj[@"code"] integerValue] == 3000 ||[resPonseObj[@"code"] integerValue] == 4000 ){
                [self.tableView endRefreshingWithNoMoreData:NO];
                [[UGManager shareInstance] signout:nil];
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                [self.tableView endRefreshingWithNoMoreData:NO];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
            [self.tableView endRefreshingWithNoMoreData:NO];
        }
    }];
}
- (NSMutableArray *)tradeHistoryArr {
    if (!_tradeHistoryArr) {
        _tradeHistoryArr = [NSMutableArray array];
    }
    return _tradeHistoryArr;
}
//MARK:--日历的点击事件
-(void)RighttouchEvent{
    NSLog(@"点击日历");
    [self getCalendarView];
    
}
//MARK:--
-(void)getCalendarView{
    if (!_calendarView) {
        _calendarView = [[NSBundle mainBundle] loadNibNamed:@"CalendarView" owner:nil options:nil].firstObject;
        _calendarView.frame=[UIScreen mainScreen].bounds;
    }
    [UIApplication.sharedApplication.keyWindow addSubview:_calendarView];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _tradeHistoryArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WalletManageDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([WalletManageDetailTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    TradeHistoryModel *model = _tradeHistoryArr[indexPath.row];
    cell.dateLabel.text = [ToolUtil transformForTimeString:model.createTime];
    cell.mentionMoneyNum.text = [ToolUtil formartScientificNotationWithString:model.amount];
    if ([model.amount doubleValue]>=0) {
        cell.mentionMoneyNum.textColor=GreenColor;
    }else{
         cell.mentionMoneyNum.textColor=RedColor;
    }
    cell.mentionMoneyType.text = model.symbol;
    if([model.type isEqualToString:@"0"]){
        cell.coinType.text = LocalizationKey(@"top-up");
    }
    else if([model.type isEqualToString:@"1"]){
        cell.coinType.text = LocalizationKey(@"withdrawal");
    }
    else if([model.type isEqualToString:@"2"]){
        cell.coinType.text = LocalizationKey(@"transfer");
    }
    else if([model.type isEqualToString:@"3"]){
        cell.coinType.text = LocalizationKey(@"coinCurrencyTrading");
    }
   else if([model.type isEqualToString:@"4"]){
        cell.coinType.text = LocalizationKey(@"FiatMoneyBuy");
    }
    else  if([model.type isEqualToString:@"5"]){
        cell.coinType.text = LocalizationKey(@"FiatMoneySell");;
    }
    else  if([model.type isEqualToString:@"6"]){
        cell.coinType.text = LocalizationKey(@"activitiesReward");;
    }
    else  if([model.type isEqualToString:@"7"]){
        cell.coinType.text = LocalizationKey(@"promotionRewards");
    }
    else  if([model.type isEqualToString:@"8"]){
        cell.coinType.text = LocalizationKey(@"shareOutBonus");
    }
    else  if([model.type isEqualToString:@"9"]){
        cell.coinType.text = LocalizationKey(@"vote");
    }
    else  if([model.type isEqualToString:@"10"]){
        cell.coinType.text = LocalizationKey(@"ArtificialTop-up");
    }else if ([model.type isEqualToString:@"11"]){
        cell.coinType.text = LocalizationKey(@"pairing");
    }else{
        cell.coinType.text = LocalizationKey(@"other");
    }
    cell.statusLabel.text = LocalizationKey(@"completed");
    cell.feeLabel.text = [ToolUtil formartScientificNotationWithString:model.fee];
     
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 125;
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
