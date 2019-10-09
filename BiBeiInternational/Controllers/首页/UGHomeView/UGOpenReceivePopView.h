//
//  UGOpenReceivePopView.h
//  BiBeiInternational
//
//  Created by conew on 2019/3/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGOpenReceivePopView : UIView
+ (void)showOpenPopViewClickItemHandle:(void(^)(BOOL isOpen))clickHandle;
+(void)hidenPopView;
@end

NS_ASSUME_NONNULL_END
