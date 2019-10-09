//
//  BuyCoinsViewController.h
//  CoinWorld
//
//  Created by iDog on 2018/1/30.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "SelectCoinTypeModel.h"

@interface BuyCoinsViewController : UGBaseViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic,strong)SelectCoinTypeModel *model;

@end
