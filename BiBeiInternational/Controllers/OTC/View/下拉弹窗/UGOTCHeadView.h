//
//  UGOTCHeadView.h
//  BiBeiInternational
//
//  Created by keniu on 2018/12/29.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTCFilterModel.h"

@class UGOTCHeadViewDelegate;

@protocol UGOTCHeadViewDelegate <NSObject>

/**
 筛选切换

 @param fileterModel 筛选后的条件模型
 */
- (void)headViewFilterWithFilerModel:(OTCFilterModel *)fileterModel;


/**
 点击发布我的出售
 */
- (void)headViewReleseToSell;


/**
 点击发布的购买
 */
- (void)headViewReleseToBuy;


@end

NS_ASSUME_NONNULL_BEGIN

@interface UGOTCHeadView : UIView

@property (nonatomic, strong) NSString *buttonTitle;

@property (nonatomic, weak) id <UGOTCHeadViewDelegate>delegate;


@end

NS_ASSUME_NONNULL_END
