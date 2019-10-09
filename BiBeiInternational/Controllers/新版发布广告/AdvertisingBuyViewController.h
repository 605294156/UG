//
//  AdvertisingBuyViewController.h
//  CoinWorld
//
//  Created by iDog on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGAdDetailModel.h"

@interface AdvertisingBuyViewController : UGBaseViewController

@property(nonatomic,assign)NSInteger index; //1 编辑界面进入
@property(nonatomic,strong)UGAdDetailModel *detailModel;


/**
 修改交易完成
 */
@property (nonatomic, copy) void(^reviseCompleteHandle)(NSDictionary *dict);

@end
