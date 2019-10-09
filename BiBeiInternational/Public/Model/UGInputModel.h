//
//  UGInputModel.h
//  BiBeiInternational
//
//  Created by conew on 2018/9/26.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

@interface UGInputModel : UGBaseModel
@property(nonatomic,copy)NSString *placehold;
@property(nonatomic,copy)NSString *icon;
@property(nonatomic,copy)NSString *inputValue;
@property(nonatomic,assign) UIKeyboardType keyboardType;
@property(nonatomic,assign) BOOL secureTextEntry;


@end
