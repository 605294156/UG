//
//  TROrderRecordTableViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/10.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "TROrderRecordTableViewCell.h"

@interface TROrderRecordTableViewCell ()
//头像
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
//对方用户名
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

//订单创建时间
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//订单状态
@property (weak, nonatomic) IBOutlet UILabel *orderStatusLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orderStatusImage;

/**
 订单名  例如：出售BTC
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;


/**
 数量 例如：数量（BTC）
 */
@property (weak, nonatomic) IBOutlet UILabel *amounNametLabel;

/**
 数量
 */
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;


/**
 交易总额 例如：交易总额（CNY）
 */
@property (weak, nonatomic) IBOutlet UILabel *totalNameLabel;

/**
 交易总额
 */
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;

//底部按钮容器view
@property (weak, nonatomic) IBOutlet UIView *buttonsConainerView;

@property (weak, nonatomic) IBOutlet UIImageView *UGPublishImageview;

@end

@implementation TROrderRecordTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOrderModel:(UGOredeModel *)orderModel {
    _orderModel = orderModel;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:orderModel.avatar] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    self.userNameLabel.text= orderModel.customerName;
    self.timeLabel.text = [UG_MethodsTool getFriendyWithStartTime:orderModel.createTime];
    self.orderStatusLabel.text = [orderModel stautsConvertToString];
    self.orderStatusImage.image = [UIImage imageNamed:[orderModel stautsConvertToImageStr]];
    
//    self.orderNameLabel.attributedText = [self convertOrderNameToAttributedString:orderModel];
    NSString *prefix = [orderModel orderTypeConvertToString];
    NSString *orderName = [NSString stringWithFormat:@"%@ %@",prefix, orderModel.coinName];
    self.orderNameLabel.text = orderName;
    
//    self.amounNametLabel.text = [NSString stringWithFormat:@"数量（%@）",orderModel.coinName];
//    self.amoutLabel.text = [NSString stringWithFormat:@"数量：%@ %@",orderModel.number,orderModel.coinName];
    NSString *Str =  [NSString stringWithFormat:@"%@ %@",orderModel.number,orderModel.coinName];
//    NSString *rangeStr =  @"数量：";
//    self.amoutLabel.attributedText = [self attributedStringWith:Str WithRangeStr:rangeStr WithColor:[UIColor blackColor]];
    self.amoutLabel.text = Str;
    
//    self.totalNameLabel.text = @"交易总额（CNY）";
//    self.totalLabel.text = [NSString stringWithFormat:@"交易额：%@ 元",orderModel.money];
    NSString *Str1 =  [NSString stringWithFormat:@"%@ 元",orderModel.money];
//    NSString *rangeStr1 =  @"交易额：";
//    self.totalLabel.attributedText = [self attributedStringWith:Str1 WithRangeStr:rangeStr1 WithColor:[UIColor blackColor]];
    self.totalLabel.text = Str1;
//    if ([_orderModel.isAdvertiser isEqualToString:@"0"]) {
//        self.UGPublishImageview.hidden = NO;
//    }
//    else
//    {
//        self.UGPublishImageview.hidden = YES;
//    }
    //底部按钮
    [self setupButtonsWithModel:orderModel];
}

-(NSMutableAttributedString *)attributedStringWith:(NSString *)attributedString WithRangeStr:(NSString *)rangeStr WithColor:(UIColor *)color{
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:attributedString];
    NSRange range1 = [[str string] rangeOfString:rangeStr];
    [str addAttribute:NSForegroundColorAttributeName value:color range:range1];
    return str;
}

- (NSAttributedString *)convertOrderNameToAttributedString:(UGOredeModel *)orderMode {
    NSString *prefix = [orderMode orderTypeConvertToString];
    NSString *orderName = [NSString stringWithFormat:@"%@ %@",prefix, orderMode.coinName];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:orderName];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSRangeFromString(orderName)];
    [attrString addAttribute:NSForegroundColorAttributeName value:UG_MainColor range:[orderName rangeOfString:prefix]];
    return attrString;
}

- (void)setupButtonsWithModel:(UGOredeModel *)orderMdel {

    [self.buttonsConainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    UIView *lastView = self.buttonsConainerView;

    NSArray <NSString *>*titles = [self buttonTitlesWithOrderStatus:orderMdel.status isBuy:[orderMdel.orderType isEqualToString:@"0"] WithStatus:orderMdel.appealStatus WithinitiatorId:orderMdel.initiatorId];
    
    for (int i = 0; i < titles.count; i ++) {
        UIButton *button = [self creatButtonWithTitle:titles[i]];
        [self.buttonsConainerView addSubview:button];
        BOOL firstView = lastView == self.buttonsConainerView;
        [button mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.buttonsConainerView.mas_top);
            make.trailing.equalTo(firstView ? lastView.mas_trailing : lastView.mas_leading).mas_offset( firstView ? 0 : -10.0f);
            make.size.mas_offset(CGSizeMake(button.titleLabel.text.length > 4 ? 100 :  button.titleLabel.text.length > 3 ? 69 : 66, 25));
        }];
        lastView = button;
    }
}

- (UIButton *)creatButtonWithTitle:(NSString *)title {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
//    UIColor *color = [title containsString:@"取消交易"] ? [UIColor colorWithHexString:@"BBBBBB"] : UG_MainColor;
    [btn setTitleColor:HEXCOLOR(0x6684c7) forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor clearColor];//[title containsString:@"取消交易"] ? [UIColor colorWithHexString:@"BBBBBB"] : UG_MainColor;
    btn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Medium" size:12];
    btn.layer.borderColor = HEXCOLOR(0x6684c7).CGColor;
    btn.layer.borderWidth = 1.0f;
//    btn.layer.cornerRadius = 2.0f;
//    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(clickButton:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}

/*
 UGOrderTypeCancle = 0,//取消交易
 UGOrderTypePay,//去支付
 UGOrderTypeputCoin,//去放币
 UGOrderTypeAppeal,//去申诉
 UGOrderTypeCheckAppeal,//查看申诉结果
 UGOrderTypeAssets,//查看资产
 UGOrderTypeOder,//查看订单
 */

- (void)clickButton:(UIButton *)btn {
    UGOrderType orderType = NSNotFound;
    NSString *title = btn.titleLabel.text;
    if ([title isEqualToString:@"取消交易"]) {
        orderType = UGOrderTypeCancle;
    } else if ([title isEqualToString:@"去支付"]) {
        orderType = UGOrderTypePay;
    } else if ([title isEqualToString:@"查看我的资产"]) {
        orderType = UGOrderTypeAssets;
    } else if ([title isEqualToString:@"申诉"] || [title isEqualToString:@"重新申诉"]) {
        orderType = UGOrderTypeAppeal;
    } else if ([title isEqualToString:@"去放币"]) {
        orderType = UGOrderTypeputCoin;
    } else if ([title isEqualToString:@"查看订单"]) {
        orderType = UGOrderTypeOder;
    } else if ([title isEqualToString:@"放弃申诉"]) {
        orderType = UGOrderTypeGiveupAppeal;
    } else if ([title isEqualToString:@"查看申诉"]) {
        orderType = UGOrderTypeCheckAppeal;
    }

    if (self.clickButtonHandle && orderType != NSNotFound) {
        self.clickButtonHandle(orderType);
    }
}

- (NSArray <NSString *>*)buttonTitlesWithOrderStatus:(NSString *)orderStatus isBuy:(BOOL)isBuy WithStatus:(NSString *)appealStatus WithinitiatorId:(NSString *)initiatorId{
    NSMutableArray <NSString *>*titles = [NSMutableArray new];
    if ([orderStatus isEqualToString:@"0"]) {
        //已取消
        [titles addObject:@"查看订单"];
        
    } else if (([orderStatus isEqualToString:@"1"])) {
        //未付款
        [titles addObjectsFromArray:isBuy ? @[@"取消交易",@"去支付"] : @[@"查看订单"]];
        
    } else if (([orderStatus isEqualToString:@"2"])) {
        //已付款
        if ([appealStatus isEqualToString:@"2"]) {
             [titles addObjectsFromArray: isBuy ? @[@"重新申诉"] : @[@"重新申诉", @"去放币"]];
        }else{
           [titles addObjectsFromArray: isBuy ? @[@"申诉"] : @[@"申诉", @"去放币"]];
        }
    } else if (([orderStatus isEqualToString:@"3"])) {
        //已完成
        [titles addObject:@"查看订单"];
        
    } else if ([orderStatus isEqualToString:@"4"]) {
        //申诉中
        if ([initiatorId isEqualToString:[UGManager shareInstance].hostInfo.ID]) {
              [titles addObjectsFromArray: @[@"重新申诉", @"放弃申诉"]];
        }else{
            [titles addObject:@"查看申诉"];
        }
    }
    //倒序排列
    return  [[titles reverseObjectEnumerator] allObjects];
}

- (BOOL)useCustomStyle{
    return NO;
}

@end
