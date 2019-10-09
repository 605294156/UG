//
//  UGMakeTrueMnemonnicVC.h
//  ug-wallet
//
//  Created by conew on 2018/9/21.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGMakeTrueMnemonnicVC : UGBaseViewController
@property(nonatomic,assign)BOOL isfromRegister;
@property (nonatomic,assign)BOOL isRegister;
@property(nonatomic,assign)BOOL isFindLoginPassword; //yes  找回密码   no 重置密码  登录
@property(nonatomic,copy)NSString *username; 
@property (nonatomic,strong)UIViewController *topVC;
@property(nonatomic,assign)BOOL isPayPassword;
@property (copy, nonatomic) void(^backlClick)(void);
@property (nonatomic,assign)BOOL isUserName;
@end

NS_ASSUME_NONNULL_END
