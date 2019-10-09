//
//  UGPickerView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPickerView.h"

@implementation UGPickerView

+ (void)ug_showPickViewWithTitles:(NSArray <NSString*>*)title handle:(void(^)(NSString *resultString))handle {
    [BAKit_PickerView ba_creatCustomPickerViewWithDataArray:title configuration:^(BAKit_PickerView *tempView) {
        // 是否显示 pickview title
        tempView.isShowTitle = NO;
        // 自定义 pickview title 的字体颜色
        tempView.ba_pickViewTitleColor = [UIColor blackColor];
        // 自定义 pickview title 的字体
        tempView.ba_pickViewTitleFont = [UIFont boldSystemFontOfSize:15];
        // 可以自由定制 toolBar 和 pickView 的背景颜色
        tempView.ba_buttonTitleColor_cancle = [UIColor whiteColor];
        tempView.ba_buttonTitleColor_sure = [UIColor whiteColor];
        tempView.ba_backgroundColor_toolBar = UG_MainColor;
        tempView.ba_backgroundColor_pickView = [UIColor whiteColor];
        tempView.animationType = BAKit_PickerViewAnimationTypeBottom;
        tempView.pickerViewPositionType = BAKit_PickerViewPositionTypeNormal;
    } block:^(NSString *resultString, NSInteger index) {
        if (handle) {
            handle(resultString);
        }
    }];
}


@end
