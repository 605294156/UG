//
//  UGug_contentInsetLabel.m
//  GLDemo
//
//  Created by keniu on 2018/10/29.
//  Copyright © 2018 keniu. All rights reserved.
//

#import "UGContentInsetLabel.h"

@implementation UGContentInsetLabel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.ug_contentInset = UIEdgeInsetsZero;
    }
    return self;
}


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.ug_contentInset = UIEdgeInsetsZero;
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.ug_contentInset = UIEdgeInsetsZero;
}

// 修改绘制文字的区域，ug_contentInset增加bounds
-(CGRect)textRectForBounds:(CGRect)bounds limitedToNumberOfLines:(NSInteger)numberOfLines {
    /*
     调用父类该方法
     注意传入的UIEdgeInsetsInsetRect(bounds, self.ug_contentInset),bounds是真正的绘图区域
     */
    CGRect rect = [super textRectForBounds:UIEdgeInsetsInsetRect(bounds,self.ug_contentInset) limitedToNumberOfLines:numberOfLines];
    //根据edgeInsets，修改绘制文字的bounds
    rect.origin.x -= self.ug_contentInset.left;
    rect.origin.y -= self.ug_contentInset.top;
    rect.size.width += self.ug_contentInset.left + self.ug_contentInset.right;
    rect.size.height += self.ug_contentInset.top + self.ug_contentInset.bottom;
    return rect;
}

-(void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.ug_contentInset)];
}

- (void)setug_contentInset:(UIEdgeInsets)ug_contentInset {
    _ug_contentInset = ug_contentInset;
    [self setNeedsDisplay];
}



@end
