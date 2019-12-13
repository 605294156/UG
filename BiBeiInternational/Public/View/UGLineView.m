//
//  UGLineView.m
//  BiBeiInternational
//
//  Created by 行者僧 on 2019/12/13.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGLineView.h"

@implementation UGLineView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];

        self.lineColor = [UIColor colorWithHexString:@"efefef"];
        self.lineWidth = 0.5;
    }

    return self;
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextBeginPath(context);

    //画一条线
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, self.frame.size.width, 0);
    CGContextSetLineWidth(context, self.lineWidth);
    CGContextSetStrokeColorWithColor(context, self.lineColor.CGColor);
    CGContextStrokePath(context);
}

@end
