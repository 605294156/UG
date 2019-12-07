//
//  UGHelpCenterViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGHelpCenterViewController.h"
#import "UGHelpCenterCell.h"

//网易七鱼
#import "QYPOPSDK.h"
#import "UGNavController.h"
#import "UGQYSDKManager.h"

@interface UGHelpCenterViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSArray *urlArray;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableView_top;
@property (weak, nonatomic) IBOutlet UILabel *userName;

@end

@implementation UGHelpCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"帮助中心";
    self.tableView.rowHeight = 47;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGHelpCenterCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGHelpCenterCell class])];
    self.dataSource = @[@"1、“交易” 规则", @"2、什么是支付密码？", @"3、什么是实名认证？", @"4、什么是高级认证？", @"5、什么是人脸识别？",@"6、两分钟入门视频"];
    NSString *str1= [UGURLConfig helpCenterApi:@"1"];
    NSString *str2=  [UGURLConfig helpCenterApi:@"2"];
//    NSString *str3= [UGURLConfig helpCenterApi:@"3"];
    NSString *str3= [UGURLConfig helpCenterApi:@"4"];
    NSString *str4= [UGURLConfig helpCenterApi:@"5"];
    NSString *str5= [UGURLConfig helpCenterApi:@"6"];
    NSString *str6= [NSString stringWithFormat:@" "];
    self.urlArray = @[str1,str2,str3,str4,str5,str6];
    
    
    if (UG_Is_iPhoneXSeries) {
        self.tableView_top.constant = -178;
        self.userName.superview.mj_h = 170.f;
    }
    @weakify(self)
    [self setupBarButtonItemWithImageName:@"back_icon" type:UGBarImteTypeLeft callBack:^(UIBarButtonItem * _Nonnull item) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [self getUserInfoRequest];
}

#pragma mark - 获取用户信息
- (void)getUserInfoRequest {
    //未登录则不拉取
    if (![[UGManager shareInstance] hasLogged]) {return;}
    @weakify(self);
    [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        UGUserInfoModel *userInfoModel = [UGManager shareInstance].hostInfo.userInfoModel;
        if (userInfoModel.bindMobilePhone) {
                self.userName.text = [NSString stringWithFormat:@"+%@  %@",userInfoModel.member.areaCode,userInfoModel.member.mobilePhone];
            }
            else{
                self.userName.text = userInfoModel.member.registername;
            }
    }];
}

- (void) viewWillAppear:(BOOL)animated{[super viewWillAppear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor], NSFontAttributeName:[UIFont systemFontOfSize:18]}];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageWithColor:[UIColor clearColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
}

- (void) viewWillDisappear:(BOOL)animated{[super viewWillDisappear:animated];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x333333), NSFontAttributeName:[UIFont systemFontOfSize:18]}];
}
- (IBAction)click_service:(id)sender {
    QYSource *source = [[QYSource alloc] init];
    source.title =  @"UG钱包";
    
   [[UGQYSDKManager shareInstance] updateDateQYUserInfo:@"" isLogin:YES];
    
    QYSessionViewController *sessionViewController = [[QYSDK sharedSDK] sessionViewController];
    sessionViewController.sessionTitle = @"在线客服";
    sessionViewController.source = source;
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"goback"]  style:UIBarButtonItemStylePlain target:self action:@selector(onBack:)];
//    sessionViewController.navigationItem.leftBarButtonItem = leftItem;
    UGNavController* navi = [[UGNavController alloc]initWithRootViewController:sessionViewController];
    [sessionViewController setNavigation];
    [self presentViewController:navi animated:YES completion:nil];
}

- (BOOL)hasHeadRefresh {
    return NO;
}

- (BOOL)hasFooterRefresh {
    return NO;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UITableViewStyle)getTableViewSytle {
    return UITableViewStyleGrouped;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGHelpCenterCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGHelpCenterCell class]) forIndexPath:indexPath];
    [cell updateTitle:self.dataSource[indexPath.row]];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([self.dataSource[indexPath.row] isEqualToString:@"6、两分钟入门视频"]) {
       [self playVideo];
    }else{
         [self gotoWebView:self.dataSource[indexPath.row] htmlUrl:self.urlArray[indexPath.row]];
    }
}
@end
