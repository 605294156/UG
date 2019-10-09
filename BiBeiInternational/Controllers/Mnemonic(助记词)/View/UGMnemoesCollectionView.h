//
//  UGMnemoesCollectionView.h
//  ug-wallet
//
//  Created by conew on 2018/9/21.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGBaseCollectionView.h"

NS_ASSUME_NONNULL_BEGIN

@class UGMnemoesCollectionView;

@protocol  UGMnemoesCollectionViewDelegate<NSObject>

@optional
/**
 *  点击选中
 */
- (void)cellDidSelected:(UGMnemoesCollectionView *)collectionView SelectedObj:(NSString *)selectedObj;

@end

@interface UGMnemoesCollectionView : UGBaseCollectionView
/**
 *  @frame: collectionView的frame
 *
 *  @title: 字符(NSArray<NSString *> *)
 *
 */
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray *)title;
/**
 *  @titleArray 字符(NSArray<NSString *> *)
 */
-(void)changeTitle:(NSArray *)titleArray;
/**
 *
 */
@property(nonatomic,weak)id<UGMnemoesCollectionViewDelegate>ugDelegate;
/**
 *  @isShowdom 边框是否带阴影/圆角
 */
@property(nonatomic,assign)BOOL isShowdom;

/**
 *  @isShowdom 可传入选中的数组 显示选中背景色
 */
@property(nonatomic,strong)NSArray *selectedArray;

@end

NS_ASSUME_NONNULL_END
