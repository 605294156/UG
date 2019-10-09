//
//  UGTableViewController.m
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGTableViewController.h"

@interface UGTableViewController ()

@end

@implementation UGTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _noDataTipText = @"暂无数据";
    _noNetworkTipImage = @"emptyData";
    self.dataSource = [NSArray new];
    [self setupTableView];
    self.minseq = 1;
}


#pragma  mark - Public Method

- (UITableViewStyle)getTableViewSytle {
    return UITableViewStyleGrouped;
}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
}

- (void)headerBeginRefresh {
    if (self.tableView.mj_header.state != MJRefreshStateRefreshing) {
        [self.tableView.mj_header beginRefreshing];
    }
}

- (BOOL)hasFooterRefresh {
    return YES;
}

- (BOOL)hasHeadRefresh {
    return YES;
}

/**
下拉刷新
 */
- (void)refreshData {
    self.minseq = 1;
    [self refreshDataAppend:NO];
}

/**
 加载更多
 */
- (void)loadMoreData {
    [self refreshDataAppend:YES];
}


- (UGBaseRequest *)getRequestApiAppend:(BOOL)append {
    return nil;
}


/**
 请求数据
 */
- (void)refreshDataAppend:(BOOL)append {
    
    UGBaseRequest *postsApi = [self getRequestApiAppend:append];
    
    @weakify(self);
    
    [postsApi ug_startWithCompletionBlock:^(UGApiError *apiError, NSDictionary *object) {
        
        if ([self.tableView.mj_header isRefreshing]) {[self.tableView.mj_header endRefreshing];}
        if (apiError) {
            if ([self.tableView.mj_footer isRefreshing]) {[self.tableView.mj_footer endRefreshing]; }
            
            if (!append && self.dataSource.count < 1) {
                [self.tableView reloadData];
                // 请求失败时，显示错误提示
                [self showErrorEmptyView:apiError.desc clickRelodRequestHandle:^{
                //按钮回调手动加载数据
                    @strongify(self);
                    [self refreshData];
                }];
            }
            
            //当已经刷出几页数据，上拉下拉加载出错时，弹窗提示错误原因
            if (self.dataSource.count) {
                [self.view ug_showToastWithToast:apiError.desc];
            }
            
        } else {
            
            //请求出错时会有遮挡，请求恢复时需要恢复。
            [self.view ly_hideEmptyView];
            //请求成功分页数++
            self.minseq++;
            NSArray *datas = [self getDataFromDictionary:object isAppend:append];
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

//            if (self.tableView.mj_footer.hidden == self.hasMore) {
//                self.tableView.mj_footer.hidden = !self.hasMore;
//            }
        }
    }];
}

- (NSArray *)getDataFromDictionary:(NSDictionary *)object isAppend:(BOOL)append {
    return nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return CGFLOAT_MIN;
}


- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    footerView.contentView.backgroundColor = [UIColor clearColor];
    return footerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    headerView.contentView.backgroundColor = [UIColor clearColor];
    return headerView;
}


#pragma mark -  DZNEmptyDataSetSource DZNEmptyDataSetDelegate

//暂无使用

- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return  self.noNetworkTipImage ? [UIImage imageNamed:self.noNetworkTipImage] : nil;
}

- (NSAttributedString *)titleForEmptyDataSet:(UIScrollView *)scrollView {
    
    NSDictionary *attributes = @{NSFontAttributeName: [UIFont boldSystemFontOfSize:12],
                                 NSForegroundColorAttributeName: [UIColor colorWithHexString:@"222222"]
                                 };
    return [[NSAttributedString alloc] initWithString:self.noDataTipText attributes:attributes];
}

#pragma mark - DZNEmptyDataSetDelegate

- (BOOL)emptyDataSetShouldAllowTouch:(UIScrollView *)scrollView {
    return NO;
}

- (BOOL)emptyDataSetShouldAllowScroll:(UIScrollView *)scrollView {
    return NO;
}

- (CGFloat)spaceHeightForEmptyDataSet:(UIScrollView *)scrollView {
    return 10.0f;
}

- (CGFloat)verticalOffsetForEmptyDataSet:(UIScrollView *)scrollView {
    CGFloat height =  self.tableView.tableHeaderView.frame.size.height /2 - 40;
    return height;
}


#pragma mark - Setter Method

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:[self getTableViewSytle]];
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSelectionStyleNone;
        _tableView.tableFooterView = [UIView new];
        _tableView.estimatedRowHeight = 0;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        //缺省页 会影响到WMPageViewController暂时屏蔽
//        _tableView.emptyDataSetSource = self;
//        _tableView.emptyDataSetDelegate = self;
        
        [_tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
        
        //回收键盘
        [self recyclingKeyboard];
        //上拉、下拉
        [self setupRefresh];
    }
    return _tableView;
}


#pragma mark - Private Method

- (void)showTableViewEmptyView {
    //先隐藏再显示
    [self hiddenTableViewEmpty];
    //显示
    LYEmptyView*emptyView = [LYEmptyView emptyViewWithImageStr:self.noNetworkTipImage titleStr:self.noDataTipText detailStr:nil];
    emptyView.autoShowEmptyView = NO;
    self.tableView.ly_emptyView = emptyView;
    [self.tableView ly_showEmptyView];
}


- (void)hiddenTableViewEmpty {
    [self.tableView ly_hideEmptyView];
}

- (void)recyclingKeyboard {
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    __weak typeof(self) weakSelf = self;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        [weakSelf.tableView endEditing:YES];
    }];
    tap.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tap];
}

- (void)setupRefresh {
    //有刷新头
    if ([self hasHeadRefresh]) {
        __weak typeof(self) weakSelf = self;
        [_tableView setupHeaderRefesh:^{
            [weakSelf refreshData];
        }];
    }
    //上拉加载更多
    if ([self hasFooterRefresh]) {
        __weak typeof(self) weakSelf = self;
        [_tableView setupNomalFooterRefesh:^{
            [weakSelf loadMoreData];
        }];
        //底部安全距离
        CGFloat offest = [UIDevice isIphoneXSeries]  ? 34.0f : 0;
        //有BottomBar则不忽略
        _tableView.mj_footer.ignoredScrollViewContentInsetBottom = self.hidesBottomBarWhenPushed ?  offest : 0;
    }
}

@end
