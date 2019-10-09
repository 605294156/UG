//
//  bannerCellModel.h
//  BiBeiInternational
//
//  Created by keniu on 2019/5/15.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface bannerCellModel : BaseModel

@property(nonatomic,copy)NSString *imageUrl;
@property(nonatomic,assign)NSInteger sort;
@property(nonatomic,copy)NSString *title;
@property(nonatomic,assign)NSInteger type;
@property(nonatomic,copy)NSString *url;

@end

NS_ASSUME_NONNULL_END
