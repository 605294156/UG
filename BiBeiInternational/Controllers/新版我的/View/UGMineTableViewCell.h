//
//  UGMineTableViewCell.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGMineTableViewCell : UITableViewCell


- (void)updateTitle:(NSString *)title imageName:(NSString *)imageName firstCell:(BOOL)firstCell lastCell:(BOOL)lastCell;

@end

NS_ASSUME_NONNULL_END
