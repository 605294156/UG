//
//  UIViewController+Order.h
//  BiBeiInternational
//
//  Created by keniu on 2018/11/30.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (Order)

#pragma mark - 处理OTC订单状态跳转




/**
 OTC订单跳转
  @param orderSn 订单号
 */
- (void)pustToOTCOrderDetailsWithOrderSn:(NSString *)orderSn;



/**
 取消订单

 @param oderSn 订单号
 */
- (void)cancelOroderWithOrderSn:(NSString *)oderSn handle:(void(^)(void))handle;



/**
 去申诉

 @param oderSn 订单号
 */
- (void)pushToOrderAppealWithOrderSn:(NSString *)oderSn WithReSubmit:(BOOL)resubmit;



/**
 去查看资产
 资产详情页面
 */
- (void)pushToAssetsViewController;



#pragma mark - 绑定谷歌验证器


/**
 检查是否绑定谷歌验证器，没绑定则会弹出提示框进行调整绑定
 
 @return 绑定状态   2.0换手机号
 */
- (BOOL)hasBindingGoogleValidator;

//带提示弹框的是否绑定谷歌验证器
- (BOOL)alerterHasBindingGoogleValidator;

@end

NS_ASSUME_NONNULL_END
