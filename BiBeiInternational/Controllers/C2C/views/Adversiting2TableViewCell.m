//
//  Adversiting2TableViewCell.m
//  CoinWorld
//
//  Created by iDog on 2018/1/31.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "Adversiting2TableViewCell.h"

@implementation Adversiting2TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView.delegate = self;
    // Initialization code
    self.contentView.userInteractionEnabled = YES;
    @weakify(self);
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        [self.textView becomeFirstResponder];
    }];
    [self.contentView addGestureRecognizer:tap];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    NSString *str = [textView.text stringByAppendingString:text];
    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewIndex:TextViewString:)]) {
        [self.delegate textViewIndex:self.index TextViewString:str];
    }
    //留言或自动回复长度100
    if (str.length > 100) {
        textView.text = [str substringToIndex:100];
        return NO;
    }
    return YES;
}

//-(void)textViewDidEndEditing:(UITextView *)textView {
//    if (self.delegate && [self.delegate respondsToSelector:@selector(textViewIndex:TextViewString:)]) {
//        [self.delegate textViewIndex:self.index TextViewString:textView.text];
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
