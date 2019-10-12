//
//  UGHomeSecondTwoHeader.h
//  BiBeiInternational
//
//  Created by XiaoCheng on 11/10/2019.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGHomeSecondTwoHeader : UITableViewHeaderFooterView
+(UGHomeSecondTwoHeader *)instanceUGHomeSecondTwoHeaderWithFrame:(CGRect)Rect;
@property(copy, nonatomic) void(^btnClickBlock)(NSInteger index);
@end

NS_ASSUME_NONNULL_END
