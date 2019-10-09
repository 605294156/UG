//
//  OTCComplaintSelectedCountryCell.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/30.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTCComplaintModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OTCComplaintSelectedCountryCell : UITableViewCell
    @property (weak, nonatomic) IBOutlet UITextField *countryFiled;
    @property (weak, nonatomic) IBOutlet UILabel *countryLabel;
    @property(nonatomic ,strong) OTCComplaintModel *model;
    @property (weak, nonatomic) IBOutlet UIButton *countryBtn;
    @property(nonatomic, copy) void(^tapBtnsHandle)(void);
    @end

NS_ASSUME_NONNULL_END
