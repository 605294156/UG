//
//  UGNotifyTableViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/12/11.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGNotifyTableViewCell.h"
#import "UGRemotemessageHandle.h"


@interface UGNotifyTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *avatarImageView;
//对方用户名
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;

/**
 订单名  例如：出售BTC
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderNameValue;

/**
 订单号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderSnLabel;
@property (weak, nonatomic) IBOutlet UILabel *orderSnValue;

/**
 交易金额 ：88.8888UG
 */
@property (weak, nonatomic) IBOutlet UILabel *amoutLabel;
@property (weak, nonatomic) IBOutlet UILabel *amoutValue;


/**
 订单创建时间
 */
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;


/**
 交易ID
 */
@property (weak, nonatomic) IBOutlet UILabel *advertiseIDLabel;
@property (weak, nonatomic) IBOutlet UILabel *advertiseIDValue;

/**
 卖家已付款，请前往放币
 */
@property (weak, nonatomic) IBOutlet UILabel *tipsLabel;

//交易ID高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *advertiselConstraint;
//订单号顶部间距
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *orderTopConstraint;

@end

@implementation UGNotifyTableViewCell

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
    
    UGJpushNotifyModel *notifyModel = (UGJpushNotifyModel *)model.data;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:notifyModel.avatar] placeholderImage:[UIImage imageNamed:@"header_defult"]];
    self.userNameLabel.text= notifyModel.others;
    
    if ([notifyModel.informType containsString:@"-"]) {
        NSArray *ar = [notifyModel.informType componentsSeparatedByString:@"-"];
        self.orderNameLabel.text = ar.firstObject;
        self.orderNameValue.text = ar.lastObject;
    }else{
//        self.orderNameLabel.attributedText = [self convertOrderNameToAttributedString:notifyModel];
        self.orderNameValue.text = notifyModel.informType;
    }
    
    
    self.advertiseIDLabel.text = @"交易ID";
    self.advertiseIDValue.text = notifyModel.advertiseId;
    self.orderSnLabel.text = @"订单号";
    self.orderSnValue.text = notifyModel.orderSn;
    self.amoutLabel.text = @"交易金额";
    self.amoutValue.text = [NSString stringWithFormat:@"%@%@",notifyModel.amount, notifyModel.coinUnit];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",[UG_MethodsTool getFriendyWithStartTime:notifyModel.createTime]];
    
    self.tipsLabel.text = notifyModel.informAction;
    //申诉不改边文字和颜色
    if ([model.messageType isEqualToString:@"APPEAL_CANCEL_INFO"] || [model.messageType isEqualToString:@"APPEAL_RELEASE_INFO"]) {
//        self.tipsLabel.textColor = UG_MainColor;
    } else {
//        self.tipsLabel.textColor = model.deal ? [UIColor colorWithHexString:@"BBBBBB"] : UG_MainColor;
        self.tipsLabel.text = model.deal ? @"已处理" : notifyModel.informAction;
    }

    //是否是OTC
    BOOL isOTC = [notifyModel.otcMessageType isEqualToString:@"OTC_ORDER_MSG"];
    self.advertiselConstraint.constant = isOTC ? 0.0f : 14.50f;
    self.orderTopConstraint.constant =  isOTC ? 0.0f : 15.0f;
    self.advertiseIDValue.hidden = isOTC ? YES : NO;
    //监听订单处理情况
    [model bk_addObserverForKeyPath:@"deal" options:NSKeyValueObservingOptionNew task:^(UGNotifyModel *obj, NSDictionary *change) {
        //非申诉的才处理
        if (![model.messageType isEqualToString:@"APPEAL_CANCEL_INFO"]  && ![model.messageType isEqualToString:@"APPEAL_RELEASE_INFO"]) {
            self.tipsLabel.text = model.deal ? @"已处理" : notifyModel.informAction;
//            self.tipsLabel.textColor = model.deal ? [UIColor colorWithHexString:@"BBBBBB"] : UG_MainColor;
        }
    }];
    
}


- (NSAttributedString *)convertOrderNameToAttributedString:(UGJpushNotifyModel *)orderMode {
    if (orderMode.informType.length == 0) {
        return nil;
    }
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:orderMode.informType];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSRangeFromString(orderMode.informType)];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:Color_RedX] range:[orderMode.informType rangeOfString:@"出售"]];
    [attrString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:Color_GreenX] range:[orderMode.informType rangeOfString:@"购买"]];
    return attrString;
}

- (void)dealloc {
    [self.model bk_removeAllBlockObservers];
}
- (BOOL)useCustomStyle{
    return NO;
}
@end
