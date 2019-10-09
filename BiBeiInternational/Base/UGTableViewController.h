//
//  UGTableViewController.h
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGBaseRequest.h"
#import "UIScrollView+EmptyDataSet.h"


NS_ASSUME_NONNULL_BEGIN

@interface UGTableViewController : UGBaseViewController<UITableViewDelegate, UITableViewDataSource,DZNEmptyDataSetSource, DZNEmptyDataSetDelegate>



@property (nonatomic, strong) UITableView *tableView;

/**
 数据源
 */
@property (nonatomic, strong) NSArray *dataSource;

/**
 分页数 
 */
@property (nonatomic, assign) NSInteger minseq;

/**
 是否有更多数据
 默认 判断有没有返回10条数据没有则判定未没有更多数据
 */
@property (nonatomic, assign) BOOL hasMore;


/**
 无数据提示语
 默认：暂无数据！
 */
@property (nonatomic, copy) NSString *noDataTipText;


/**
 缺省提示语
 需要网络请求框架处理
 */
@property (nonatomic, copy) NSString *noNetworkTipText;

/**
 缺省图片名字
 默认：emptyData
 */
@property (nonatomic, copy) NSString *noNetworkTipImage;


/**
 调用下拉刷新
 */
- (void)headerBeginRefresh;

/**
 设置表单类型 默认UITableViewStyleGrouped

 @return 表单类型
 */
- (UITableViewStyle)getTableViewSytle;

/**
 是否有刷新头
 默认有
 */
- (BOOL)hasHeadRefresh;


/**
 是否有上拉加载更多
 默认有
 */
- (BOOL)hasFooterRefresh;

/**
 创建表单
 */
- (void)setupTableView;

/**
 刷新数据
 */
- (void)refreshData;

/**
 加载更多
 */
- (void)loadMoreData;


/**
 请求对象

 @param append 是否上拉
 */
- (UGBaseRequest *)getRequestApiAppend:(BOOL)append;


/**
 处理后台返回的数据

 @param object 后台数据 NSDictionary
 @param append 是否是上拉加载更多
 @return 处理后的数组
 */
- (NSArray *)getDataFromDictionary:(NSDictionary *)object isAppend:(BOOL)append;

- (void)showTableViewEmptyView;

- (void)hiddenTableViewEmpty;

@end

NS_ASSUME_NONNULL_END
