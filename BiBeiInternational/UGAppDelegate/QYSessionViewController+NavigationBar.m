//
//  QYSessionViewController+NavigationBar.m
//  BiBeiInternational
//
//  Created by XiaoCheng on 21/11/2019.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "QYSessionViewController+NavigationBar.h"


@implementation QYSessionViewController (NavigationBar)

- (void) setNavigation{
    [self setupBarButtonItemWithImageName:@"goback" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
