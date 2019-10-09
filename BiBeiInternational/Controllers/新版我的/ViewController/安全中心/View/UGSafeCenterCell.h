//
//  UGSafeCenterCell.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/12.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGSafeCenterCell : UGBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIImageView *arrowIcon;
@property (weak, nonatomic) IBOutlet UISwitch *switchOpen;
@property (nonatomic,copy)void ((^isOpenSwitchBlock)(BOOL isopen));

@end

NS_ASSUME_NONNULL_END
