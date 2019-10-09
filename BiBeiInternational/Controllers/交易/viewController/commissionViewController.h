//
//  commissionViewController.h
//  bit123
//
//  Created by sunliang on 2018/1/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

@interface commissionViewController : UGBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,assign)int baseCoinScale;
@property(nonatomic,assign)int coinScale;

@end
