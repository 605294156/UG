//
//  UGReviseWalletPasswordVC.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/24.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGReviseWalletPasswordVC : UGBaseViewController
@property (nonatomic,assign)BOOL isFace;
@property (nonatomic,assign)BOOL isAuxiliaries;
@property (nonatomic,copy)NSString  *token;
@property (nonatomic,copy)NSString *auxiliaries;
@property (nonatomic,strong)UIViewController *topVC;
@end

NS_ASSUME_NONNULL_END
