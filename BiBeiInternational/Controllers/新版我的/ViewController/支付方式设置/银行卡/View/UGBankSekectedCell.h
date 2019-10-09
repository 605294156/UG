//
//  UGBankSekectedCell.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGBankSekectedCell : UGBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *backNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

NS_ASSUME_NONNULL_END
