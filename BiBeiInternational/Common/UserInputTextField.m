//
//  UserInputTextField.m
//  UserInputTextField
//
//  Created by zsm on 2018/5/11.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UserInputTextField.h"


@implementation UserTextFieldHelper


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    /*
     * 不能输入.0-9以外的字符。
     * 设置输入框输入的内容格式
     * 只能有一个小数点
     * 小数点后最多能输入两位
     * 如果第一位是.则前面加上0.
     * 如果第一位是0则后面必须输入点，否则不能输入。
     */
    
    // 判断是否有小数点
    if ([textField.text containsString:@"."]) {
        self.hasDot = YES;
    }else{
        self.hasDot = NO;
    }
    
    if (string.length > 0) {
        
        //当前输入的字符
        unichar single = [string characterAtIndex:0];
        
        
        // 不能输入.0-9以外的字符
        if (!((single >= '0' && single <= '9') || single == '.')){
//                        Toast(@"您的输入格式不正确");
            return NO;
        }
        
        // 只能有一个小数点
        if (self.hasDot && single == '.') {
//                        Toast(@"最多只能输入一个小数点");
            return NO;
        }
        // 如果第一位是.则前面加上0.
        if ((textField.text.length == 0) && (single == '.')) {
            textField.text = @"0";
        }
        // 如果第一位是0则后面必须输入点，否则不能输入。
        if ([textField.text hasPrefix:@"0"]) {
            if (textField.text.length > 1) {
                NSString *secondStr = [textField.text substringWithRange:NSMakeRange(1, 1)];
                if (![secondStr isEqualToString:@"."]) {
//                                        Toast(@"第二个字符需要是小数点");
                    return NO;
                }
            }else{
                if (![string isEqualToString:@"."]) {
//                                        Toast(@"第二个字符需要是小数点");
                    return NO;
                }
            }
        }
        
    }
    
    if ([self.delegate  respondsToSelector:@selector(userInputTextField:shouldChangeCharactersInRange:replacementString: hasDot:)]) {
        return [self.delegate userInputTextField:self.helpObject shouldChangeCharactersInRange:range replacementString:string hasDot:self.hasDot];
    }
    
    return YES;
}


@end

@implementation UserInputTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        super.delegate = self.helper;
    }
    return self;
}
- (UserTextFieldHelper *)helper
{
    if (_helper == nil) {
        _helper = [[UserTextFieldHelper alloc] init];
        _helper.helpObject = self;
    }
    return _helper;
}

- (void)setDelegate:(id<UserInputTextFieldDelegate>)delegate
{
    self.helper.delegate = delegate;
    super.delegate = self.helper;
}


@end



 
