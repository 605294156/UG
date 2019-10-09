//
//  TradeNumCell.m
//  CoinWorld
//
//  Created by sunliang on 2018/6/1.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "TradeNumCell.h"

@implementation TradeNumCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.contentView.backgroundColor=[UIColor backgroundColor];
    // Initialization code
}
-(void)configmodel:(TradeNumModel*)model{
   
    if ([model.price intValue]<0) {
         self.buyType.text=@"--";
         self.priceLabel.text=@"--";
         self.amountLabel.text=@"--";
         self.timeLabel.text=@"--";
    }else{
        if ([model.direction isEqualToString:@"BUY"]) {
            self.buyType.text=LocalizationKey(@"Buy");
            self.buyType.textColor=GreenColor;
        }else{
            self.buyType.text=LocalizationKey(@"Sell");
            self.buyType.textColor=RedColor;
        }
        self.timeLabel.text=[self convertStrToTime:model.time];
        self.priceLabel.text=[ToolUtil judgeStringForDecimalPlaces:model.priceStr];
        self.amountLabel.text=[ToolUtil judgeStringForDecimalPlaces:model.amountStr];
    }
  
}
//MARK:--判断字符串后有几位小数，超过八位就省略
+(NSString *)judgeStringForDecimalPlaces:(NSString *)string{
    NSString *numStr = @"";
    NSArray *array = [string componentsSeparatedByString:@"."];
    if (array.count == 2) {
        NSString *str = array[1];
        if (str.length > 8) {
            numStr = [NSString stringWithFormat:@"%.8f",[string doubleValue]];
        }else{
            numStr = string;
        }
    }else{
        numStr = string;
    }
    return numStr;
}
//MARK:--毫秒时间戳转 HH:mm MM/dd格式
- (NSString *)convertStrToTime:(NSString *)timeStr
{
    long long time=[timeStr longLongValue];
    NSDate *d = [[NSDate alloc]initWithTimeIntervalSince1970:time/1000.0];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"HH:mm:ss"];
    NSString*timeString=[formatter stringFromDate:d];
    return timeString;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
