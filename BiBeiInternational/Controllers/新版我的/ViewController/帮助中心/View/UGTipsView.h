//
//  UGTipsView.h
//  BiBeiInternational
//
//  Created by XiaoCheng on 21/10/2019.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGTipsView : UIView
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *subTitle;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

NS_ASSUME_NONNULL_END
