//
//  UGButton.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/16.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGButton.h"
#import "UIImage+Expand.h"

@interface UGButton ()

@end

@implementation UGButton

/**
 创建按钮
 
 @param style 按钮风格
 UGButtonStyleNone,//无风格
 UGButtonStyleBlue,//蓝色背景
 UGButtonStyleWhite,//白色背景
 UGButtonStyleLightblue//淡蓝色背景
 */
- (instancetype)initWithUGStyle:(UGButtonStyle)style {
    self = [super init];
    if (self) {
        self.buttonStyle = style;
    }
    return self;
}

#pragma mark - Setter Method

- (void)setButtonStyle:(UGButtonStyle)buttonStyle {
    _buttonStyle = buttonStyle;
    [self setupStyleWithStyle:buttonStyle];
}


#pragma mark - 设置风格

- (void)setupStyleWithStyle:(UGButtonStyle)style {
    
    if (style == UGButtonStyleNone) {return; }
    
    self.layer.cornerRadius = 2;
    self.layer.masksToBounds = YES;
    
    if (style == UGButtonStyleBlue || style == UGButtonStyleLightblue) {
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        UIColor *normalColor =  [UIColor colorWithHexString: style == UGButtonStyleBlue ? @"6684c7" : @"ffffff"];
        UIColor *highlightedColor =  [UIColor colorWithHexString: style == UGButtonStyleBlue ? @"6684c7" : @"ffffff"];
        [self setBackgroundImage:[UIImage imageWithColor:normalColor] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:highlightedColor] forState:UIControlStateHighlighted];
        
    } else {
        [self setTitleColor:UG_MainColor forState:UIControlStateNormal];
        [self setTitleColor:[UIColor colorWithHexString:@"7EC9FF"] forState:UIControlStateHighlighted];
        [self setBackgroundColor:[UIColor whiteColor]];
        self.layer.borderColor = UG_MainColor.CGColor;
        self.layer.borderWidth = 1.0f;
        
        @weakify(self);
        [self bk_addEventHandler:^(id sender) {
            @strongify(self);
            self.layer.borderColor = [UIColor colorWithHexString:@"7EC9FF"].CGColor;
        } forControlEvents:UIControlEventTouchDown];
        
        [self bk_addEventHandler:^(id sender) {
            @strongify(self);
            self.layer.borderColor = UG_MainColor.CGColor;
        } forControlEvents:UIControlEventTouchUpInside];
        
    }
    
}





@end
