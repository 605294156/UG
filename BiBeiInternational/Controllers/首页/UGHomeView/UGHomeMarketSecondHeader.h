//
//  UGHomeMarketSecondHeader.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/16.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseView.h"

@interface UGHomeMarketSecondHeader : UGBaseView
@property(nonatomic,copy)NSMutableArray *titlesArray;
@property(copy, nonatomic) void(^btnClickBlock)(NSInteger index);
@property(copy, nonatomic) void(^clickBlock)(id obj);
@property(nonatomic,assign)NSInteger index;
- (void)btnClickBlock:(void(^)(NSInteger index))block;
- (void)clickBlock:(void(^)(id obj))block;

@end
