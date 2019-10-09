//
//  OTCComplaintPhotoCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/25.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "OTCComplaintPhotoCell.h"
#import "MJPhotoBrowser.h"

@interface OTCComplaintPhotoCell ()
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *photoContainerView;//放添加图片、图片
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxNumLabel;

@end

@implementation OTCComplaintPhotoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.addButton.layer.borderWidth = 1.0f;
//    self.addButton.layer.borderColor = [UIColor colorWithHexString:@"BBBBBB"].CGColor;
    [self.addButton setImage:[UIImage imageNamed:@"OTC_add"] forState:UIControlStateNormal];
    [self.addButton addTarget:self action:@selector(clickAdd:) forControlEvents:UIControlEventTouchUpInside];
    [self.photoContainerView addSubview:self.addButton];
    [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.photoContainerView);
        make.width.equalTo(self.photoContainerView.mas_height);
        make.leading.mas_equalTo( self.photoContainerView);
        make.top.equalTo(self.photoContainerView);
    }];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)setModel:(OTCComplaintModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    self.maxNumLabel.text = model.placeholder;
    if ( ! UG_CheckArrayIsEmpty(model.imagelist) && model.imagelist.count>0) {
        [self setupImageViews];
    }
    @weakify(self);
    [model bk_addObserverForKeyPath:@"imagelist" options:NSKeyValueObservingOptionNew task:^(OTCComplaintModel *obj, NSDictionary *change) {
        @strongify(self);
        [self setupImageViews];
    }];
}

- (void)clickAdd:(UIButton *)sender {
    if (self.tapPhotosHandle) {
        self.tapPhotosHandle(self.addButton);
    }
}

-(void)setupImageViews {
    //先移除
    for (UIView *view in self.photoContainerView.subviews) {
        if ([view isKindOfClass:[UIImageView class]]) {
            [view removeFromSuperview];
        }
    }
    //当有3张图片时 隐藏添加按钮
    if (!UG_CheckArrayIsEmpty(self.model.imagelist) && self.model.imagelist.count>=3) {
            self.addButton.hidden = YES;
    }else{
            self.addButton.hidden = NO;
    }
    UIView *lastView = self.photoContainerView;
    for (int i = 0; i < self.model.imagelist.count; i++) {
        UIImageView *imageView = [self careatImageViewWithImage:self.model.imagelist[i]];
        imageView.tag = 9999 + i;
        [self.photoContainerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.height.equalTo(self.photoContainerView);
            make.width.mas_equalTo(self.photoContainerView.mas_height);
            make.leading.mas_equalTo(i == 0 ? lastView : lastView.mas_trailing).mas_offset(i == 0 ? 0 : 5);
        }];
        lastView = imageView;
    }
    
    BOOL isEmpty = lastView == self.photoContainerView;
    [self.addButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(self.photoContainerView);
        make.width.equalTo(self.photoContainerView.mas_height);
        make.top.equalTo(self.photoContainerView);
        make.leading.mas_equalTo( isEmpty ? lastView : lastView.mas_trailing).mas_offset(isEmpty ? 0 : 5);
    }];
        [self.photoContainerView layoutIfNeeded];
}


- (UIImageView *)careatImageViewWithImage:(UIImage *)image {
    UIImageView *imageView = [UIImageView new];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.image = image;
    imageView.userInteractionEnabled = YES;
    @weakify(self);
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        if (state == UIGestureRecognizerStateBegan) {
            [UIAlertController ug_showAlertWithStyle:UIAlertControllerStyleAlert title:nil message:@"您确定要移除该相片吗？" cancle:@"取消" others:@[@"确定"] handle:^(NSInteger buttonIndex, UIAlertAction *action) {
                if (buttonIndex ==1 ){
                    @strongify(self);
                    NSInteger index = sender.view.tag - 9999;
                    NSMutableArray *tempArray = [[NSMutableArray alloc] initWithArray:self.model.imagelist];
                    [tempArray removeObjectAtIndex:index];
                    self.model.imagelist = tempArray.copy;
                }
            }];
        }
    }];
    [imageView addGestureRecognizer:longPressGestureRecognizer];
    
    UITapGestureRecognizer *tapPressGestureRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        if (state == UIGestureRecognizerStateEnded) {
            NSInteger index = sender.view.tag - 9999;
            [MJPhotoBrowser showlocalImages:self.model.imagelist currentImage:index < self.model.imagelist.count ? self.model.imagelist[index] : 0];
        }
    }];
    [imageView addGestureRecognizer:tapPressGestureRecognizer];
    return imageView;
}

- (void)dealloc {
    [self.model bk_removeAllBlockObservers];
    NSLog(@"OTCComplaintPhotoCell释放了");
}

@end
