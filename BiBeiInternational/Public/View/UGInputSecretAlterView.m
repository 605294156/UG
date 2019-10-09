//
//  UGInputSecretAlterView.m
//  ug-wallet
//
//  Created by conew on 2018/9/20.
//  Copyright © 2018年 keniu. All rights reserved.
//

#import "UGInputSecretAlterView.h"
#import "UGPassWordInputView.h"

@interface UGInputSecretAlterView()<UIGestureRecognizerDelegate,UGPassWordInputViewDelegate>
@property(nonatomic,strong)UIView *controllerView;
@property(nonatomic,copy)NSString *titleStr;
@property(nonatomic,strong)UIView *backView;
@property(nonatomic,strong)UILabel *titleLabel;
@property(nonatomic,strong)UIButton *cancelBtn;
@property(nonatomic,strong)UIButton *trueBtn;
@property(nonatomic,strong)UGPassWordInputView *passWordView;
@end

@implementation UGInputSecretAlterView

-(instancetype)initWithController:(UIView *)controller WithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.titleStr = title;
        self.controllerView = controller;
        [self setupViews];

    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title {
    self = [super init];
    if (self) {
        self.titleStr = title;
        self.controllerView = [UIApplication sharedApplication].keyWindow;
        [self setupViews];
    }
    return self;
}


- (void)setupViews {
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    self.userInteractionEnabled = YES;
    [self initUI];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardAction:) name:UIKeyboardWillHideNotification object:nil];

}



// 键盘监听事件
- (void)keyboardAction:(NSNotification*)sender {
    NSDictionary *useInfo = [sender userInfo];
    NSValue *value = [useInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height =[value CGRectValue].size.height;
    if([sender.name isEqualToString:UIKeyboardWillShowNotification] && [self.passWordView isFirstResponder]){
        self.backView.frame= CGRectMake(UG_AutoSize(57), UG_SCREEN_HEIGHT-height-UG_AutoSize(160), UG_SCREEN_WIDTH-2*UG_AutoSize(57), UG_AutoSize(125));
    } else if ([sender.name isEqualToString:UIKeyboardWillHideNotification] && ![self.passWordView isFirstResponder] )  {
        self.backView.frame= CGRectMake(UG_AutoSize(57), UG_SCREEN_HEIGHT-height-UG_AutoSize(160), UG_SCREEN_WIDTH-2*UG_AutoSize(57), UG_AutoSize(125));
    }
}

-(void)initUI
{
    self.backView.frame =CGRectMake(UG_AutoSize(57), UG_AutoSize(300), UG_SCREEN_WIDTH-2*UG_AutoSize(57), UG_AutoSize(125));
    [self addSubview:self.backView];
    
    self.titleLabel.frame =CGRectMake(0, UG_AutoSize(13), self.backView.frame.size.width, UG_AutoSize(22));
    [self.backView addSubview:self.titleLabel];
    
//    self.cancelBtn.frame = CGRectMake(UG_AutoSize(30), self.backView.frame.size.height-UG_AutoSize(15)-UG_AutoSize(30), UG_AutoSize(70), UG_AutoSize(30));
//    [self.backView addSubview:self.cancelBtn];
//
//    self.trueBtn.frame = CGRectMake(self.backView.frame.size.width-UG_AutoSize(30)-UG_AutoSize(70), self.backView.frame.size.height-UG_AutoSize(15)-UG_AutoSize(30), UG_AutoSize(70), UG_AutoSize(30));
//    [self.backView addSubview:self.trueBtn];
    
    self.passWordView.frame = CGRectMake(0, CGRectGetMaxY(self.titleLabel.frame)+UG_AutoSize(20), self.backView.frame.size.width, UG_AutoSize(50));
    [self.backView addSubview:self.passWordView];
    
    UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hide)];
    recognizer.delegate = self;
    [self addGestureRecognizer:recognizer];
}

- (void)passWordCompleteInput:(UGPassWordInputView *)passWord{
        if (self.doneBlock) {
            self.doneBlock(self.passWordView.textStore);
        }
}

-(UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = self.titleStr;
        _titleLabel.font = UG_AutoFont(16);
        _titleLabel.textColor = [UIColor colorWithRed:34/255.0 green:34/255.0 blue:34/255.0 alpha:1];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _titleLabel;
}

-(UIView *)backView{
    if (!_backView) {
        _backView = [[UIView alloc] init];
        _backView.backgroundColor = UG_WhiteColor;
        _backView.layer.cornerRadius = 8;
        _backView.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5].CGColor;
        _backView.layer.shadowOffset = CGSizeMake(0,2);
        _backView.layer.shadowOpacity = 1;
        _backView.layer.shadowRadius = 4;
        _backView.hidden = YES;
    }
    return _backView;
}

//-(UIButton *)cancelBtn{
//    if (!_cancelBtn) {
//        _cancelBtn = [[UIButton alloc] init];
//        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
//        [_cancelBtn setTitleColor:UG_MainColor forState:UIControlStateNormal];
//        _cancelBtn.titleLabel.font = UG_AutoFont(14);
//        [_cancelBtn addTarget:self action:@selector(cancelClick) forControlEvents:UIControlEventTouchUpInside];
//        _cancelBtn.layer.borderColor = UG_MainColor.CGColor;
//        _cancelBtn.layer.borderWidth = 1.0f;
//        _cancelBtn.layer.cornerRadius = 4;
//        _cancelBtn.layer.masksToBounds = YES;
//    }
//    return _cancelBtn;
//}

//-(void)cancelClick{
//    [self hide];
//}

//-(UIButton *)trueBtn{
//    if (!_trueBtn) {
//        _trueBtn = [[UIButton alloc] init];
//        [_trueBtn setTitle:@"确定" forState:UIControlStateNormal];
//        [_trueBtn setTitleColor:UG_WhiteColor forState:UIControlStateNormal];
//        _trueBtn.titleLabel.font = UG_AutoFont(14);
//        [_trueBtn addTarget:self action:@selector(trueClick) forControlEvents:UIControlEventTouchUpInside];
//        _trueBtn.backgroundColor = UG_MainColor;
//        _trueBtn.layer.cornerRadius =4;
//        _trueBtn.layer.masksToBounds = YES;
//    }
//    return _trueBtn;
//}

//-(void)trueClick{
//    if (self.trueBlock) {
//        self.trueBlock(self.passWordView.textStore);
//    }
//}

-(UGPassWordInputView *)passWordView{
    if (!_passWordView) {
        _passWordView = [[UGPassWordInputView alloc] init];
        _passWordView.passWordNum = 6;
        _passWordView.delegate = self;
        _passWordView.rectColor = [UIColor colorWithHexString:@"C6C6C6"];
        _passWordView. squareWidth =UG_AutoSize(37);
        _passWordView.pointRadius = 3;
        _passWordView.pointColor = UG_BlackColor;
    }
    return _passWordView;
}

#pragma mark- 显示视图
- (void)show {
    //将本身加在父类View上
    [self.controllerView addSubview:self];
    
    //设置出现的大小
    CGRect thisFrame = CGRectMake(UG_AutoSize(57), UG_AutoSize(300), UG_SCREEN_WIDTH-2*UG_AutoSize(57), UG_AutoSize(125));
    self.backView.frame = thisFrame;

    //动画显示
    [UIView animateWithDuration:0.3 animations:^{
        self.backView.hidden = NO;
    } completion:^(BOOL finished) {
    }];
    
    if (![self.passWordView isFirstResponder]) {
        [self.passWordView becomeFirstResponder];
    }
}

#pragma mark- 隐藏视图
-(void)hide {
    [self.passWordView resignFirstResponder];
    //隐藏
    CGRect thisFrame = CGRectMake(UG_AutoSize(57), -UG_AutoSize(300), UG_SCREEN_WIDTH-2*UG_AutoSize(57), UG_AutoSize(125));
    self.backView.frame = thisFrame;
    self.backView.hidden = YES;
    [self removeFromSuperview];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if ([touch.view isDescendantOfView:self.backView]) {
        return NO;
    }
    return YES;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
