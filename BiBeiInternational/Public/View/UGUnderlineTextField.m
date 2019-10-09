//
//  UGUnderlineTextField.m
//  ug-wallet
//
//  Created by keniu on 2018/9/19.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGUnderlineTextField.h"

@interface UGUnderlineTextField ()

@property(nonatomic, strong) UIImageView *leftImageView;

@end

@implementation UGUnderlineTextField

- (instancetype)init {
    self = [super init];
    if (self) {
        _lineHeight = 1.0f;
        _lineColor = [UIColor colorWithHexString:@"D8D8D8"];
        self.leftView = self.leftImageView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.borderStyle = UITextBorderStyleNone;
        self.leftImageName = @"";
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _lineHeight = 1.0f;
        _lineColor = [UIColor colorWithHexString:@"D8D8D8"];
        self.leftView = self.leftImageView;
        self.leftViewMode = UITextFieldViewModeAlways;
        self.borderStyle = UITextBorderStyleNone;
        self.leftImageName = @"";
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextAddRect(context, CGRectMake(0, self.ug_height - self.lineHeight, self.ug_width, self.lineHeight));
    CGContextSetLineWidth(context, self.lineHeight);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextDrawPath(context, kCGPathFillStroke);
}


- (CGRect)textRectForBounds:(CGRect)bounds {
    CGRect rect = [super textRectForBounds:bounds];
    if (self.leftImageName.length > 0) {
        rect.origin.x += 22;
    }
    return rect;
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    CGRect rect = [super editingRectForBounds:bounds];
    if (self.leftImageName.length > 0) {
        rect.origin.x += 22;
    }
    return  rect;
}

#pragma mark - Setter Mehod
-(void)setLeftImageName:(NSString *)leftImageName {
    _leftImageName = leftImageName;
    self.leftViewMode = leftImageName.length > 0 ? UITextFieldViewModeAlways : UITextFieldViewModeNever;
    if (leftImageName.length > 0) {
        self.leftImageView.image = [UIImage imageNamed:leftImageName];
    }
    [self setNeedsLayout];
}

- (void)setLineColor:(UIColor *)lineColor {
    _lineColor = lineColor;
    [self setNeedsLayout];
}

- (void)setLineHeight:(CGFloat)lineHeight {
    _lineHeight = lineHeight;
    [self setNeedsLayout];
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 17, 20)];
    }
    return _leftImageView;
}



@end
