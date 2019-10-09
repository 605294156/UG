//
//  UGPayCodeView.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/11.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGPayCodeView : UIView
@property (weak, nonatomic) IBOutlet UIButton *codeLabel;
@property (weak, nonatomic) IBOutlet UIButton *codeTypeLabel;
@property (nonatomic,copy) void(^copyClickBlock)(void);
@property (nonatomic,copy) void(^quesetionClickBlock)(void);
+ (instancetype)fromXib;
@end

NS_ASSUME_NONNULL_END
