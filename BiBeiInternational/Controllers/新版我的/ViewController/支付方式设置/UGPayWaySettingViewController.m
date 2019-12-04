//
//  UGPayWaySettingViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPayWaySettingViewController.h"
#import "UGWechaPayViewController.h"
#import "UGBankPaySettingViewController.h"
#import "UGPayWayTableViewCell.h"
#import "UGPayWayModel.h"
#import "UGButton.h"
#import "UGGeneralCertificationVC.h"

@interface UGPayWaySettingViewController ()
@property (nonatomic, strong) NSMutableArray *NOBindBankList,*YESBindBankList;
@end

@implementation UGPayWaySettingViewController
- (NSMutableArray *) NOBindBankList{if (!_NOBindBankList) _NOBindBankList = NSMutableArray.array;
    return _NOBindBankList;
}
- (NSMutableArray *) YESBindBankList{if (!_YESBindBankList) _YESBindBankList = NSMutableArray.array;
    return _YESBindBankList;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =  self.isReleaseAd ?   (( ! UG_CheckStrIsEmpty(self.sellOrBuy) && [self.sellOrBuy isEqualToString:@"1"]) ? @"选择收款方式" : @"选择支付方式") : @"支付方式设置";
    self.tableView.rowHeight = 68.f;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGPayWayTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGPayWayTableViewCell class])];
//    [self initData];
    [self headerBeginRefresh];
    if (self.isReleaseAd) {
        [self setupTableFooterView];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reInitData) name:@"银行卡绑定成功返回" object:nil];
}

-(void)reInitData{
    [self initData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showBindBankFrist];
}


-(void)showBindBankFrist{
    BOOL hasBankBinding = [UGManager shareInstance].hostInfo.userInfoModel.hasBankBinding;
    if (!hasBankBinding) {
        //未实名认证
        if([self  gotoRealNameAuthentication]){return;};
        //校验是否绑定银行卡
        if ( [self checkHadGotoBankBinding]) {
        }
    }
    
}

- (void)setupTableFooterView {
    CGFloat footerHeight = 187.0f;
    if ([UG_MethodsTool is4InchesScreen]) {
        footerHeight = 130.0f;
    }
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.size.width, footerHeight)];
    UGButton *confirmButton = [[UGButton alloc] initWithUGStyle:UGButtonStyleBlue];
    [confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [confirmButton setTitle:@"确定" forState:UIControlStateHighlighted];
    confirmButton.frame = CGRectMake((self.view.size.width - 240) /2 , footerHeight -46, 240, 46);
    [confirmButton addTarget:self action:@selector(clickConfirm:) forControlEvents:UIControlEventTouchUpInside];
    [footerView addSubview:confirmButton];
    self.tableView.tableFooterView = footerView;
}


- (void)initData {
    [self.YESBindBankList removeAllObjects];
    [self.NOBindBankList removeAllObjects];
    @weakify(self);
    [self updateBindingStatus:^(NSString *weChatPay, NSString *aliPay, NSString *bankPay, NSString *unionPay) {
        @strongify(self);
        [self getListData:bankPay :aliPay :weChatPay :unionPay];
        
        //发布出售购买银行卡必须选
        if (self.isReleaseAd) {
            if (UG_CheckArrayIsEmpty(self.payWays) || self.payWays.count <= 0) {
                BOOL hasBankBinding = [UGManager shareInstance].hostInfo.userInfoModel.hasBankBinding;
                if (hasBankBinding) {
                    self.payWays= @[@"银行卡"];
                }
            }else{
                BOOL hasbank = NO;
                for (NSString *pay in self.payWays) {
                    if ([pay containsString:@"银联"] || [pay containsString:@"银行"]) {
                        hasbank = YES;
                        break;
                    }
                }
                if ( ! hasbank) {
                    NSMutableArray *arr = [NSMutableArray arrayWithArray:self.payWays];
                    [arr insertObject:@"银行卡" atIndex:0];
                    self.payWays = [NSArray arrayWithArray:arr];
                }
            }
        }
        //--------
        
        NSArray *modelArray =  [UGPayWayModel mj_objectArrayWithKeyValuesArray:self.YESBindBankList].copy;
        for (UGPayWayModel *model in modelArray) {
            for (NSString *pay in self.payWays) {
                if ([model.title containsString:pay]) {
                    model.selected = YES;
                }
                if ([pay containsString:@"银联"] && [model.title containsString:@"银行"]) {
                    model.selected = YES;
                }
            }
        }
        self.YESBindBankList = modelArray.mutableCopy;
        self.NOBindBankList = [UGPayWayModel mj_objectArrayWithKeyValuesArray:self.NOBindBankList].mutableCopy;
        
        [self.tableView reloadData];
    }];
}

- (NSArray *) getListData:(NSString *)bankPay :(NSString *)aliPay :(NSString *)weChatPay :(NSString *)unionPay{
    NSMutableArray *list = @[
                        @{
                            @"title" : @"银行卡",
                            @"desc" : bankPay,
                            @"imageName" : @"pay_bank1",
                            @"selected" : @(NO)
                            },
                        @{
                            @"title" : @"支付宝",
                            @"desc" : aliPay,
                            @"imageName" : @"pay_ali1",
                            @"selected" : @(NO)
                            },
                        @{
                            @"title" : @"微信支付",
                            @"desc" :  weChatPay,
                            @"imageName" : @"pay_wechat1",
                            @"selected" : @(NO)
                            },
                        @{
                            @"title" : @"云闪付",
                            @"desc" :  unionPay,
                            @"imageName" : @"pay_union1",
                            @"selected" : @(NO)
                            }
                        ].mutableCopy;
    
    
    BOOL hasBankBinding = [UGManager shareInstance].hostInfo.userInfoModel.hasBankBinding;
    
    BOOL hasWechatPay = [UGManager shareInstance].hostInfo.userInfoModel.hasWechatPay;
    
    BOOL hasAliPay = [UGManager shareInstance].hostInfo.userInfoModel.hasAliPay;
    
    BOOL hasUnionPay = [UGManager shareInstance].hostInfo.userInfoModel.hasUnionPay;

    if (hasBankBinding) [self.YESBindBankList addObject:list.firstObject];
    if (hasAliPay) [self.YESBindBankList addObject:list[1]];
    if (hasWechatPay) [self.YESBindBankList addObject:list[2]];
    if (hasUnionPay) [self.YESBindBankList addObject:list[3]];
    
    if (self.YESBindBankList.count>0 && self.YESBindBankList.count<4) {
        NSPredicate * filterPredicate1 = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",list];
        NSArray * filter1 = [self.YESBindBankList filteredArrayUsingPredicate:filterPredicate1];
        //找到在arr1中不在数组arr2中的数据
        NSPredicate * filterPredicate2 = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)",self.YESBindBankList];
        NSArray * filter2 = [list filteredArrayUsingPredicate:filterPredicate2];
        //拼接数组
        [self.NOBindBankList addObjectsFromArray:filter1];
        [self.NOBindBankList addObjectsFromArray:filter2];
    }if (self.YESBindBankList.count==0) {
        [self.NOBindBankList addObjectsFromArray:list];
    }
    
    return nil;
}

- (void)refreshData {
    [[UGManager shareInstance] sendGetUserInfoRequestCompletionBlock:^(UGApiError *apiError, id object) {
        [self.tableView endRefreshingWithNoMoreData:YES];
        if (object) {
            [self updateCellDatas];
        }
    }];
}

- (void)updateCellDatas {
    [self initData];
}

- (void)updateBindingStatus:(void(^)(NSString *weChatPay, NSString *aliPay, NSString *bankPay, NSString *unionPay))completionBlock {
    UGMember *member = [UGManager shareInstance].hostInfo.userInfoModel.member;
    UGUserInfoModel *userInfo = [UGManager shareInstance].hostInfo.userInfoModel;
    
    NSString *weChatPay = userInfo.hasWechatPay ? member.wechat : @"未绑定";
    NSString *aliPay = userInfo.hasAliPay ? member.aliNo : @"未绑定";
    NSString *bankPay = userInfo.hasBankBinding ? member.cardNo : @"未绑定";
    NSString *unionPay = userInfo.hasUnionPay ? member.unionPay : @"未绑定";
    
    if (completionBlock) {
        completionBlock(weChatPay, aliPay, bankPay,unionPay);
    }
}

- (BOOL)hasFooterRefresh {
    return NO;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) {
        return self.YESBindBankList.count;
    }else{
        return self.NOBindBankList.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPayWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGPayWayTableViewCell class]) forIndexPath:indexPath];
    cell.isReleaseAd = self.isReleaseAd;
    if (indexPath.section==0) {
        cell.model = self.YESBindBankList[indexPath.row];
    }else if (indexPath.section==1){
        cell.model = self.NOBindBankList[indexPath.row];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  section == 0 ? 10.f : (self.YESBindBankList.count>0?56:CGFLOAT_MIN);
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1) {
        UITableViewHeaderFooterView *header2 = [tableView dequeueReusableHeaderFooterViewWithIdentifier:@"Header22222"];
        if (!header2) {
            header2 = [[UITableViewHeaderFooterView alloc] initWithReuseIdentifier:@"Header22222"];
            UILabel *l = UILabel.new;
            l.text = @"未绑定支付方式";
            l.textColor = HEXCOLOR(0x8c96a5);
            l.font = [UIFont systemFontOfSize:14];
            [l setBackgroundColor:[UIColor clearColor]];
            [header2 addSubview:l];
            [l mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(@15);
                make.bottom.equalTo(@-10);
            }];
        }
        return header2;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL hasBankBinding = [UGManager shareInstance].hostInfo.userInfoModel.hasBankBinding;
    
    BOOL hasWechatPay = [UGManager shareInstance].hostInfo.userInfoModel.hasWechatPay;
    
    BOOL hasAliPay = [UGManager shareInstance].hostInfo.userInfoModel.hasAliPay;
    
    BOOL hasUnionPay = [UGManager shareInstance].hostInfo.userInfoModel.hasUnionPay;
    
    
    UGPayWayModel *model;
    
    if (indexPath.section==0) {
        model = self.YESBindBankList[indexPath.row];
    }else if (indexPath.section==1){
        model = self.NOBindBankList[indexPath.row];
    }
    
    //银行卡
    if ([model.title isEqualToString:@"银行卡"]) {
        //未实名认证
        if ([self gotoRealNameAuthentication]){return;};
        //交易发布且已经绑定改支付方式
        if (self.isReleaseAd && hasBankBinding) {
            model.selected = YES;
            [self.view ug_showToastWithToast:@"银行卡为必选项"];
            return;
        }
        UGBankPaySettingViewController *bankSettingVC = [UGBankPaySettingViewController new];
        bankSettingVC.topVC = self.topVC;
        bankSettingVC.updateBind = hasBankBinding;
        @weakify(self);
        bankSettingVC.handle = ^{
            @strongify(self);
            [self updateCellDatas];
        };
        [self.navigationController pushViewController:bankSettingVC animated:YES];
        return;
    }
    
    //云闪付
    if ([model.title isEqualToString:@"云闪付"]) {
        //未实名认证
        if ([self gotoRealNameAuthentication]){return;};
        //交易发布且已经绑定改支付方式
        if (self.isReleaseAd && hasUnionPay) {
            model.selected = !model.selected;
            return;
        }
        //云闪付
        UGWechaPayViewController *vc = [UGWechaPayViewController new];
        vc.topVC = self.topVC;
        vc.payType =UGPayTypeUnionPay;
        vc.updateBind =  hasUnionPay;
        @weakify(self);
        vc.handle = ^{
            @strongify(self);
            [self updateCellDatas];
        };
        [self.navigationController pushViewController:vc animated:YES];
        return;
    }
    
    
    //交易发布且已经绑定改支付方式
    if (self.isReleaseAd && (indexPath.row == 2 ? hasWechatPay : hasAliPay)) {
        model.selected = !model.selected;
        return;
    }
    //微信、支付宝
    UGWechaPayViewController *vc = [UGWechaPayViewController new];
    vc.topVC = self.topVC;
    vc.payType = [model.title isEqualToString:@"微信支付"]? UGPayTypeWeChatPay: UGPayTypeAliPay;
    
    if (vc.payType==UGPayTypeWeChatPay) {
        vc.updateBind = hasWechatPay;
    }else if (vc.payType==UGPayTypeAliPay){
        vc.updateBind = hasAliPay;
    }
    @weakify(self);
    vc.handle = ^{
        @strongify(self);
        [self updateCellDatas];
    };
    [self.navigationController pushViewController:vc animated:YES];
}


- (void)clickConfirm:(UIButton *)sender {
    //未实名认证
    if ([self gotoRealNameAuthentication]){return;};
    //校验是否绑定银行卡
    if ( [self checkHadGotoBankBinding]) {
        return;
    }
    
    NSMutableArray <NSString *>*array = [NSMutableArray new];
    for (UGPayWayModel *model in self.YESBindBankList) {
        if (model.selected) {
            [array addObject:model.title];
        }
    }
    if (array.count<=0) {
        [self.view ug_showToastWithToast:@"请选择至少一种支付方式"];
        return;
    }
    if (self.choosePayModHandle) {
        self.choosePayModHandle(array);
    }
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
