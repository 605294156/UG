//
//  UIScrollView+Refersh.h
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIScrollView (Refersh)


/**
 为了兼容之前的老代码，这里结束刷新需要请求响应了才能处理。暂时不动这里需要修改的太多了。
 正确的需要打开屏蔽的代码，网络请求后处理刷新状态
 @param refreshBlock 回调
 */
- (void)setupHeaderRefesh:(void(^)(void))refreshBlock;


/**
 为了兼容之前的老代码，这里结束刷新需要请求响应了才能处理。暂时不动这里需要修改的太多了。
 正确的需要打开屏蔽的代码，网络请求后处理刷新状态
 
 @param refreshBlock 回调
 */
- (void)setupNomalFooterRefesh:(void(^)(void))refreshBlock;



/**
 结束刷新状态

 @param noMoreData 是否没有更多数据
 */
- (void)endRefreshingWithNoMoreData:(BOOL)noMoreData;


@end

NS_ASSUME_NONNULL_END
