//
//  UIScrollView+Refersh.m
//  ug-wallet
//
//  Created by keniu on 2018/9/18.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UIScrollView+Refersh.h"
#import "UGRefreshNormalHeader.h"
#import "UGRefreshBackNormalFooter.h"

@implementation UIScrollView (Refersh)

- (void)setupHeaderRefesh:(void(^)(void))refreshBlock {
    @weakify(self);
    self.mj_header = [UGRefreshNormalHeader headerWithRefreshingBlock:^{
        @strongify(self);
        [self.mj_footer resetNoMoreData];
        if (refreshBlock) {
            refreshBlock();
        }
    }];
    self.mj_header.automaticallyChangeAlpha = YES;
}


- (void)setupNomalFooterRefesh:(void(^)(void))refreshBlock {
   self.mj_footer = [UGRefreshBackNormalFooter  footerWithRefreshingBlock:^{
        if (refreshBlock) {
            refreshBlock();
        }
    }];
//    self.mj_footer.automaticallyHidden = YES;
}

/**
 结束刷新状态
 
 @param noMoreData 是否没有更多数据
 */
- (void)endRefreshingWithNoMoreData:(BOOL)noMoreData {
    //结束下拉刷新
    if (self.mj_header.isRefreshing) {[self.mj_header endRefreshing];}
    //结束上拉加载更多
    if (self.mj_footer.isRefreshing) {
        [self.mj_footer endRefreshing];
        if (noMoreData) {
            [self.mj_footer endRefreshingWithNoMoreData];
        } else {
            [self.mj_footer endRefreshing];
        }
    }
}



@end
