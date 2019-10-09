//
//  UGAnnouncementNewPopView.h
//  BiBeiInternational
//
//  Created by keniu on 2019/8/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGAnnouncementNewPopView : UIView
+ (void)showPopViewWithTitle:(NSString *)title andAnnouncement:(NSString *)announcement clickItemHandle:(void(^)(void))clickHandle;
+(void)hidePopView;
@end

NS_ASSUME_NONNULL_END
