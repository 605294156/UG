//
//  MyEntrustViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/4/10.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MyEntrustViewController.h"
#import "MyEntrustTableViewCell.h"
#import "MineNetManager.h"
#import "MyEntrustInfoModel.h"
#import "MyEntrustDetailViewController.h"
#import "TradeNetManager.h"
#import "PST_MenuView.h"
#import "UGTabBarController.h"

@interface MyEntrustViewController ()<UITableViewDelegate,UITableViewDataSource,MyEntrustTableViewCellDelegate,PST_MenuViewDelegate>{
    
    int _baseCoinScale;//精确度(小数点后几位)
    int _coinScale;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *tradCoinArr;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *coinArr;//获取支持币对数组
@property(nonatomic,copy)NSString *clickIndex;//点击标记
@property(nonatomic,strong)PST_MenuView *menuView;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,assign)NSInteger indexPathRow;
@property (weak, nonatomic) IBOutlet UIImageView *pullimageV;
@property (weak, nonatomic) IBOutlet UIButton *titleBtn;

@end

@implementation MyEntrustViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"myEntrust");
    [self.view addSubview:[self tableView]];
    self.tradCoinArr = [[NSMutableArray alloc] init];
    self.dataArr = [[NSMutableArray alloc] init];
    self.coinArr = [[NSMutableArray alloc] init];
    self.pageNo = 0;
    [self getTradCoinData];
    [self.view bringSubviewToFront:self.backView];
    self.indexPathRow = 0;
    [self setupRefesh];
}

//MARK:--获取交易对数据
-(void)getTradCoinData{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager getTradCoinForCompleteHandle:^(id resPonseObj, int code) {
        NSLog(@"--%@",resPonseObj);
        if ([resPonseObj isKindOfClass:[NSArray class]]) {
            NSArray *dataArr = [MyEntrustInfoModel mj_objectArrayWithKeyValuesArray:resPonseObj];
            if (dataArr.count > 0) {
                for (MyEntrustInfoModel *model in dataArr) {
                    [self.tradCoinArr addObject:model.symbol];
                    [self.coinArr addObject:model];
                }
                MyEntrustInfoModel * model = self.coinArr[0];
                self->_baseCoinScale = model.baseCoinScale;
                self->_coinScale = model.coinScale;
                [self.titleBtn setTitle:model.symbol forState:UIControlStateNormal];
                [self getData];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
-(UITableView *)tableView{
    if (!_tableView) {
        UGTabBarController*tabbar=(UGTabBarController*)APPLICATION.window.rootViewController;
        if (tabbar.selectedIndex==2) {
           _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kWindowW, kWindowH-SafeAreaBottomHeight-60) style:UITableViewStylePlain];
        }else{
           _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kWindowW, kWindowH-SafeAreaBottomHeight-SafeAreaTopHeight-60) style:UITableViewStylePlain];
        }
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight=185;
        _tableView.tableFooterView=[UIView new];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"MyEntrustTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MyEntrustTableViewCell class])];
    }
    return _tableView;
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
    [TradeNetManager historyEntrustForSymbol:[self.tradCoinArr objectAtIndex:self.indexPathRow] withPageNo:pageNoStr withPageSize:@"10" CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"---%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                
                //解析数据
                if (self.pageNo == 0) {
                    [self.dataArr removeAllObjects];
                }
                NSArray *dataArr = [MyEntrustInfoModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"content"]];
                //结束刷新状态
                [self.tableView endRefreshingWithNoMoreData: self.pageNo == 0 ? NO : ( dataArr.count >0 ?  : NO)];

                for (MyEntrustInfoModel *model in dataArr) {
                    [self.dataArr addObject:model];
                }
                if (self.dataArr.count > 0) {
                    self.backView.hidden = YES;
                }else{
                   self.backView.hidden = NO;
                }
                [self.tableView reloadData];
                
                //页码++
                self.pageNo++;

                
            }else if ([resPonseObj[@"code"] integerValue]==4000){
                [[UGManager shareInstance] signout:nil];
                [self.tableView endRefreshingWithNoMoreData:NO];
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
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyEntrustTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MyEntrustTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MyEntrustInfoModel *model = self.dataArr[indexPath.row];
    cell.index = indexPath;
    if ([model.direction isEqualToString:@"BUY"]) {
        cell.payStatus.text = LocalizationKey(@"Buy");
        cell.payStatus.textColor = GreenColor;
    }else{
        cell.payStatus.text = LocalizationKey(@"Sell");
        cell.payStatus.textColor =RedColor;
    }
    cell.timeTitle.text = LocalizationKey(@"time");
    cell.entrustPriceTitle.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"entrustPrice"),model.baseSymbol];
    cell.timeData.text = [ToolUtil convertStrToTime:model.time];
    cell.dealTitle.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"dealTotal"),model.baseSymbol];
    cell.dealData.text = [ToolUtil removeFloatAllZeroByString:[NSString stringWithFormat:@"%.8f",model.turnover]];
  
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
        cell.dealPerPriceData.text = [NSString stringWithFormat:@"0.00"];
    }else{
        double dealPerPriceDou = model.turnover /model.tradedAmount;
        cell.dealPerPriceData.text = [ToolUtil removeFloatAllZeroByString:[NSString stringWithFormat:@"%.8f",dealPerPriceDou]];
    }
    
    cell.entrustNumData.text = [ToolUtil stringFromNumber:[model.amount floatValue] withlimit:_coinScale];
    cell.dealNumTitle.text = [NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"dealNum"),model.coinSymbol];
     cell.dealNumData.text = [ToolUtil stringFromNumber:model.tradedAmount withlimit:_coinScale];
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

-(void)didSelectRowAtIndex:(NSInteger)index title:(NSString *)title img:(NSString *)img{
    NSLog(@"index----%zd,  title---%@, image---%@", index, title, img);
    if ([self.clickIndex isEqualToString:@"1"]) {
        self.clickIndex = @"0";
    }else{
        self.clickIndex = @"1";
    }
    
    self.indexPathRow = index;
    MyEntrustInfoModel * model = self.coinArr[index];
    _baseCoinScale = model.baseCoinScale;
    _coinScale = model.coinScale;
    [self.titleBtn setTitle:title forState:UIControlStateNormal];
    _pageNo=0;
    [self getData];
}

//MARK:切换标题选项
- (IBAction)touchEvent:(UIButton *)sender {
    if ([self.clickIndex isEqualToString:@"1"]) {
       
        self.pullimageV.image=[UIImage imageNamed:@"downBlackImage"];
        self.clickIndex = @"0";
    }else{
        
        self.pullimageV.image=[UIImage imageNamed:@"pullBlackImage"];
        self.clickIndex = @"1";
    }
    //点击出现弹框
    NSMutableArray *imageArr = [[NSMutableArray alloc] init];
    for (NSString *str  in self.tradCoinArr) {
        NSLog(@"--%@",str);
        [imageArr addObject:@""];
    }
    PST_MenuView *menuView = [[PST_MenuView alloc] initWithFrame:CGRectMake(10, SafeAreaTopHeight+40, 120, 260) titleArr:self.tradCoinArr imgArr:imageArr arrowOffset:100 rowHeight:50 layoutType:0 directionType:0 delegate:self];
    menuView.backgroundColor = [UIColor clearColor];
    menuView.lineColor = [UIColor darkGrayColor];
    menuView.titleColor = [UIColor whiteColor];
    menuView.arrowColor = [UIColor colorWithRed:0/255.0 green:96/255.0 blue:96/255.0 alpha:1];
    
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
