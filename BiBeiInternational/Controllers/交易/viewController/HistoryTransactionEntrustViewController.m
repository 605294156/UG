//
//  HistoryTransactionEntrustViewController.m
//  bit123
//
//  Created by iDog on 2018/4/25.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "HistoryTransactionEntrustViewController.h"
#import "MyEntrustTableViewCell.h"
#import "TradeNetManager.h"
#import "MyEntrustInfoModel.h"
#import "MyEntrustDetailViewController.h"

@interface HistoryTransactionEntrustViewController ()<UITableViewDelegate,UITableViewDataSource,MyEntrustTableViewCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,strong)NSMutableArray *dataArr;

@end

@implementation HistoryTransactionEntrustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.symbol;
    self.dataArr = [[NSMutableArray alloc] init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"nohistoryData") detailStr:nil];
    self.tableView.ly_emptyView = emptyView;
    [self.tableView registerNib:[UINib nibWithNibName:@"MyEntrustTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyEntrustTableViewCell class])];
    [self setupRefesh];
     [self getData];
}

//MARK:--设置刷新头尾
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
    [TradeNetManager historyEntrustForSymbol:self.symbol withPageNo:pageNoStr withPageSize:@"10" CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"---%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                //解析数据
                if (self->_pageNo == 0) {
                    [self->_dataArr removeAllObjects];
                }
                NSArray *dataArr = [MyEntrustInfoModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"content"]];
                
                //结束刷新状态
                [self.tableView endRefreshingWithNoMoreData: self.pageNo == 0 ? NO : ( dataArr.count >0 ?  : NO)];

                for (MyEntrustInfoModel *model in dataArr) {
                    [self.dataArr addObject:model];
                }
                [self.tableView reloadData];
                
                //页码++
                self.pageNo++;

            }else if ([resPonseObj[@"code"] integerValue]==4000){
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

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyEntrustTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyEntrustTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyEntrustInfoModel *model = self.dataArr[indexPath.row];
    cell.entrustPriceTitle.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"entrustPrice"),model.baseSymbol];
    cell.timeTitle.text = [NSString stringWithFormat:@"%@",LocalizationKey(@"time")];
    cell.index = indexPath;
    if ([model.direction isEqualToString:@"BUY"]) {
        cell.payStatus.text = LocalizationKey(@"buyDirection");
        cell.payStatus.textColor = GreenColor;
    }else{
        cell.payStatus.text =  LocalizationKey(@"sellDirection");
        cell.payStatus.textColor =RedColor;
    }
    cell.timeData.text =[UG_MethodsTool getFriendyWithStartTime:[self convertStrToTime:model.time]];
    cell.dealTitle.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"dealTotal"),model.baseSymbol];
    cell.dealData.text = [ToolUtil removeFloatAllZeroByString:[NSString stringWithFormat:@"%.4f",model.turnover]];
    
    if ([model.type isEqualToString:@"MARKET_PRICE"]) {
        //
        cell.ntrustPriceData.text = LocalizationKey(@"marketPrice");
        if ([model.direction isEqualToString:@"BUY"]) {
            cell.entrustNumTitle.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"delegateTotal"),model.baseSymbol];
        }else{
            cell.entrustNumTitle.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"entrustNum"),model.coinSymbol];
        }
        
    }else{
        cell.ntrustPriceData.text = [ToolUtil stringFromNumber:[model.price floatValue] withlimit:_baseCoinScale];
        cell.entrustNumTitle.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"entrustNum"),model.coinSymbol];
    }
    cell.dealPerPriceTitle.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"dealPerPrice"),model.baseSymbol];
    if (model.tradedAmount <= 0) {
        cell.dealPerPriceData.text = [ToolUtil stringFromNumber:[@"0" floatValue] withlimit:_baseCoinScale];
    }else{
        double dealPerPriceDou = model.turnover/ model.tradedAmount;
        cell.dealPerPriceData.text = [ToolUtil removeFloatAllZeroByString:[NSString stringWithFormat:@"%.4f",dealPerPriceDou]];
    }
    
    cell.entrustNumData.text = [ToolUtil stringFromNumber:[model.amount floatValue] withlimit:_coinScale];
    cell.dealNumTitle.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"dealNum"),model.coinSymbol];
    cell.dealNumData.text = [ToolUtil stringFromNumber:model.tradedAmount  withlimit:_coinScale];
    if ([model.status isEqualToString:@"COMPLETED"]) {
        //已完成
        cell.statusLabel.text = LocalizationKey(@"completed");
        cell.statusImage.hidden = NO;
        cell.statusButton.userInteractionEnabled = YES;
    }else if ([model.status isEqualToString:@"TRADING"]){
        //交易中
        cell.statusLabel.text = LocalizationKey(@"trading");
        cell.statusImage.hidden = YES;
        cell.statusButton.userInteractionEnabled = NO;
    }else{
        //已取消
        cell.statusLabel.text = LocalizationKey(@"cancelled");
        cell.statusImage.hidden = YES;
        cell.statusButton.userInteractionEnabled = NO;
    }
    cell.delegate = self;
    return cell;
}
//MARK:--已完成回来的代理方法
-(void)completeButtonIndex:(NSIndexPath *)index{
    MyEntrustInfoModel *model = self.dataArr[index.row];
    MyEntrustDetailViewController *detailVC = [[MyEntrustDetailViewController alloc] init];
    detailVC.model = model;
    detailVC.baseCoinScale = _baseCoinScale;
    detailVC.coinScale = _coinScale;
    [self.navigationController pushViewController:detailVC animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 185;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)convertStrToTime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
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
