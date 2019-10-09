//
//  UGHomeRightPopView.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/16.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseView.h"

@interface UGHomeRightPopView : UGBaseView
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)NSArray *iconArray;
@property (copy, nonatomic) void(^cellClick)(UGHomeRightPopView *popview,NSInteger index);
- (void)cellClick:(void(^)(UGHomeRightPopView *popview,NSInteger index))block;
/**
 *  初始化调用
 */
-(instancetype)initWithController:(UIViewController *)controller;

/**
 *  显示弹框
 */
- (void)show;

/**
 *  隐藏弹框
 */
-(void)hide;

/**
 *  替换图片
 */
-(void)setTitleArray:(NSArray *)titleArray withIconArray:(NSArray *)iconArray;

@end
