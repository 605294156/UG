//
//  CToCViewController.m
//  CoinWorld
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "CToCViewController.h"
//#import "BuyCoinsViewController.h"
//#import "SellCoinsViewController.h"
#import "SearchViewController.h"
#import "countryViewController.h"
#import "ImageBtn.h"
#import "countryModel.h"
#import "C2CNetManager.h"
#import "SelectCoinTypeModel.h"

#import "SellCoinsChildViewController.h"
#import "BuyCoinsChildViewController.h"
#import "AdvertisingBGView.h"
#import "AdvertisingBuyViewController.h"
#import "AdvertisingSellViewController.h"
#import "C2CNetManager.h"

@interface CToCViewController (){
    AdvertisingBGView *_adView; //交易
}
@property (nonatomic, strong) UIScrollView       *scrollView;
@property (nonatomic, assign) NSInteger           currentIndex;
@property (nonatomic, strong) UISegmentedControl *segment;
@property(nonatomic,strong)NSMutableArray *coinTypeArr;
@property (nonatomic, copy) NSString *memberLever;
@end

@implementation CToCViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self accountSettingData];
}
-(void)accountSettingData{
    
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [C2CNetManager getBusinessStatusForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"---%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                
                NSString*memberLevel = [NSString stringWithFormat:@"%@",resPonseObj[@"data"][@"memberLevel"]];
                self.memberLever = memberLevel;
                
            }else if ([resPonseObj[@"code"] integerValue]==4000){
                
                [[UGManager shareInstance] signout:nil];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNavBarUI];
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.navigationItem.title=@"";
    _currentIndex = 0;
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH-SafeAreaTopHeight)];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.scrollEnabled = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_scrollView];
    _scrollView.contentSize = CGSizeMake(kWindowW*2, 0);
    [self addChildViewController];
}

- (void)addChildViewController {
    
    BuyCoinsChildViewController *buyVC = [[BuyCoinsChildViewController alloc] init];
    buyVC.view.frame = CGRectMake(0, 0, kWindowW, _scrollView.frame.size.height);
    [self addChildViewController:buyVC];
    buyVC.coinTypeArr = _coinTypeArr;
    [self.scrollView addSubview:buyVC.view];
    
    
    SellCoinsChildViewController *sellVC = [[SellCoinsChildViewController alloc] init];
    sellVC.view.frame = CGRectMake(kWindowW, 0, kWindowW, _scrollView.frame.size.height);
    [self addChildViewController:sellVC];
    [self.scrollView addSubview:sellVC.view];
}

//MARK:--国际化通知处理事件
- (void)languageChange {
    [self setNavBarUI];
    if (_adView) {
        [_adView.buyButton setTitle:LocalizationKey(@"buy") forState:UIControlStateNormal];
        [_adView.sellButton setTitle:LocalizationKey(@"sell") forState:UIControlStateNormal];
    }
}


//MARK:--导航栏的设置
-(void)setNavBarUI{
    _segment = [[UISegmentedControl alloc]initWithItems:@[
                                                          LocalizationKey(@"BuyCoin"),
                                                          LocalizationKey(@"SellCoin"),
                                                          ]];
    _segment.frame =CGRectMake(60,(SafeAreaTopHeight-30)/2,200, 30);
    self.navigationItem.titleView = _segment;
    _segment.selectedSegmentIndex = 0;
    _segment.tintColor =mainColor;
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:mainColor,NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:17],NSFontAttributeName ,nil];
    NSDictionary *dic_select = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont fontWithName:@"AppleGothic"size:17],NSFontAttributeName ,nil];
    [_segment setTitleTextAttributes:dic forState:UIControlStateNormal];
    [_segment setTitleTextAttributes:dic_select forState:UIControlStateSelected];
    [_segment addTarget:self action:@selector(handelSegementControlAction:) forControlEvents:(UIControlEventValueChanged)];
    [self setupNavItem];
    
}

#pragma mark - 导航栏左右按钮
- (void)setupNavItem {
    @weakify(self);
    [self setupBarButtonItemWithImageName:@"orders" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem *item) {
        @strongify(self);
        [self LefttouchEvent];
    }];
    
    [self setupBarButtonItemWithImageName:@"adversitingClickImage" type:UGBarImteTypeRight callBack:^(UIBarButtonItem *item) {
        @strongify(self);
        [self RighttouchEvent];
    }];
}


//MARK:--我的订单点击事件
-(void)LefttouchEvent{
    if(!([[UGManager shareInstance] hasLogged])){
        [self showLoginViewController];
        return;
    }
//    MyBillViewController *billVC = [[MyBillViewController alloc] init];
//    [self.navigationController pushViewController:billVC animated:YES];
}


//MARK:--跳进创建交易界面
-(void)RighttouchEvent{

    if ([self.memberLever isEqualToString:@"2"]) {
        [self advertisingBGView];
    }else{
        [self.view ug_showToastWithToast:LocalizationKey(@"memberLevelTip")];
        
    }
}
-(void)advertisingBGView{
    
    if (!_adView) {
        _adView = [[NSBundle mainBundle] loadNibNamed:@"AdvertisingBGView" owner:nil options:nil].firstObject;
        _adView.frame=[UIScreen mainScreen].bounds;
        
        [_adView.buyButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [_adView.sellButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [_adView.cancelButton addTarget:self action:@selector(push:) forControlEvents:UIControlEventTouchUpInside];
        [_adView.buyButton setTitle:LocalizationKey(@"buy") forState:UIControlStateNormal];
        [_adView.sellButton setTitle:LocalizationKey(@"sell") forState:UIControlStateNormal];
    }
    [_adView setMenu];
    
    [UIApplication.sharedApplication.keyWindow addSubview:_adView];
}
-(void)push:(UIButton*)sender{
    
    [_adView dismissMenu];
    
    if(!([[UGManager shareInstance] hasLogged])&&sender.tag != 3){
        [self showLoginViewController];
    }else{
        if(sender.tag == 1){
            //购买
            AdvertisingBuyViewController *buyVC = [[AdvertisingBuyViewController alloc] init];
            [self.navigationController pushViewController:buyVC animated:YES];
        }else if (sender.tag == 2){
            //出售
            AdvertisingSellViewController *sellVC = [[AdvertisingSellViewController alloc] init];
            [self.navigationController pushViewController:sellVC animated:YES];
        }else if (sender.tag == 3){
            //取消
            NSLog(@"取消发布");
        }else{
            //其他
        }
    }
}
//MARK:--选择国家的点击事件
-(void)leftBtnClick{
    __weak CToCViewController*weakSelf=self;
      countryViewController *countryVC = [[countryViewController alloc]init];
      countryVC.returnValueBlock = ^(countryModel *model){
         //MARK:重置标题无效，只能重新设置leftBarButtonItem
          ImageBtn*leftButton=[[ImageBtn alloc]initWithFrame:CGRectMake(0, 0, 70, 40) :model.zhName :[UIImage imageNamed:@"pullImage.png"]];
          leftButton.backgroundColor=[UIColor clearColor];
          [leftButton addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];
          UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
          weakSelf.navigationItem.leftBarButtonItem = leftBarButton;
    };
    
    [self.navigationController pushViewController:countryVC animated:YES];
}
- (void)handelSegementControlAction:(UISegmentedControl *)segment
{
    _currentIndex = segment.selectedSegmentIndex;
    [self.scrollView setContentOffset:CGPointMake(kWindowW*_currentIndex, 0) animated:NO];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
