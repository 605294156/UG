//
//  UGPlaceholderTextView.m
//  ug-wallet
//
//  Created by keniu on 2018/9/21.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGPlaceholderTextView.h"




@interface UGPlaceholderTextView ()

@property(nonatomic, copy)NSString *tempPlaceHoleder;

@end

@implementation UGPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _placeholderColor = [UIColor lightGrayColor];
        _placeholder = @"请输入内容";
        _tempPlaceHoleder = _placeholder;
        _placeholderFont = [UIFont systemFontOfSize:14];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _placeholderColor = [UIColor lightGrayColor];
        _placeholder = @"请输入内容";
        _tempPlaceHoleder = _placeholder;
        _placeholderFont = [UIFont systemFontOfSize:14];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self setNeedsDisplay];
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
    
    [super drawRect:rect];
    
    // 如果有文字，就直接返回，不需要画占位文字
    if (self.hasText) return;
    
    NSDictionary *attrs = @{
                            NSFontAttributeName : self.placeholderFont,
                            NSForegroundColorAttributeName : self.placeholderColor
                            };
    //调整间距
    CGRect textRect = rect;
    textRect.origin.x = 5;
    textRect.origin.y = 8;
    textRect.size.width -= 2 * rect.origin.x;
    //绘制文字
    [self.placeholder drawInRect:textRect withAttributes:attrs];
}

#pragma mark - UITextViewTextDidChangeNotification

- (void)textDidChangeNotification:(NSNotification *)notification {
    UITextView *textView = notification.object;
    if (textView == self) {
        self.placeholder = textView.text.length > 0 ? @"" : self.tempPlaceHoleder;
    }
}

#pragma mark - Setter Method
// 设置属性的时候需要重绘，所以需要重写相关属性的set方法
- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    //记录设置的placeholder
    if (placeholder.length) {
        _tempPlaceHoleder = placeholder;
    }
    [self setNeedsDisplay];
}


- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    [self setNeedsDisplay];
}

- (void)setPlaceholderFont:(UIFont *)placeholderFont {
    _placeholderFont = placeholderFont;
    [self setNeedsDisplay];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end

