//
//  TradeViewController.h
//  bit123
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

@interface TradeViewController : UGBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *asktableView;//卖出
@property (weak, nonatomic) IBOutlet UITableView *bidtableView;//买入
@property (weak, nonatomic) IBOutlet UITableView *entrusttableView;//委托lineView
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDistance;
@property (weak, nonatomic) IBOutlet UIButton *logBtn;

@end
