//
//  UGRefreshNormalHeader.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/13.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGRefreshNormalHeader.h"

@implementation UGRefreshNormalHeader


//重写取消国际化
- (void)setLastUpdatedTimeKey:(NSString *)lastUpdatedTimeKey {
    [super setLastUpdatedTimeKey:lastUpdatedTimeKey];
    NSMutableString *str = [[NSMutableString alloc] initWithString:self.lastUpdatedTimeLabel.text];
    
    NSString *last = [NSBundle mj_localizedStringForKey:MJRefreshHeaderLastTimeText];
    
    if ([str rangeOfString:last].location != NSNotFound ) {
        [str replaceCharactersInRange:[str rangeOfString:last] withString:@"最后更新："];

    }
    NSString *today = [NSBundle mj_localizedStringForKey:MJRefreshHeaderDateTodayText];

    if ([str rangeOfString:today].location != NSNotFound ) {
        [str replaceCharactersInRange:[str rangeOfString:today] withString:@"今天"];
    }
    
    NSString *noStr = [NSBundle mj_localizedStringForKey:MJRefreshHeaderNoneLastDateText];
    if ([str rangeOfString:noStr].location != NSNotFound ) {
        [str replaceCharactersInRange:[str rangeOfString:noStr] withString:@"无记录"];
    }

    self.lastUpdatedTimeLabel.text = str;
}

- (void)prepare
{
    [super prepare];
        
    // 自定义文字显示
    [self setTitle:@"松开立即刷新" forState:MJRefreshStatePulling];
    [self setTitle:@"努力加载中" forState:MJRefreshStateRefreshing];
    [self setTitle:@"加载完成" forState:MJRefreshStateIdle];

}

@end
