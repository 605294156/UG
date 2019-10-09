//
//  IdentityAuthenticationViewController.h
//  CoinWorld
//
//  Created by iDog on 2018/2/7.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

@interface IdentityAuthenticationViewController : UGBaseViewController

@property(nonatomic,copy)NSString *identifyStatus;
@property(nonatomic,copy)NSString *realAuditing; //该项表示实名认证是否正在审核中，0表示是，1表示否
@property(nonatomic,copy)NSString *realNameRejectReason;//拒绝理由

@end
