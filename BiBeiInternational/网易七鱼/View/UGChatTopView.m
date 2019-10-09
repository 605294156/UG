//
//  UGChatTopView.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/26.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGChatTopView.h"

@implementation UGChatTopView

+(instancetype)fromXib {
    return [[NSBundle mainBundle] loadNibNamed:@"UGChatTopView" owner:nil options:nil].firstObject;
}

@end
