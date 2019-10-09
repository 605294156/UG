//
//  UGMineViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGMineViewController.h"
#import "UIButton+Expand.h"
#import "UGMineTableViewCell.h"
#import "UGPersonalCenterVC.h"
#import "TransactionRecordViewController.h"
#import "UGBillViewController.h"
#import "UGHelpCenterViewController.h"
#import "UGAboutMineViewController.h"
#import "UGSettingsViewController.h"
#import "UGAuthenticationViewController.h"
#import "UGMineAdViewController.h"
#import "UGWallteManagerVC.h"
#import "UGPayWaySettingViewController.h"
#import "UGMineInfoApi.h"
#import "UGUserInfoModel.h"
#import "UGHomeMessageVC.h"
#import "UGSafeCenterVC.h"
#import "UGLinkmanVC.h"
#import "UGScheduleView.h"
#import "UGMineMyIntegraVC.h"
#import "UGGetTotalScoresApi.h"
#import "UGRegistrationInvitationVC.h"

@interface UGMineViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIButton *walletMangerButton;
@property (weak, nonatomic) IBOutlet UIButton *tradeRecodeButton;
@property (weak, nonatomic) IBOutlet UIButton *contactButton;
@property (weak, nonatomic) IBOutlet UIView *topView;//整个顶部视图
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet UIButton *messageButton;

@property(nonatomic,strong,readonly) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mineTopConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeightConstraint;
@property (weak, nonatomic) IBOutlet UIButton *intergrationbtn;
@property (weak, nonatomic) IBOutlet UIButton *card_vBtn;

@property(nonatomic, strong) UGUserInfoModel *userInfoModel;


//需要更新值的控件
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *cnyLabel;
@property (weak, nonatomic) IBOutlet UILabel *userPhoneLabel;
//新账号需求
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *useridCenterLayout;
@property (weak, nonatomic) IBOutlet UIImageView *phoneImageview;


@property (nonatomic, assign) BOOL isFirstView;

@end

@implementation UGMineViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        self.navigationBarHidden = YES;
        [self getUserInfoRequest];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserInfoRequest) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getUserInfoRequest];
    
//    [self getOrderWaitingData];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self getOrderWaitingData];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    [UGScheduleView hidePopView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    self.mineTopConstraint.constant = UG_StatusBarAndNavigationBarHeight - 32;
    [self updateButtons];
    [self.topView sendSubviewToBack:self.bgImageView];
    self.tableView.rowHeight = 60;
    [self.tableView ug_registerNibCellWithCellClass:[UGMineTableViewCell class]];
    [self initDataSource];
    [self updateViews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hidenShowGuideView) name:@"发现更新" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reShowScheduleView) name:@"发现有待办事项" object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userLoginSucess) name:@"LOGINSUCCES" object:nil];
    
    UILongPressGestureRecognizer *longGes = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    longGes.minimumPressDuration = 0.5;//2秒（默认0.5秒）
    [longGes setNumberOfTouchesRequired:1];
    [self.userNameLabel addGestureRecognizer:longGes];
    

    UILongPressGestureRecognizer *longGes2 = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction2:)];
    longGes2.minimumPressDuration = 0.5;//2秒（默认0.5秒）
    [longGes2 setNumberOfTouchesRequired:1];
    self.userPhoneLabel.userInteractionEnabled = YES;
    [self.userPhoneLabel addGestureRecognizer:longGes2];
    
    
}

#pragma mark -长按复制
-(void)longPressAction2:(UILongPressGestureRecognizer *)longPress
{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSString *qrstring =  self.userInfoModel.member.mobilePhone;
        [UIPasteboard generalPasteboard].string = !UG_CheckStrIsEmpty(qrstring)?qrstring:@"";
        [self.view ug_showToastWithToast:@"复制成功！"];
    }
}

-(void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        NSString *qrstring =  [UGManager shareInstance].hostInfo.username;
        [UIPasteboard generalPasteboard].string = !UG_CheckStrIsEmpty(qrstring)?qrstring:@"";
        [self.view ug_showToastWithToast:@"复制成功！"];
    }
}

-(void)userLoginSucess{
    [self initDataSource];
    [self.tableView reloadData];
}

-(void)reShowScheduleView{
    [self getOrderWaitingData];
}

#pragma mark -隐藏待办事项 
-(void)hidenShowGuideView{
    [UGScheduleView hidePopView];
}

-(void)getOrderWaitingData{
    if (![[UIViewController currentViewController] isKindOfClass:[UGMineViewController class]]) {
        return;
    }
//    if (!self.isFirstView) {
//        self.isFirstView = YES;
        [[UGManager shareInstance]  getOrderWaitingDealList:^(BOOL complete, NSMutableArray * _Nonnull object) {
            //显示待办事项
            if (object.count>0) {
                //先隐藏
                [UGScheduleView hidePopView];
                @weakify(self);
                [UGScheduleView initWithArr:object WithHandle:^(UGOrderWaitingModel * _Nonnull model) {
                    @strongify(self);
                    [self gotoDetail:model];
                } WithViewHandle:^(UGScheduleView * _Nonnull scheduleView) {
                    
                } WithCloseHandle:nil];
            }
        }];
//    }
}

#pragma mark - 获取用户信息
- (void)getUserInfoRequest {
    //未登录则不拉取
    if (![[UGManager shareInstance] hasLogged]) {return;}
    @weakify(self);
    [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
        @strongify(self);
        self.userInfoModel = [UGManager shareInstance].hostInfo.userInfoModel;
        [self updateViews];
    }];
}

#pragma mark - 获取今日积分
- (void)getTotalScoreoRequest {
    UGGetTotalScoresApi *api = [[UGGetTotalScoresApi alloc] init];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dict = (NSDictionary *)object;
                NSString *totalStr = [dict objectForKey:@"totalScore"];
//                NSString *todayStr = [dict objectForKey:@"todayScore"];
                [self.intergrationbtn setTitle:[NSString stringWithFormat:@"%@ 积分",totalStr] forState:UIControlStateNormal];
            }
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
    }];
}

//更新UI显示
- (void)updateViews {
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.userInfoModel.member.avatar] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    self.userNameLabel.text = self.userInfoModel.member.username;
    if (self.userInfoModel.bindMobilePhone) {
        self.phoneImageview.image = [UIImage imageNamed:@"topPhone"];
        self.userPhoneLabel.text = [NSString stringWithFormat:@"+%@  %@",self.userInfoModel.member.areaCode,self.userInfoModel.member.mobilePhone];
   
    }
    else
    {
        self.phoneImageview.image = [UIImage imageNamed:@"usernameTittleImage"];
        self.userPhoneLabel.text = self.userInfoModel.member.registername;
     
    }
    
    if (!UG_CheckArrayIsEmpty(self.userInfoModel.list) && self.userInfoModel.list.count > 0 ) {
        self.balanceLabel.text = [((UGWalletAllModel *)self.userInfoModel.list.firstObject).balance ug_amountFormat];
        self.cnyLabel.text = [NSString stringWithFormat:@"= ¥ %@",self.balanceLabel.text];
    }else{
        self.balanceLabel.text = @"0";
        self.cnyLabel.text =@"= ¥ 0";
    }
    if ([self isCardVip]) {
        self.intergrationbtn.hidden = NO;
        self.card_vBtn.hidden = NO;
        [self getTotalScoreoRequest];
    }else{
         self.intergrationbtn.hidden = YES;
         self.card_vBtn.hidden = YES;
    }
}

- (void)initDataSource {
    _dataSource = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Mine" ofType:@"plist"]];
    if ([self isCardVip]) {
        //承兑商才有积分
         NSDictionary *dic = @{@"Title" : @"我的积分",@"ImageName" :  @"my_integral"};
        NSDictionary *dic2 = @{@"Title" : @"邀请注册",@"ImageName" :  @"my_invite"};
        NSMutableArray *arr = [NSMutableArray new];
        [arr addObject:dic];
        [arr addObject:dic2];
        [arr addObjectsFromArray:_dataSource];
        _dataSource = [[NSArray alloc] initWithArray:arr];
    }
    self.userInfoModel = [UGManager shareInstance].hostInfo.userInfoModel;
}

- (void)updateButtons {
    [self.walletMangerButton layoutButtonWithEdgeInsetsStyle:UGButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.tradeRecodeButton layoutButtonWithEdgeInsetsStyle:UGButtonEdgeInsetsStyleTop imageTitleSpace:5];
    [self.contactButton layoutButtonWithEdgeInsetsStyle:UGButtonEdgeInsetsStyleTop imageTitleSpace:5];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGMineTableViewCell *cell = [tableView ug_dequeueReusableNibCellWithCellClass:[UGMineTableViewCell class] forIndexPath:indexPath];
    [cell updateTitle:self.dataSource[indexPath.section][@"Title"] imageName:self.dataSource[indexPath.section][@"ImageName"] firstCell:indexPath.section == 0 lastCell:indexPath.section == self.dataSource.count -1];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc = nil;
    if ([self isCardVip]) {
        switch (indexPath.section) {
            case 0:
                vc = [[UGMineMyIntegraVC alloc] init];
            break;
            case 1:
                //邀请注册
                vc = [[UGRegistrationInvitationVC alloc] init];
                break;
            case 2:
                vc = [UGAuthenticationViewController new];
                break;
            case 3:
                vc = [UGPayWaySettingViewController new];
                break;
            case 4:
                vc = [UGWallteManagerVC new];
                break;
            case 5:
                vc = [UGSafeCenterVC new];
                break;
            case 6:
                vc = [UGHelpCenterViewController new];
                break;
            default:
                vc = [UGAboutMineViewController new];
                break;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        switch (indexPath.section) {
                //            case 0:
                //            vc = [UGLinkmanVC new];
                //            break;
            case 0:
                vc = [UGAuthenticationViewController new];
                break;
            case 1:
                vc = [UGPayWaySettingViewController new];
                break;
            case 2:
                vc = [UGWallteManagerVC new];
                break;
            case 3:
                vc = [UGSafeCenterVC new];
                break;
            case 4:
                vc = [UGHelpCenterViewController new];
                break;
            default:
                vc = [UGAboutMineViewController new];
                break;
        }
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return self.dataSource.count - 1 == section ? CGFLOAT_MIN : 0.5;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UITableViewHeaderFooterView *footerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    footerView.contentView.backgroundColor = [UIColor colorWithHexString:@"DFDFDF"];
    return footerView;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  section == 0 ? 10 : CGFLOAT_MIN;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([UITableViewHeaderFooterView class])];
    headerView.contentView.backgroundColor = [UIColor clearColor];
    return headerView;
}

#pragma mark - SEL Method

//我的交易
- (IBAction)clickWalletManger:(UIButton *)sender {
    [self.navigationController pushViewController:[UGMineAdViewController new] animated:YES];
}

//UG钱包记录- 我的账单
- (IBAction)clickTradeRecode:(UIButton *)sender {
    [self.navigationController pushViewController:[UGBillViewController new] animated:YES];
}

//交易记录
- (IBAction)clickContact:(UIButton *)sender {
    [self.navigationController pushViewController:[TransactionRecordViewController new] animated:YES];
}

//个人中心
- (IBAction)tapUserInfo:(UITapGestureRecognizer *)sender {
    
    UGPersonalCenterVC *personalVC = [[UGPersonalCenterVC alloc]init];
    personalVC.userName = self.userInfoModel.member.username;
    personalVC.userPhone = self.userInfoModel.member.mobilePhone;
    personalVC.areaCode = self.userInfoModel.member.areaCode;
    [self.navigationController pushViewController:personalVC animated:YES];
    
    
    
}
- (IBAction)clickMessage:(UIButton *)sender {
    [self.navigationController pushViewController:[UGSettingsViewController new] animated:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
