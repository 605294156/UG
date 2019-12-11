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

@property (nonatomic, assign) CGFloat  headerXXHeight;


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


/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 *  param lineDirection   虚线的方向  YES 为水平方向， NO 为垂直方向
 **/
- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor lineDirection:(BOOL)isHorizonal;
@end

NS_ASSUME_NONNULL_END
