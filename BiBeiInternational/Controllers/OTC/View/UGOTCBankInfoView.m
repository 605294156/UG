//
//  UGOTCBankInfoView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/8.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGOTCBankInfoView.h"

@interface UGOTCBankInfoView ()


@end

@implementation UGOTCBankInfoView

+ (instancetype)fromXib {
    return [[NSBundle mainBundle] loadNibNamed:@"UGOTCBankInfoView" owner:nil options:nil].firstObject;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (IBAction)copClick:(id)sender {
    if(self.copClickBlock){
        self.copClickBlock();
    }
}


@end
