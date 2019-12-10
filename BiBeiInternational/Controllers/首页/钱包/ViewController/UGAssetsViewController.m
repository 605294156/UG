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
#import "UGBillTableViewCell.h"
#import "UGOrderListApi.h"
#import "UGOrderListModel.h"

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


@property (weak, nonatomic) IBOutlet UILabel *priceTwo;
@property (weak, nonatomic) IBOutlet UILabel *cnyPriceTwo;
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
    [self.tableView ug_registerNibCellWithCellClass:([UGBillTableViewCell class])];
    [self languageChange];
    [self updateUI];
    
    [self headerBeginRefresh];
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
        self.price.text = [ToolUtil stringChangeMoneyWithStr:self.price.text];
        self.cnyprice.text= [NSString stringWithFormat:@"可用余额：%@ (UG)",self.price.text];
        self.rightingsTyoe.text =!UG_CheckStrIsEmpty(model.yesterdayIncome) ? [model.yesterdayIncome ug_amountFormat] : @"暂无收益";
        self.allEarningsType.text =!UG_CheckStrIsEmpty(model.totalIncome) ? [model.totalIncome ug_amountFormat] : @"暂无收益";
         self.earningsType.text =!UG_CheckStrIsEmpty(model.frozenBalance) ? [model.frozenBalance ug_amountFormat] : @"暂无收益";
        self.priceTwo.text = self.price.text;
        self.cnyPriceTwo.text = [NSString stringWithFormat:@"≈%@CNY",self.price.text];
        [self.tableView reloadData];
    }
}

- (UIView *) tableViewHeaderView{
    UIView *bg_headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.mj_w, 36)];
    bg_headerView.backgroundColor = UIColor.whiteColor;
    
    UILabel *la = UILabel.new;
    la.text = @"交易记录";
    la.font = [UIFont fontWithName:@"PingFangSC-Medium" size:15];
    la.textColor = HEXCOLOR(0x333333);
    [bg_headerView addSubview:la];
    
    [la mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.centerY.equalTo(bg_headerView.mas_centerY);
    }];
    
    UIImageView *img = UIImageView.new;
    img.backgroundColor = HEXCOLOR(0xefefef);
    [bg_headerView addSubview:img];
    [img mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.equalTo(@1);
    }];
    return bg_headerView;
}

- (void)setupTableView {
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.priceTwo.superview.mas_bottom).offset(10);
        make.left.right.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
    self.tableView.tableHeaderView = self.tableViewHeaderView;
}

- (BOOL)hasFooterRefresh {
    return YES;
}

-(BOOL)hasHeadRefresh{
    return YES;
}

#pragma mark - 下拉刷新
- (void)refreshData {
    [super refreshData];
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

- (UGBaseRequest *)getRequestApiAppend:(BOOL)append {
    UGOrderListApi *api = [[UGOrderListApi alloc] init];
    api.searchType = @"全部";
    api.appClassType = -1;
    api.currentPage =  @(self.minseq);
    return api;
}

- (NSArray *)getDataFromDictionary:(NSDictionary *)object isAppend:(BOOL)append {
    if (object[@"rows"]) {
        NSArray *array = [UGOrderListModel mj_objectArrayWithKeyValuesArray:object[@"rows"]];
        return array;
    }
    return nil;
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGBillTableViewCell *billCell = [tableView ug_dequeueReusableNibCellWithCellClass:[UGBillTableViewCell class] forIndexPath:indexPath];
    billCell.orderListModel = self.dataSource[indexPath.section];
    return billCell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 67;
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UITableViewHeaderFooterView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"UITableViewHeaderFooterView"];
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

#pragma mark - SEL
- (IBAction)backClick:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
