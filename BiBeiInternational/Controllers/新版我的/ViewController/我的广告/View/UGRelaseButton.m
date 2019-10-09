//
//  UGRelaseButton.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGRelaseButton.h"

@implementation UGRelaseButton

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"mine_releaseNol"];
        self.imageView.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.isKeepBounds = YES;
    }
    return self;
}


- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.imageView.image = [UIImage imageNamed:@"mine_releaseNol"];
//        self.imageView.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        self.isKeepBounds = YES;
    }
    return self;
}

@end
