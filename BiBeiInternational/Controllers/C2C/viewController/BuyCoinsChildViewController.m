//
//  BuyCoinsChildViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/25.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BuyCoinsChildViewController.h"
#import "BuyCoinsViewController.h"
#import "C2CNetManager.h"

@interface BuyCoinsChildViewController ()<XLBasePageControllerDelegate,XLBasePageControllerDataSource>
@property (nonatomic, strong)NSArray *menuList;

@end

@implementation BuyCoinsChildViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.delegate = self;
    self.dataSource = self;
    self.lineWidth = 2.0;//选中下划线宽度
    self.titleFont = [UIFont systemFontOfSize:17.0];
    self.defaultColor = [UIColor blackColor];//默认字体颜色
    self.chooseColor = baseColor;//选中字体颜色
    self.bgViewColor = [UIColor groupTableViewBackgroundColor];
    self.selectIndex = 0;//默认选中第几页
    [self getCoinTypeData];
   
    // Do any additional setup after loading the view.
}
//MARK:--获取全部货币种类
-(void)getCoinTypeData{
   // [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [C2CNetManager selectCoinTypeForCompleteHandle:^(id resPonseObj, int code) {
       // [EasyShowLodingView hidenLoding];
        if (code){
            if ([resPonseObj[@"code"] integerValue]==0) {
                //获取数据成功
                [self->_coinTypeArr removeAllObjects];
                NSLog(@"--%@",resPonseObj);
                NSArray *dataArr = [SelectCoinTypeModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                [self.coinTypeArr addObjectsFromArray:dataArr];
                [self switchViewUI];
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
- (NSMutableArray *)coinTypeArr {
    if (!_coinTypeArr) {
        _coinTypeArr = [NSMutableArray array];
    }
    return _coinTypeArr;
}
//MARK:--第三方切换视图的封装方法
-(void)switchViewUI{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (SelectCoinTypeModel *model in _coinTypeArr) {
        [arr addObject:model.unit];
        NSLog(@"---%@",model.unit);
    }
    self.menuList = arr;
    [self reloadScrollPage];
}
-(NSInteger)numberViewControllersInViewPager:(XLBasePageController *)viewPager
{
    return _menuList.count;
}

-(UIViewController *)viewPager:(XLBasePageController *)viewPager indexViewControllers:(NSInteger)index
{
    BuyCoinsViewController *buyVC = [[BuyCoinsViewController  alloc] init];
    buyVC.model = _coinTypeArr[index];
    return buyVC;
}

-(CGFloat)heightForTitleViewPager:(XLBasePageController *)viewPager
{
    return 40;
}
-(NSString *)viewPager:(XLBasePageController *)viewPager titleWithIndexViewControllers:(NSInteger)index
{
    return self.menuList[index];
}
-(void)viewPagerViewController:(XLBasePageController *)viewPager didFinishScrollWithCurrentViewController:(UIViewController *)viewController
{
    self.title = viewController.title;
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
