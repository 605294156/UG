//
//  UGAnnouncementPopView.h
//  BiBeiInternational
//
//  Created by keniu on 2019/5/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGAnnouncementPopView : UIView
+ (instancetype)shareInstance;
-(void)showPopViewWithTitle:(NSString *)title WithAnnouncement:(NSString *)announcement;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UILabel *tittleLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentTextViewHeightLayout;

@end

NS_ASSUME_NONNULL_END
