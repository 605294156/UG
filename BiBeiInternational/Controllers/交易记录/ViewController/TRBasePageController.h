//
//  TRBasePageController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "WMPageController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TRBasePageController : WMPageController

@property (nonatomic, assign) BOOL isOTC;


/**
 0 全部
 1 支出
 2 收入
 */
@property (nonatomic, assign) NSInteger orderType;

@end

NS_ASSUME_NONNULL_END
