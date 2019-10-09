//
//  Advertising1TableViewCell.m
//  CoinWorld
//
//  Created by iDog on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "Advertising1TableViewCell.h"
#import "TXMatchConst.h"

@implementation Advertising1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.contentView.userInteractionEnabled = YES;
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        [self.centerTextFileld becomeFirstResponder];
    }];
    [self.contentView addGestureRecognizer:tap];
    [self.centerTextFileld addTarget:self action:@selector(textfieldAction:) forControlEvents:UIControlEventEditingDidEnd];
    [self.centerTextFileld addTarget:self action:@selector(textfieldValueChange:) forControlEvents:UIControlEventEditingChanged];
    //适配4英寸屏
    if ([UG_MethodsTool is4InchesScreen]) {
        self.leftLabel.font = UG_AutoFont(self.leftLabel.font.pointSize );
        self.centerTextFileld.font = UG_AutoFont(self.centerTextFileld.font.pointSize);
        self.centerTextFileld.textAlignment = NSTextAlignmentCenter;
        self.rightLabel.font = UG_AutoFont(self.rightLabel.font.pointSize);
        self.leftSpaceLayout.constant = 8;
        self.leftLabelWidthLayout.constant = 80;
    }
}

- (void)setIndex:(NSIndexPath *)index {
    _index = index;
    
//    if (index.row == 6) {
    if (index.row == 5) {
        self.centerTextFileld.limitedType = TXLimitedTextFieldTypeCustom;
        self.centerTextFileld.limitedRegEx = kTXLimitedTextFieldNumberOnlyRegex;
    } else {
        self.centerTextFileld.limitedType = TXLimitedTextFieldTypePrice;
        //小数点钱位数控制
        self.centerTextFileld.limitedPrefix = 20;
        //小数点后位数控制. UG 6位数 CNY 2位 限制金额输入最多为两位小数
//        self.centerTextFileld.limitedSuffix = index.row == 3 ? 6 : 2;
        self.centerTextFileld.limitedSuffix = index.row == 3 ? 6 : 6;
    }

}

- (void)textfieldValueChange:(UITextField *)textField {
    //密码输入
//    if (self.index.row == 6) { return;  }
    if (self.index.row == 5) { return;  }
    //第一位数是.
    if (textField.text.length > 0) {
        NSString *firstStr = [textField.text substringToIndex:1];
        if ([firstStr isEqualToString:@"."]) {
            textField.text = [NSString stringWithFormat:@"0%@",textField.text];
        }
    }
    
    //买入总数量
    if (self.index.row == 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldIndex:TextChangeString:)]) {
            [self.delegate textFieldIndex:self.index TextChangeString:textField.text];
        }
    }
}


- (void)textfieldAction:(UITextField *)textField {
//    if (_index.row != 6 && textField.left > 1) {
     if (_index.row != 5 && textField.left > 1) {
        //最后一位数是.
        NSString *lastStr = [textField.text substringWithRange:NSMakeRange(textField.text.length - 1, 1)];
        if ([lastStr isEqualToString:@"."]) {
            textField.text = [textField.text substringToIndex:textField.text.length - 1];
        }
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(textFieldIndex:TextFieldString:)]) {
        [self.delegate textFieldIndex:self.index TextFieldString:textField.text];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
