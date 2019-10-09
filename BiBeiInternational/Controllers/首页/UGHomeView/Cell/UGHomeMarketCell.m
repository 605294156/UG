//
//  UGHomeMarketCell.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/16.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeMarketCell.h"
#import "AppDelegate.h"
#import "symbolModel.h"
#import "UGSymbolThumbModel.h"

@implementation UGHomeMarketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(BOOL)useCustomStyle{
    return NO;
}

-(void)layoutSubviews{
    [super layoutSubviews];
}

-(void)configDataWithModel:(UGSymbolThumbModel*)model{
    NSArray *array = [model.symbol componentsSeparatedByString:@"/"];
    NSString*baseSymbol=[array firstObject];
    NSString*coinSymbol=[array lastObject];
    self.titleLabel.text=baseSymbol;
    self.subTitleLabel.text=[NSString stringWithFormat:@"/%@",coinSymbol];
    self.changenumLabel.text =[model.closeStr ug_amountFormat];
    
    NSString *str1 = [NSString ug_positiveFormatWithMultiplier:model.close multiplicand:model.baseUsdRate scale:6 roundingMode:NSRoundDown];
    NSString *rate = ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRate;
    NSString *cnyStr =[NSString ug_positiveFormatWithMultiplier:str1 multiplicand:rate scale:6 roundingMode: NSRoundDown];
    self.cnyLabel.text=[NSString stringWithFormat:@"¥ %@",cnyStr];//计算人民币 切换美元
    self.percenLabel.text =[NSString stringWithFormat:@"%@%%", [NSString ug_positiveFormatWithMultiplier: model.chg multiplicand:@"100" scale:2 roundingMode:NSRoundDown]];
    self.percenLabel.layer.cornerRadius= 2;
    self.percenLabel.layer.masksToBounds= YES;
    self.hournumLabel.text=[NSString stringWithFormat:@"%@ %@",LocalizationKey(@"hourvol"), [model.volume ug_amountFormat]];
    if ([model.chg doubleValue] >=0) {
        self.changenumLabel.textColor=[UIColor colorWithHexString:Color_GreenX];
        self.percenLabel.backgroundColor=[UIColor colorWithHexString:Color_GreenX];
    }else{
        self.changenumLabel.textColor=[UIColor colorWithHexString:Color_RedX];
        self.percenLabel.backgroundColor=[UIColor colorWithHexString:Color_RedX];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
