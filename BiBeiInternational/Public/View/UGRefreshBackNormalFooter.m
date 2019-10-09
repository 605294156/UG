//
//  UGRefreshBackNormalFooter.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/13.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGRefreshBackNormalFooter.h"

@implementation UGRefreshBackNormalFooter

- (void)prepare
{
    [super prepare];
    
    // 自定义文字显示
    [self setTitle:@"点击或上拉加载更多" forState:MJRefreshStateIdle];
    [self setTitle:@"努力加载中" forState:MJRefreshStateRefreshing];
    [self setTitle:@"松开立即加载更多" forState:MJRefreshStatePulling];
    [self setTitle:@"没有更多数据" forState:MJRefreshStateNoMoreData];
}

@end
