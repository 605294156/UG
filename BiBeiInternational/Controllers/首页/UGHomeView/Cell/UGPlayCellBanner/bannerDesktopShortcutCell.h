//
//  bannerDesktopShortcutCell.h
//  BiBeiInternational
//
//  Created by keniu on 2019/5/28.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface bannerDesktopShortcutCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *cellContentImageView;
@property (weak, nonatomic) IBOutlet UIView *buttonAndLabelView;
@property (weak, nonatomic) IBOutlet UIButton *saveToDesktopButton;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@end

NS_ASSUME_NONNULL_END
