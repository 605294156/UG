//
//  UGPlayerCellBanner.m
//  BiBeiInternational
//
//  Created by keniu on 2019/5/14.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGPlayerCellBanner.h"
#import "AppDelegate.h"
#define MaxSections 100
#define identifier @"UGBannerImagesCell"
#define identifier2 @"bannerDesktopShortcutCell"
#import "UGBannerImagesCell.h"
#import "bannerDesktopShortcutCell.h"

@interface UGPlayerCellBanner()<UICollectionViewDataSource,UICollectionViewDelegate>

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

@property(nonatomic,assign)BOOL isShowDesktopShortcutButton;

@end

@implementation UGPlayerCellBanner

-(id)initWithFrame:(CGRect)frame viewSize:(CGSize)viewSize{
    self = [super initWithFrame:frame];
    if (self) {
        self.viewSize = viewSize;
        [self addNSTimer];
        self.index = 0;
        self.backgroundColor = [UIColor clearColor];
//        self.noDatabackImage.image = [UIImage imageNamed:@"wallet_backimage.png"];
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
        _isShowDesktopShortcutButton = NO;
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.itemSize = CGSizeMake(self.viewSize.width, self.viewSize.height);
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.minimumLineSpacing = 0;
        _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.viewSize.width, self.viewSize.height) collectionViewLayout:flowLayout];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
        _myCollectionView.backgroundColor = [UIColor colorWithHexString:@"F8F9FC"];
        _myCollectionView.showsHorizontalScrollIndicator = NO;
        _myCollectionView.pagingEnabled = YES;
//        _myCollectionView.backgroundColor = [UIColor clearColor];
        [_myCollectionView registerNib:[UINib nibWithNibName:identifier bundle:nil] forCellWithReuseIdentifier:identifier];
         [_myCollectionView registerNib:[UINib nibWithNibName:identifier2 bundle:nil] forCellWithReuseIdentifier:identifier2];
        [_myCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:MaxSections / 2] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        [self addSubview:_myCollectionView];
        //适配4英寸屏幕
        if(UG_SCREEN_WIDTH == 320)
        {
         _mypageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.viewSize.height-UG_AutoSize(32),self.viewSize.width, UG_AutoSize(20))];
        }
        else
        {
         _mypageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.viewSize.height-UG_AutoSize(25),self.viewSize.width, UG_AutoSize(20))];
        }
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
    bannerCellModel *model = self.items[indexPath.row];
    UGBannerImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString *imageUrl = model.imageUrl;
    [cell.cellContentImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"BannerPlaceHolderPic"]];
    return cell;
//    if (model.type == 3) {
//        bannerDesktopShortcutCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier2 forIndexPath:indexPath];
//        if (_isShowDesktopShortcutButton)
//        {
//            [cell.cellContentImageView setImage:[UIImage imageNamed:@"bannerDesktopShortcut"]];
//            cell.buttonAndLabelView.hidden = NO;
//            cell.saveToDesktopButton.tag = indexPath.row +100;
//            [cell.saveToDesktopButton addTarget:self action:@selector(saveToDesktopButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//        }
//        else
//        {
//            [cell.cellContentImageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:[UIImage imageNamed:@"BannerPlaceHolderPic"]];
//            cell.buttonAndLabelView.hidden = YES;
//        }
//        return cell;
//    }
//    else
//    {
//        UGBannerImagesCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//        NSString *imageUrl = model.imageUrl;
//        [cell.cellContentImageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"BannerPlaceHolderPic"]];
//        return cell;
//    }

}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
     bannerCellModel *model = self.items[indexPath.row];
//    if (model.type == 3)
//    {
//        _isShowDesktopShortcutButton = !_isShowDesktopShortcutButton;
//        self.mypageControl.hidden = _isShowDesktopShortcutButton;
//        [_myCollectionView reloadData];
//    }
//    else
//    {
//        if (self.cellClick)
//        {
//            self.cellClick(self,model);
//        }
//    }
    if (self.cellClick)
    {
        self.cellClick(self,model);
    }
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    int page = (int)(scrollView.contentOffset.x / scrollView.frame.size.width + 0.5) % _items.count;
    self.mypageControl.currentPage = page;
//    bannerCellModel *model = self.items[page];
//    if (model.type == 3 && _isShowDesktopShortcutButton) {
//        self.mypageControl.hidden = YES;
//    }
//    else
//    {
//        self.mypageControl.hidden = NO;
//    }
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

#pragma mark -
-(void)saveToDesktopButtonAction:(UIButton *)saveButton;
{
   NSInteger index = saveButton.tag -100;
   bannerCellModel *model = self.items[index];
    if (self.cellClick)
    {
        self.cellClick(self,model);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
