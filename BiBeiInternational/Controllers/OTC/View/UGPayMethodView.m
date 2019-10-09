//
//  UGPayMethodView.m
//  BiBeiInternational
//
//  Created by keniu on 2018/11/3.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGPayMethodView.h"

@interface UGPayMethodView ()

@property (nonatomic, strong) NSMutableArray *payList;


@end

@implementation UGPayMethodView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.layer.masksToBounds = YES;
        self.payList = [NSMutableArray new];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.layer.masksToBounds = YES;
        self.payList = [NSMutableArray new];
    }
    return self;
}

- (void)setPayDetail:(UGOTCPayDetailModel *)payDetail {
    _payDetail = payDetail;
    [self.payList removeAllObjects];
    if (payDetail != nil) {
        if (payDetail.bankInfo != nil && payDetail.bankInfo.cardNo.length>0) {
            [self.payList addObject:@"银行卡"];
        }
        if (payDetail.alipay != nil && payDetail.alipay.aliNo.length>0) {
            [self.payList addObject:@"支付宝"];
        }
        if (payDetail.wechatPay != nil && payDetail.wechatPay.wechat.length>0) {
            [self.payList addObject:@"微信"];
        }
        if (payDetail.unionPay != nil && payDetail.unionPay.unionNo.length>0) {
            [self.payList addObject:@"云闪付"];
        }
    }
    [self setupViews];
}

- (void)setPayInfoModel:(UGPayInfoModel *)payInfoModel {
    _payInfoModel = payInfoModel;
    [self.payList removeAllObjects];
    if (payInfoModel != nil) {
        if (payInfoModel.bankInfo != nil && payInfoModel.bankInfo.cardNo.length>0) {
            [self.payList addObject:@"银行卡"];
        }
        if (payInfoModel.alipay != nil && payInfoModel.alipay.aliNo.length>0) {
            [self.payList addObject:@"支付宝"];
        }
        if (payInfoModel.wechatPay != nil && payInfoModel.wechatPay.wechat.length>0) {
            [self.payList addObject:@"微信"];
        }
        if (payInfoModel.unionPay != nil && payInfoModel.unionPay.unionNo.length>0) {
            [self.payList addObject:@"云闪付"];
        }
    }
    [self setupViews];
}

- (void)setPayWays:(NSArray<NSString *> *)payWays {
    _payWays = payWays;
    [self.payList removeAllObjects];
    BOOL match1 = NO,match2 = NO,match3 = NO,match4 = NO;
    if ( ! UG_CheckArrayIsEmpty(payWays) && payWays.count >0) {
        for (NSString *obj in payWays) {
            if ([obj containsString:@"银行卡"]) {
                match1 = YES;
            }else if ([obj containsString:@"支付宝"]) {
                match2 = YES;
            }else if ( [obj containsString:@"微信"]) {
                match3 = YES;
            }else if ( [obj containsString:@"云闪付"]) {
                match4 = YES;
            }
        }
    }
    if (match1) {
        [self.payList addObject:@"银行卡"];
    }
    if (match2) {
        [self.payList addObject:@"支付宝"];
    }
    if (match3) {
        [self.payList addObject:@"微信"];
    }
    if (match4) {
        [self.payList addObject:@"云闪付"];
    }
    [self setupViews];
}

- (void)setupViews {
    self.viewWidth = 0.0f;
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];    
    UIView *lastView = self;
    for (int i = 0; i < self.payList.count; i ++) {
        NSString *text = self.payList[i];
        UIImageView *imageView = [self creatImageViewWithText:text];
        [self addSubview:imageView];
        BOOL firstView = lastView == self;
        CGFloat offest = firstView ? 0.f : 6.f;
        CGFloat width = 14.0f;
        self.viewWidth += offest + width;
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self);
            make.leading.equalTo(firstView ? lastView : lastView.mas_trailing).mas_offset(offest);
            make.width.mas_equalTo(width);
            make.height.mas_equalTo(imageView.mas_width);
        }];
        lastView = imageView;
    }
}

- (UIImageView *)creatImageViewWithText:(NSString *)text {
    UIImageView *imageView = [UIImageView new];
    imageView.backgroundColor = [UIColor whiteColor];
    NSString *imageName =[text containsString:@"微"] ? @"pay_wechat" : ([text containsString:@"支"] ? @"pay_ali" : ([text containsString:@"云"] ? @"pay_union" : @"pay_bank"));
    imageView.image = [UIImage imageNamed:imageName];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.clipsToBounds = YES;
    return imageView;
}

@end
