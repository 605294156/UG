//
//  UGReceiptCoinPopView.h
//  BiBeiInternational
//
//  Created by XiaoCheng on 05/12/2019.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGReceiptCoinPopView : UIView
+ (void)showWithContext:(NSString *)title WithHandle:(void(^)(void))clickHandle;
@end

NS_ASSUME_NONNULL_END
