//
//  UGBillDetailVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/19.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBillDetailVC.h"
#import "UGBillDetailModel.h"
#import "UGBillDetailApi.h"
#import "UGOrderListModel.h"

#define  topHeight (415.0f - 17.0f)

@interface UGBillDetailVC ()
@property(nonatomic,strong)UGBillDetailModel *detailModel;

@property (weak, nonatomic) IBOutlet UIImageView *headerImage;
@property (weak, nonatomic) IBOutlet UILabel *otherAcount;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *transActionType;
@property (weak, nonatomic) IBOutlet UILabel *createTime;
@property (weak, nonatomic) IBOutlet UILabel *createTimeShow;
@property (weak, nonatomic) IBOutlet UILabel *billNumber;
@property (weak, nonatomic) IBOutlet UILabel *billNumberShow;
@property (weak, nonatomic) IBOutlet UILabel *otherWalletAdress;
@property (weak, nonatomic) IBOutlet UILabel *oyherWalletAdressShow;
@property (weak, nonatomic) IBOutlet UILabel *changeNum;
@property (weak, nonatomic) IBOutlet UILabel *serverNum;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serverHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *serverTop;
@property (weak, nonatomic) IBOutlet UILabel *serverLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkTextView;
@end

@implementation UGBillDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self languageChange];
    [self showEmptyView];
    [self request];
}

-(void)languageChange{
    self.title = @"订单详情";
}

#pragma mark- 复制对方地址
- (IBAction)copyClick:(id)sender {
    if (UG_CheckStrIsEmpty(self.detailModel.otherCardNo)) {return;}
    [UIPasteboard generalPasteboard].string =self.detailModel.otherCardNo;
    [self.view ug_showToastWithToast:@"复制成功！"]; 
}

#pragma mark- 获取UG钱包记录详情
-(void)request{
    [self.view ug_showMBProgressHUD];
    UGBillDetailApi *api = [[UGBillDetailApi alloc] init];
    api.orderType =self.orderType;
    api.orderSn =self.orderSn;
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        [self.view ug_hiddenMBProgressHUD];
        if (object) {
            [self.view ly_hideEmptyView];
            self.detailModel = [UGBillDetailModel mj_objectWithKeyValues:object];
        }else {
            @weakify(self);
            [self showErrorEmptyView:apiError.desc clickRelodRequestHandle:^{
                @strongify(self);
                [self request];
            }];
        }
    }];
}

#pragma mark - Setter Method

- (void)setDetailModel:(UGBillDetailModel *)detailModel {
    _detailModel = detailModel;
    
    self.otherAcount.text = detailModel.otherloginName;
    if ([self.orderType isEqualToString:@"0"]){
        self.number.text = [NSString stringWithFormat:@"+%@ UG",[detailModel.tradeAmount ug_amountFormat]];
//        self.number.textColor = [UIColor colorWithHexString:Color_GreenX];
        self.serverHeight.constant = 0;
        self.serverTop.constant = 0;
        self.serverLabel.hidden = YES;
        self.serverNum.hidden = YES;
    }
    else if([self.orderType isEqualToString:@"1"]){
        self.number.text = [NSString stringWithFormat:@"-%@ UG",[detailModel.tradeAmount ug_amountFormat]];
//        self.number.textColor = [UIColor colorWithHexString:Color_RedX];
    }
    //如果是个人转给商户 则没有手续费 隐藏手续费
    if ([detailModel.orderType isEqualToString:@"1"]){
        self.serverHeight.constant = 0;
        self.serverTop.constant = 0;
        self.serverLabel.hidden = YES;
        self.serverNum.hidden = YES;
    }
    
    if ([detailModel.payState isEqualToString:@"0"]) {
        self.transActionType.text = @"交易成功";
    }
    else if([detailModel.payState isEqualToString:@"1"]) {
        self.transActionType.text = @"交易失败";
    }
    else if([detailModel.payState isEqualToString:@"2"]) {
        self.transActionType.text = @"支付中";
    }
    self.createTimeShow.text = [UG_MethodsTool getFriendyWithStartTime:detailModel.createDate];
    self.billNumberShow.text = detailModel.orderSn;
    self.changeNum.text = [NSString stringWithFormat:@"%@ UG",[detailModel.tradeUgNumber ug_amountFormat]];
    self.serverNum.text =  [NSString stringWithFormat:@"%@ UG",[detailModel.poundage ug_amountFormat]];
    self.oyherWalletAdressShow.text = self.detailModel.otherCardNo;
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:detailModel.avatar] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    self.remarkTextView.text = !UG_CheckStrIsEmpty(detailModel.remark) ? detailModel.remark : @"";
}

@end
