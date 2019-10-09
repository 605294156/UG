//
//  UGAdancedCertificationCell.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/23.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAdancedCertificationCell.h"

@interface UGAdancedCertificationCell ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *photoImageView;

@end

@implementation UGAdancedCertificationCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.photoImageView.userInteractionEnabled = YES;
    @weakify(self);
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] bk_initWithHandler:^(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) {
        @strongify(self);
        //非认证失败、才能进行放大
        BOOL authenticationFailed = [[UGManager shareInstance].hostInfo.userInfoModel.application.auditStatus isEqualToString:@"1"];
        if (authenticationFailed) {
            if (self.tapPhotosHandle) {
                self.tapPhotosHandle(self.photoImageView);
            }
        } else {
            BOOL showPhoto = self.model.submitImageUrlStr.length > 0;
            if (showPhoto) {
                if (self.showPhotosHandle) {
                    self.showPhotosHandle(self.photoImageView.image,NO);
                }
            } else {
                if (self.tapPhotosHandle) {
                    self.tapPhotosHandle(self.photoImageView);
                }
            }
        }
    }];
    [self.photoImageView addGestureRecognizer:tapGestureRecognizer];
    
}
- (IBAction)clickBtn:(id)sender {
    if (self.showPhotosHandle) {
        self.showPhotosHandle(self.photoImageView.image,YES);
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (BOOL)useCustomStyle {
    return NO;
}

- (void)setFrame:(CGRect)frame {
    BOOL small = frame.size.width < 375;
    self.leftConstraint.constant = small ? 14.0f : 27.0f;
    self.rightConstraint.constant = small ? 8.0f : 31.0f;
    [super setFrame:frame];
}

- (void)setModel:(UGAdancedCertificationModel *)model {
    _model = model;
    self.titleLabel.text = model.title;
    if (model.submitImageUrlStr.length > 0 ) {
        [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:model.submitImageUrlStr]];
        self.chekBtn.hidden = YES;
    } else {
        self.photoImageView.image = [UIImage imageNamed:model.defaultImageName];
        self.chekBtn.hidden = YES;
    }
    
    [model bk_addObserverForKeyPath:@"value" options:NSKeyValueObservingOptionNew task:^(UGAdancedCertificationModel *obj, NSDictionary *change) {
        self.photoImageView.image = [UIImage imageWithData:obj.value];
        self.chekBtn.hidden = NO;
    }];
}

- (void)dealloc {
    [self.model bk_removeAllBlockObservers];
}

@end
