//
//  UGAuthenticationCell.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAuthenticationCell : UGBaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subtitleLabel2;
@property (weak, nonatomic) IBOutlet UIImageView *authenticationIcon;
@property (weak, nonatomic) IBOutlet UIImageView *dd2;
@property (nonatomic, assign) NSInteger  iconType;
//需要修改传入model
-(void)updateTitle:(NSInteger )title;


@end

NS_ASSUME_NONNULL_END
