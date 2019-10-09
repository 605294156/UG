//
//  UGHomeMarketVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/20.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeMarketVC.h"
#import "UGHomeMarketListVC.h"

@interface UGHomeMarketVC ()

@end

@implementation UGHomeMarketVC
- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuViewStyle = WMMenuViewStyleLine;
        self.showOnNavigationBar = NO;
        self.titleColorSelected = [UIColor colorWithHexString:@"108BE4"];
        self.titleColorNormal = [UIColor colorWithHexString:@"7EC9FF"];
        self.progressColor = [UIColor colorWithHexString:@"108BE4"];
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.progressViewIsNaughty = YES;
        self.titleSizeSelected = 14;
        self.titleSizeNormal = 14;
        self.selectIndex = 0;
        self.automaticallyCalculatesItemWidths = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"行情";
    @weakify(self);
    [self setupBarButtonItemWithImteWithImageName:@"changeMoney" type:UGBarImteTypeRight callBack:^(UIBarButtonItem * _Nonnull item) {
        @strongify(self);
        [self rightEvent];
    }];
}

#pragma mark - 左边按钮
-(void)rightEvent{
    
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    menuView.backgroundColor = [UIColor whiteColor];
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width, 40);
    return rect;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    CGFloat originY = 40;
    return CGRectMake(0, originY, self.view.frame.size.width, self.view.frame.size.height - originY);
}


- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return 3;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return @[@"USDT", @"UG", @"自选"] [index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    return [UGHomeMarketListVC new];
}

- (void)dealloc {
    NSLog(@"..............");
}
@end
