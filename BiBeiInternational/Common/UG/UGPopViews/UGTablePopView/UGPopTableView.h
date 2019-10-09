//
//  UGPopTableView.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/18.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGTableViewController.h"

@interface UGPopTableView : UIView


- (instancetype)initWithTtles:(NSArray <NSString *>*)titles selectedIndex:(NSInteger)selectedIndex handle:(void(^) (NSString *title, NSInteger index))handle;


- (void)showPopViewOnView:(UIView *)onView removedFromeSuperView:(void (^)(void))handle;

- (void)hiddenPopView;

@end
