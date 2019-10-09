//
//  countryViewController.h
//  CoinWorld
//
//  Created by sunliang on 2018/2/23.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "countryModel.h"


typedef void (^ReturnValueBlock) (countryModel *model);

@interface countryViewController : UGBaseViewController

@property(nonatomic, copy) ReturnValueBlock returnValueBlock;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
