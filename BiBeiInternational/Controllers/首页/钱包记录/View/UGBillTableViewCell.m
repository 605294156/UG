//
//  UGBillTableViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/17.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGBillTableViewCell.h"
#import "UGOrderListModel.h"

@interface UGBillTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *acount;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *typeLable;


@end

@implementation UGBillTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    if ([UG_MethodsTool is4InchesScreen]) {
        self.balanceLabel.font = UG_AutoFont(self.balanceLabel.font.pointSize);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderListModel:(UGOrderListModel *)orderListModel {
    _orderListModel = orderListModel;
    
    [self.image sd_setImageWithURL:[NSURL URLWithString:[orderListModel showAvatar]] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    self.acount.text = [orderListModel showUserName] ;
    UIColor *color = [UIColor colorWithHexString:Color_RedX];
    NSString *totalAmount = orderListModel.totalAmount;
    
    //模型.m文件处理了，但是+号会被去掉所以这里需要补上
    if (![totalAmount containsString:@"-"]) {
        totalAmount = [NSString stringWithFormat:@"+%@",totalAmount];
        color = [UIColor colorWithHexString:Color_GreenX];
    }
    
    self.price.text = [NSString stringWithFormat:@"%@ UG",totalAmount];
    self.price.textColor = color;
    
    self.balanceLabel.text = [NSString stringWithFormat:@"余额：%@ UG",orderListModel.curBalance];
    
    
    self.typeLable.text = [orderListModel showType];
    
    self.time.text = [UG_MethodsTool getFriendyWithStartTime:orderListModel.createTime];
    
}

- (BOOL)useCustomStyle{
    return NO;
}


@end
