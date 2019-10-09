//
//  UGBillDetailVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/19.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"


@interface UGBillDetailVC : UGBaseViewController


@property (nonatomic,strong)NSString *orderType;//转收币类型 0 收入  1 转出
@property (nonatomic,strong)NSString *orderSn; //订单号


@end
