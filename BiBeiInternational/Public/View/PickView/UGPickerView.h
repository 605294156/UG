//
//  UGPickerView.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "BAKit_PickerView.h"

NS_ASSUME_NONNULL_BEGIN

@interface UGPickerView : BAKit_PickerView

+ (void)ug_showPickViewWithTitles:(NSArray <NSString*>*)title handle:(void(^)(NSString *resultString))handle;

@end

NS_ASSUME_NONNULL_END
