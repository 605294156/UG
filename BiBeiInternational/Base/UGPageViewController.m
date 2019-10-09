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
        self.titleColorSelected = [UIColor whiteColor];
        self.titleColorNormal = [UIColor colorWithHexString:@"7EC9FF"];
        self.progressColor = [UIColor whiteColor];
        self.progressViewBottomSpace = 5;
        self.menuViewLayoutMode = WMMenuViewLayoutModeCenter;
        self.titleSizeSelected = 20;
        self.titleSizeNormal = 20;
        self.selectIndex = 0;
        self.progressViewIsNaughty = YES;
        self.progressWidth = 40;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
}


- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    return width;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    CGFloat leftMargin = 68;
    CGRect rect = CGRectMake(leftMargin, 0, self.view.frame.size.width - leftMargin *2, 44);
    return rect;
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return self.view.bounds;
}

@end
