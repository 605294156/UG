//
//  UGPayWayCell.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGPayWayCell : UITableViewCell

@property (nonatomic, strong) id model;

@property (nonatomic, assign) NSInteger check;

@property (weak, nonatomic) IBOutlet UIButton *btn1;

@property (weak, nonatomic) IBOutlet UIButton *btn2;

@property (nonatomic, strong) NSArray *models;
@end

NS_ASSUME_NONNULL_END
