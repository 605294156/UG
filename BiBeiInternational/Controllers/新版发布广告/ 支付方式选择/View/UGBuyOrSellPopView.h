//
//  UGBuyOrSellPopView.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/19.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGBuyOrSellPopView : UIView

+ (void)initWithTitle:(NSString *)title WithNumber:(NSString *)number WithRate:(NSString *)rate WithReal:(NSString *)real withType:(BOOL)type WithHandle:(void(^)(void))clickHandle;

@end

NS_ASSUME_NONNULL_END
