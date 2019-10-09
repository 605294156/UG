//
//  UITableView+Expand.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/29.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITableView (Expand)

- (void)ug_registerNibCellWithCellClass:(Class)nibClass;

- (__kindof UITableViewCell *)ug_dequeueReusableNibCellWithCellClass:(Class)nibClass;

- (__kindof UITableViewCell *)ug_dequeueReusableNibCellWithCellClass:(Class)nibClass forIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
