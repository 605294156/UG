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
#define xxxxx_menuItemWidth 63.f
- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuViewStyle = WMMenuViewStyleLine;
        self.showOnNavigationBar = NO;
        self.menuItemWidth = xxxxx_menuItemWidth;
        self.titleColorNormal = HEXCOLOR(0x9a9fa7);
        self.titleColorSelected = HEXCOLOR(0x4264b8);
        self.titleFontName = @"PingFangSC-Medium";
        self.titleSizeSelected = 15;
        self.titleSizeNormal = 15;
        self.selectIndex = 0;
        self.scrollEnable = NO;
        self.menuView.layoutMode = WMMenuViewLayoutModeScatter;
    }
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"发布交易";
    self.view.backgroundColor = [UIColor whiteColor];
//    self.scrollView.backgroundColor = [UIColor yellowColor];
    self.color = [UIColor colorWithHexString:@"43B0FF"];
    self.selectIndex = self.mIndex;
    
    
    UIImageView *line = UIImageView.new;
    line.backgroundColor = HEXCOLOR(0xefefef);
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.height.equalTo(@.5);
        make.bottom.equalTo(self.menuView.mas_bottom);
    }];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    CGFloat width = [super menuView:menu widthForItemAtIndex:index];
//    menu.superview.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
    menu.backgroundColor = [UIColor whiteColor];
    //需要把color strong 不然会导致真机crash，因为过早释放
//    menu.progressView.color = [self.color CGColor];
//    menu.progressView.cornerRadius = 10.0f;
//    menu.speedFactor = 10;
//    menu.progressViewBottomSpace = 28;
//    menu.layer.masksToBounds = YES;
//    menu.layer.borderWidth = 1.0f;
//    menu.layer.borderColor = [UIColor colorWithHexString:@"43B0FF"].CGColor;
//    menu.layer.cornerRadius = 13.0f;
    self.progressViewBottomSpace = 10.f;
    return width;
}

-(BOOL)isCardVip{
    return [[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString:@"1"];
}
#define xxxxx_Release_H  28.f
#define xxxx_hhhh  5.f
- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    if ([self isCardVip]) {
        //卡商
//        self.menuItemWidth = 66;
        return CGRectMake(10, 0, xxxxx_menuItemWidth, xxxxx_Release_H+xxxx_hhhh);
    }
    return CGRectMake(10, 0, xxxxx_menuItemWidth*2+25, xxxxx_Release_H+xxxx_hhhh);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, xxxxx_Release_H+xxxx_hhhh, self.view.size.width, self.view.size.height - xxxxx_Release_H-xxxx_hhhh);
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
