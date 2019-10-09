//
//  TRRightChooseView.h
//  BiBeiInternational
//
//  Created by keniu on 2018/10/19.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OTCFilterModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MoreChooseItemModel:NSObject

@property(nonatomic ,copy) NSString *itemName;
@property(nonatomic ,assign) BOOL selected;

@end

@interface MoreChooseDataModel:NSObject

@property(nonatomic ,copy) NSString *type;//1 是button 0双输入框
@property(nonatomic ,copy) NSString *name;
@property(nonatomic ,assign) BOOL select;//是否有操作
@property(nonatomic ,copy) NSString *minString;//用户输入最小值
@property(nonatomic ,copy) NSString *maxString;//用户输入最大值
@property(nonatomic ,copy) NSString *minPlaceholder;//右边最小占位符
@property(nonatomic ,copy) NSString *maxPlaceholder;//左边最大占位符
@property(nonatomic ,strong) NSArray<MoreChooseItemModel *> *items;


@end


@interface TRRightChooseView : UIView

@property(nonatomic ,strong) NSArray<MoreChooseDataModel *> *dataArr;

@property(nonatomic, copy) void(^clickSure)(BOOL hasSelected, OTCFilterModel *filterModel);

@end

NS_ASSUME_NONNULL_END
