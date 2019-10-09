//
//  UGBaseTextField.h
//  ug-wallet
//
//  Created by keniu on 2018/9/21.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Xib.h"

NS_ASSUME_NONNULL_BEGIN

/**
 用于可视化编辑XIB、Storyboard直接调用UIView+Xib中的属性，不需要Run即可看到效果
 */
IB_DESIGNABLE
@interface UGBaseTextField : UITextField

@end

NS_ASSUME_NONNULL_END
