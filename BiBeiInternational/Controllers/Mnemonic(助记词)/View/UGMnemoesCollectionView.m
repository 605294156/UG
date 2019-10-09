//
//  UGMnemoesCollectionView.m
//  ug-wallet
//
//  Created by conew on 2018/9/21.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGMnemoesCollectionView.h"

@interface UGMnemoesCollectionView()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) NSArray *titleArr;
@property (nonatomic, strong) UICollectionViewFlowLayout *Layout;
@property (nonatomic,copy)NSString *reuseIdentifier;
@end

@implementation UGMnemoesCollectionView
- (instancetype)initWithFrame:(CGRect)frame withTitle:(NSArray *)title{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake((frame.size.width - 48) / 4, (frame.size.height - 32) / 3);
    layout.minimumLineSpacing = 8.0; // 竖
    layout.minimumInteritemSpacing = 8.0; // 横
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    if (self = [super initWithFrame:frame collectionViewLayout:layout]) {
        _titleArr = title;
        _Layout = (UICollectionViewFlowLayout *)layout;
        _reuseIdentifier = @"UGMnemoesCollectionViewCell";
        self.pagingEnabled = NO;
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.backgroundColor = UG_WhiteColor;
        self.layer.shadowColor = [UIColor colorWithHexString:@"D8D8D8"].CGColor;
        self.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        self.layer.shadowOpacity = 0.2;
        self.layer.shadowRadius = 3;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = NO;
        self.delegate = self;
        self.dataSource = self;
        [self registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:_reuseIdentifier];
    }
    return self;
}

#pragma mark - UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return  !UG_CheckArrayIsEmpty(self.titleArr) ? self.titleArr.count : 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:_reuseIdentifier forIndexPath:indexPath];
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    if (UG_CheckArrayIsEmpty(self.titleArr))
        return nil;
    NSString *titleStr =_titleArr[indexPath.row];
    UILabel *label = [[UILabel alloc] init];
    label.font = UG_AutoFont(12);
    label.text = titleStr;
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [self isSelectedObj:titleStr] ? UG_WhiteColor : UG_BlackColor;
    label.backgroundColor = [self isSelectedObj:titleStr] ? UG_MainColor : [UIColor clearColor];
    CGRect labelFrame = cell.bounds;
    labelFrame.size = _Layout.itemSize;
    label.frame = labelFrame;
    label.layer.cornerRadius = 8;
    label.layer.masksToBounds = YES;
    [cell.contentView addSubview:label];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (UG_CheckArrayIsEmpty(self.titleArr))
        return;
    if (self.ugDelegate && [self.ugDelegate respondsToSelector:@selector(cellDidSelected:SelectedObj:)] ) {
        [self.ugDelegate cellDidSelected:self SelectedObj:self.titleArr[indexPath.row]];
    }
}

-(BOOL)isSelectedObj:(NSString *)selectedObj{
    BOOL isObj = false;
    if (!UG_CheckArrayIsEmpty(self.selectedArray)) {
        NSInteger index =[self.selectedArray  indexOfObject:selectedObj];
        if (index != NSNotFound) {
            isObj = YES;
        }else{
            isObj = NO;
        }
    }
    return isObj;
}

-(void)changeTitle:(NSArray *)titleArray{
    _titleArr = titleArray;
    [self reloadData];
}

#pragma mark -setter
-(void)setIsShowdom:(BOOL)isShowdom{
    _isShowdom = isShowdom;
    if (!_isShowdom) {
        self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
        self.layer.shadowOpacity = 0;
        self.layer.shadowRadius = 0;
        self.layer.cornerRadius = 0;
        self.layer.masksToBounds = YES;
    }
}

-(void)setSelectedArray:(NSArray *)selectedArray{
    _selectedArray = selectedArray;
    [self reloadData];
}

@end
