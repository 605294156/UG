//
//  OTCPayWayView.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGPayWayView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray *)titles handle:(void(^) (NSString *title, NSInteger index))handle;

@end

NS_ASSUME_NONNULL_END
