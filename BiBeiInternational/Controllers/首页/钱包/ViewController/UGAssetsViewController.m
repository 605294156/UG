//
//  UGAssetsViewController.m
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGAssetsViewController.h"
#import "UGAssetsTableViewCell.h"
#import "UGSaveDataTool.h"
#import "AppDelegate.h"
#import "UGWalletAllModel.h"

@interface UGAssetsViewController ()
@property (weak, nonatomic) IBOutlet UIView *rectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *navHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *cnyprice;
@property (weak, nonatomic) IBOutlet UILabel *earnings;
@property (weak, nonatomic) IBOutlet UILabel *earningsType;
@property (weak, nonatomic) IBOutlet UILabel *allEarnings;
@property (weak, nonatomic) IBOutlet UILabel *allEarningsType;
@property (weak, nonatomic) IBOutlet UILabel *rightings;
@property (weak, nonatomic) IBOutlet UILabel *rightingsTyoe;
@end

@implementation UGAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarHidden = YES;
    self.earnings.text = @"冻结金额(UG)";
    self.allEarnings.text = @"总收益(UG)";
    self.rightings.text = @"昨日总收益(UG)";
    [self.view bringSubviewToFront:self.rectView];
    self.navHeightConstraint.constant = [UG_MethodsTool navigationBarHeight];
    self.rectView.layer.shadowColor = [UIColor colorWithHexString:@"D8D8D8"].CGColor;
    self.rectView.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    self.rectView.layer.shadowOpacity = 0.2;
    self.rectView.layer.shadowRadius = 3;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGAssetsTableViewCell class]) bundle:nil] forCellReuseIdentifier:@"UGAssetsTableViewCell"];
    [self.tableView registerClass:[UITableViewHeaderFooterView class] forHeaderFooterViewReuseIdentifier:@"UITableViewHeaderFooterView"];
    [self languageChange];
    [self updateUI];
}

-(void)languageChange{
    self.noNetworkTipImage = @"qr_defult";
    self.noDataTipText = @"暂无资产";
}

-(void)updateUI{
    if (self.listData.count>0) {
        UGWalletAllModel *model = self.listData[0];
        self.allLabel.text = [NSString stringWithFormat:@"总资产(%@)",!UG_CheckStrIsEmpty(model.coinId)? model.coinId:@"UG"] ;
        self.price.text = [[NSString ug_addFormatWithMultiplier:model.balance multiplicand:model.frozenBalance] ug_amountFormat];
        self.cnyprice.text= [NSString stringWithFormat:@"可用余额：%@ (UG)",[model.balance ug_amountFormat]];
        self.rightingsTyoe.text =!UG_CheckStrIsEmpty(model.yesterdayIncome) ? [model.yesterdayIncome ug_amountFormat] : @"暂无收益";
        self.allEarningsType.text =!UG_CheckStrIsEmpty(model.totalIncome) ? [model.totalIncome ug_amountFormat] : @"暂无收益";
         self.earningsType.text =!UG_CheckStrIsEmpty(model.frozenBalance) ? [model.frozenBalance ug_amountFormat] : @"暂无收益";
        [self.tableView reloadData];
    }
}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.rectView.mas_bottom).offset(0);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
}

- (BOOL)hasFooterRefresh {
    return NO;
}

-(BOOL)hasHeadRefresh{
    return YES;
}

#pragma mark - 下拉刷新
- (void)refreshData {
    @weakify(self);
    [self getWalletData:^(UGApiError *apiError, id object) {
        @strongify(self);
        if (object){
            self.listData = [UGWalletAllModel mj_objectArrayWithKeyValuesArray:object];
            [self updateUI];
        }else{
            [self.view ug_showToastWithToast:apiError.desc];
        }
        [self.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGAssetsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGAssetsTableViewCell" forIndexPath:indexPath];
    if(self.listData.count>0)
    {
        UGWalletAllModel *model = self.listData[0];
        NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG;
        NSString *cnyStr = [NSString ug_positiveFormatWithMultiplier:model.balance multiplicand:cnyRate scale:6 roundingMode:NSRoundDown];
        [cell updateBalance:[model.balance ug_amountFormat] cny:[NSString stringWithFormat:@"= ¥ %@",[cnyStr ug_amountFormat]] type:model.coinId];
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.listData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 66;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 15.0f;
}

#pragma mark - SEL
- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
