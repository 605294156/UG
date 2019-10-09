//
//  UGHomeMessageSystemDetailVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/23.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"

@interface UGHomeMessageSystemDetailVC : UGBaseViewController
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UITextView *textVew;
@property (weak, nonatomic) IBOutlet UILabel *systemLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,copy)NSString *textStr;

@end
