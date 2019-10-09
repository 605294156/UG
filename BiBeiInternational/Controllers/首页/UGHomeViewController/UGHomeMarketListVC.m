//
//  UGHomeMarketListVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/20.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeMarketListVC.h"
#import "UGHomeMarketTableVC.h"
#import "AppDelegate.h"
#import "MarketNetManager.h"
#import "KchatViewController.h"
#import "UGAddSelfSelectedVC.h"
#import "UGCnyToUsdtApi.h"
#import "UGSymbolThumbApi.h"
#import "UGSymbolThumbModel.h"

@interface UGHomeMarketListVC ()
@property (nonatomic,strong)NSMutableArray *contentArr;
@property (nonatomic,strong)NSMutableArray *baseArray;
@property (nonatomic,strong)NSDictionary *marketDict;
@end

@implementation UGHomeMarketListVC

- (instancetype)init {
    self = [super init];
    if (self) {
        self.menuViewStyle = WMMenuViewStyleLine;
        self.showOnNavigationBar = NO;
        self.titleColorSelected = UG_MainColor;
        self.titleColorNormal = [UIColor colorWithHexString:@"7EC9FF"];
        self.progressColor = UG_MainColor;
        self.menuViewLayoutMode = WMMenuViewLayoutModeScatter;
        self.progressViewIsNaughty = YES;
        self.titleSizeSelected = 15;
        self.titleSizeNormal = 14;
        self.selectIndex = 0;
        self.automaticallyCalculatesItemWidths = YES;
        self.scrollEnable = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"  行情 ！进来了 ！");
    
    self.title = @"行情";
    [self setupBarButtonItemWithImageName:@"changeMoney" type:UGBarImteTypeRight callBack:^(UIBarButtonItem * _Nonnull item) {
        ((AppDelegate*)[UIApplication sharedApplication].delegate).isShowCNY=!((AppDelegate*)[UIApplication sharedApplication].delegate).isShowCNY;
        [[NSNotificationCenter defaultCenter] postNotificationName:SHOWCNY object:nil];
    }];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self getUSDTToCNYRate];
    
    [self getMarketDatas];
}

#pragma mark-获取USDT对CNY汇率
-(void)getUSDTToCNYRate{
    
    UGCnyToUsdtApi *api = [[UGCnyToUsdtApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
               ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate= [NSString stringWithFormat:@"%@",object];
        }else {
            [self.view ug_showToastWithToast:[NSString stringWithFormat:@"汇率-%@",apiError.desc]];
        }
    }];
}

-(NSMutableArray *)baseArray{
    if (!_baseArray) {
        _baseArray = [NSMutableArray new];
    }
    return _baseArray;
}

#pragma mark - 获取所有交易币种缩略行情
-(void)getMarketDatas{
    UGSymbolThumbApi *api = [UGSymbolThumbApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            [self.baseArray removeAllObjects];
            if ([object isKindOfClass:[NSDictionary class]]) {
               self.marketDict  = (NSDictionary *)object;
                self.baseArray = [NSMutableArray arrayWithArray:[self.marketDict allKeys]];
            }
            [self.baseArray addObject:@"自选"];
            [self reloadData];
        }
    }];
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
    return self.baseArray.count;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    if (self.baseArray.count>0) {
          return self.baseArray[index];
    }
    return @" ";
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    UGHomeMarketTableVC *vc = [[UGHomeMarketTableVC alloc] init];
    if (self.baseArray.count>0) {
        vc.baseCoin = self.baseArray[index];
    }
    vc.cellClick = ^(UGSymbolThumbModel *model) {
    KchatViewController*klineVC=[[KchatViewController alloc]init];
    klineVC.symbol=model.symbol;
    [self.navigationController pushViewController:klineVC animated:YES];
    };
    if (index ==self.baseArray.count-1) {
        vc.selectedClick = ^{
            [self.navigationController pushViewController:[UGAddSelfSelectedVC new] animated:YES];
        };
    }
    return vc;
}

- (void)dealloc {
    NSLog(@"..............");
}

@end
