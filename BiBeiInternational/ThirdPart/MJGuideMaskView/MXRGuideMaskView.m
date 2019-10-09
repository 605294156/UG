//
//  MXRGuideMaskView.m
//  MJGuideMaskView
//
//  Created by MinJing_Lin on 2018/7/30.
//  Copyright © 2018年 MinJing_Lin. All rights reserved.
//

#import "MXRGuideMaskView.h"

NSInteger countNum = 0;

@interface MXRGuideMaskView ()

/// 图层
@property (nonatomic, weak)   CAShapeLayer   *fillLayer;
/// 路径
@property (nonatomic, strong) UIBezierPath   *overlayPath;
/// 透明区数组
@property (nonatomic, strong) NSMutableArray *transparentPaths;
/// 图片数组
@property (nonatomic, strong) NSMutableArray *imageArr;
/// 图片frame数组
@property (nonatomic, strong) NSMutableArray *frameArr;
/// 点击计数
@property (nonatomic, assign) NSInteger index;
/// 图片frame数组
@property (nonatomic, strong) NSMutableArray *orderArr;
/// 是否单张循环，默认YES
@property (nonatomic, assign) BOOL isSingle;
/// 标题数组
@property (nonatomic, strong) NSMutableArray *titleArr;
/// 标题frame数组
@property (nonatomic, strong) NSMutableArray *titleframeArr;
/// 按钮数组
@property (nonatomic, strong) NSMutableArray *nextArr;
/// 按钮frame数组
@property (nonatomic, strong) NSMutableArray *nextframeArr;

/// 跳过指引
@property (nonatomic, strong) NSMutableArray *goOutFrameArr;
/// 下次不再显示
@property (nonatomic, strong) NSMutableArray *notSeeFrameArr;

@property (nonatomic,strong) UIButton *imgBtn;

@end

@implementation MXRGuideMaskView

#pragma mark - 初始化
- (instancetype)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame: [UIScreen mainScreen].bounds];
    if (self) {
        [self setUp];
    }
    return self;
}

- (void)setUp {
    self.index = 0;
    self.isSingle = YES;
    
    self.backgroundColor = [UIColor clearColor];
    
    UIColor *maskColor = [UIColor colorWithWhite:0 alpha:0.7];
    self.fillLayer.path      = self.overlayPath.CGPath;
    self.fillLayer.fillRule  = kCAFillRuleEvenOdd;
    self.fillLayer.fillColor = maskColor.CGColor;
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClickedMaskView)];
//    [self addGestureRecognizer:tapGesture];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
}

#pragma mark - 公有方法

//- (void)addTransparentOvalRect:(CGRect)rect {
//    UIBezierPath *transparentPath = [UIBezierPath bezierPathWithOvalInRect:rect];
//
//    [self addTransparentPath:transparentPath];
//}

- (void)addImages:(NSArray *)images imageFrame:(NSArray *)imageframeArr WithTitle:(NSArray *)titles titleFrame:(NSArray *)titleFrameArr WithNext:(NSArray *)nexts WithNextFrame:(NSArray *)nextFrame TransparentRect:(NSArray *)rectArr goOutRect:(NSArray *)goOutFrameArr notSeeRect:(NSArray *)notSeeFrameArr{
    if (images.count != imageframeArr.count || images.count != rectArr.count || titles.count != titleFrameArr.count || titles.count != rectArr.count || nexts.count != nextFrame.count || nexts.count != rectArr.count) {
        return;
    }
    self.isSingle = YES;
    [images enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage * image = [UIImage imageNamed:obj];
        [self.imageArr addObject:image];
    }];
    [titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.titleArr addObject:obj];
    }];
    
    [nexts enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.nextArr addObject:obj];
    }];
    
    self.frameArr = [imageframeArr mutableCopy];
    self.titleframeArr = [titleFrameArr mutableCopy];
    self.nextframeArr = [nextFrame mutableCopy];
    self.goOutFrameArr = [goOutFrameArr mutableCopy];
    self.notSeeFrameArr = [notSeeFrameArr mutableCopy];
    [self addImage:_imageArr[0] withFrame:[_frameArr[0] CGRectValue] WithTitle:_titleArr[0] WithFrame:[_titleframeArr[0] CGRectValue] WithNext:_nextArr[0] WithNextFrame:[_nextframeArr[0] CGRectValue] goOutFrame:[_goOutFrameArr[0] CGRectValue] notSeeFrame:[_notSeeFrameArr [0] CGRectValue]];
    
    for (NSInteger i=0; i<rectArr.count; i++) {
        UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRoundedRect:[rectArr[i] CGRectValue] cornerRadius:5];
        [self.transparentPaths addObject:transparentPath];
    }
    [self addTransparentPath:_transparentPaths[0]];
    
}

- (void)addImages:(NSArray *)images imageFrame:(NSArray *)imageframeArr WithTitle:(NSArray *)titles titleFrame:(NSArray *)titleFrameArr WithNext:(NSArray *)nexts WithNextFrame:(NSArray *)nextFrame TransparentRect:(NSArray *)rectArr orderArr:(NSArray *)orderArr goOutRect:(NSArray *)goOutFrameArr notSeeRect:(NSArray *)notSeeFrameArr{
    if (images.count != imageframeArr.count || images.count != rectArr.count || titles.count != titleFrameArr.count || titles.count != rectArr.count || nexts.count != nextFrame.count || nexts.count != rectArr.count) {
        return;
    }
    //判断顺序数组总数是否等于图片数组
    NSInteger numCount = 0;
    for (NSNumber * num in orderArr) {
        NSInteger order = [num integerValue];
        numCount += order;
    }
    if (numCount != images.count) {
        return;
    }
    
    self.isSingle = NO;
    self.orderArr = [orderArr mutableCopy];
    [images enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage * image = [UIImage imageNamed:obj];
        [self.imageArr addObject:image];
    }];
    [titles enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.titleArr addObject:obj];
    }];
    [nexts enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.nextArr addObject:obj];
    }];
    
    self.frameArr = [imageframeArr mutableCopy];
    self.titleframeArr = [titleFrameArr mutableCopy];
    self.nextframeArr = [nextFrame mutableCopy];
    self.goOutFrameArr = [goOutFrameArr mutableCopy];
    self.notSeeFrameArr = [notSeeFrameArr mutableCopy];
    for (NSInteger i=0; i<rectArr.count; i++) {
        UIBezierPath *transparentPath = [UIBezierPath bezierPathWithRoundedRect:[rectArr[i] CGRectValue] cornerRadius:5];
        [self.transparentPaths addObject:transparentPath];
    }
    
    // 控制多个显示逻辑
    for (NSInteger i=0; i<[orderArr[0] integerValue]; i++) {
        [self addImage:_imageArr[i] withFrame:[_frameArr[i] CGRectValue] WithTitle:_titleArr[i] WithFrame:[_titleframeArr[i] CGRectValue] WithNext:_nextArr[i] WithNextFrame:[_nextframeArr[i] CGRectValue] goOutFrame:[_goOutFrameArr[i] CGRectValue] notSeeFrame:[_notSeeFrameArr[i] CGRectValue]];
        [self addTransparentPath:_transparentPaths[i]];
    }
    
}

- (void)addImage:(UIImage*)image withFrame:(CGRect)frame WithTitle:(NSString *)title WithFrame:(CGRect)titleFrame WithNext:(NSString *)next WithNextFrame:(CGRect )nextFrame goOutFrame:(CGRect)goOutFrame notSeeFrame:(CGRect)notSeeFrame{
    
    UIImageView * imageView   = [[UIImageView alloc]initWithFrame:frame];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image           = image;
    [self addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] initWithFrame:titleFrame];
    label.text = title;
    label.font = [UIFont systemFontOfSize:17];
    label.numberOfLines = 0;
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    [self addSubview:label];
    
    UIButton *nextlabel = [[UIButton alloc] initWithFrame:nextFrame];
    [nextlabel setTitle:next forState:UIControlStateNormal];
    nextlabel.titleLabel.font = [UIFont systemFontOfSize:17];
    nextlabel.backgroundColor = [UIColor clearColor];
    [nextlabel setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    nextlabel.layer.borderColor = [UIColor whiteColor].CGColor;
    nextlabel.layer.borderWidth = 1.0;
    nextlabel.layer.cornerRadius = 2;
    nextlabel.layer.masksToBounds = YES;
    [nextlabel addTarget:self action:@selector(tapClickedMaskView) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:nextlabel];
    
     //跳过指引
    if (goOutFrame.size.width > 0 && goOutFrame.size.height > 0) {
       
        UIButton *gotoBtn = [[UIButton alloc] initWithFrame:goOutFrame];
        [gotoBtn setTitle:@"跳过指引" forState:UIControlStateNormal];
        gotoBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        gotoBtn.backgroundColor = [UIColor clearColor];
        [gotoBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [gotoBtn addTarget:self action:@selector(goOut) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:gotoBtn];
        UILabel *line1 = [[UILabel alloc] initWithFrame:CGRectMake(goOutFrame.origin.x, CGRectGetMaxY(goOutFrame), goOutFrame.size.width, 0.5f)];
        line1.backgroundColor = [UIColor whiteColor];
        [self addSubview:line1];
    }
    //下次不看
    if (notSeeFrame.size.width > 0 && notSeeFrame.size.height > 0) {
        self.imgBtn = [[UIButton alloc] initWithFrame:CGRectMake(notSeeFrame.origin.x, notSeeFrame.origin.y+(notSeeFrame.size.height-18)/2.0, 18, 18)];
//        self.imgBtn.imageEdgeInsets = UIEdgeInsetsMake(2, 2, 2, 2);
        self.imgBtn.tag = 100011;
        self.imgBtn.selected = NO;
        [self.imgBtn setImage:[UIImage imageNamed:@"pop_unselected"] forState:UIControlStateNormal];
        [self.imgBtn setImage:[UIImage imageNamed:@"pop_selected"] forState:UIControlStateSelected];
        [self.imgBtn addTarget:self action:@selector(noSee:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.imgBtn];
        
        UIButton *noSeeBtn = [[UIButton alloc] initWithFrame:CGRectMake(notSeeFrame.origin.x+18, notSeeFrame.origin.y, notSeeFrame.size.width-18, notSeeFrame.size.height)];
        noSeeBtn.tag = 100012;
        [noSeeBtn setTitle:@"下次不再显示" forState:UIControlStateNormal];
        noSeeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        noSeeBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 3, 0, 0);
        noSeeBtn.titleLabel.font = [UIFont systemFontOfSize:17];
        noSeeBtn.backgroundColor = [UIColor clearColor];
        [noSeeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [noSeeBtn addTarget:self action:@selector(noSee:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:noSeeBtn];
    }
}

-(void)goOut{
    [self dismissMaskView];
    if (self.goOutBlock) {
        self.goOutBlock();
    }
    NSLog(@"~~~~跳过指引");
}

-(void)noSee:(UIButton *)sender{
    NSLog(@"~~~~下次不再显示");
    self.imgBtn.selected = !self.imgBtn.selected;
}

- (void)addTransparentPath:(UIBezierPath *)transparentPath {
    
    [self.overlayPath appendPath:transparentPath];
    self.fillLayer.path = self.overlayPath.CGPath;
}

#pragma mark - 显示/隐藏

- (void)showMaskViewInView:(UIView *)view{
    
    self.alpha = 0;
    if (view != nil) {
        [view addSubview:self];
    }else{
        [[UIApplication sharedApplication].keyWindow addSubview:self];
    }
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)tapClickedMaskView{
    
    //    __weak typeof(self)weakSelf = self;
    
    _index++;
    if (_isSingle) {
        if (_index < _imageArr.count) {
            
            [self refreshMask];
            [self addTransparentPath:_transparentPaths[_index]];
            
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [self addImage:_imageArr[_index] withFrame:[_frameArr[_index] CGRectValue] WithTitle:_titleArr[_index] WithFrame:[_titleframeArr[_index] CGRectValue] WithNext:_nextArr[_index] WithNextFrame:[_nextframeArr[_index] CGRectValue] goOutFrame:[_goOutFrameArr[_index] CGRectValue] notSeeFrame:[_notSeeFrameArr[_index] CGRectValue]];
        }else{
            [self dismissMaskView];
            
        }
    }else{
        if (_index < _orderArr.count) {
            
            [self refreshMask];
            [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            
            // 控制多个显示逻辑
            NSInteger baseNum = [_orderArr[_index-1] integerValue];
            countNum = countNum + baseNum;
            NSInteger endNum = [_orderArr[_index] integerValue]+countNum;
            for (NSInteger i=countNum; i<endNum; i++) {
                
                [self addTransparentPath:_transparentPaths[i]];
                [self addImage:_imageArr[i] withFrame:[_frameArr[i] CGRectValue] WithTitle:_titleArr[i] WithFrame:[_titleframeArr[i] CGRectValue] WithNext:_nextArr[i] WithNextFrame:[_nextframeArr[i] CGRectValue] goOutFrame:[_goOutFrameArr[i] CGRectValue] notSeeFrame:[_notSeeFrameArr[i] CGRectValue]];
            }
        }else{
            countNum = 0;
            if (self.notSeeBlock) {
                self.notSeeBlock(self.imgBtn.selected);
            }
            [self dismissMaskView];
        }
    }
}

- (void)dismissMaskView{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)refreshMask {
    
    UIBezierPath *overlayPath = [self generateOverlayPath];
    self.overlayPath = overlayPath;
    
}

- (UIBezierPath *)generateOverlayPath {
    
    UIBezierPath *overlayPath = [UIBezierPath bezierPathWithRect:self.bounds];
    [overlayPath setUsesEvenOddFillRule:YES];
    
    return overlayPath;
}

#pragma mark - 懒加载Getter Methods

- (UIBezierPath *)overlayPath {
    if (!_overlayPath) {
        _overlayPath = [self generateOverlayPath];
    }
    
    return _overlayPath;
}

- (CAShapeLayer *)fillLayer {
    if (!_fillLayer) {
        CAShapeLayer *fillLayer = [CAShapeLayer layer];
        fillLayer.frame = self.bounds;
        [self.layer addSublayer:fillLayer];
        
        _fillLayer = fillLayer;
    }
    
    return _fillLayer;
}

- (NSMutableArray *)transparentPaths {
    if (!_transparentPaths) {
        _transparentPaths = [NSMutableArray array];
    }
    
    return _transparentPaths;
}

- (NSMutableArray *)imageArr {
    if (!_imageArr) {
        _imageArr = [NSMutableArray array];
    }
    
    return _imageArr;
}

- (NSMutableArray *)frameArr {
    if (!_frameArr) {
        _frameArr = [NSMutableArray array];
    }
    
    return _frameArr;
}

- (NSMutableArray *)orderArr {
    if (!_orderArr) {
        _orderArr = [NSMutableArray array];
    }
    
    return _orderArr;
}

- (NSMutableArray *)titleArr {
    if (!_titleArr) {
        _titleArr = [NSMutableArray array];
    }
    
    return _titleArr;
}

- (NSMutableArray *)titleframeArr {
    if (!_titleframeArr) {
        _titleframeArr = [NSMutableArray array];
    }
    
    return _titleframeArr;
}

- (NSMutableArray *)nextArr {
    if (!_nextArr) {
        _nextArr = [NSMutableArray array];
    }
    
    return _nextArr;
}

- (NSMutableArray *)nextframeArr {
    if (!_nextframeArr) {
        _nextframeArr = [NSMutableArray array];
    }
    
    return _nextframeArr;
}

@end
