//
//  UGGeneralCertificationVC.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGGeneralCertificationVC : UGBaseViewController

@property (nonatomic, copy) void(^refeshData)(NSString *name, NSString *idCar);

@property(nonatomic,assign)BOOL isCarvip;  //点击承兑商按钮过来
@property(nonatomic,strong)UIViewController *baseVC;
@property(nonatomic,assign)BOOL isChangeVip;  //修改实名认证

@end

NS_ASSUME_NONNULL_END
