//
//  commissionViewController.m
//  bit123
//
//  Created by sunliang on 2018/1/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "commissionViewController.h"
#import "TradeNetManager.h"
#import "commissionModel.h"
#import "marketManager.h"
#import "EntrustCell.h"
#import "sectionHeaderView.h"
#import "HistoryTransactionEntrustViewController.h"
#import "UGCommissionPopView.h"
#import "UGOrderCancelApi.h"
@interface commissionViewController ()
{
    int _page;
}
@property (nonatomic,strong)NSMutableArray *contentArr;
@end

@implementation commissionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=[marketManager shareInstance].symbol;
    [self setTablewViewHeard];
    LYEmptyView*emptyView=[LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:LocalizationKey(@"nocurrentData") detailStr:nil];
    self.tableView.ly_emptyView = emptyView;
    [self getCommissionData:[marketManager shareInstance].symbol];
    [self setupRefesh];
}

-(void)setTablewViewHeard{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.backgroundColor = [UIColor clearColor]; //加上背景颜色，方便观察Button的大小
    //设置图片
    UIImage *imageForButton = [UIImage imageNamed:@"history"];
    [button setImage:imageForButton forState:UIControlStateNormal];
    //设置文字
    NSString *buttonTitleStr = LocalizationKey(@"history");
    [button setTitle:buttonTitleStr forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    CGSize buttonTitleLabelSize = [buttonTitleStr sizeWithAttributes:@{NSFontAttributeName:button.titleLabel.font}]; //文本尺寸
    CGSize buttonImageSize = imageForButton.size;   //图片尺寸
    button.frame = CGRectMake(0,0,
                              buttonImageSize.width + buttonTitleLabelSize.width,
                              buttonImageSize.height);
    [button addTarget:self action:@selector(RighttouchEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    [self.tableView registerNib:[UINib nibWithNibName:@"EntrustCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    self.tableView.rowHeight=115;
    self.tableView.tableFooterView=[UIView new];
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


#pragma mark-查询委托历史
-(void)RighttouchEvent{
    HistoryTransactionEntrustViewController *historyVC = [[HistoryTransactionEntrustViewController alloc] init];
    historyVC.symbol = [marketManager shareInstance].symbol;
    historyVC.baseCoinScale = _baseCoinScale;
    historyVC.coinScale = _coinScale;
    [self.navigationController pushViewController:historyVC animated:YES];
}

#pragma mark-上拉加载更多
- (void)refreshFooterAction{
    _page ++;
    [self getCommissionData:[marketManager shareInstance].symbol];
}

#pragma mark-下拉刷新
- (void)refreshHeaderAction{
    _page = 0;
    [self.contentArr removeAllObjects];
    [self getCommissionData:[marketManager shareInstance].symbol];
}

-(void)getCommissionData:(NSString*)symbol{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [TradeNetManager Querythecurrentdelegatesymbol:symbol withpageNo:_page withpageSize:10 CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if (resPonseObj[@"content"]) {
                NSArray*contentArray=resPonseObj[@"content"];
                if (contentArray.count==0) {
                  //  [self.view ug_showToastWithToast:LocalizationKey(@"nomoreData")];
                    [self.tableView reloadData];
                    return ;
                }
                for (int i=0; i<contentArray.count; i++) {
                    commissionModel*model = [commissionModel mj_objectWithKeyValues:contentArray[i]];
                    [self.contentArr addObject:model];
                }
                [self.tableView reloadData];
                
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EntrustCell * cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
   
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    commissionModel*model=self.contentArr[indexPath.row];
    [cell configModel:model withBaseCoinScale:_baseCoinScale withCoinScale:_coinScale];
    cell.withDraw.tag=indexPath.row;
    [cell.withDraw addTarget:self action:@selector(withDraw:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
    
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    sectionHeaderView*sectionView=[sectionHeaderView instancesectionHeaderViewWithFrame:CGRectMake(0, 0, kWindowW, 40)];
    return sectionView;
    
}
#pragma mark-撤销按钮
-(void)withDraw:(UIButton*)sender{
    commissionModel*model=self.contentArr[sender.tag];
    __weak commissionViewController*weakSelf=self;
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
    
    NSArray *contentArr= @[[model.direction isEqualToString:@"BUY"]==YES?LocalizationKey(@"buyDirection"):LocalizationKey(@"sellDirection"),price,commissionAmount,commissionTotal];
    
    [UGCommissionPopView showPopViewWithTitle:LocalizationKey(@"Confirmation") Titles:contentArr WithTureBtn:@"撤单"  clickItemHandle:^{
        [weakSelf cancelCommissionwithOrderID:model.orderId];//撤单
    }];
}

#pragma mark-撤单
-(void)cancelCommissionwithOrderID:(NSString*)orderId{
    [MBProgressHUD ug_showHUDToKeyWindow];
    UGOrderCancelApi *api= [[UGOrderCancelApi alloc] init];
    api.orderId = orderId;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [MBProgressHUD ug_hideHUDFromKeyWindow];
        if (!apiError) {
            [self.view ug_showToastWithToast:@"撤单成功！"];
            [self refreshHeaderAction];
        }else
            [self.view ug_showToastWithToast:apiError.desc];
    }];
    
//     [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
//    [TradeNetManager cancelCommissionwithOrderID:orderId CompleteHandle:^(id resPonseObj, int code) {
//        if (code) {
//            [EasyShowLodingView hidenLoding];
//            if ([resPonseObj[@"code"] integerValue] == 0) {
//             [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
////                [self.contentArr enumerateObjectsUsingBlock:^(commissionModel* obj, NSUInteger idx, BOOL * _Nonnull stop) {
////                    if ([obj.orderId isEqualToString:orderId]) {
////                        *stop = YES;
////                        [self.contentArr removeObject:obj];
////                        [self.tableView reloadData];
////                    }
////                }];
//                [self refreshHeaderAction];
//            }else{
//                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
//            }
//        }else{
//            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
//        }
//        
//    }];
}
#pragma mark-刷新数据
-(void)reloadShowData:(NSNotification *)text{
    _page = 0;
    [self.contentArr removeAllObjects];
    [self getCommissionData:[NSString stringWithFormat:@"%@/%@",text.userInfo[@"object"],text.userInfo[@"base"]]];
}
#pragma mark-每次滑动
-(void)reloadNewData{
    _page = 0;
    [self.contentArr removeAllObjects];
}
- (NSMutableArray *)contentArr
{
    if (!_contentArr) {
        _contentArr = [NSMutableArray array];
    }
    return _contentArr;
}
kRemoveCellSeparator
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
