//
//  UGSysFreezeResultCell.m
//  BiBeiInternational
//
//  Created by keniu on 2019/7/5.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGSysFreezeResultCell.h"

@interface UGSysFreezeResultCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;//订单标题

@property (weak, nonatomic) IBOutlet UILabel *orderCreatTime;//订单时间

@property (weak, nonatomic) IBOutlet UILabel *coinAmountLabel;//金额

@property (weak, nonatomic) IBOutlet UILabel *returnAmountLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalLabel;//当前可用金额

@end

@implementation UGSysFreezeResultCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UGNotifyModel *)model {
    
    _model = model;
    
    UGSysFreezeResultModel *sysFreezeResultModel = (UGSysFreezeResultModel *)model.data;
    
    self.titleLabel.text =  model.title;
    
    self.orderCreatTime.text = [UG_MethodsTool getFriendyWithStartTime:sysFreezeResultModel.createTime];
    
    self.coinAmountLabel.text = [NSString stringWithFormat:@"%@ %@",sysFreezeResultModel.total,sysFreezeResultModel.coinUnit];
    
    self.returnAmountLabel.text = [NSString stringWithFormat:@"%@ %@",sysFreezeResultModel.resultAmount,sysFreezeResultModel.coinUnit];
    
    self.totalLabel.text = [NSString stringWithFormat:@"%@ %@",sysFreezeResultModel.balance,sysFreezeResultModel.coinUnit];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)useCustomStyle{
    return NO;
}

@end
