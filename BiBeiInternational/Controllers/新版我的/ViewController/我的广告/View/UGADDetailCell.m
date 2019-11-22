//
//  UGADDetailCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/12/26.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGADDetailCell.h"
@interface UGADDetailCell ()
@property (weak, nonatomic) IBOutlet UILabel *orderLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headerImg;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *payState;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *traderNum;
@property (weak, nonatomic) IBOutlet UIImageView *payStateImage;

@end

@implementation UGADDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setModel:(UGAdDetailListModel *)model{
    _model = model;
    
    //订单号
    self.orderLabel.text = [NSString stringWithFormat:@"订单号：%@",model.orderSn];
    
    //时间
    self.timeLabel.text = [UG_MethodsTool getFriendyWithStartTime:model.createTime];
    
    //头像
    
    [self.headerImg sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
   
    //用户名
    self.userName.text =model.customerName;
    
    //付款状态
    self.payState.text = [model statusStr];
    self.payStateImage.image = [UIImage imageNamed:[model stautsConvertToImageStr]];

    //数量
    self.numberLabel.text = [NSString stringWithFormat:@"%@ UG",[model.number ug_amountFormat]];
    
    //交易金额
    self.traderNum.text = [NSString stringWithFormat:@"%@ 元",[model.money ug_amountFormat]];
}

- (BOOL)useCustomStyle{
    return NO;
}

@end
