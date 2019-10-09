//
//  UGOTCBaseViewController.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "UGOrderDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCBaseViewController : UGBaseViewController



/**
订单号
 */
@property (nonatomic, strong) NSString *orderSn;



/**
 获取订单详情成功

 @param orderDetailModel 订单详情
 */
- (void)updateViewsData:(UGOrderDetailModel *)orderDetailModel;


/**
 跳转到聊天页面
 */
- (void)pushToChatViewController;



/**
 是否收到新消息
用来更改消息按钮出的红点显示
 @param hasNewMessage 有新消息
 */
- (void)receiveNewIMMessage:(BOOL)hasNewMessage;

@end

NS_ASSUME_NONNULL_END
