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

@end

@implementation UGPayWaySettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title =  self.isReleaseAd ?   (( ! UG_CheckStrIsEmpty(self.sellOrBuy) && [self.sellOrBuy isEqualToString:@"1"]) ? @"选择收款方式" : @"选择支付方式") : @"支付方式设置";
    self.tableView.rowHeight = 67.f;
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([UGPayWayTableViewCell class]) bundle:nil] forCellReuseIdentifier:NSStringFromClass([UGPayWayTableViewCell class])];
    [self initData];
    [self headerBeginRefresh];
    if (self.isReleaseAd) {
        [self setupTableFooterView];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reInitData) name:@"银行卡绑定成功返回" object:nil];
}

-(void)reInitData{
    [self initData];
    [self.tableView reloadData];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self showBindBankFrist];
}


-(void)showBindBankFrist{
    BOOL hasBankBinding = [UGManager shareInstance].hostInfo.userInfoModel.hasBankBinding;
    if (!hasBankBinding) {
        //未实名认证
        if([self gotoRealNameAuthentication]){return;};
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
    @weakify(self);
    [self updateBindingStatus:^(NSString *weChatPay, NSString *aliPay, NSString *bankPay, NSString *unionPay) {
        @strongify(self);
        NSArray *array = @[
                           @{
                               @"title" : @"银行卡",
                               @"desc" : bankPay,
                               @"imageName" : @"pay_bank",
                               @"selected" : @(NO)
                               },
                           @{
                               @"title" : @"支付宝",
                               @"desc" : aliPay,
                               @"imageName" : @"pay_ali",
                               @"selected" : @(NO)
                               },
                           @{
                               @"title" : @"微信支付",
                               @"desc" :  weChatPay,
                               @"imageName" : @"pay_wechat",
                               @"selected" : @(NO)
                               },
                           @{
                               @"title" : @"云闪付",
                               @"desc" :  unionPay,
                               @"imageName" : @"pay_union",
                               @"selected" : @(NO)
                               }
                           ];
        
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
        
        NSArray *modelArray =  [UGPayWayModel mj_objectArrayWithKeyValuesArray:array].copy;
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
        self.dataSource = modelArray.copy;
    }];
    
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
    @weakify(self);
    [self updateBindingStatus:^(NSString *weChatPay, NSString *aliPay, NSString *bankPay, NSString *unionPay) {
        @strongify(self);
        for (UGPayWayModel *model in self.dataSource) {
            if ([model.title isEqualToString:@"微信支付"]) {
                model.desc = weChatPay;
            } else if ([model.title isEqualToString:@"支付宝"]) {
                model.desc = aliPay;
            } else if ([model.title isEqualToString:@"银行卡"]){
                model.desc = bankPay;
            } else if ([model.title isEqualToString:@"云闪付"]){
                model.desc = unionPay;
            }
        }
    }];
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
    return self.dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UGPayWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([UGPayWayTableViewCell class]) forIndexPath:indexPath];
    cell.isReleaseAd = self.isReleaseAd;
    cell.model = self.dataSource[indexPath.section];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return  section == 0 ? 10.f : 20.f;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    BOOL hasBankBinding = [UGManager shareInstance].hostInfo.userInfoModel.hasBankBinding;
    
    BOOL hasWechatPay = [UGManager shareInstance].hostInfo.userInfoModel.hasWechatPay;
    
    BOOL hasAliPay = [UGManager shareInstance].hostInfo.userInfoModel.hasAliPay;
    
    BOOL hasUnionPay = [UGManager shareInstance].hostInfo.userInfoModel.hasUnionPay;
    
    UGPayWayModel *model = self.dataSource[indexPath.section];
    
    //银行卡
    if (indexPath.section == 0) {
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
    if (indexPath.section == 3) {
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
    if (self.isReleaseAd && (indexPath.section == 2 ? hasWechatPay : hasAliPay)) {
        model.selected = !model.selected;
        return;
    }
    //微信、支付宝
    UGWechaPayViewController *vc = [UGWechaPayViewController new];
    vc.topVC = self.topVC;
    vc.payType = indexPath.section == 2 ? UGPayTypeWeChatPay: UGPayTypeAliPay;
    vc.updateBind = indexPath.section == 2 ? hasWechatPay : hasAliPay;
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
    for (UGPayWayModel *model in self.dataSource) {
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
