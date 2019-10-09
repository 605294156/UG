//
//  UGPayCodeView.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/11.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGPayCodeView.h"


@interface UGPayCodeView ()


@end

@implementation UGPayCodeView

+ (instancetype)fromXib {
    return [[NSBundle mainBundle] loadNibNamed:@"UGPayCodeView" owner:nil options:nil].firstObject;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (IBAction)quesetionClick:(id)sender {
    if (self.quesetionClickBlock) {
        self.quesetionClickBlock();
    }
}

- (IBAction)copyClick:(id)sender {
    if (self.copyClickBlock) {
        self.copyClickBlock();
    }
}
@end
