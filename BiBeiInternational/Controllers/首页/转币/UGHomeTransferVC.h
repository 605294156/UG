//
//  UGHomeTransferVC.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/18.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController.h"
#import "TXLimitedTextField.h"

NS_ASSUME_NONNULL_BEGIN

@class UGPayQRModel;

@interface UGHomeTransferVC : UGBaseViewController
@property (weak, nonatomic) IBOutlet UIButton *UGCBtn;
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (weak, nonatomic) IBOutlet UIView *view3;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *sendwallet;
@property (weak, nonatomic) IBOutlet UILabel *selectedwallet;
@property (weak, nonatomic) IBOutlet UIButton *selectedBtn;
@property (weak, nonatomic) IBOutlet UILabel *ssendNum;
@property (weak, nonatomic) IBOutlet UITextField *sendNumTextFiled;
@property (weak, nonatomic) IBOutlet UILabel *cny;
@property (weak, nonatomic) IBOutlet UILabel *aceipet;
@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *View3;
@property (weak, nonatomic) IBOutlet UILabel *acceptUser;
@property (weak, nonatomic) IBOutlet TXLimitedTextField *acceptUserTextFiled;


@property (nonatomic,strong) TXLimitedTextField *acceptTextFiled;
@property (nonatomic,strong) UIScrollView *backScrollVew;
@property (nonatomic,assign) NSInteger indextext;

@property(nonatomic,strong)UGPayQRModel *qrModel;
@end

NS_ASSUME_NONNULL_END
