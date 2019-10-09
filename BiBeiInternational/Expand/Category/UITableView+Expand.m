//
//  UITableView+Expand.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/29.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UITableView+Expand.h"

@implementation UITableView (Expand)

- (void)ug_registerNibCellWithCellClass:(Class)nibClass {
    [self registerNib:[UINib nibWithNibName:NSStringFromClass(nibClass) bundle:nil] forCellReuseIdentifier:NSStringFromClass(nibClass)];
}


- (__kindof UITableViewCell *)ug_dequeueReusableNibCellWithCellClass:(Class)nibClass {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(nibClass)];
}

- (__kindof UITableViewCell *)ug_dequeueReusableNibCellWithCellClass:(Class)nibClass forIndexPath:(NSIndexPath *)indexPath {
    return [self dequeueReusableCellWithIdentifier:NSStringFromClass(nibClass) forIndexPath:indexPath];
}

@end
