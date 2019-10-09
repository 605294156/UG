//
//  BuyCoinsViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/1/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BuyCoinsViewController.h"
#import "CoinTableViewCell.h"
#import "AdvertisingBGView.h"
#import "AdvertisingBuyViewController.h"
#import "AdvertisingSellViewController.h"
#import "BuyCoinsDetailViewController.h"
#import "C2CNetManager.h"
#import "CoinUserInfoModel.h"

@interface BuyCoinsViewController ()<UITableViewDataSource,UITableViewDelegate>{
    AdvertisingBGView *_adView; //交易
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;
@property(nonatomic,assign)NSInteger pageNo;
@property (nonatomic,strong)NSMutableArray *coinTypeArr;
@end

@implementation BuyCoinsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"CoinTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([CoinTableViewCell class])];
//    AdjustsScrollViewInsetNever(self, self.tableView);
    [self setupRefesh];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if ([version compare:@"10.0"] != NSOrderedAscending) {
       self.bottomViewHeight.constant = SafeAreaBottomHeight+49;
    }else{
       self.bottomViewHeight.constant = SafeAreaBottomHeight;
    }
    [self languageChange];
}


//MARK:--国际化通知处理事件
- (void)languageChange {
    LYEmptyView *emptyView=[LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"noBuyCoinTip") detailStr:nil];
    self.tableView.ly_emptyView = emptyView;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.pageNo = 1;
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
    self.pageNo = 1;
    [self getData];
}
//MARK:--获取交易的数据
-(void)getData{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    NSString *pageNoStr = [[NSString alloc] initWithFormat:@"%ld",(long)_pageNo];
    @weakify(self)
    [C2CNetManager advertisingQueryForPageNo:pageNoStr withPageSize:@"20" withAdvertiseType:@"SELL" withAdvertiseId:self.model.ID CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"-model---id-%@",self.model.ID);
        @strongify(self);
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                if (self.pageNo == 1) {
                     [self.coinTypeArr removeAllObjects];
                }
                
                NSLog(@"--%@",resPonseObj);
                NSArray *dataArr = [CoinUserInfoModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"][@"context"]];
                //结束刷新状态
                [self.tableView endRefreshingWithNoMoreData: self.pageNo == 0 ? NO : ( dataArr.count >0 ?  : NO)];

                [self.coinTypeArr addObjectsFromArray:dataArr];

                [self.tableView reloadData];
                
                //页码++
                self.pageNo++;

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
- (NSMutableArray *)coinTypeArr {
    if (!_coinTypeArr) {
        _coinTypeArr = [NSMutableArray array];
    }
    return _coinTypeArr;
}
//MARK:--买币的点击事件
- (IBAction)buyCoinBtnClick:(UIButton *)sender {
    NSLog(@"买币了");
    [self advertisingBGView];
}
-(void)advertisingBGView{
    
    if (!_adView) {
        _adView = [[NSBundle mainBundle] loadNibNamed:@"AdvertisingBGView" owner:nil options:nil].firstObject;
        _adView.frame=[UIScreen mainScreen].bounds;
       
        [_adView.buyButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [_adView.sellButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [_adView.cancelButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
    }
     [_adView setMenu];
    
    [UIApplication.sharedApplication.keyWindow addSubview:_adView];
}
-(void)push:(UIButton*)sender{
    
    [_adView dismissMenu];
    
    if(!([[UGManager shareInstance] hasLogged])&&sender.tag != 3){
        [self showLoginViewController];
    }else{
        if(sender.tag == 1){
            //购买
            AdvertisingBuyViewController *buyVC = [[AdvertisingBuyViewController alloc] init];
            [self.navigationController pushViewController:buyVC animated:YES];
        }else if (sender.tag == 2){
            //出售
            AdvertisingSellViewController *sellVC = [[AdvertisingSellViewController alloc] init];
            [self.navigationController pushViewController:sellVC animated:YES];
        }else if (sender.tag == 3){
            //取消
            NSLog(@"取消发布");
        }else{
            //其他
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _coinTypeArr.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CoinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CoinTableViewCell class]) forIndexPath:indexPath];
    CoinUserInfoModel *model = _coinTypeArr[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (model.avatar == nil || [model.avatar isEqualToString:@""]) {
        cell.headImage.image = [UIImage imageNamed:@"header_defult"];
    }else{
        NSURL *headUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",PicHOST,model.avatar]];
        [cell.headImage sd_setImageWithURL:headUrl];
    }
    cell.userName.text = model.memberName;
    cell.tradingNum.text = [NSString stringWithFormat:@"%@%@",LocalizationKey(@"trading"),model.transactions];
    [cell.buyButton setTitle: LocalizationKey(@"buy") forState:UIControlStateNormal];
    cell.limitNum.text = [NSString stringWithFormat:@"%@%@-%@元",LocalizationKey(@"limit"),model.minLimit,model.maxLimit];
    cell.coinNum.text = [NSString stringWithFormat:@"%@元",model.price];
    NSArray  *array = [model.payMode componentsSeparatedByString:@","];
    [cell cellForArray:array];
    cell.remainAmount.text = [NSString stringWithFormat:@"%@:%@",LocalizationKey(@"amount"),[ToolUtil judgeStringForDecimalPlaces:model.remainAmount]];

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(!([[UGManager shareInstance] hasLogged])){
        [self showLoginViewController];
    }else{
        BuyCoinsDetailViewController *detailVC = [[BuyCoinsDetailViewController alloc] init];
        CoinUserInfoModel *model = _coinTypeArr[indexPath.row];
        detailVC.advertisingId = model.advertiseId;
        detailVC.unit = model.unit;
        detailVC.headImage = model.avatar;
        detailVC.flagindex = 2;
        detailVC.remainAmount=model.remainAmount;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
