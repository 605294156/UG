//
//  UGFindPassWordTureVC.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/22.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGFindPassWordTureVC : UGBaseViewController
@property (nonatomic, copy) NSString *phone;//---旧手机号
@property(nonatomic,copy)NSString *code;//验证码
@property (nonatomic,strong)UIViewController *topVC;
@property(nonatomic,assign)BOOL isFindLoginPassword;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *auxiliaries;

@end

NS_ASSUME_NONNULL_END
