//
//  BuyCoinsDetail2TableViewCell.m
//  CoinWorld
//
//  Created by iDog on 2018/2/1.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "BuyCoinsDetail2TableViewCell.h"

@implementation BuyCoinsDetail2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tradeTipLabel.text = LocalizationKey(@"tradingRemind");
    [self.coinType1Num setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
    [self.coinType2Num setFont:[UIFont fontWithName:@"Helvetica-Bold" size:15.0]];
    self.coinType1Width.constant = (kWindowW-141)/2;
    [self.coinType1Num addTarget:self action:@selector(textfieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.coinType2Num addTarget:self action:@selector(textfieldAction:) forControlEvents:UIControlEventEditingChanged];
    // Initialization code
}
- (void)textfieldAction:(UITextField *)textField
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldTag:TextFieldString:)]) {
        [self.delegate textFieldTag:textField.tag  TextFieldString:textField.text];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
