//
//  LanguageSettingsViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/2/2.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "LanguageSettingsViewController.h"

@interface LanguageSettingsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *englishImage;
@property (weak, nonatomic) IBOutlet UIImageView *simplifiedChineseImage;
@property (weak, nonatomic) IBOutlet UIImageView *traditionalChineseImage;
//国际化需要
@property (weak, nonatomic) IBOutlet UILabel *englishLabel;
@property (weak, nonatomic) IBOutlet UILabel *ChineseLabel;

@end

@implementation LanguageSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = LocalizationKey(@"languageSettings");
    self.englishLabel.text = LocalizationKey(@"English");
    self.ChineseLabel.text = LocalizationKey(@"simplifiedChinese");
    if ([[ChangeLanguage userLanguage] isEqualToString:@"en"]) {
        self.englishImage.hidden=NO;
        self.simplifiedChineseImage.hidden=YES;
        self.traditionalChineseImage.hidden=YES;
       
    }else if ([[ChangeLanguage userLanguage] isEqualToString:@"zh-Hans"])
    {  self.englishImage.hidden=YES;
        self.simplifiedChineseImage.hidden=NO;
        self.traditionalChineseImage.hidden=YES;
        
    }else{
        
    }
    // Do any additional setup after loading the view from its nib.
}
- (IBAction)btnClick:(UIButton *)sender {
    if (sender.tag == 1) {
        //英语
        self.englishImage.hidden=NO;
        self.simplifiedChineseImage.hidden=YES;
        self.traditionalChineseImage.hidden=YES;
        [ChangeLanguage setUserlanguage:@"en"];
    }else if (sender.tag == 2){
        //简体中文
        self.englishImage.hidden=YES;
        self.simplifiedChineseImage.hidden=NO;
        self.traditionalChineseImage.hidden=YES;
        [ChangeLanguage setUserlanguage:@"zh-Hans"];
    }else{
        //其他
    }
    self.title = LocalizationKey(@"languageSettings");
    self.englishLabel.text = LocalizationKey(@"English");
    self.ChineseLabel.text = LocalizationKey(@"simplifiedChinese");
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotificationName:LanguageChange object:nil];
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
