//
//  UGFindLinkCell.h
//  BiBeiInternational
//
//  Created by conew on 2019/1/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGFindLinkCell : UGBaseTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic,copy) void ((^headClick)(void));
@property (nonatomic,copy) void ((^addClick)(void));
@end

NS_ASSUME_NONNULL_END
