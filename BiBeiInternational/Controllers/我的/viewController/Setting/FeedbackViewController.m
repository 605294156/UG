//
//  FeedbackViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/2.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "FeedbackViewController.h"
#import "UITextView+Placeholder.h"
#import "MineNetManager.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UITextView *feedbackTextView;
@property (weak, nonatomic) IBOutlet UITextField *feedbackPhoneNum;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomViewHeight;

//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *feedBackTopViewLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButtom;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = LocalizationKey(@"feedback");
    self.bottomViewHeight.constant = SafeAreaBottomHeight;
    self.feedbackTextView.placeholder = LocalizationKey(@"feedbackTip2");
    self.feedBackTopViewLabel.text = LocalizationKey(@"feedbackTip1");
    self.feedbackPhoneNum.placeholder = LocalizationKey(@"feedbackTip3");
    [self.submitButtom setTitle:LocalizationKey(@"submit") forState:UIControlStateNormal];
    self.feedbackTextView.delegate = self;
    // Do any additional setup after loading the view from its nib.
}
-(void)textViewDidChange:(UITextView *)textView{
    //字数限制操作
    if (textView.text.length >= 100) {
        [self.feedbackTextView resignFirstResponder];
        [self.view ug_showToastWithToast:LocalizationKey(@"feedbackJudgeAlphanumeric")];
        return;
    }
}
//MARK:--提交的点击事件
- (IBAction)submitBtnClick:(UIButton *)sender {
    if ([_feedbackTextView.text isEqualToString:@""]) {
        [self.view ug_showToastWithToast:LocalizationKey(@"inputFeedbackTip")];
        return ;
    }
    //上传反馈意见
    [EasyShowLodingView showLodingText:LocalizationKey(@"loading")];
    [MineNetManager takeUpFeedBackForRemark:self.feedbackTextView.text CompleteHandle:^(id resPonseObj, int code) {
        [EasyShowLodingView hidenLoding];
        if (code) {
            if ([resPonseObj[@"code"] integerValue]==0) {
                //上传成功
                [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    
                    [self.navigationController popViewControllerAnimated:YES];
                });
                
            }else if ([resPonseObj[@"code"] integerValue] == 3000 || [resPonseObj[@"code"] integerValue] == 4000 ){
               // [ShowLoGinVC showLoginVc:self withTipMessage:resPonseObj[MESSAGE]];
                [[UGManager shareInstance] signout:nil];
            }else{
                 [self.view ug_showToastWithToast:resPonseObj[MESSAGE]];
            }
        }else{
            [self.view ug_showToastWithToast:LocalizationKey(@"noNetworkStatus")];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
