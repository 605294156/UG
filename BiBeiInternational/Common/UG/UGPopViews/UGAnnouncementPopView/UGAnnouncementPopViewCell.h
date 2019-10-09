//
//  UGAnnouncementPopViewCell.h
//  BiBeiInternational
//
//  Created by keniu on 2019/8/9.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGAnnouncementPopViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *announcementContentTextView;
@property (weak, nonatomic) IBOutlet UILabel *announcementTittleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewHeightLayout;
@property (weak, nonatomic) IBOutlet UIButton *iKnowButton;

@end

NS_ASSUME_NONNULL_END
