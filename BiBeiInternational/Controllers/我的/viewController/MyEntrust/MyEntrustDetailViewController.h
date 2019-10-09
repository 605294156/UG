//
//  MyEntrustDetailViewController.h
//  CoinWorld
//
//  Created by iDog on 2018/4/11.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "MyEntrustInfoModel.h"

@interface MyEntrustDetailViewController : UGBaseViewController

@property(nonatomic,strong)MyEntrustInfoModel *model;
@property(nonatomic,assign)int baseCoinScale;
@property(nonatomic,assign)int coinScale;

@end
