//
//  UGWalletBanner.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/15.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGWalletBanner.h"
#import "UGWalletBannerCVCell.h"
#import "UGWalletAllModel.h"
#import "AppDelegate.h"
#define MaxSections 100
#define identifier @"UGWalletBannerCVCell"

@interface UGWalletBanner() <UICollectionViewDataSource,UICollectionViewDelegate>
@property (strong, nonatomic) NSMutableArray *imageViews;
@property (strong, nonatomic) UICollectionView *myCollectionView;
@property (strong, nonatomic) UIPageControl *mypageControl;
@property (assign, nonatomic) CGSize viewSize;
@property (strong, nonatomic) NSTimer *timer;
@property (nonatomic,strong) UIImageView *noDatabackImage;
/** index */
@property (nonatomic ,assign) NSInteger index;
/** index2 */
@property (nonatomic ,assign) NSInteger index2;
@end

@implementation UGWalletBanner
-(id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewSize = viewSize;
        [self addNSTimer];
        self.index = 0;
        self.noDatabackImage.image = [UIImage imageNamed:@"wallet_backimage.png"];
    }
    return self;
}

- (void)setItems:(NSArray *)items{
    _items = items;
   if (UG_CheckArrayIsEmpty(_items) || _items.count<=0)
        return;
    if (_items.count<2) {
        self.myCollectionView.scrollEnabled = NO;
        [self.mypageControl setHidden:YES];
    }else{
        self.myCollectionView.scrollEnabled = YES;
        [self.mypageControl setHidden:NO];
        NO;
    }
    [self.myCollectionView reloadData];
    self.mypageControl.numberOfPages = _items.count;
}

-(UIImageView *)noDatabackImage
{
    if (!_noDatabackImage) {
        _noDatabackImage = [[UIImageView alloc] initWithFrame:CGRectMake(UG_AutoSize(14), (self.viewSize.height-UG_AutoSize(160))/2.0, self.viewSize.width-2*UG_AutoSize(14), UG_AutoSize(160))];
        _noDatabackImage.userInteractionEnabled = YES;
        [self addSubview:_noDatabackImage];
    }
    return _noDatabackImage;
}

- (UICollectionView *)myCollectionView{
    
    if (!_myCollectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.viewSize.width, self.viewSize.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height) collectionViewLayout:flowLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        _myCollectionView.pagingEnabled = YES;
        _myCollectionView.backgroundColor = [UIColor clearColor];
        [_myCollectionView registerClass:[UGWalletBannerCVCell class] forCellWithReuseIdentifier:identifier];
        [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:MaxSections / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        [self addSubview:_myCollectionView];
        _mypageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.viewSize.height-UG_AutoSize(30),self.viewSize.width, UG_AutoSize(20))];
        _mypageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _mypageControl.pageIndicatorTintColor = [UIColor lightGrayColor];
        [self addSubview:_mypageControl];
    }
    return _myCollectionView;
}

#pragma mark -delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return MaxSections;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    [collectionView registerNib: [UINib nibWithNibName:identifier bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:identifier];
    UGWalletBannerCVCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    if (!UG_CheckArrayIsEmpty(self.items) && self.items.count>0) {
        UGWalletAllModel *model = self.items[indexPath.row];
        cell.walletAllNumLabel.text = [model.balance ug_amountFormat];
        cell.walletAllNumLabel.text = [ToolUtil stringChangeMoneyWithStr:cell.walletAllNumLabel.text];
        if ([[UGManager shareInstance].hostInfo.userInfoModel.member.cardVip isEqualToString:@"1"]) {
            //卡商
            [cell.buyButton setTitle:@"充值" forState:UIControlStateNormal];
        }else{
            [cell.buyButton setTitle:@"购买" forState:UIControlStateNormal];
        }
        NSString*cnyRate= ((AppDelegate*)[UIApplication sharedApplication].delegate).CNYRateToUG;
        NSString *cnyStr =  [NSString ug_positiveFormatWithMultiplier:model.balance multiplicand:cnyRate scale:6 roundingMode:NSRoundDown];
        cell.walletAllTypeLabel.text=[NSString stringWithFormat:@"%@ = %@ CNY",model.coinId,[cnyStr ug_amountFormat]];
        cell.buyClick = ^(NSInteger index) {
            if (self.buyClick) {
                self.buyClick(self, index);
            }
        };
        cell.idLongClick = ^(UILongPressGestureRecognizer *longPress) {
            if (self.idLongClick) {
                self.idLongClick(longPress);
            }
        };
        cell.sellClick = ^(NSInteger index) {
            if (self.sellClick) {
                self.sellClick(self, index);
            }
        };
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.cellClick) {
        self.cellClick(self,indexPath.row);
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % _items.count;
    self.mypageControl.currentPage = page;
    self.index2 = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % _items.count;
    if (self.index2  == _items.count) {
        self.index2 = 0;
    }
}

- (void)nextPage{
    if (_items.count<2) {
        return;
    }
    NSIndexPath *currentIndexPath = [[self.myCollectionView indexPathsForVisibleItems] lastObject];
    NSIndexPath *currentIndexPathSet = [NSIndexPath indexPathForItem:currentIndexPath.item inSection:MaxSections / 2];
    [self.myCollectionView scrollToItemAtIndexPath:currentIndexPathSet atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
    NSInteger nextItem = currentIndexPathSet.item + 1;
    NSInteger nextSection = currentIndexPathSet.section;
    if (nextItem == _items.count) {
        nextItem = 0;
        nextSection ++;
    }
    NSIndexPath *nextIndexPath = [NSIndexPath indexPathForItem:nextItem inSection:nextSection];
    [self.myCollectionView scrollToItemAtIndexPath:nextIndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
}

- (NSMutableArray *)imageViews{
    if (!_imageViews) {
        _imageViews = @[].mutableCopy;
    }
    
    return _imageViews;
}

#pragma mark -当用户开始拖拽的时候就调用移除计时器
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self removeNSTimer];
}
#pragma mark -当用户停止拖拽的时候调用添加定时器
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self addNSTimer];
}

#pragma mark -添加定时器
-(void)addNSTimer{
    _timer =[NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop]addTimer:_timer forMode:NSRunLoopCommonModes];
}

#pragma mark -删除定时器
-(void)removeNSTimer{
    [_timer invalidate];
    _timer =nil;
}

- (void)dealloc{
    _imageViews = nil;
    [self removeNSTimer];
}
@end
