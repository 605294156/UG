//
//  UGAccountCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/11/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAccountCell.h"
#import "UGRemotemessageHandle.h"

@interface UGAccountCell ()

@property (weak, nonatomic) IBOutlet UIButton *typeButon;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ugLabel;
@property (weak, nonatomic) IBOutlet UILabel *accountLabel2;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel2;

@end

@implementation UGAccountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UGNotifyModel *)model {
    _model = model;
    
    UGTransferModel *transerModel = (UGTransferModel *)model.data;
    
    [self.typeButon setTitle:[transerModel.orderType isEqualToString:@"SUB_TYPE_RECEIPT"] ? @"收币入账" : @"转币扣款" forState:UIControlStateNormal];
    self.timeLabel.text = [UG_MethodsTool getFriendyWithStartTime:transerModel.createTime];
    self.ugLabel.text = [transerModel.orderType isEqualToString:@"SUB_TYPE_RECEIPT"] ? [NSString stringWithFormat:@"+ %@ UG",transerModel.amount] : [NSString stringWithFormat:@"- %@ UG",transerModel.amount];
//    self.ugLabel.textColor = [transerModel.orderType isEqualToString:@"SUB_TYPE_RECEIPT"] ? [UIColor colorWithHexString:Color_GreenX] : [UIColor colorWithHexString:Color_RedX];
    self.accountLabel.text =[transerModel.orderType isEqualToString:@"SUB_TYPE_RECEIPT"] ? @"转币账号" : @"收币账号";
    self.nameLabel.text = transerModel.customer;
    self.accountLabel2.text = [transerModel.orderType isEqualToString:@"SUB_TYPE_RECEIPT"] ? @"交易金额" : @"转币扣款";
    self.nameLabel2.text = [NSString stringWithFormat:@"%@ CNY",transerModel.amount];
    //隐藏或显示红点
    //        self.nameLabel.hidden = [obj.status isEqualToString:@"1"];

    [model bk_addObserverForKeyPath:@"status" options:NSKeyValueObservingOptionNew task:^(UGNotifyModel *obj, NSDictionary *change) {
        //隐藏或显示红点
//        self.nameLabel.hidden = [obj.status isEqualToString:@"1"];
    }];
}

- (void)dealloc {
    [self.model bk_removeAllBlockObservers];
}

- (BOOL)useCustomStyle{
    return NO;
}

@end
