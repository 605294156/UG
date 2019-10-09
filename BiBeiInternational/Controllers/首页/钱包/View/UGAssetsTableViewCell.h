//
//  UGAssetsTableViewCell.h
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGBaseTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGAssetsTableViewCell : UGBaseTableViewCell
- (void)updateBalance:(NSString *)balance cny:(NSString *)cny type:(NSString *)type;
@end

NS_ASSUME_NONNULL_END
