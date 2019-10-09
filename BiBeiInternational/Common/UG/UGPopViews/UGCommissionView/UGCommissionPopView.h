//
//  UGCommissionPopView.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/7.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGCommissionPopView : UIView
+ (void)showPopViewWithTitle:(NSString *)title Titles:(NSArray <NSString *>*)titles WithTureBtn:(NSString *)tureStr  clickItemHandle:(void(^)(void))clickHandle;
@end

NS_ASSUME_NONNULL_END
