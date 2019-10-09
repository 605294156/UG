//
//  UGHomeMarketTableVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/20.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGTableViewController.h"
#import "UGHomeMarketListVC.h"
#import "symbolModel.h"
#import "UGSymbolThumbModel.h"

@interface UGHomeMarketTableVC : UGTableViewController
@property (copy, nonatomic) void(^cellClick)(UGSymbolThumbModel *model);
@property (copy, nonatomic) void(^selectedClick)(void);
@property(nonatomic,assign)ChildViewType  childViewType;
@property(nonatomic,copy)NSString  *baseCoin;
@end
