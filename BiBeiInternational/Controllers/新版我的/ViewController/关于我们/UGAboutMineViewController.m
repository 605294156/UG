//
//  UGAboutMineViewController.m
//  BiBeiInternational
//
//  Created by keniu on 2018/10/22.
//  Copyright © 2018 XinHuoKeJi. All rights reserved.
//

#import "UGAboutMineViewController.h"

@interface UGAboutMineViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottonLienConstraint;
@property (weak, nonatomic) IBOutlet UILabel *appNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *yearlabel;

@end

@implementation UGAboutMineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.bottonLienConstraint.constant += SafeAreaBottomHeight;
    self.bottomConstraint.constant += SafeAreaBottomHeight;
    self.title = @"关于我们";
        
    self.appNameLabel.text = [NSString stringWithFormat:@"%@ %@",APP_NAME, APP_VERSION];
    
    NSDate *  senddate=[NSDate date];
    NSDateFormatter  *dateformatter=[[NSDateFormatter alloc] init];
    [dateformatter setDateFormat:@"yyyy"];
    //    今年2019
    NSString *thisYearString=[dateformatter stringFromDate:senddate];
    self.yearlabel.text = [NSString stringWithFormat:@"@ %@ UG钱包",thisYearString];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)clickPrivacyService:(UIButton *)sender {
    NSLog(@"点击隐私服务");
}
- (IBAction)clickTeamsOfService:(UIButton *)sender {
    NSLog(@"点击服务条款");
    [self gotoWebView:@"服务与隐私条款" htmlUrl:[UGURLConfig serveApi]];
}

- (IBAction)clickAuthoriztion:(UIButton *)sender {
    NSLog(@"点击授权声明");
}

@end
