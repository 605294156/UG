//
//  UGBillViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBillViewController.h"
#import "UGBillContentVC.h"
#import "UGPopTableView.h"

@interface UGBillViewController ()

@property(nonatomic,strong)UGPopTableView *popMenuView;
@property(nonatomic,assign)NSInteger popSelectedIndex;

/**
 赛选条件 默认ALL
 */
@property (nonatomic, assign) UGAppClassType appClassType;


@end

@implementation UGBillViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.appClassType = UGAppClassType_All;
        self.menuViewStyle = WMMenuViewStyleLine;
        self.showOnNavigationBar = NO;
        self.titleColorSelected = HEXCOLOR(0x4264b8);
        self.titleFontName = @"PingFangSC-Medium";
        self.titleColorNormal = [UIColor colorWithHexString:@"9a9fa7"];
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.progressViewIsNaughty = YES;
        self.titleSizeSelected = 15;
        self.titleSizeNormal = 15;
        self.selectIndex = 0;
        self.automaticallyCalculatesItemWidths = YES;
        self.delegate = self;
        self.postNotification = YES;
        self.menuItemWidth = 30;
        CGFloat gap = ((kWindowW-15*2)-self.menuItemWidth*4)/3;
        self.itemsMargins = @[@(15),@(gap),@(gap),@(gap),@(15)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.scrollView.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
    self.title = @"钱包记录";
    self.popSelectedIndex = 0;
    @weakify(self);
    [self setupBarButtonItemWithImageName:@"OT_sx_sx" type:UGBarImteTypeRight callBack:^(UIBarButtonItem * _Nonnull item) {
//        @strongify(self);
//        [self.popMenuView showPopViewOnView:self.navigationController.navigationBar removedFromeSuperView:^{
//            self.popMenuView = nil;
//        }];
        
        [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleActionSheet title:nil message:nil cancle:@"取消" others:@[@"全部",@"收入",@"支出"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
            @strongify(self);
            if (buttonIndex != 0) {
                self.popSelectedIndex = buttonIndex;
                //全部 ：-1  收入：1   支出：0
                NSInteger idx = buttonIndex == 1 ?  -1 : buttonIndex == 2 ? 1 : 0;
                self.appClassType = (UGAppClassType)idx;
                
                [[NSNotificationCenter defaultCenter]postNotificationName:@"UG钱包记录筛选" object:nil userInfo:@{
                                                                                                          @"appClass":@(self.appClassType),
                                                                                                          @"currentConroller" : self.currentViewController
                                                                                                          }];
            }
        }];
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    if (_popMenuView) {
        [self.popMenuView hiddenPopView];
        self.popMenuView = nil;
    }
}

-(UGPopTableView *)popMenuView{
    if (!_popMenuView) {
        @weakify(self);
        _popMenuView = [[UGPopTableView alloc] initWithTtles:@[@"全部",@"收入",@"支出"] selectedIndex:self.popSelectedIndex handle:^(NSString *title, NSInteger index) {
            @strongify(self);
            self.popSelectedIndex = index;
            //全部 ：-1  收入：1   支出：0
            NSInteger idx = index == 0 ?  -1 : index == 2 ? 0 : 1;
            self.appClassType = (UGAppClassType)idx;
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UG钱包记录筛选" object:nil userInfo:@{
                                                                                                      @"appClass":@(self.appClassType),
                                                                                                      @"currentConroller" : self.currentViewController
                                                                                                      }];
        }];
    }
    return _popMenuView;
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
    return 4;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return @[@"全部",@"当日", @"本周", @"本月"] [index];
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    UGBillContentVC *vc = [[UGBillContentVC alloc] init];
    vc.appClassType = self.appClassType;
    vc.title = @[@"全部",@"当日", @"本周", @"本月"] [index];
    return vc;
}

- (void)dealloc {
    NSLog(@"..............");
}


@end
