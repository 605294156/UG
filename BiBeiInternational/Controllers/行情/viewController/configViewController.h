//
//  configViewController.h
//  bit123
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

//typedef enum : NSUInteger {
//    ChildViewType_USDT=0,
//    ChildViewType_UG,
//    ChildViewType_Collection
//} ChildViewType;
@interface configViewController : UGBaseViewController


- (instancetype)initWithChildViewType:(ChildViewType)childViewType;
-(void)reloadData;//刷新数据


@end
