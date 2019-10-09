//
//  UGPopView.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/19.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGPopView : UIView

+ (void)showPopViewWithTitles:(NSArray <NSString *>*)titles imgNames:(NSArray <NSString *>*)imgNames onView:(UIView *)view clickItemHandle:(void(^)(NSInteger index))clickHandle;
@end

NS_ASSUME_NONNULL_END
