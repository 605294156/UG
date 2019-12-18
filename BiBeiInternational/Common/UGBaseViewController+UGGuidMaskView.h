//
//  UGBaseViewController+UGGuidMaskView.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/3.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "MXRGuideMaskView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGBaseViewController (UGGuidMaskView)

#pragma mark - 首页新手引导
- (void)setupHomeNewGuideView:(BOOL)hasPlatData WithBlock:(void(^)(MXRGuideMaskView *maskView))view withCardVip:(BOOL) isCardVip WithHiden:(void(^)(void))hiden;

#pragma mark - otc列表 新手指引
-(void)setOTCGuidView:(NSInteger)count WithBlock:(void(^)(MXRGuideMaskView *maskView))view WithHiden:(void(^)(void))hiden;

#pragma mark - 购买、出售页 新手引导
- (void)setupOTCBuyOrSellNewGuideView:(BOOL)isBuy WithBlock:(void(^)(MXRGuideMaskView *maskView))view;

#pragma mark - 等待支付页面 新手引导
- (void)setupWaitingForPayNewGuideView:(NSInteger)num WithBlock:(void(^)(MXRGuideMaskView *maskView))view;

#pragma mark - 付款页面 新手引导
- (void)setupPayNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view;

#pragma mark - 购买已付款页面 新手引导
- (void)setupHavePayNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view;

#pragma mark - 出售未付款页面 新手引导
- (void)setupDoNotPayNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view;

#pragma mark - 我的发布页面 新手引导
- (void)setupMineAdNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view WithHiden:(void(^)(void))hiden;

#pragma mark - 转币页面 新手引导
- (void)setupTransferNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view;

#pragma mark - 币币兑换页面 新手引导
- (void)setupConinChangeNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view;
@end

NS_ASSUME_NONNULL_END
