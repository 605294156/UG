//
//  TREntrustTableViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/27.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "TREntrustTableViewCell.h"


@interface TREntrustTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *tradeType;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIButton *withDraw;


@property (weak, nonatomic) IBOutlet UILabel *titlePrice;
@property (weak, nonatomic) IBOutlet UILabel *titleAmount;
@property (weak, nonatomic) IBOutlet UILabel *titleDeal;

@property (weak, nonatomic) IBOutlet UILabel *price;
@property (weak, nonatomic) IBOutlet UILabel *amount;
@property (weak, nonatomic) IBOutlet UILabel *deal;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end


@implementation TREntrustTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setExchangeModel:(UGOTCExchageModel *)exchangeModel {
    _exchangeModel = exchangeModel;
    BOOL isBuy = [exchangeModel.direction isEqualToString:@"0"];
    self.tradeType.text= isBuy ? LocalizationKey(@"buyDirection") : LocalizationKey(@"sellDirection");
    self.tradeType.textColor= isBuy ? GreenColor : RedColor;
    self.timeLabel.text=[UG_MethodsTool getFriendyWithStartTime:[self convertStrToTime:exchangeModel.time]];
    
    self.titlePrice.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"price"),exchangeModel.baseSymbol];
    self.titleAmount.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"amount"),exchangeModel.coinSymbol];
    self.titleDeal.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"tradedAmount"),exchangeModel.coinSymbol];
    self.statusLabel.text = [exchangeModel stautsConvertToString];
    if ([exchangeModel.status isEqualToString:@"0"]) {
        self.withDraw.hidden = NO;
        [self.withDraw setTitle:LocalizationKey(@"Revoke") forState:UIControlStateNormal];
    }
    BOOL isLimitPrice = [exchangeModel.type isEqualToString:@"LIMIT_PRICE"];
    //保留6位
    int decimalNum = 6;
    
    if (isLimitPrice) {//限价
        self.price.text=[ToolUtil stringFromNumber:[exchangeModel.price floatValue] withlimit:decimalNum];
        self.amount.text=[ToolUtil stringFromNumber:[exchangeModel.amount floatValue] withlimit:decimalNum];
        self.deal.text=[ToolUtil stringFromNumber:[exchangeModel.tradedAmount floatValue] withlimit:decimalNum];
    } else {//市价
        self.price.text=LocalizationKey(@"marketPrice");
        if (isBuy) {
            self.amount.text=[NSString stringWithFormat:@"%@",@"--"];
            self.deal.text=[ToolUtil stringFromNumber:[exchangeModel.tradedAmount floatValue] withlimit:decimalNum];
        } else {
            self.amount.text=[ToolUtil stringFromNumber:[exchangeModel.amount floatValue] withlimit:decimalNum];
            self.deal.text=[ToolUtil stringFromNumber:[exchangeModel.tradedAmount floatValue] withlimit:decimalNum];
        }
    }
}

- (NSString *)convertStrToTime:(NSString *)timeStr {
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
}

//撤销
- (IBAction)clickCancle:(UIButton *)sender {
    if (self.clickCancelHandle) {
        self.clickCancelHandle(self.exchangeModel);
    }
}

@end
