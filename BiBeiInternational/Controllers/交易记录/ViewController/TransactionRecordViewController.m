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

@property(nonatomic,strong)UGPopTableView *popMenuView;
@property(nonatomic,assign)NSInteger popSelectedIndex;


@end

@implementation TransactionRecordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.popSelectedIndex = 0;
    
    self.menuItemWidth = kWindowW- 80;
    self.titleColorSelected = HEXCOLOR(0x333333);
    self.titleSizeSelected = 18;
//    self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
    
    UIButton *btn = [self setupBarButtonItemWithImageName:@"bill_Shape" type:UGBarImteTypeRight callBack:^(UIBarButtonItem * _Nonnull item) {
        [self.popMenuView showPopViewOnView:self.navigationController.navigationBar removedFromeSuperView:^{
            self.popMenuView = nil;
        }];
    }];
    
//    [btn setImage:[UIImage imageNamed:@"TR_upload_sel"] forState:UIControlStateHighlighted];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_popMenuView) {
        [self.popMenuView hiddenPopView];
        self.popMenuView = nil;
    }
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


-(UGPopTableView *)popMenuView{
    if (!_popMenuView) {
        @weakify(self);
        _popMenuView = [[UGPopTableView alloc] initWithTtles:@[@"全部",@"买入",@"卖出"] selectedIndex:self.popSelectedIndex handle:^(NSString *title, NSInteger index) {
            @strongify(self);
            if (self.popSelectedIndex != index) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"TROrderRefreshData" object:@(index)];
            }
            self.popSelectedIndex = index;
        }];
    }
    return _popMenuView;
}




@end
