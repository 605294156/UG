//
//  PlatformMessageDetailViewController.m
//  CoinWorld
//
//  Created by iDog on 2018/3/21.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import "PlatformMessageDetailViewController.h"

@interface PlatformMessageDetailViewController ()<UIWebViewDelegate>
@property(nonatomic,strong)UIWebView *webView;
@end

@implementation PlatformMessageDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.navtitle;
    [self.view addSubview:[self webView]];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
}

-(UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWindowW, kWindowH-[UG_MethodsTool navigationBarHeight])];
        _webView.delegate = self;
        [_webView scalesPageToFit];
        if (!UG_CheckStrIsEmpty(self.url))
            [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
        else
            [_webView loadHTMLString:self.content baseURL:nil];
    }
    return _webView;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    [MBProgressHUD ug_showHUDToKeyWindow];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [MBProgressHUD ug_hideHUDFromKeyWindow];
}
-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [MBProgressHUD ug_hideHUDFromKeyWindow];
}


@end
