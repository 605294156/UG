//
// "PictureCroppingVC.h"
//  OriginalTools
//
//  Created by keniu on 2019/8/12.
//  Copyright © 2019 NickSun. All rights reserved.
//


#import "PictureCroppingVC.h"
#import "TKImageView.h"

@interface PictureCroppingVC ()<TKImageViewDelegate>

@property (nonatomic,strong) TKImageView  *tkImageView;
@property(nonatomic,strong)UIImage *resultImage;
@end

@implementation PictureCroppingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBarHidden = YES;
    
    [self setUpTKImageView];
    
//    [self addBottom];
}

- (void)setUpTKImageView {
    self.tkImageView = [[TKImageView alloc] initWithFrame:self.view.bounds];
    _tkImageView.toCropImage = _image;          //设置底图（必须属性!）
    _tkImageView.needScaleCrop = YES;           //允许手指捏和缩放裁剪框
    _tkImageView.showInsideCropButton = YES;    //允许内部裁剪按钮
    _tkImageView.btnCropWH = 35;                //内部裁剪按钮宽高，有默认值，不设也没事
    _tkImageView.delegate = self;               //需要实现内部裁剪代理事件
    _tkImageView.cropAreaCornerLineColor = UG_MainColor;
    [self.view addSubview:_tkImageView];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    
    self.navigationController.navigationBarHidden = NO;
}


-(void) clickCancelBtn{
   [self.navigationController popViewControllerAnimated: YES];
}


#pragma mark - 裁剪代理事件
-(void)TKImageViewFinish:(UIImage *)cropImage{

    self.resultImage = cropImage;
    if (self.croppingBlock)
    {
        self.croppingBlock(self.resultImage);
    }
    [self.navigationController popViewControllerAnimated: YES];
    
}

-(void)TKImageViewCancel{
    [self clickCancelBtn];
}

@end
