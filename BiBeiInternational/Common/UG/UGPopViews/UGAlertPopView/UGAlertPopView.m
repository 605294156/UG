//
//  UGAlertPopView.m
//  BiBeiInternational
//
//  Created by keniu on 2019/5/29.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGAlertPopView.h"
#import "PopView.h"

@interface UGAlertPopView()
//@property(nonatomic,copy)NSString *alertTittle;
//@property(nonatomic,copy)NSString *alertMessage;
//@property(nonatomic,copy)NSString *cancleButtonTittle;
//@property(nonatomic,copy)NSString *confirmlButtonTittle;
//@property (copy, nonatomic) void(^confirm)(void);
//@property (copy, nonatomic) void(^cancel)(void);

@property(nonatomic,strong)UGAlertPopView *alertPopView;

//-(instancetype)initAlertPopViewWithTitle:(NSString *)title andMessage:(NSString *)message andCancelButtonTittle:(NSString *)cancelButtonTittle andConfirmlButtonTittle:(NSString *)confirmlButtonTittle confirmBlock:(confirmOut)confirmOut cancelBlock:(cancelOut)cancelOut;
@end




@implementation UGAlertPopView

+(instancetype)shareInstance
{
    static UGAlertPopView *alertView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken,^{
        alertView = [[UGAlertPopView alloc]init];
    });
    return alertView;
}

-(void)showAlertPopViewWithTitle:(NSString *)title andMessage:(NSString *)message andCancelButtonTittle:(NSString *)cancelButtonTittle andConfirmlButtonTittle:(NSString *)confirmlButtonTittle cancelBlock:(cancelBlock)cancelBlock confirmBlock:(confirmBlock)confirmBlock
{
    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"UGAlertPopView"owner:self options:nil];
    _alertPopView = [nibView objectAtIndex:0];
    _alertPopView.confirmBlock = confirmBlock;
    _alertPopView.cancelBlock = cancelBlock;
    _alertPopView.alertTittleLabel.text = title;
    _alertPopView.alertMessageTextView.text = message;
    [_alertPopView.alertCancelButton setTitle:cancelButtonTittle forState:UIControlStateNormal];
    [_alertPopView.alertConfirmButton setTitle:confirmlButtonTittle forState:UIControlStateNormal];
    _alertPopView.layer.cornerRadius = 4;
    _alertPopView.layer.masksToBounds  = YES;
    CGFloat width = kWindowW - 96;
    CGFloat height = 250;
    CGFloat contentHeight = [UG_MethodsTool heightWithWidth:width -32 font:16 str:message]+24;
    if(contentHeight + 100 < 150)
    {
        height = 150;
    }else if (contentHeight + 100 < 480) {
        height = contentHeight +100;
        _alertPopView.alertMessageTextView.scrollEnabled = NO;
    }
    else
    {
        height = 480;
        _alertPopView.alertMessageTextView.scrollEnabled = YES;
    }
    CGRect frame = CGRectMake(0,0,width,height);
    [_alertPopView setFrame:frame];
    [[NSOperationQueue mainQueue] addOperationWithBlock: ^{
        [self.alertPopView.alertMessageTextView setContentOffset:CGPointZero animated:NO];
    }];
    PopView *popView =[PopView popSideContentView:_alertPopView direct:PopViewDirection_SlideInCenter];
    popView.clickOutHidden = NO;
    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    popView.didRemovedFromeSuperView = ^{
        [self.alertPopView removeFromSuperview];
    };
    

}

//+(void)showAlertPopViewWithTitle:(NSString *)title andMessage:(NSString *)message andCancelButtonTittle:(NSString *)cancelButtonTittle andConfirmlButtonTittle:(NSString *)confirmlButtonTittle showsOnView:(UIView *)view confirmBlock:(confirmOut)confirmOut cancelBlock:(cancelOut)cancelOut
//{
//    UGAlertPopView  *alertView = [[UGAlertPopView alloc] initAlertPopViewWithTitle:title andMessage:message andCancelButtonTittle:cancelButtonTittle andConfirmlButtonTittle:confirmlButtonTittle confirmBlock:^{
//
//        if (confirmOut) {
//            confirmOut();
//        }
//
//
//    } cancelBlock:^{
//
//        if (cancelOut) {
//            cancelOut();
//        }
//    }];
//
//    PopView *popView =[PopView popSideContentView:alertView direct:PopViewDirection_SlideInCenter];
//    popView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
//    popView.didRemovedFromeSuperView = ^{
//        [alertView removeFromSuperview];
//    };
//
//}

//-(instancetype)initAlertPopViewWithTitle:(NSString *)title andMessage:(NSString *)message andCancelButtonTittle:(NSString *)cancelButtonTittle andConfirmlButtonTittle:(NSString *)confirmlButtonTittle confirmBlock:(confirmOut)confirmOut cancelBlock:(cancelOut)cancelOut
//{
//    self = [super init];
//    if (self) {
//
//        if (self) {
////            self.frame = frame;
//            self.confirm = confirmOut;
//            self.cancel = cancelOut;
//            self.alertTittle = title;
//            self.alertMessage = message;
//            self.confirmlButtonTittle = confirmlButtonTittle;
//            self.cancleButtonTittle = cancelButtonTittle;
//            [self initUI];
//        }
//    }
//    return self;
//
//}
//
//-(void)initUI{
//
//    NSArray *nibView =  [[NSBundle mainBundle] loadNibNamed:@"UGAlertPopView"owner:self options:nil];
//
//    UGAlertPopView *alertView = [nibView objectAtIndex:0];
//
//    alertView.alertTittleLabel.text = self.alertTittle;
//
//    alertView.alertMessageTextView.text = self.alertMessage;
//
//    [alertView.alertCancelButton setTitle:self.cancleButtonTittle forState:UIControlStateNormal];
//
//    [alertView.alertConfirmButton setTitle:self.confirmlButtonTittle forState:UIControlStateNormal];
//
//    CGFloat width = kWindowW - 80;
//    CGFloat height = 250;
//    CGFloat contentHeight = [UG_MethodsTool heightWithWidth:width -32 font:14 str:self.alertMessage];
//    if (contentHeight + 88.5 < 440) {
//
//        height = contentHeight +88.5;
//    }
//    else
//    {
//        height = 440;
//
//    }
//    CGRect frame = CGRectMake(-150,-130,width,height);
//
//    [alertView setFrame:frame];
//
//    [self addSubview:alertView];
//
//
//}

+(void)hidePopView{
    [PopView hidenPopView];
}

- (IBAction)cancelButtonAction:(id)sender {
    if (_cancelBlock) {
        _cancelBlock();
    }
     [PopView hidenPopView];
}

- (IBAction)confirmButtonAction:(id)sender {
    if (_confirmBlock) {
        _confirmBlock();
    }
     [PopView hidenPopView];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
