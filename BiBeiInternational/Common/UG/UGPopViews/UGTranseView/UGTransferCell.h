//
//  UGTransferCell.h
//  BiBeiInternational
//
//  Created by conew on 2018/11/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGTransferCell : UGBaseTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *sub;
@property (weak, nonatomic) IBOutlet UIButton *btn;
@property (copy, nonatomic) void(^click)(void);
@end

NS_ASSUME_NONNULL_END
