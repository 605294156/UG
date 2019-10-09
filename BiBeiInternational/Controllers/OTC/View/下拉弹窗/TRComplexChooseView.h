//
//  PriceChooseView.h
//  PopView
//
//  Created by 李林 on 2018/3/9.
//  Copyright © 2018年 李林. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TRComplexChooseView : UIView

- (instancetype)initWithFrame:(CGRect)frame titles:(NSArray <NSString *>*)titles selectedIndex:(NSInteger)selectedIndex;

/**
 选择回调
 */
@property (nonatomic, copy) void(^clickHanlder) (NSString *title, NSInteger index);

@end
