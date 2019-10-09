//
//  UGHomeReceiptCoinVC.m
//  BiBeiInternational
//
//  Created by conew on 2018/10/18.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGHomeReceiptCoinVC.h"
#import "UGPopTableView.h"
//#import "UGQRScanVC.h"
#import "UGWalletAllModel.h"
#import "UGPayQRModel.h"
#import "QRCodeViewModel.h"

@interface UGHomeReceiptCoinVC ()
@property (nonatomic,strong)UGPopTableView *popMenuView;
@property (nonatomic,copy)NSString *walletName;
@property (nonatomic,assign)BOOL showPopView;
@property (nonatomic,assign)NSInteger popSelectedIndex;
@property (nonatomic,strong)UGWalletAllModel *model;
@end

@implementation UGHomeReceiptCoinVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor =UG_MainColor;
    [self languageChange];
    [self getData];
    if ([UG_MethodsTool is4InchesScreen]) {
        self.desTitle.font = [UIFont systemFontOfSize: 13];
    }
    
}

-(void)languageChange{
    self.title = @"收币";
    
    self.popSelectedIndex = 0;
}

-(void)getData{
    if ([UGManager shareInstance].hostInfo.userInfoModel.list.count>0) {
        self.model =[UGManager shareInstance].hostInfo.userInfoModel.list[0];
        [self initUI];
    }
    if ([UGManager shareInstance].hostInfo.userInfoModel.list.count>0) {
        self.model =[UGManager shareInstance].hostInfo.userInfoModel.list[0];
        [self initUI];
    }
}

-(void)initUI{
    self.showPopView = NO;
    
    UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(seletedWallet:)];
    [self.view1 addGestureRecognizer:tapGes];
    
    if (self.model) {
        self.selectedwallet.text = ! UG_CheckStrIsEmpty(self.model.name)?self.model.name:@"--";
        //根据model 生成二维码 并编码
        UGPayQRModel *payModel = [self getModel];
        NSString *encodeStr = [UG_MethodsTool encodeString:[UG_MethodsTool convertToJsonData:payModel.mj_keyValues]];
//      self.qrImg.image = [UGQRScanVC createQRImageWithStr:encodeStr withSize:self.qrImg.frame.size];
        self.qrImg.image = [QRCodeViewModel createQRimageString:encodeStr sizeWidth:self.qrImg.frame.size.width fillColor:[UIColor blackColor]];
        UILongPressGestureRecognizer *press = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
        press.minimumPressDuration = 0.5;//2秒（默认0.5秒）
        [press setNumberOfTouchesRequired:1];
        [self.qrImg addGestureRecognizer:press];
    }
}

-(UGPayQRModel *)getModel{
    UGPayQRModel *model = [UGPayQRModel new];
    model.merchCardNo =self.model.address;
    model.loginName = [UGManager shareInstance].hostInfo.username;
    model.orderType = @"0";
    model.amount = @"";
    model.orderSn = @"";
    model.merchNo = @"";
    model.extra = @"";
    return model;
}

#pragma mark -长按复制
-(void)longPressAction:(UILongPressGestureRecognizer *)longPress{
    [self becomeFirstResponder];
    if (longPress.state == UIGestureRecognizerStateBegan) {
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        
        UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(menuCopyBtnPressed:)];
        
        menuController.menuItems = @[copyItem];
        
        [menuController setTargetRect:longPress.view.frame inView:longPress.view.superview];
        
        [menuController setMenuVisible:YES animated:YES];
        
        [UIMenuController sharedMenuController].menuItems=nil;
    }
}

-(void)menuCopyBtnPressed:(UIMenuItem *)menuItem
{
    NSString *address = self.model.address;
//    NSString *name = [UGManager shareInstance].hostInfo.username;
    NSString *qrstring = [NSString stringWithFormat:@"%@", address];
    [UIPasteboard generalPasteboard].string = !UG_CheckStrIsEmpty(qrstring)?qrstring:@"";
    [self.view ug_showToastWithToast:@"复制成功！"];
}

#pragma mark -选择UG钱包
- (IBAction)seletedWallet:(id)sender {
//    @weakify(self);
//    [self.popMenuView showPopViewOnView:self.navigationController.navigationBar removedFromeSuperView:^{
//            @strongify(self);
//            self.popMenuView = nil;
//        }];
}

-(UGPopTableView *)popMenuView{
    if (!_popMenuView) {
//        @weakify(self);
//        _popMenuView = [[UGPopTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view1.frame), kWindowW, 120) titles:@[@"UG钱包1"] selectedIndex:self.popSelectedIndex handle:^(NSString *title, NSInteger index) {
//            @strongify(self);
//            self.popSelectedIndex = index;
//        }];
    }
    return _popMenuView;
}

//-(UGPopTableView *)walletSelectedPopView{
//    if (!_walletSelectedPopView) {
//        _walletSelectedPopView = [[UGPopTableView alloc] initWithFrame:CGRectMake(kWindowW-14-UG_AutoSize(140), CGRectGetMaxY(self.view1.frame), UG_AutoSize(140), UG_AutoSize(120))];
//        _walletSelectedPopView.array = [NSMutableArray arrayWithArray:@[@"UG钱包1",@"UG钱包2",@"UG钱包3",@"UG钱包4"]];
//        __weak typeof(self)weakSelf = self;
//        _walletSelectedPopView.celllClick = ^(UGPopTableView *popview, NSString *seleted) {
//            if (!UG_CheckStrIsEmpty(seleted)) {
//                weakSelf.walletName = seleted;
//                weakSelf.selectedwallet.text = weakSelf.walletName;
//                weakSelf.selectedwallet.textColor = [UIColor blackColor];
//                weakSelf.showPopView = NO;
//            }
//        };
//    }
//    _walletSelectedPopView.frame = CGRectMake(kWindowW-14-UG_AutoSize(140), CGRectGetMaxY(self.view1.frame), UG_AutoSize(140), UG_AutoSize(120));
//    _walletSelectedPopView.selectedStr = !UG_CheckStrIsEmpty(self.walletName)?self.walletName:@"";
//    self.showPopView = YES;
//    return _walletSelectedPopView;
//}

#pragma mark -长按复制需要设置的 响应者
-(BOOL)canBecomeFirstResponder{
    return YES;
}

-(BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    if (action == @selector(menuCopyBtnPressed:)) {
        
        return YES;
    }
    return NO;
}

@end
