//
//  UGSystemMessageDetailVC.h
//  BiBeiInternational
//
//  Created by keniu on 2018/12/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGNotifyModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGSystemMessageDetailVC : UGBaseViewController

@property (nonatomic, strong) UGJpushSystemModel *notifyModel;

@property (nonatomic,assign)BOOL isProclamation;//是否是从公告过来
@property (nonatomic,copy)NSString *titleStr;
@property (nonatomic,copy)NSString *content;
@property (nonatomic,copy)NSString *createTime;

@end

NS_ASSUME_NONNULL_END
