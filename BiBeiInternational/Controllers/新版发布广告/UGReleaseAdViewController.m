//
//  UGReleaseAdViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/24.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGReleaseAdViewController.h"
#import "AdvertisingBuyViewController.h"
#import "AdvertisingSellViewController.h"

@interface UGReleaseAdViewController ()
@property (nonatomic, strong)UIColor *color;
@end

@implementation UGReleaseAdViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuViewStyle = WMMenuViewStyleFlood;
        self.showOnNavigationBar = NO;
        self.menuItemWidth = 120;
        self.titleColorNormal = UG_MainColor;
        self.titleColorSelected = [UIColor whiteColor];
        self.titleSizeSelected = 14;
        self.titleSizeNormal = 14;
        self.selectIndex = 0;
        self.scrollEnable = NO;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布交易";
    self.view.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
    self.color = [UIColor colorWithHexString:@"43B0FF"];
    self.selectIndex = self.mIndex;
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
    menu.superview.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
    menu.backgroundColor = [UIColor clearColor];
    //需要把color strong 不然会导致真机crash，因为过早释放
    menu.progressView.color = [self.color CGColor];
    menu.progressView.cornerRadius = 10.0f;
    menu.speedFactor = 10;
    menu.progressHeight = 28;
    menu.layer.masksToBounds = YES;
    menu.layer.borderWidth = 1.0f;
    menu.layer.borderColor = [UIColor colorWithHexString:@"43B0FF"].CGColor;
    menu.layer.cornerRadius = 13.0f;

    return width;
}

-(BOOL)isCardVip{
    return [[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString:@"1"];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    if ([self isCardVip]) {
        //卡商
        self.menuItemWidth = 160;
        return CGRectMake((self.view.frame.size.width - 162)/2, 9, 162, 28);
    }
    return CGRectMake((self.view.frame.size.width - 242)/2, 9, 242, 28);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, 9*2+28, self.view.size.width, self.view.size.height - 9*2 - 28);
}

- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    if ([self isCardVip]) {
        //卡商
        return 1;
    }
    return 2;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if ([self isCardVip]) {
        //卡商
        return @"我要出售";
    }
    return index == 0 ? @"我要购买" : @"我要出售";
}


- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    if ([self isCardVip]) {
        //卡商
        return [AdvertisingSellViewController new];
    }
    if (index == 0) {
        return [AdvertisingBuyViewController new];
    }
    return [AdvertisingSellViewController new];
}


@end
