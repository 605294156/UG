//
//  UGAdancedCertificationOneCell.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGAdancedCertificationOneCell.h"

@interface UGAdancedCertificationOneCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView1;
@property (weak, nonatomic) IBOutlet UIImageView *imageView2;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleHeightConstraint;//22

/**
 查看大图按钮 根据情况隐藏
 */
@property (weak, nonatomic) IBOutlet UIButton *chekOneBtn;

/**
 查看大图按钮 根据情况隐藏
 */
@property (weak, nonatomic) IBOutlet UIButton *chekTwoBtn;

@end

@implementation UGAdancedCertificationOneCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    self.titleLabel.text =  [UGManager shareInstance].hostInfo.userInfoModel.hasHighValidation ? @"身份证照片":@"上传身份证照片";
    
    @weakify(self);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        //非认证失败、才能进行放大
        BOOL authenticationFailed = [[UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus isEqualToString:@"1"];
        if (authenticationFailed) {
            if (self.tapPhotosHandle) {
                self.tapPhotosHandle(self.imageView1);
            }
        } else {
            BOOL showPhoto = self.model.submitImageUrlStr.length > 0;
            if (showPhoto) {
                if (self.showPhotosHandle) {
                    self.showPhotosHandle(self.imageView1.image,NO);
                }
            } else {
                if (self.tapPhotosHandle) {
                    self.tapPhotosHandle(self.imageView1);
                }
            }
        }
    }];
    [self.imageView1 addGestureRecognizer:tapGestureRecognizer];
    
    UITapGestureRecognizer *tapGestureRecognizer2 = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        //非认证失败、才能进行放大
        BOOL authenticationFailed = [[UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus isEqualToString:@"1"];
        if (authenticationFailed) {
            if (self.tapPhotosTwoHandle) {
                self.tapPhotosTwoHandle(self.imageView2);
            }
        } else {
            BOOL showPhoto = self.model2.submitImageUrlStr.length > 0;
            if (showPhoto) {
                if (self.showPhotosTwoHandle) {
                    self.showPhotosTwoHandle(self.imageView2.image,NO);
                }
            } else {
                if (self.tapPhotosTwoHandle) {
                    self.tapPhotosTwoHandle(self.imageView2);
                }
            }
        }
    }];
    [self.imageView2 addGestureRecognizer:tapGestureRecognizer2];
}

- (IBAction)clickBtn:(id)sender {
//    BOOL authenticationFailed = [[UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus isEqualToString:@"1"];
//    if (authenticationFailed) {
        if (self.tapPhotosHandle) {
            self.tapPhotosHandle(self.imageView1);
        }
//    }else{
//        if (self.showPhotosHandle) {
//            self.showPhotosHandle(self.imageView1.image,YES);
//        }
//    }
}

- (IBAction)clickTwoBtn:(id)sender {
//    BOOL authenticationFailed = [[UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus isEqualToString:@"1"];
//    if (authenticationFailed) {
        if (self.tapPhotosTwoHandle) {
            self.tapPhotosTwoHandle(self.imageView2);
        }
//    }else{
//        if (self.showPhotosTwoHandle) {
//            self.showPhotosTwoHandle(self.imageView2.image,YES);
//        }
//    }
}

-(BOOL)useCustomStyle{
    return NO;
}

- (void)setModel:(UGAdancedCertificationModel *)model {
    _model = model;
    
    if (model.submitImageUrlStr.length > 0 ) {
        [self.imageView1 sd_setImageWithURL:[NSURL URLWithString:model.submitImageUrlStr]];
        self.chekOneBtn.hidden = NO;
    } else {
        self.imageView1.image = [UIImage imageNamed:model.defaultImageName];
        self.chekOneBtn.hidden = YES;
    }
    
    [model bk_addObserverForKeyPath:@"value" options:NSKeyValueObservingOptionNew task:^(UGAdancedCertificationModel *obj, NSDictionary *change) {
        self.imageView1.image = [UIImage imageWithData:obj.value];
        self.chekOneBtn.hidden = NO;
    }];
}

-(void)setModel2:(UGAdancedCertificationModel *)model2{
    _model2 = model2;
    if (model2.submitImageUrlStr.length > 0 ) {
        [self.imageView2 sd_setImageWithURL:[NSURL URLWithString:model2.submitImageUrlStr]];
        self.chekTwoBtn.hidden = NO;
    } else {
        self.imageView2.image = [UIImage imageNamed:model2.defaultImageName];
        self.chekTwoBtn.hidden = YES;
    }
    
    [model2 bk_addObserverForKeyPath:@"value" options:NSKeyValueObservingOptionNew task:^(UGAdancedCertificationModel *obj, NSDictionary *change) {
        self.imageView2.image = [UIImage imageWithData:obj.value];
        self.chekTwoBtn.hidden = NO;
    }];
}

- (void)dealloc {
    [self.model bk_removeAllBlockObservers];
    [self.model2 bk_removeAllBlockObservers];
}

@end
