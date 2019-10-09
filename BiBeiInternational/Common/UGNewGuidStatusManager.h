//
//  UGNewGuidStatusManager.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/14.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGNewGuidStatusManager : NSObject

+ (instancetype) shareInstance;

/**
 首页新手引导全局临时变量值
 */
@property (nonatomic, copy) NSString *homeNewStatus;

/**
 OTC新手引导全局临时变量值
 */
@property (nonatomic, copy) NSString *OTCStatus;
@property (nonatomic, copy) NSString *OTCShowOne;//页面的特殊性 出现过一次就不让它出现了

/**
 购买页面
 */
@property (nonatomic,copy) NSString *OTCBuyStatus;

/**
 出售页面
 */
@property (nonatomic,copy) NSString *OTCSellStatus;

/**
 广告列表页面
 */
@property (nonatomic,copy) NSString *AdStatus;

/**
 转币
 */
@property (nonatomic,copy) NSString *TransferStatus;
/**
 币币兑换
 */
@property (nonatomic,copy) NSString *CoinToCoinStatus;

/**
 卡商 开启接单 弹框  全局状态控制
 */
@property (nonatomic,copy) NSString *openCardOrderReceive;

/**
  公告弹窗是否被View 全局状态控制
*/
@property(nonatomic,assign) BOOL AnnouncementIsViewByUser;

@end

NS_ASSUME_NONNULL_END
