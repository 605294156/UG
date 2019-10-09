//
//  MineViewController.m
//  CoinWorld
//
//  Created by sunliang on 2018/1/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "MineViewController.h"
#import "MineTableViewCell.h"
#import "AccountSettingViewController.h"
#import "MyAdvertisingViewController.h"
#import "SettingCenterViewController.h"
#import "WalletManageViewController.h"
#import "IdentityAuthenticationViewController.h"
#import "GestureViewController.h"
#import "MineNetManager.h"
#import "AccountSettingInfoModel.h"
#import "UIImageView+WebCache.h"
#import "WalletManageModel.h"
#import "NSUserDefaultUtil.h"
#import "MyEntrustViewController.h"
#import "MyPromoteViewController.h"
#import "VersionUpdateModel.h"
#import "MineTableHeadView.h"
@interface MineViewController ()<UITableViewDataSource,UITableViewDelegate>{
    BOOL updateFlag;
    UIView *_tableHeadView;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;
@property(nonatomic,strong) AccountSettingInfoModel *accountInfo;
@property(nonatomic,strong) NSMutableArray *assetTotalArr;
@property(nonatomic,copy)NSString *assetUSD;
@property(nonatomic,copy)NSString *assetCNY;
@property(nonatomic,strong)VersionUpdateModel *versionModel;
@property(nonatomic,strong) MineTableHeadView *headerView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.topViewHeight.constant = -(SafeAreaTopHeight- 44);

    self.navigationBarHidden = YES;

    self.navigationItem.title=@"";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"MineTableViewCell" bundle:nil] forCellReuseIdentifier:NSStringFromClass([MineTableViewCell class])];
    
    _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWindowW, kWindowW/3*2+50)];
    self.tableView.tableHeaderView = _tableHeadView;
    self.headerView=[[[MineTableHeadView alloc]init] instancetableHeardViewWithFrame:_tableHeadView.frame];
    [self.headerView.headButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.headButton.tag = 1;
    [self.headerView.assetButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.assetButton.tag = 2;
    [self.headerView.eyeButton addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    self.headerView.eyeButton.tag = 3;
    [_tableHeadView addSubview:self.headerView];
    self.assetTotalArr = [[NSMutableArray alloc] init];
    self.headerView.totalAssets.text = LocalizationKey(@"totalAssets");
    [self versionUpdate];
    
}
//MARK:--版本更新接口请求
-(void)versionUpdate{
    [MineNetManager versionUpdateForId:@"1" CompleteHandle:^(id resPonseObj, int code) {
         NSLog(@"--%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                self.versionModel = [VersionUpdateModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                // app当前版本
                 NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
                NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
                if ([app_Version compare:self.versionModel.version] == NSOrderedSame ||[app_Version compare:self.versionModel.version] == NSOrderedDescending) {
                    //不需要更新
                    self->updateFlag = NO;
                }else{
                    self->updateFlag = YES;
                }
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:6 inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            }else if ([resPonseObj[@"code"] integerValue]==4000||[resPonseObj[@"code"] integerValue]==3000){
                [[UGManager shareInstance] signout:nil];
                
            }else if ([resPonseObj[@"code"] integerValue] == 500) {
                //无版本更新，不提示
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
    
}
//MARK:--国际化通知处理事件
- (void)languageChange{
    self.headerView.totalAssets.text = LocalizationKey(@"totalAssets");
    [self.tableView reloadData];
}



-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([[NSUserDefaultUtil GetDefaults:HIDEMONEY] boolValue]) {
        self.headerView.eyeButton.selected = NO;
    }else{
        self.headerView.eyeButton.selected = YES;
    }
    if(!([[UGManager shareInstance] hasLogged])){
        //没登录不做处理
        self.headerView.headImage.image = [UIImage imageNamed:@"header_defult"];
        self.headerView.userName.text = LocalizationKey(@"userName");
        self.headerView.account.text = LocalizationKey(@"accounting");
        if (!self.headerView.eyeButton.selected) {
            [self.headerView.eyeButton setBackgroundImage:[UIImage imageNamed:@"closeEye"]
                                  forState:UIControlStateNormal];
            self.headerView.asset1.text = @"********";
            self.headerView.asset2.text = [NSString stringWithFormat:@"********"];
        }else{
            [self.headerView.eyeButton setBackgroundImage:[UIImage imageNamed:@"openEye"]
                                  forState:UIControlStateNormal];
            self.headerView.asset1.text = @"0.000000";
            self.headerView.asset2.text = [NSString stringWithFormat:@"≈0.00CNY"];
        }
    }else{
        
        [self accountSettingData];
        if (!self.headerView.eyeButton.selected) {
            [self.headerView.eyeButton setBackgroundImage:[UIImage imageNamed:@"closeEye"]
                                  forState:UIControlStateNormal];
            self.headerView.asset1.text = @"********";
            self.headerView.asset2.text = [NSString stringWithFormat:@"********"];
        }else{
            [self.headerView.eyeButton setBackgroundImage:[UIImage imageNamed:@"openEye"]
                                  forState:UIControlStateNormal];
            [self getTotalAssets];
        }
    }
}
-(NSArray *)getImageArr{
    NSArray * imageArr = @[@"orderImage",@"advertisingImage",@"entrustImage",@"promoteImage",@"safeImage",@"setting",@"versionUpdate"];
    return imageArr;
}
-(NSArray *)getNameArr{
    
    NSArray * nameArr = @[
                          LocalizationKey(@"myBill"),
                          LocalizationKey(@"myAdvertising"),
                          LocalizationKey(@"myEntrust"),
                          LocalizationKey(@"myPromotion"),
                          LocalizationKey(@"safeCenter"),
                         LocalizationKey(@"settingCenter"),
                          LocalizationKey(@"versionUpdate")
                          ];
    return nameArr;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 7;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MineTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MineTableViewCell class]) forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.leftImage.image = [UIImage imageNamed:[self getImageArr][indexPath.row]];
    cell.leftLabel.text = [self getNameArr][indexPath.row];
    if (indexPath.row == 6) {
        if (updateFlag) {
            cell.rightLabel.hidden = NO;
        }else{
            cell.rightLabel.hidden = YES;
        }
    }else{
       cell.rightLabel.hidden = YES;
    }
    return cell;
    
}
//MARK:--头像点击事件  账号设置
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        //判断用户是否已经登录
        if(!([[UGManager shareInstance] hasLogged])){
            [self showLoginViewController];
        }else{
            //头像点击事件  账号设置
            AccountSettingViewController *accountVC = [[AccountSettingViewController alloc] init];
            [self.navigationController pushViewController:accountVC animated:YES];
        }
    }else if (sender.tag == 2){
        //判断用户是否已经登录
        if(!([[UGManager shareInstance] hasLogged])){
            [self showLoginViewController];
        }else{
            //我的UG钱包点击事件 查看资产
            WalletManageViewController *walletVC = [[WalletManageViewController alloc] init];
            walletVC.assetUSD = self.assetUSD;
            walletVC.assetCNY = self.assetCNY;
            [self.navigationController pushViewController:walletVC animated:YES];
        }
    }else if (sender.tag == 3){
        //眼睛的点击事件  显示或隐藏
        if (sender.selected) {
            [sender setBackgroundImage:[UIImage imageNamed:@"closeEye"]
             forState:UIControlStateNormal];
            self.headerView.asset1.text = @"********";
            self.headerView.asset2.text = [NSString stringWithFormat:@"********"];
            [NSUserDefaultUtil PutBoolDefaults:HIDEMONEY Value:YES];
        }else{
            [sender setBackgroundImage:[UIImage imageNamed:@"openEye"]
              forState:UIControlStateNormal];
            if(!([[UGManager shareInstance] hasLogged])){
                //没登录不做处理
                self.headerView.asset1.text = @"0.000000";
                self.headerView.asset2.text = [NSString stringWithFormat:@"≈0.00CNY"];
                 [NSUserDefaultUtil PutBoolDefaults:HIDEMONEY Value:NO];
            }else{
                double ass1 = 0.0;
                double ass2 = 0.0;
                for (WalletManageModel *walletModel in self.assetTotalArr) {
                    //计算总资产
                   
                    ass1 = ass1 +[walletModel.balance doubleValue]*[walletModel.coin.usdRate doubleValue];
                    ass2 = ass2 +[walletModel.balance doubleValue]*[walletModel.coin.cnyRate doubleValue];
                }
                self.headerView.asset1.text = [NSString stringWithFormat:@"%f",ass1];
                self.headerView.asset2.text = [NSString stringWithFormat:@"≈%.2fCNY",ass2];
                 [NSUserDefaultUtil PutBoolDefaults:HIDEMONEY Value:NO];
            }
        }
        sender.selected = !sender.selected;
    }    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 6){
       //版本更新
        if (updateFlag) {
            //版本更新
            NSURL *url = [NSURL URLWithString:_versionModel.downloadUrl];
            if([[UIDevice currentDevice].systemVersion floatValue] >= 10.0){
                if ([[UIApplication sharedApplication] respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    if (@available(iOS 10.0, *)) {
                        [[UIApplication sharedApplication] openURL:url options:@{}
                                                 completionHandler:^(BOOL success) {
                                                     NSLog(@"Open %d",success);
                                                 }];
                    } else {
                        
                    }
                } else {
                    BOOL success = [[UIApplication sharedApplication] openURL:url];
                    NSLog(@"Open  %d",success);
                }
                
            } else{
                bool can = [[UIApplication sharedApplication] canOpenURL:url];
                if(can){
                    [[UIApplication sharedApplication] openURL:url];
                }
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"versionUpdateTip")];
            return;
        }
    }else{
        if(!([[UGManager shareInstance] hasLogged])){
            [self showLoginViewController];
        }else{
            if (indexPath.row == 0 ){
                //我的账单
//                MyBillViewController *billVC = [[MyBillViewController alloc] init];
//                [self.navigationController pushViewController:billVC animated:YES];
            }else if (indexPath.row == 1){
                //我的交易
                MyAdvertisingViewController *advertisingVC = [[MyAdvertisingViewController alloc] init];
                advertisingVC.avatar=self.accountInfo.avatar;
                [self.navigationController pushViewController:advertisingVC animated:YES];
            }else if (indexPath.row == 2){
                //我的委托
                MyEntrustViewController *entrustVC = [[MyEntrustViewController alloc] init];
                [self.navigationController pushViewController:entrustVC animated:YES];
            }else if(indexPath.row == 3){
                //我的推广
                NSLog(@"我的推广");
                MyPromoteViewController *promoteVC = [[MyPromoteViewController alloc] init];
                [self.navigationController pushViewController:promoteVC animated:YES];
            }else if(indexPath.row == 4){
                // 安全中心
                GestureViewController *safeVC = [[GestureViewController alloc] init];
                [self.navigationController pushViewController:safeVC animated:YES];
            }
            else if (indexPath.row == 5){
                //设置中心
                SettingCenterViewController *setVC = [[SettingCenterViewController alloc] init];
                [self.navigationController pushViewController:setVC animated:YES];
               
            }else{
                //其他
            }
        }
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

//MARK:--请求总资产的接口
-(void)getTotalAssets{
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager getMyWalletInfoForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                NSLog(@"--%@",resPonseObj);
                [self.assetTotalArr removeAllObjects];
                NSArray *dataArr = [WalletManageModel mj_objectArrayWithKeyValuesArray:resPonseObj[@"data"]];
                double ass1 = 0.0;
                double ass2 = 0.0;
                for (WalletManageModel *walletModel in dataArr) {
                    //计算总资产
                    ass1 = ass1 +[walletModel.balance doubleValue]*[walletModel.coin.usdRate doubleValue];
                    ass2 = ass2 +[walletModel.balance doubleValue]*[walletModel.coin.cnyRate doubleValue];
                    
                    [self.assetTotalArr addObject:walletModel];
                }
                self.headerView.asset1.text = [NSString stringWithFormat:@"%f",ass1];
                self.headerView.asset2.text = [NSString stringWithFormat:@"≈%.2fCNY",ass2];
                self.assetUSD = self.headerView.asset1.text;
                self.assetCNY  = self.headerView.asset2.text;
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
//MARK:--账号设置的状态信息获取
-(void)accountSettingData{
    
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager accountSettingInfoForCompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        NSLog(@"---%@",resPonseObj);
        if (code) {
            if ([resPonseObj[@"code"] integerValue] == 0) {
                
                self.accountInfo = [AccountSettingInfoModel mj_objectWithKeyValues:resPonseObj[@"data"]];
                
                if (![self.accountInfo.avatar isEqualToString:[UGManager shareInstance].hostInfo.userInfoModel.member.avatar]) {
                  //保存头像
                    [UGManager shareInstance].hostInfo.userInfoModel.member.avatar = self.accountInfo.avatar;
//                    [YLUserInfo saveUser:[YLUserInfo shareUserInfo]];
                }
                [self getAccountSettingStatus];
            }else if ([resPonseObj[@"code"] integerValue]==4000){
                [[UGManager shareInstance] signout:nil];
                //[ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                
            }else{
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}
//MARK:--整理账号设置的信息状态
-(void)getAccountSettingStatus{
    if (self.accountInfo.avatar == nil || [self.accountInfo.avatar isEqualToString:@""]) {
    }else{
        
        NSString *headStr = [NSString stringWithFormat:@"%@%@",PicHOST,self.accountInfo.avatar];
        NSURL *headUrl = [NSURL URLWithString:headStr];
        
        [self.headerView.headImage sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"header_defult"]];
    }    
    self.headerView.userName.text = self.accountInfo.username;
    self.headerView.account.text = self.accountInfo.mobilePhone;
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
