//
//  UIView+UGToast.h
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (UGToast)

- (void)ug_showToastWithToast:(NSString *)toast;


- (void)ug_showSpeialToastWithToast:(NSString *)toast;

@end

NS_ASSUME_NONNULL_END
