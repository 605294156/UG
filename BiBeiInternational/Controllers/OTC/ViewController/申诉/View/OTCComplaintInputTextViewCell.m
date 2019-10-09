//
//  OTCComplaintInputTextViewCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/25.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCComplaintInputTextViewCell.h"
#import "UGPlaceholderTextView.h"

@interface OTCComplaintInputTextViewCell () <UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UGPlaceholderTextView *inputTextView;

@end

@implementation OTCComplaintInputTextViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(intputTextChange:) name:UITextViewTextDidChangeNotification object:self.inputTextView];
    self.inputTextView.delegate = self;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(OTCComplaintModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.inputTextView.placeholder = model.placeholder;
    self.inputTextView.text = model.value;
    
}

- (void)intputTextChange:(NSNotification *)sender {
    if (sender.object == self.inputTextView) {
        self.model.value = self.inputTextView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
        return NO;//此处是限制emoji表情输入
    }
    //判断键盘是不是九宫格键盘
    if ([NSString isNineKeyBoard:text] ){
        return YES;
    }else{
        if ([NSString hasEmoji:text] || [NSString stringContainsEmoji:text]){
            return NO;
        }
    }
    
    //限制输入235个字符
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    NSInteger caninputlen = 235 - comcatstr.length;
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = [text substringWithRange:rg];
            
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
        }
        return NO;
    }
    
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
