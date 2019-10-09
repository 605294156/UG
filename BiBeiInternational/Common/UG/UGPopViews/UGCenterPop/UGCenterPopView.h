//
//  UGCenterPopView.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/20.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface UGCenterPopView : UIView

+ (void)showPopViewWithTitle:(NSString *)title Titles:(NSArray <NSString *>*)titles WithSelected:(NSString *)selectedStr clickItemHandle:(void(^)(NSString *obj))clickHandle;
+(void)hidePopView;
@end

NS_ASSUME_NONNULL_END
