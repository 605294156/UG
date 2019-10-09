//
//  UGSaveOfficialWebsiteGuideController.m
//  BiBeiInternational
//
//  Created by keniu on 2019/7/10.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGSaveOfficialWebsiteGuideController.h"
#import "AppDelegate.h"
#import "UGGuideViewCell.h"

@interface UGSaveOfficialWebsiteGuideController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpaceLayout;

@end

@implementation UGSaveOfficialWebsiteGuideController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.navigationBarHidden = YES;
    [self.tableView registerNib:[UINib nibWithNibName:@"UGGuideViewCell" bundle:nil] forCellReuseIdentifier:@"UGGuideViewCell"];
    self.tableView.backgroundColor = UG_MainColor;
    self.topSpaceLayout.constant = 0.0f;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UGGuideViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UGGuideViewCell" forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //348 图片以外的原始高度， 10 cell 上下留边高度
    return 348 + 3*(((UG_SCREEN_WIDTH-75.0f)/2)*(16.0f/9.0f))+10+10;
}

#pragma mark - 返回
- (IBAction)goBackHomeVCAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - 保存官网到桌面
- (IBAction)addDesktopShortcut:(id)sender
{
    NSString *URLString = [self upDataMessage:@"ugWebUrl" WithMessage:@"https://ugcoin.pro"];
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"phone_template" ofType:@"mobileconfig"];/*读取app内的文件*/
    //动态生成一个包含正确官网的地址的描述文件
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];
    NSMutableDictionary * config = [data mutableCopy];
    NSMutableDictionary * content = config[@"PayloadContent"][0];
    [content setObject:URLString forKey:@"URL"];
    //0快捷方式不可移除  1快捷方式可移除
    [content setValue:@(0) forKey:@"IsRemovable"];
    //不同的手机型号使用不同规格的Icon
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"ugDesktopShortcut"]);
    [content setObject:imageData forKey:@"Icon"];
    NSString *documentsDirectory =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *filename = [documentsDirectory stringByAppendingPathComponent:@"New_template.mobileconfig"];
    [config writeToFile:filename atomically:YES];
    //目标位置
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"profile.mobileconfig"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    BOOL success = [[NSFileManager defaultManager] copyItemAtPath:filename toPath:path error:nil];
    __weak AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UInt16 port = appDelegate.httpServer.port;
    if (success) [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://localhost:%u/profile.mobileconfig", port]]];
}

#pragma mark - 状态栏控制
- (BOOL)prefersStatusBarHidden {
    return YES;
}

@end
