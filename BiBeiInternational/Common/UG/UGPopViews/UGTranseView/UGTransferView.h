//
//  UGTransferView.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UGRemotemessageHandle.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGTransferView : UIView
+ (void)showPopViewWithModel:(UGTransferModel *)model clickItemHandle:(void(^)(void))clickHandle;
@end

NS_ASSUME_NONNULL_END
