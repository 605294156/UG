//
//  UGPopIntegrationView.m
//  BiBeiInternational
//
//  Created by conew on 2019/3/26.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGPopIntegrationView.h"
#import "PopView.h"
#import "UGGetIntegrationRuleApi.h"

@interface UGPopIntegrationView ()
@property(nonatomic,strong)UIImageView *backImage;
@property(nonatomic,strong)UIButton *closeBtn;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UITextView *textView;

@property (copy, nonatomic) void(^clickHandle)(void);
- (instancetype)initWithIntegrationRuleClickHandle:(void(^)(void))clickHandle;
@end

@implementation UGPopIntegrationView

+ (void)showIntegrationRuleClickHandle:(void(^)(void))clickHandle{
    UGPopIntegrationView *centerView =[[UGPopIntegrationView alloc] initWithIntegrationRuleClickHandle:^{
        if (clickHandle) {
            clickHandle();
        }
    }];
    PopView *popView =[PopView popSideContentView:centerView direct:PopViewDirection_SlideInCenter];
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.clickOutHidden = NO;
    popView.didRemovedFromeSuperView = ^{
        [centerView removeFromSuperview];
    };
}

- (instancetype)initWithIntegrationRuleClickHandle:(void(^)(void))clickHandle{
    self = [super init];
    if (self) {
        CGRect frame = CGRectMake((kWindowW-UG_AutoSize(300))/2.0, (kWindowH-UG_AutoSize(420))/2.0, UG_AutoSize(300), UG_AutoSize(420));
        self = [super initWithFrame:frame];
        if (self) {
            self.frame = frame;
            self.clickHandle = clickHandle;
            self.backgroundColor = [UIColor clearColor];
            self.layer.cornerRadius = 4;
            self.layer.masksToBounds = YES;
            self.layer.cornerRadius = 4;
            [self initUI];
        }
    }
    return self;
}

#pragma mark -获取积分规则
-(void)requestData{
  UGGetIntegrationRuleApi *api =  [UGGetIntegrationRuleApi new];
    [api ug_startWithCompletionBlock:^(UGApiError *apiError, id object) {
        if (object) {
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSDictionary *dic = (NSDictionary *)object;
                [self setHtmlStr: [dic objectForKey:@"dicValue"]];
            }
        }
    }];
}

-(void)setHtmlStr:(NSString *)htmlString{
    NSData *data = [htmlString dataUsingEncoding:NSUnicodeStringEncoding];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:12],
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType
                                 };
    NSAttributedString *html = [[NSAttributedString alloc]initWithData:data
                                                               options:attributes
                                                    documentAttributes:nil
                                                                 error:nil];
    self.textView.attributedText = html;
}

-(void)initUI{
    self.backImage.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-UG_AutoSize(45));
    [self addSubview:self.backImage];
    self.titleLabel.frame = CGRectMake(UG_AutoSize(10), UG_AutoSize(20), self.frame.size.width-2*UG_AutoSize(10), UG_AutoSize(22));
    [self addSubview:self.titleLabel];
    self.textView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+UG_AutoSize(35), self.frame.size.width, self.frame.size.height-UG_AutoSize(45)-CGRectGetMaxY(self.titleLabel.frame)-UG_AutoSize(35)-UG_AutoSize(10));
    [self addSubview:self.textView];
    self.closeBtn.frame = CGRectMake((self.frame.size.width-UG_AutoSize(30))/2.0, CGRectGetMaxY(self.backImage.frame)+UG_AutoSize(10), UG_AutoSize(30), UG_AutoSize(30));
    [self addSubview:self.closeBtn];
    
    [self requestData];
}

-(UIImageView *)backImage{
    if (!_backImage) {
        _backImage = [[UIImageView alloc] init];
        _backImage.userInteractionEnabled = YES;
        _backImage.image = [UIImage imageNamed:@"intergration_rule"];
    }
    return _backImage;
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        _titleLabel.text = @"积分规则";
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
//        _textView.text = @"1、积分专属UG钱包平台，仅作用于UG钱包平台。 积分越高，平台派单率越高。\n2、积分获取渠道包括\n（1）完成1个平台派单，增加1积分；\n（2）连续7天，每天都接收平台派单，奖励10积分（如中断，则天数清零）；\n（3）单次充值大于200UG，增加1积分；\n（4）单次充值大于2000UG，增加5积分；\n3、积分扣除规则\n（1）主动取消订单，扣除1积分；\n（2）待支付订单超时被取消，扣除5积分；\n（3）连续关闭接单7天以上，扣除5积分，第8天开始，每天持续扣除1积分；\n4、本系统积分不设上限，积分越多，平台接单越有优势。\n5、当积分少于“-50分”，系统将关闭账号交易，需联系客服处理。";
        _textView.font = [UIFont systemFontOfSize:12];
        [_textView setEditable:NO];
        _textView.textContainerInset = UIEdgeInsetsMake(0, 30, 0, 30);
//        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//        paragraphStyle.lineSpacing = 5;// 字体的行间距
//        NSDictionary *attributes = @{
//                                     NSFontAttributeName:[UIFont systemFontOfSize:12],
//                                     NSParagraphStyleAttributeName:paragraphStyle
////                                     NSForegroundColorAttributeName: [UIColor colorWithHexString:@"666666"],
//                                     };
//        _textView.attributedText = [[NSAttributedString alloc] initWithString:_textView.text attributes:attributes];
//        NSMutableAttributedString *string = [[NSMutableAttributedString alloc]initWithAttributedString:_textView.attributedText];
//        [string addAttribute:NSForegroundColorAttributeName value:UG_MainColor range:[_textView.text rangeOfString:@"积分获取渠道包括"]];
//        [string addAttribute:NSForegroundColorAttributeName value:UG_MainColor range:[_textView.text rangeOfString:@"积分扣除规则"]];
//        [_textView setAttributedText:string];
    }
    return _textView;
}

-(UIButton *)closeBtn{
    if (!_closeBtn) {
        _closeBtn = [[UIButton alloc] init];
        [_closeBtn setImage:[UIImage imageNamed:@"close_integraton"] forState:UIControlStateNormal];
        [_closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _closeBtn;
}

-(void)closeBtnClick{
    if (self.clickHandle) {
        self.clickHandle();
    }
    [PopView hidenPopView];
}




@end
