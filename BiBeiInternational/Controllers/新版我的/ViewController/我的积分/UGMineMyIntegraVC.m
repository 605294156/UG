//
//  UGMineMyIntegraVC.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/26.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGMineMyIntegraVC.h"
#import "UGGetTotalScoresApi.h"
#import "UGGetIntergrationListApi.h"
#import "UGIntegrationModel.h"
#import "UGMineMyIntegraCell.h"
#import "UGPopIntegrationView.h"

@interface UGMineMyIntegraVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong) NSArray *dataSource;
@property(nonatomic,strong)NSArray *array;
@property (weak, nonatomic) IBOutlet UILabel *intergrallabel; //积分显示
@property (weak, nonatomic) IBOutlet UILabel *todayIntergraLabel;//今日累计积分
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstraint;
@property (nonatomic,assign)int minseq;

@end

@implementation UGMineMyIntegraVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationBarHidden = YES;
       [self getTotalScoreoRequest];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.topConstraint.constant = UG_StatusBarAndNavigationBarHeight - 44;
  
//    self.tableView.rowHeight = 54;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView ug_registerNibCellWithCellClass:[UGMineMyIntegraCell class]];
    [self setupRefresh];
    
    [self headerBeginRefresh];
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (void)setupRefresh {
    //有刷新头
    __weak typeof(self) weakSelf = self;
    [_tableView setupHeaderRefesh:^{
        [weakSelf refreshData];
    }];
    
    //上拉加载更多
    [_tableView setupNomalFooterRefesh:^{
        [weakSelf loadMoreData];
    }];
    //底部安全距离
    CGFloat offest = [UIDevice isIphoneXSeries]  ? 34.0f : 0;
    //有BottomBar则不忽略
    _tableView.mj_footer.ignoredScrollViewContentInsetBottom = self.hidesBottomBarWhenPushed ?  offest : 0;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getTotalScoreoRequest];
}

- (void)headerBeginRefresh {
    if (self.tableView.mj_header.state != MJRefreshStateRefreshing) {
        [self.tableView.mj_header beginRefreshing];
    }
}

/**
 下拉刷新
 */
- (void)refreshData {
    self.minseq = 1;
    
    [self getTotalScoreoRequest];
    
    [self refreshDataAppend:NO];
}

/**
 加载更多
 */
- (void)loadMoreData {
    [self refreshDataAppend:YES];
}

-(NSArray *)dataSource{
    if (!_dataSource) {
        _dataSource = [[NSArray alloc] init];
    }
    return _dataSource;
}

#pragma mark - 获取今日积分
- (void)getTotalScoreoRequest {
    UGGetTotalScoresApi *api = [[UGGetTotalScoresApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)object;
                NSString *totalStr = [dict objectForKey:@"totalScore"];
                NSString *todayStr = [dict objectForKey:@"todayScore"];
                self.intergrallabel.text = ! UG_CheckStrIsEmpty(totalStr) ? totalStr : @"0";
                self.todayIntergraLabel.text =  ! UG_CheckStrIsEmpty(todayStr) ? todayStr : @"0";
            }
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

/**
 请求数据
 */
- (void)refreshDataAppend:(BOOL)append {
    UGGetIntergrationListApi *postsApi = [[UGGetIntergrationListApi alloc] init];
    postsApi.currentPage =  @(self.minseq);
    [postsApi ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object[@"rows"]) {
            self.array = [UGIntegrationModel mj_objectArrayWithKeyValuesArray:object[@"rows"]];
        }
        if ([self.tableView.mj_header isRefreshing]) {[self.tableView.mj_header endRefreshing];}
        if (apiError) {
            if ([self.tableView.mj_footer isRefreshing]) {[self.tableView.mj_footer endRefreshing]; }
            if (!append && self.dataSource.count < 1) {
                [self.tableView reloadData];
            }
        } else {
            //请求成功分页数++
            self.minseq++;
            NSArray *datas =self.array;
            NSMutableArray *tempArray = nil;
            if (append && self.dataSource) {
                tempArray = [NSMutableArray arrayWithArray:[self.dataSource copy]];
                [tempArray addObjectsFromArray:datas];
            } else {
                if (datas.count > 0) {
                    tempArray = [NSMutableArray arrayWithArray:[datas copy]];
                }
            }
            self.dataSource = [tempArray copy];
            [self.tableView reloadData];
            
            if (!append && self.dataSource.count == 0) {
                [self showTableViewEmptyView];
            } else if (!append && self.dataSource.count > 0){
                [self hiddenTableViewEmpty];
            }
            if ( datas.count < 10) {//后台每页10条数据
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else  if ([self.tableView.mj_footer isRefreshing]) {
                [self.tableView.mj_footer endRefreshing];
            }
        }
    }];
}

- (void)showTableViewEmptyView {
    //先隐藏再显示
    [self hiddenTableViewEmpty];
    //显示
    LYEmptyView*emptyView = [LYEmptyView emptyViewWithImageStr:@"emptyData" titleStr:@"暂无数据" detailStr:nil];
    emptyView.autoShowEmptyView = NO;
    self.tableView.ly_emptyView = emptyView;
    [self.tableView ly_showEmptyView];
}


- (void)hiddenTableViewEmpty {
    [self.tableView ly_hideEmptyView];
}

#pragma maek - 积分规则
- (IBAction)showIntergralHandle:(id)sender {
    [UGPopIntegrationView showIntegrationRuleClickHandle:^{
    }];
}

#pragma mark -返回
- (IBAction)backHandle:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGMineMyIntegraCell *cell = [tableView ug_dequeueReusableNibCellWithCellClass:[UGMineMyIntegraCell class] forIndexPath:indexPath];
    cell.model = self.dataSource[indexPath.section];
    return cell;
}

//#pragma mark - UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return 10.0f;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView  *view = [UIView new];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}

@end
