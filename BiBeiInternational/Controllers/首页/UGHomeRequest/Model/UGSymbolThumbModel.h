//
//  UGSymbolThumbModel.h
//  BiBeiInternational
//
//  Created by conew on 2019/2/25.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGSymbolThumbModel : UGBaseModel
@property(nonatomic,copy)NSString *symbol;/*币对展示*/
@property(nonatomic,copy)NSString *open;/**/
@property(nonatomic,copy)NSString *high;/**/
@property(nonatomic,copy)NSString *low;/**/
@property(nonatomic,copy)NSString *close;/*]*/
@property(nonatomic,copy)NSString *chg;
@property(nonatomic,copy)NSString *change;/**/
@property(nonatomic,copy)NSString *volume;
@property(nonatomic,copy)NSString *turnover;/**/
@property(nonatomic,copy)NSString *lastDayClose;/**/
@property(nonatomic,copy)NSString *usdRate;
@property(nonatomic,copy)NSString *baseUsdRate;/**/
@property(nonatomic,copy)NSString *closeStr;


@end

NS_ASSUME_NONNULL_END
