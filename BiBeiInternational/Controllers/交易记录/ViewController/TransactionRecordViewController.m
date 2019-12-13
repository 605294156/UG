//
//  TransactionRecordViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "TransactionRecordViewController.h"
#import "TRBasePageController.h"
#import "UGPopTableView.h"


@interface TransactionRecordViewController ()

@property(nonatomic,assign)NSInteger popSelectedIndex;


@end

@implementation TransactionRecordViewController

- (void)viewDidLoad {@weakify(self)
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.popSelectedIndex = 0;
    
    self.menuItemWidth = kWindowW- 80;
    self.titleColorSelected = HEXCOLOR(0x333333);
    self.titleSizeSelected = 18;
//    self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
    
    UIButton *btn = [self setupBarButtonItemWithImageName:@"OT_sx_sx" type:UGBarImteTypeRight callBack:^(UIBarButtonItem * _Nonnull item) {
        
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleActionSheet title:nil message:nil cancle:@"取消" others:@[@"全部",@"买入",@"卖出"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
           @strongify(self);
            if (self.popSelectedIndex != buttonIndex && buttonIndex != 0) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TROrderRefreshData" object:@(buttonIndex-1)];
            }
            self.popSelectedIndex = buttonIndex;
        }];
    }];
    
//    [btn setImage:[UIImage imageNamed:@"TR_upload_sel"] forState:UIControlStateHighlighted];
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
//    return 2;
    return 1;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
//    return index == 0 ?  @"法币" : @"币币";
    return @"交易订单";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    TRBasePageController *pageVC = [TRBasePageController new];
    pageVC.orderType = self.popSelectedIndex;
    pageVC.isOTC = index == 0;
    return   pageVC;
}



@end
