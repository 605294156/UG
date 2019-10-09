//
//  LeftMenuViewController.h
//  bit123
//
//  Created by sunliang on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

@interface LeftMenuViewController : UGBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(assign,nonatomic)ChildViewType viewType;
@property (copy, nonatomic) void(^selectedClick)(void);
- (void)showFromLeft;

@end
