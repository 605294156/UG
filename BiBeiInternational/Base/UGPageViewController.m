//
//  UGPageViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/16.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPageViewController.h"
#import "MXRGuideMaskView.h"

@interface UGPageViewController ()

@end

@implementation UGPageViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuViewStyle = WMMenuViewStyleLine;
        self.showOnNavigationBar = YES;
        self.titleColorSelected = HEXCOLOR(0x4264b8);
        self.titleColorNormal = HEXCOLOR(0x9a9fa7);
//        self.progressColor = HEXCOLOR(0x4264b8);
        self.progressViewBottomSpace = -3;
        self.menuViewLayoutMode = WMMenuViewLayoutModeLeft;
        self.titleSizeSelected = 17;
        self.titleSizeNormal = 17;
        self.selectIndex = 0;
//        self.progressViewIsNaughty = YES;
//        self.progressWidth = 34;
        self.itemMargin = 10;
//        self.menuViewContentMargin = 15;
        
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
}


- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index]-10;
    return width;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGFloat leftMargin = 40;
    CGRect rect = CGRectMake(leftMargin, 0, self.view.mj_w-leftMargin*2, 44);
//    menuView.backgroundColor = [UIColor yellowColor];
    return rect;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return self.view.bounds;
}

@end
