//
//  EntrustCell.m
//  bit123
//
//  Created by sunliang on 2018/4/14.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "EntrustCell.h"

@implementation EntrustCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)configModel:(commissionModel*)model withBaseCoinScale:(int)baseCoinScale withCoinScale:(int)coinScale{
    [self.withDraw setTitle:LocalizationKey(@"Revoke") forState:UIControlStateNormal];
    if ([model.direction isEqualToString:@"BUY"]) {
        self.tradeType.text=LocalizationKey(@"buyDirection");
    }else{
        self.tradeType.text=LocalizationKey(@"sellDirection");
    }
    self.tradeType.textColor=[model.direction isEqualToString:@"BUY"]==YES?GreenColor:RedColor;
    self.timeLabel.text=[UG_MethodsTool getFriendyWithStartTime:[self convertStrToTime:model.time]];
    if ([model.type isEqualToString:@"LIMIT_PRICE"]) {
        self.titlePrice.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"price"),model.baseSymbol];
        self.titleAmount.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"amount"),model.coinSymbol];
        self.titleDeal.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"tradedAmount"),model.coinSymbol];
        self.price.text=[ToolUtil stringFromNumber:[model.price floatValue] withlimit:baseCoinScale];
        self.amount.text=[ToolUtil stringFromNumber:[model.amount floatValue] withlimit:coinScale];
        self.deal.text=[ToolUtil stringFromNumber:[model.tradedAmount floatValue] withlimit:coinScale];
       
    }else{
        //市价
        if ([model.direction isEqualToString:@"SELL"]) {//卖
            self.titlePrice.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"price"),model.baseSymbol];
            self.titleAmount.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"amount"),model.coinSymbol];
            self.titleDeal.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"tradedAmount"),model.coinSymbol];
            self.price.text=LocalizationKey(@"marketPrice");
            self.amount.text=[ToolUtil stringFromNumber:[model.amount floatValue] withlimit:coinScale];
            self.deal.text=[ToolUtil stringFromNumber:[model.tradedAmount floatValue] withlimit:coinScale];

        }else{//买
            self.titlePrice.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"price"),model.baseSymbol];
            self.titleAmount.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"amount"),model.coinSymbol];
            self.titleDeal.text=[NSString stringWithFormat:@"%@(%@)",LocalizationKey(@"tradedAmount"),model.coinSymbol];
            self.price.text=LocalizationKey(@"marketPrice");
            self.amount.text=[NSString stringWithFormat:@"%@",@"--"];
            self.deal.text=[ToolUtil stringFromNumber:[model.tradedAmount floatValue] withlimit:coinScale];
        }
  }
  
}
- (NSString *)convertStrToTime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
