//
//  UGCountryPopView.h
//  BiBeiInternational
//
//  Created by conew on 2019/4/16.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UGCountryPopView : UIView
@property(nonatomic,assign)NSInteger index;
- (instancetype)initWithFrame:( CGRect)viewFrame WithArr:(NSMutableArray *)orderArr WithIndex:(NSInteger)index WithHandle:(void (^)(NSString *title, NSInteger index))clickHandle;
-(void)showDropDownMenuWithBtnFrame:(CGRect)viewRect;
-(void)hideDropDownMenuWithBtnFrame:(CGRect)btnFrame;
@end

NS_ASSUME_NONNULL_END
