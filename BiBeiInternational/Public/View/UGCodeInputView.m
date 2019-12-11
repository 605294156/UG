//
//  TestView.m
//  GLDemo
//
//  Created by keniu on 2018/11/15.
//  Copyright © 2018 keniu. All rights reserved.
//

#import "UGCodeInputView.h"

static NSString  * const MONEYNUMBERS = @"0123456789";


@interface UGCodeInputView ()<UIKeyInput>

@property (strong, nonatomic) NSMutableString *inputString;//输入的字符串

@end

@implementation UGCodeInputView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self gl_initStyle];
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self gl_initStyle];
    }
    return self;
}
#define LINEWIDTH   45.f
#pragma mark - 初始化数据
- (void)gl_initStyle {
    NSLog(@"%.f",UG_SCREEN_WIDTH);
    _squareWidth = 45.0f;
    _borderWidth = 1.5f;
    _codeNum = 6;
    _secureText = NO;
    _noRectColor = [UIColor colorWithHexString:@"dddddd"];
    _inputRectColor = [UIColor colorWithHexString:@"6684c7"];
    _codeFont = [UIFont fontWithName:@"PingFangSC-Regular" size:22];
    _codeColor = [UIColor colorWithHexString:@"333333"];
    _pointRadius = 4.0f;
    self.padding = ((UG_SCREEN_WIDTH-40)-self.codeNum*LINEWIDTH)/5.0;
    
    self.inputString = [NSMutableString new];
    //不设置背景色会出现绘制过的文字不能清除的bug
    self.backgroundColor = [UIColor whiteColor];
    _showKeyBoard = NO;
//    [self becomeFirstResponder];
}


- (void)setShowKeyBoard:(BOOL)showKeyBoard {
    _showKeyBoard = showKeyBoard;
    if (showKeyBoard) {
        [self becomeFirstResponder];
    }
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    [[UIColor whiteColor] setFill];
    
    //绘制正方形
    for (int i = 0; i < self.codeNum; i++) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextFillRect(context, rect);
        //边框
        CGContextSetLineWidth(context, self.borderWidth);
        //正方形
        CGFloat pointX = (i * self.padding) + i* LINEWIDTH;
//        CGContextAddRect(context, CGRectMake(pointX, 0, self.squareWidth, self.squareWidth));
        //填充
        CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
        //边框颜色
        CGContextSetStrokeColorWithColor(context, [self squareFillColor:i].CGColor);

        //绘制路径及填充模式
//        CGContextDrawPath(context, kCGPathFillStroke);

        CGPoint aPoints[2];//坐标点
        aPoints[0] =CGPointMake(pointX, self.mj_h-self.borderWidth);//坐标1
        aPoints[1] =CGPointMake(pointX+LINEWIDTH, self.mj_h-self.borderWidth);//坐标2
        CGContextAddLines(context, aPoints, 2);//添加线
        CGContextClosePath(context);
        CGContextDrawPath(context, kCGPathFillStroke); //根据坐标绘制路径
    }
    
    //小黑点
    if (self.secureText ) {
        if ( self.inputString.length > 0) {
            //画黑点
            for (int i = 0 ; i < self.inputString.length; i++) {
                CGFloat pointX = (i * self.padding) + i * LINEWIDTH + LINEWIDTH / 2;
                CGContextRef context = UIGraphicsGetCurrentContext();
                CGContextDrawPath(context, kCGPathFillStroke);
                CGContextSetFillColorWithColor(context, HEXCOLOR(0x6684c7).CGColor);
                CGContextAddArc(context,  pointX, (LINEWIDTH + self.borderWidth - self.pointRadius)/2, self.pointRadius, 0, M_PI*2, YES);
                CGContextDrawPath(context, kCGPathFill);
            }
        }
        return;
    }

    //绘制文字
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    NSDictionary *attributes = @{
                                 NSFontAttributeName : self.codeFont,
                                 NSForegroundColorAttributeName : self.codeColor,
                                 NSParagraphStyleAttributeName : paragraphStyle
                                 };
    for(int i =0; i < [self.inputString length]; i++) {
        NSString *code = [self.inputString substringWithRange:NSMakeRange(i,1)];
        CGFloat pointX = (i * self.padding) + i * LINEWIDTH;
        CGFloat stringH = [code sizeWithAttributes:attributes].height;
        CGRect rect = CGRectMake(pointX, (LINEWIDTH + self.borderWidth - stringH)/2 , LINEWIDTH, LINEWIDTH);
        [code drawInRect:rect withAttributes:attributes];
    }
    
}

- (UIColor *)squareFillColor:(int)index {
    UIColor *color = self.noRectColor;
    if (index < self.inputString.length && self.inputString.length != 0) {
        color = self.inputRectColor;
    }
    return color;
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (![self isFirstResponder]) {
        [self becomeFirstResponder];
    }
}

#pragma mark - UIKeyInput

/**
 *  设置键盘的类型
 */
- (UIKeyboardType)keyboardType {
    return UIKeyboardTypeNumberPad;
}

/**
 *  用于显示的文本对象是否有任何文本
 */
- (BOOL)hasText {
    return self.inputString.length > 0;
}

/**
 *  插入文本
 */
- (void)insertText:(NSString *)text {
    if (self.inputString.length < self.codeNum) {
        //判断是否是数字
        NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:MONEYNUMBERS] invertedSet];
        NSString*filtered = [[text componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [text isEqualToString:filtered];
        if(basicTest) {
            [self.inputString appendString:text];
            if ([self.delegate respondsToSelector:@selector(codeDidChange:)]) {
                [self.delegate codeDidChange:self];
            }
            if (self.inputString.length == self.codeNum) {
                if ([self.delegate respondsToSelector:@selector(codeCompleteInput:)]) {
                    [self.delegate codeCompleteInput:self];
                }
            }
            [self setNeedsDisplay];
        }
    }
}

/**
 *  删除文本
 */
- (void)deleteBackward {
    if (self.inputString.length > 0) {
        [self.inputString deleteCharactersInRange:NSMakeRange(self.inputString.length - 1, 1)];
    }
    [self setNeedsDisplay];
}


- (BOOL)becomeFirstResponder {
    if ([self.delegate respondsToSelector:@selector(codeBeginInput:)]) {
        [self.delegate codeBeginInput:self];
    }
    return [super becomeFirstResponder];
}

- (BOOL)resignFirstResponder {
    return [super resignFirstResponder];
}

/**
 *  是否能成为第一响应者
 */
- (BOOL)canBecomeFirstResponder {
    return YES;
}


#pragma mark - Setter Method

- (void)setSquareWidth:(CGFloat)squareWidth {
    _squareWidth = squareWidth;
    [self setNeedsDisplay];
}

- (void)setPadding:(CGFloat)padding {
    _padding = padding;
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    [self setNeedsDisplay];
}

- (void)setNoRectColor:(UIColor *)noRectColor {
    _noRectColor = noRectColor;
    [self setNeedsDisplay];
}

- (void)setInputRectColor:(UIColor *)inputRectColor {
    _inputRectColor = inputRectColor;
    [self setNeedsDisplay];
}

- (void)setCodeFont:(UIFont *)codeFont {
    _codeFont = codeFont;
    [self setNeedsDisplay];
}

- (void)setCodeColor:(UIColor *)codeColor {
    _codeColor = codeColor;
    [self setNeedsDisplay];
}

- (void)setSecureText:(BOOL)secureText {
    _secureText = secureText;
    [self setNeedsDisplay];
}

- (void)setPointRadius:(CGFloat)pointRadius {
    _pointRadius = pointRadius;
    [self setNeedsDisplay];
}

#pragma mark - Getter Mehod

- (NSString *)textStore {
    return [NSString stringWithString:self.inputString];
}

@end

