//
//  UGSelectedBankHeader.h
//  BiBeiInternational
//
//  Created by conew on 2018/12/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGSelectedBankHeader : UITableViewHeaderFooterView
@property (nonatomic,copy) void(^sectionBlock)(void);
@end

NS_ASSUME_NONNULL_END
