//
//  UGAdancedCertificationTwoCell.m
//  BiBeiInternational
//
//  Created by conew on 2019/4/2.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGAdancedCertificationTwoCell.h"

@interface UGAdancedCertificationTwoCell ()

/**
 查看大图按钮 根据情况隐藏
 */
@property (weak, nonatomic) IBOutlet UIButton *chekBtn;

@property (weak, nonatomic) IBOutlet UIImageView *ImgView;

@end

@implementation UGAdancedCertificationTwoCell

-(void)awakeFromNib{
    [super awakeFromNib];
    
    @weakify(self);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        //非认证失败、才能进行放大
        BOOL authenticationFailed = [[UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus isEqualToString:@"1"];
        if (authenticationFailed) {
            if (self.tapPhotosHandle) {
                self.tapPhotosHandle(self.ImgView);
            }
        } else {
            BOOL showPhoto = self.model3.submitImageUrlStr.length > 0;
            if (showPhoto) {
                if (self.showPhotosHandle) {
                    self.showPhotosHandle(self.ImgView.image,NO);
                }
            } else {
                if (self.tapPhotosHandle) {
                    self.tapPhotosHandle(self.ImgView);
                }
            }
        }
    }];
    [self.ImgView addGestureRecognizer:tapGestureRecognizer];
}

-(BOOL)useCustomStyle{
    return NO;
}

- (IBAction)clickTwoBtn:(id)sender {
//    BOOL authenticationFailed = [[UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus isEqualToString:@"1"];
//    if (authenticationFailed) {
        if (self.tapPhotosHandle) {
            self.tapPhotosHandle(self.ImgView);
        }
//    }else{
//        if (self.showPhotosHandle) {
//            self.showPhotosHandle(self.ImgView.image,YES);
//        }
//    }
}

-(void)setModel3:(UGAdancedCertificationModel *)model3{
    _model3 = model3;
    if (model3.submitImageUrlStr.length > 0) {
        self.chekBtn.hidden = NO;
        [self.ImgView sd_setImageWithURL:[NSURL URLWithString:model3.submitImageUrlStr]];
    } else {
        self.ImgView.image = [UIImage imageNamed:model3.defaultImageName];
        self.chekBtn.hidden = YES;
    }
    
    [model3 bk_addObserverForKeyPath:@"value" options:NSKeyValueObservingOptionNew task:^(UGAdancedCertificationModel *obj, NSDictionary *change) {
        self.ImgView.image = [UIImage imageWithData:obj.value];
        self.chekBtn.hidden = NO;
    }];
}

- (void)dealloc {
    [self.model3 bk_removeAllBlockObservers];
}
@end
