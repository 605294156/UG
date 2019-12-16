//
//  UGBaseViewController+UGGuidMaskView.m
//  BiBeiInternational
//
//  Created by conew on 2019/1/3.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import "UGBaseViewController+UGGuidMaskView.h"
#import "MXRGuideMaskView.h"
#import "UGNewGuidStatusManager.h"

@implementation UGBaseViewController (UGGuidMaskView)

NS_INLINE CGSize GetGuideImgSize(NSArray *imgs,NSInteger index){
    UIImage *img = [UIImage imageNamed:imgs[index]];
    return img.size;
}

NS_INLINE CGRect GetGuideNSValueRect(NSArray *values,NSInteger index){
    NSValue *value = values[index];
    return value.CGRectValue;
}

#pragma mark - 首页新手引导
- (void)setupHomeNewGuideView:(BOOL)hasPlatData WithBlock:(void(^)(MXRGuideMaskView *maskView))view WithHiden:(void(^)(void))hiden{
    
    if ( ! [UG_MethodsTool is4InchesScreen]) {
        NSArray * imageArr = @[
                               @"new_guid_1",
                               @"new_guid_2",
                               @"new_guid_3",
                               @"new_guid_4",
                               @"new_guid_5",
                               @"new_guid_6",
                               @"new_guid_7",
                               @"new_guid_8",
                               @"new_guid_9",
                               @"new_guid_10"
                               ];
        NSArray * titleArr = @[
                               @"这里是您的钱包，可用金额都在这里，点击查看您的所有资产",
                               @"",
                               @"",
                               @"",
                               @"",
                               @"",
                               @"",
                               @"",
                               @"",
                               @""
                               ];
        NSArray * nextArr = @[
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"开始体验"
                              ];
        //轮播图位置
        CGRect rect1 =CGRectMake(10, [UG_MethodsTool navigationBarHeight]+8, UG_SCREEN_WIDTH-20, UG_AutoSize(160));
        //出售购买按钮位置
        CGRect rect2 = CGRectMake(rect1.size.width-UG_AutoSize(130), CGRectGetMaxY(rect1) - UG_AutoSize(55), UG_AutoSize(130), UG_AutoSize(45));
        //扫一扫位置  hasPlatData 根据 是否有平台消息判断 位置
        CGFloat w_h = UG_AutoSize(80.f);
        CGFloat space = (UG_SCREEN_WIDTH-12-4*w_h)/3.0;
        CGRect rect3 = CGRectMake(6,  CGRectGetMaxY(rect1)+(hasPlatData ? UG_AutoSize(51) : 25), w_h, w_h);
        //转币位置
        CGRect rect4 = CGRectMake(CGRectGetMaxX(rect3)+space,  CGRectGetMinY(rect3), w_h, w_h);
        //收币位置
        CGRect rect5 = CGRectMake(CGRectGetMaxX(rect4)+space,  CGRectGetMinY(rect4), CGRectGetWidth(rect4), CGRectGetHeight(rect4));
        //钱包记录位置
        CGRect rect6 = CGRectMake(CGRectGetMaxX(rect5)+space,  CGRectGetMinY(rect5), CGRectGetWidth(rect5), CGRectGetHeight(rect5));
        //币币兑换位置
        CGRect rect7 = CGRectMake(CGRectGetMinX(rect5),  CGRectGetMaxY(rect5)-8, CGRectGetWidth(rect5), CGRectGetHeight(rect5));
        //交易记录位置
        CGRect rect8 = CGRectMake(CGRectGetMaxX(rect7)+space,  CGRectGetMinY(rect7), CGRectGetWidth(rect5), CGRectGetHeight(rect5));
        //行情位置
        CGRect rect9 = CGRectMake(0, CGRectGetMaxY(rect8)+98, UG_SCREEN_WIDTH, UG_SCREEN_HEIGHT-(CGRectGetMaxY(rect8)+98)-[UG_MethodsTool tabBarHeight]);
        //tab位置
        CGRect rect10 = CGRectMake(0, UG_SCREEN_HEIGHT-[UG_MethodsTool tabBarHeight], UG_SCREEN_WIDTH, [UG_MethodsTool tabBarHeight]);
        
        NSArray * imgFrameArr = @[
                                  
                                  [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(15), CGRectGetMaxY(rect1)+UG_AutoSize(35), GetGuideImgSize(imageArr, 0).width, GetGuideImgSize(imageArr, 0).height)],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(CGRectGetMaxX(rect2)-GetGuideImgSize(imageArr, 1).width-15, CGRectGetMaxY(rect2), GetGuideImgSize(imageArr, 1).width, GetGuideImgSize(imageArr, 1).height)],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(rect3)+UG_AutoSize(15), CGRectGetMaxY(rect3), GetGuideImgSize(imageArr, 2).width, GetGuideImgSize(imageArr, 2).height)],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(rect4)-UG_AutoSize(39), CGRectGetMaxY(rect4), GetGuideImgSize(imageArr, 3).width, GetGuideImgSize(imageArr, 3).height)],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(rect5)-GetGuideImgSize(imageArr, 4).width * .5, CGRectGetMaxY(rect5), GetGuideImgSize(imageArr, 4).width, GetGuideImgSize(imageArr, 4).height)],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(rect6)-GetGuideImgSize(imageArr, 5).width * .75, CGRectGetMaxY(rect6), GetGuideImgSize(imageArr, 5).width, GetGuideImgSize(imageArr, 5).height)],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(rect7)-GetGuideImgSize(imageArr, 6).width * .55, CGRectGetMaxY(rect7), GetGuideImgSize(imageArr, 6).width, GetGuideImgSize(imageArr, 6).height)],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(CGRectGetMinX(rect8)-GetGuideImgSize(imageArr, 7).width * .76, CGRectGetMaxY(rect8), GetGuideImgSize(imageArr, 7).width, GetGuideImgSize(imageArr, 7).height)],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(CGRectGetMidX(rect9)-(GetGuideImgSize(imageArr, 8).width/2), CGRectGetMinY(rect9)-GetGuideImgSize(imageArr, 8).height-25, GetGuideImgSize(imageArr, 8).width, GetGuideImgSize(imageArr, 8).height)],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(CGRectGetMidX(rect10)-(GetGuideImgSize(imageArr, 9).width/2), rect10.origin.y-UG_AutoSize(65)-UG_AutoSize(10), GetGuideImgSize(imageArr, 9).width, GetGuideImgSize(imageArr, 9).height)],
                                  ];
        
        NSArray * titleFrameArr = @[
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(CGRectGetMaxX(GetGuideNSValueRect(imgFrameArr, 0))+10), CGRectGetMaxY(rect1)+UG_AutoSize(10), UG_SCREEN_WIDTH-(rect1.origin.x+UG_AutoSize(15+65+10+10)), UG_AutoSize(90))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(40), CGRectGetMaxY(rect2)+UG_AutoSize(15), UG_SCREEN_WIDTH-2*UG_AutoSize(40), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(rect3.origin.x+UG_AutoSize(20), CGRectGetMaxY(rect3)+UG_AutoSize(10), UG_SCREEN_WIDTH-(rect3.origin.x+UG_AutoSize(20))-UG_AutoSize(25), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(70), CGRectGetMaxY(rect4)+UG_AutoSize(10), UG_SCREEN_WIDTH-(130), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(100), CGRectGetMaxY(rect5)+UG_AutoSize(10),UG_SCREEN_WIDTH-(125), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(rect6.origin.x+UG_AutoSize(20), CGRectGetMaxY(rect6)+UG_AutoSize(10), UG_SCREEN_WIDTH-(rect6.origin.x+UG_AutoSize(20))-UG_AutoSize(25), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(25),  CGRectGetMaxY(rect7)+UG_AutoSize(10),UG_SCREEN_WIDTH-(140), UG_AutoSize(90))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(80), CGRectGetMaxY(rect8)+UG_AutoSize(10),UG_SCREEN_WIDTH-(90), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(rect9.origin.x+UG_AutoSize(25+65+20), rect9.origin.y-UG_AutoSize(80), UG_SCREEN_WIDTH-(rect9.origin.x+UG_AutoSize(25+65+20+25)), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(rect10.origin.x+UG_AutoSize(15+65+10), rect10.origin.y-UG_AutoSize(50)-UG_AutoSize(20), UG_SCREEN_WIDTH-(rect10.origin.x+UG_AutoSize(15+65+10)), UG_AutoSize(50))],
                                    ];
        NSArray * nextFrameArr = @[
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(30+90+35), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(GetGuideNSValueRect(imgFrameArr, 1))+UG_AutoSize(60), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake(UG_SCREEN_WIDTH-UG_AutoSize(108)-UG_AutoSize(44), CGRectGetMaxY(GetGuideNSValueRect(imgFrameArr, 2))+UG_AutoSize(60), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, UG_AutoSize(CGRectGetMaxY(GetGuideNSValueRect(imgFrameArr, 3)) + 50), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(GetGuideNSValueRect(imgFrameArr, 4)) + 50, UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(GetGuideNSValueRect(imgFrameArr, 5)) + 50, UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake(UG_SCREEN_WIDTH-UG_AutoSize(125), CGRectGetMaxY(GetGuideNSValueRect(imgFrameArr, 6)) + 50, UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(GetGuideNSValueRect(imgFrameArr, 7)) + 50, UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108)-26), CGRectGetMinY(GetGuideNSValueRect(imgFrameArr, 8)) - 100, UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, rect10.origin.y-UG_AutoSize(210), UG_AutoSize(108), UG_AutoSize(40))],
                                   ];
        
        NSArray * goOutFrameArr = @[
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_SCREEN_WIDTH-UG_AutoSize(80+40), CGRectGetMaxY(rect1)+UG_AutoSize(30+90+35+60), UG_AutoSize(80), UG_AutoSize(40))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],

                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    ];
        
        NSArray * notSeeFrameArr = @[
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],

                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(160))/2.0, rect10.origin.y-UG_AutoSize(145), UG_AutoSize(160), UG_AutoSize(40))],
                                     ];
        
        NSArray * transparentRectArr = @[
                                         [NSValue valueWithCGRect:rect1],
                                         [NSValue valueWithCGRect:rect2],
                                         [NSValue valueWithCGRect:rect3],
                                         [NSValue valueWithCGRect:rect4],
                                         [NSValue valueWithCGRect:rect5],
                                         [NSValue valueWithCGRect:rect6],
                                         [NSValue valueWithCGRect:rect7],
                                         [NSValue valueWithCGRect:rect8],
                                         [NSValue valueWithCGRect:rect9],
                                         [NSValue valueWithCGRect:rect10]
                                         ];
        NSArray * orderArr = @[@1,@1,@1,@1,@1,@1,@1,@1,@1,@1];
        MXRGuideMaskView *maskView = [MXRGuideMaskView new];
        if (view) {
            view(maskView);
        }
        maskView.goOutBlock = ^{
            [UGNewGuidStatusManager shareInstance].homeNewStatus = @"1";
            if (hiden) {
                hiden();
            }
        };
        maskView.notSeeBlock = ^(BOOL isSee) {
            if (hiden) {
                hiden();
            }
            if (isSee) {
                [NSUserDefaultUtil PutDefaults:@"haveShowHomeGuidView" Value:@"1"];
            }else{
                [NSUserDefaultUtil PutDefaults:@"haveShowHomeGuidView" Value:@"0"];
            }
        };
        [maskView addImages:imageArr imageFrame:imgFrameArr WithTitle:titleArr titleFrame:titleFrameArr WithNext:nextArr WithNextFrame:nextFrameArr TransparentRect:transparentRectArr orderArr:orderArr goOutRect:goOutFrameArr notSeeRect:notSeeFrameArr];
        [maskView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
    }
    
    else{
        NSArray * imageArr = @[
                               @"new_guid_white",
                               @"new_guid_white",
                               @"new_guid_white",
                               @"new_guid_white",
                               @"new_guid_white",
                               @"new_guid_white",
                               @"new_guid_white",
                               @"new_guid_white",
                               @"new_guid_white"
                               ];
        NSArray * titleArr = @[
                               @"这里是您的钱包哦～ \n您的可用金额都在这里～ \n点击可以查看您的所有资产",
                               @"点击这里可以直接进行法币交易哦～ \n快去交易，兑换您的UG币吧～",
                               @"扫一扫转币，轻松快捷！ 点击扫描对方收币二维码吧～",
                               @"点击转币，手动填写 \n或扫描对方收币信息进行转币!",
                               @"二维码收币，轻松快捷！ \n向对方展示您的收币二维码吧～",
                               @"UG币的收支往来都在这里了 \n点击这里查看账单明细吧！",
                               @"一键委托，轻松兑换 \n点击用您的UG币兑换 \n其他数字货币吧～",
                               @"您的法币交易都记录在这里了 \n随时查看，及时处理交易订单",
                               @"法币交易，消息提醒都在这里哦～"
                               ];
        NSArray * nextArr = @[
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"下一步",
                              @"开始体验"
                              ];
        //轮播图位置
        CGRect rect1 =CGRectMake(5, [UG_MethodsTool navigationBarHeight], UG_SCREEN_WIDTH-10, UG_AutoSize(180));
        //出售购买按钮位置
        CGRect rect2 = CGRectMake(rect1.size.width-UG_AutoSize(140), CGRectGetMaxY(rect1) - UG_AutoSize(60), UG_AutoSize(140), UG_AutoSize(50));
        //扫一扫位置  hasPlatData 根据 是否有平台消息判断 位置
        CGFloat space = (UG_SCREEN_WIDTH-40-3*90)/2.0;
        CGRect rect3 = CGRectMake(20,  CGRectGetMaxY(rect1)+(hasPlatData ? UG_AutoSize(40) : 0), 90, 90);
        //转币位置
        CGRect rect4 = CGRectMake(20+(90+space),  CGRectGetMaxY(rect1)+(hasPlatData ? UG_AutoSize(40) : 0), 90, 90);
        //收币位置
        CGRect rect5 = CGRectMake(20+(180+2*space),  CGRectGetMaxY(rect1)+(hasPlatData ? UG_AutoSize(40) : 0), 90, 90);
        //钱包记录位置
        CGRect rect6 = CGRectMake(20,  CGRectGetMaxY(rect1)+(hasPlatData ? UG_AutoSize(40) : 0)+80, 90, 90);
        //币币兑换位置
        CGRect rect7 = CGRectMake(20+(90+space),  CGRectGetMaxY(rect1)+(hasPlatData ? UG_AutoSize(40) : 0)+80, 90, 90);
        //交易记录位置
        CGRect rect8 = CGRectMake(20+(180+2*space),  CGRectGetMaxY(rect1)+(hasPlatData ? UG_AutoSize(40) : 0)+80, 90, 90);
        //tab位置
        CGRect rect10 = CGRectMake(0, UG_SCREEN_HEIGHT-[UG_MethodsTool tabBarHeight], UG_SCREEN_WIDTH, [UG_MethodsTool tabBarHeight]);
        
        NSArray * imgFrameArr = @[
                                  
                                  [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(15), CGRectGetMaxY(rect1)+UG_AutoSize(20), UG_AutoSize(65), UG_AutoSize(65))],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(rect2.origin.x-UG_AutoSize(35)-UG_AutoSize(65), rect2.origin.y, UG_AutoSize(65), UG_AutoSize(65))],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(CGRectGetMaxX(rect3)+UG_AutoSize(20), rect3.origin.y-UG_AutoSize(20), UG_AutoSize(65), UG_AutoSize(65))],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(rect4.origin.x-UG_AutoSize(35)-UG_AutoSize(65), rect4.origin.y, UG_AutoSize(65), UG_AutoSize(65))],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(rect5.origin.x-UG_AutoSize(35)-UG_AutoSize(65), rect5.origin.y, UG_AutoSize(65), UG_AutoSize(65))],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(CGRectGetMaxX(rect6)+UG_AutoSize(20), rect6.origin.y-UG_AutoSize(20), UG_AutoSize(65), UG_AutoSize(65))],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(rect7.origin.x-UG_AutoSize(35)-UG_AutoSize(65), rect7.origin.y, UG_AutoSize(65), UG_AutoSize(65))],
                                  
                                  [NSValue valueWithCGRect:CGRectMake(rect8.origin.x-UG_AutoSize(35)-UG_AutoSize(65), rect8.origin.y, UG_AutoSize(65), UG_AutoSize(65))],
                                  [NSValue valueWithCGRect:CGRectMake(rect10.origin.x+UG_AutoSize(15), rect10.origin.y-UG_AutoSize(65)-UG_AutoSize(10), UG_AutoSize(65), UG_AutoSize(65))],
                                  ];
        
        NSArray * titleFrameArr = @[
                                    
                                    [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(15+65+10), CGRectGetMaxY(rect1)+UG_AutoSize(10), UG_SCREEN_WIDTH-(rect1.origin.x+UG_AutoSize(15+65+10+10)), UG_AutoSize(90))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(40), CGRectGetMaxY(rect2)+UG_AutoSize(15), UG_SCREEN_WIDTH-2*UG_AutoSize(40), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(rect3.origin.x+UG_AutoSize(20), CGRectGetMaxY(rect3)+UG_AutoSize(10), UG_SCREEN_WIDTH-(rect3.origin.x+UG_AutoSize(20))-UG_AutoSize(25), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(70), CGRectGetMaxY(rect4)+UG_AutoSize(10), UG_SCREEN_WIDTH-(130), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(100), CGRectGetMaxY(rect5)+UG_AutoSize(10),UG_SCREEN_WIDTH-(125), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(rect6.origin.x+UG_AutoSize(20), CGRectGetMaxY(rect6)+UG_AutoSize(10), UG_SCREEN_WIDTH-(rect6.origin.x+UG_AutoSize(20))-UG_AutoSize(25), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(25),  CGRectGetMaxY(rect7)+UG_AutoSize(10),UG_SCREEN_WIDTH-(140), UG_AutoSize(90))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(80), CGRectGetMaxY(rect8)+UG_AutoSize(10),UG_SCREEN_WIDTH-(90), UG_AutoSize(70))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(rect10.origin.x+UG_AutoSize(15+65+10), rect10.origin.y-UG_AutoSize(50)-UG_AutoSize(20), UG_SCREEN_WIDTH-(rect10.origin.x+UG_AutoSize(15+65+10)), UG_AutoSize(50))],
                                    ];
        NSArray * nextFrameArr = @[
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(30+90+35), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect2)+UG_AutoSize(30+70+35), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect3)+UG_AutoSize(30+70+35), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect4)+UG_AutoSize(30+70+35), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect5)+UG_AutoSize(30+70+35), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect6)+UG_AutoSize(10+70+10), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake(UG_SCREEN_WIDTH-UG_AutoSize(125), CGRectGetMaxY(rect7)+UG_AutoSize(40), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect8)+UG_AutoSize(10+50+20), UG_AutoSize(108), UG_AutoSize(40))],
                                   
                                   [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, rect10.origin.y-UG_AutoSize(210), UG_AutoSize(108), UG_AutoSize(40))],
                                   ];
        
        NSArray * goOutFrameArr = @[
                                    
                                    [NSValue valueWithCGRect:CGRectMake(UG_SCREEN_WIDTH-UG_AutoSize(80+40), CGRectGetMaxY(rect1)+UG_AutoSize(30+90+35+60), UG_AutoSize(80), UG_AutoSize(40))],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                    
                                    ];
        
        NSArray * notSeeFrameArr = @[
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                     
                                     [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(160))/2.0, rect10.origin.y-UG_AutoSize(145), UG_AutoSize(160), UG_AutoSize(40))],
                                     ];
        
        NSArray * transparentRectArr = @[
                                         [NSValue valueWithCGRect:rect1],
                                         [NSValue valueWithCGRect:rect2],
                                         [NSValue valueWithCGRect:rect3],
                                         [NSValue valueWithCGRect:rect4],
                                         [NSValue valueWithCGRect:rect5],
                                         [NSValue valueWithCGRect:rect6],
                                         [NSValue valueWithCGRect:rect7],
                                         [NSValue valueWithCGRect:rect8],
                                         [NSValue valueWithCGRect:rect10]
                                         ];
        NSArray * orderArr = @[@1,@1,@1,@1,@1,@1,@1,@1,@1];
        MXRGuideMaskView *maskView = [MXRGuideMaskView new];
        if (view) {
            view(maskView);
        }
        maskView.goOutBlock = ^{
            [UGNewGuidStatusManager shareInstance].homeNewStatus = @"1";
            if (hiden) {
                hiden();
            }
        };
        maskView.notSeeBlock = ^(BOOL isSee) {
            if (hiden) {
                hiden();
            }
            if (isSee) {
                [NSUserDefaultUtil PutDefaults:@"haveShowHomeGuidView" Value:@"1"];
            }else{
                [NSUserDefaultUtil PutDefaults:@"haveShowHomeGuidView" Value:@"0"];
            }
        };
        [maskView addImages:imageArr imageFrame:imgFrameArr WithTitle:titleArr titleFrame:titleFrameArr WithNext:nextArr WithNextFrame:nextFrameArr TransparentRect:transparentRectArr orderArr:orderArr goOutRect:goOutFrameArr notSeeRect:notSeeFrameArr];
        [maskView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
    }
}

#pragma mark - otc列表 新手指引
-(void)setOTCGuidView:(NSInteger)count WithBlock:(void(^)(MXRGuideMaskView *maskView))view WithHiden:(void(^)(void))hiden{
    NSArray * imageArr = nil;
    if (count <= 0) {
        imageArr = @[@"new_guid_white",
                     @"new_guid_white",
                     @"new_guid_white",
                     ];

    }else{
        imageArr = @[@"new_guid_11",
                     @"new_guid_12",
                     @"new_guid_13",
                     @"new_guid_14",
                     @"new_guid_15"
                     ];
    }
    
    NSArray * titleArr = nil;
    if (count <= 0) {
        titleArr = @[
                     @"交易订单可以在这里\n点击直接查看",
                     @"点击这里进行筛选购买/出售列表",
                     @"点击这里就可以直接 \n发布自己的出售/购买广告"
                     ];
    }else{
        titleArr = @[
                     @"",
                     @"",
                     @"",
                     @"",
                     @""
                     ];
    }
    
    NSArray * nextArr = nil;
    if (count <=0) {
        nextArr = @[
                    @"下一步",
                    @"下一步",
                    @"知道了",
                    ];
    }else{
        nextArr = @[
                    @"下一步",
                    @"下一步",
                    @"下一步",
                    @"下一步",
                    @"知道了"
                    ];
    }
    //右上角点击位置-订单
    CGRect rect1 =CGRectMake(UG_SCREEN_WIDTH-UG_AutoSize(9+36), [UG_MethodsTool statusBarHeight]+3, UG_AutoSize(36), UG_AutoSize(36));
    //筛选位置
    CGRect rect2 = CGRectMake(CGRectGetMinX(rect1)-CGRectGetWidth(rect1)-UG_AutoSize(2), CGRectGetMinY(rect1), CGRectGetWidth(rect1), CGRectGetHeight(rect1));
    //发布出售、购买位置
    CGRect rect3 = CGRectMake(130 , [UG_MethodsTool navigationBarHeight],UG_SCREEN_WIDTH-130-15, 50);
    //交易量成功率位置
    CGRect rect4 = CGRectMake(UG_SCREEN_WIDTH-UG_AutoSize(140)-14, CGRectGetMaxY(rect3)+10, UG_AutoSize(140),UG_AutoSize(50));
    //列表展示位置
    CGRect rect5 = CGRectMake(14, CGRectGetMaxY(rect3)+10, UG_SCREEN_WIDTH-28, 110);
 
    NSArray * imgFrameArr = nil;
    NSArray * titleFrameArr = nil;
    NSArray * nextFrameArr = nil;
    NSArray * goOutFrameArr = nil;
    NSArray * notSeeFrameArr = nil;
    
    if (count <= 0){
        imgFrameArr = @[
                        
                        [NSValue valueWithCGRect:CGRectMake(rect1.origin.x-UG_AutoSize(65+20), rect1.origin.y, UG_AutoSize(65), UG_AutoSize(65))],
                        
                        [NSValue valueWithCGRect:CGRectMake(CGRectGetMaxX(rect2)+UG_AutoSize(20), rect2.origin.y-UG_AutoSize(10), UG_AutoSize(65), UG_AutoSize(65))],
                        
                        [NSValue valueWithCGRect:CGRectMake(rect3.origin.x-UG_AutoSize(65+20), rect3.origin.y-UG_AutoSize(10), UG_AutoSize(65), UG_AutoSize(65))]
                        ];
    }else{
        imgFrameArr = @[
                        
                        [NSValue valueWithCGRect:CGRectMake(CGRectGetMaxX(rect1)-4-GetGuideImgSize(imageArr, 0).width, CGRectGetMaxY(rect1), GetGuideImgSize(imageArr, 0).width, GetGuideImgSize(imageArr, 0).height)],
                        
                        [NSValue valueWithCGRect:CGRectMake(CGRectGetMaxX(rect1)-4-GetGuideImgSize(imageArr, 1).width, CGRectGetMaxY(rect2)-3, GetGuideImgSize(imageArr, 1).width, GetGuideImgSize(imageArr, 1).height)],
                        
                        [NSValue valueWithCGRect:CGRectMake(rect3.origin.x-UG_AutoSize(65+20), rect3.origin.y-UG_AutoSize(10), UG_AutoSize(65), UG_AutoSize(65))],
                        
                        [NSValue valueWithCGRect:CGRectMake(rect4.origin.x-UG_AutoSize(85), rect4.origin.y-UG_AutoSize(10), UG_AutoSize(65), UG_AutoSize(65))],
                        
                        [NSValue valueWithCGRect:CGRectMake(rect5.origin.x+UG_AutoSize(20), CGRectGetMaxY(rect5)+UG_AutoSize(15), UG_AutoSize(65), UG_AutoSize(65))],
                        ];
    }
    
    if (count <= 0){
        titleFrameArr = @[
                          
                          [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(80), CGRectGetMaxY(rect1)+UG_AutoSize(20), UG_SCREEN_WIDTH-UG_AutoSize(80), UG_AutoSize(50))],
                          
                          [NSValue valueWithCGRect:CGRectMake(rect2.origin.x+UG_AutoSize(20), CGRectGetMaxY(rect2)+UG_AutoSize(15), UG_SCREEN_WIDTH-(rect2.origin.x+UG_AutoSize(40)), UG_AutoSize(70))],
                          
                          [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(70), CGRectGetMaxY(rect3)+UG_AutoSize(15), UG_SCREEN_WIDTH-UG_AutoSize(70)-14, UG_AutoSize(60))]
                          ];
 
    }else{
        titleFrameArr = @[
                          
                          [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(80), CGRectGetMaxY(rect1)+UG_AutoSize(20), UG_SCREEN_WIDTH-UG_AutoSize(80), UG_AutoSize(50))],
                          
                          [NSValue valueWithCGRect:CGRectMake(rect2.origin.x+UG_AutoSize(20), CGRectGetMaxY(rect2)+UG_AutoSize(15), UG_SCREEN_WIDTH-(rect2.origin.x+UG_AutoSize(40)), UG_AutoSize(70))],
                          
                           [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(70), CGRectGetMaxY(rect3)+UG_AutoSize(15), UG_SCREEN_WIDTH-UG_AutoSize(70)-14, UG_AutoSize(60))],
                          
                          [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(80), CGRectGetMaxY(rect4)+UG_AutoSize(15), UG_SCREEN_WIDTH-UG_AutoSize(90), UG_AutoSize(70))],
                          
                          [NSValue valueWithCGRect:CGRectMake(rect5.origin.x+UG_AutoSize(20+65+15), CGRectGetMaxY(rect5)+UG_AutoSize(30), UG_SCREEN_WIDTH-(rect5.origin.x+UG_AutoSize(20+65+15+10)), UG_AutoSize(70))]
                          ];
    }
    
    if (count <= 0){
        nextFrameArr = @[
                         
                         [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(90), UG_AutoSize(108), UG_AutoSize(40))],
                         
                         [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect2)+UG_AutoSize(125), UG_AutoSize(108), UG_AutoSize(40))],
                         
                         [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect3)+UG_AutoSize(125), UG_AutoSize(108), UG_AutoSize(40))]
                         ];
    }else{
        nextFrameArr = @[
                         
                        [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(GetGuideNSValueRect(imgFrameArr, 0))+50, UG_AutoSize(108), UG_AutoSize(40))],
                         
                         [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect2)+UG_AutoSize(125)+30, UG_AutoSize(108), UG_AutoSize(40))],
                         
                         [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect3)+UG_AutoSize(125), UG_AutoSize(108), UG_AutoSize(40))],
                         
                         [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect4)+UG_AutoSize(140), UG_AutoSize(108), UG_AutoSize(40))],
                         
                         [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect5)+UG_AutoSize(140), UG_AutoSize(108), UG_AutoSize(40))]
                         ];
    }
    
    if (count <= 0){
        goOutFrameArr = @[
                          
                          [NSValue valueWithCGRect:CGRectMake(UG_SCREEN_WIDTH-UG_AutoSize(80+40), CGRectGetMaxY(rect1)+UG_AutoSize(160), UG_AutoSize(80), UG_AutoSize(40))],
                          
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                          
                          [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)]

                          ];
    }else{
       
        goOutFrameArr = @[
                                    
                            [NSValue valueWithCGRect:CGRectMake(UG_SCREEN_WIDTH-UG_AutoSize(80+40), CGRectGetMaxY(rect1)+UG_AutoSize(160)+30, UG_AutoSize(80), UG_AutoSize(40))],
                            
                            [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                            
                            [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                            
                            [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                            
                            [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)]
                        ];
    }
    
    if (count <= 0){
        notSeeFrameArr = @[
                           [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                           
                           [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                           
                           [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                           ];
    }else{
        
        notSeeFrameArr = @[
                           [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                           
                           [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                           
                           [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                           
                           [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                           
                           [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(160))/2.0, CGRectGetMaxY(rect5)+UG_AutoSize(200), UG_AutoSize(160), UG_AutoSize(40))],
                        ];

    }

    NSArray * transparentRectArr = nil;
    if (count <= 0){
          transparentRectArr = @[
                                 [NSValue valueWithCGRect:rect1],
                                 [NSValue valueWithCGRect:rect2],
                                 [NSValue valueWithCGRect:rect3]
                                 ];
      }else{
          transparentRectArr = @[
                                 [NSValue valueWithCGRect:rect1],
                                 [NSValue valueWithCGRect:rect2],
                                 [NSValue valueWithCGRect:rect3],
                                 [NSValue valueWithCGRect:rect4],
                                 [NSValue valueWithCGRect:rect5]
                                 ];
      }
    NSArray * orderArr = nil;
    if (count <= 0){
        orderArr = @[@1,@1,@1];
    }else{
        orderArr = @[@1,@1,@1,@1,@1];
    }
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    if (view) {
        view(maskView);
    }
    maskView.goOutBlock = ^{
        if (hiden) {
            hiden();
        }
        [UGNewGuidStatusManager shareInstance].OTCStatus = @"1";
    };
    maskView.notSeeBlock = ^(BOOL isSee) {
        if (hiden) {
            hiden();
        }
        if (isSee) {
            [NSUserDefaultUtil PutDefaults:@"haveShowOTCGuidView" Value:@"1"];
        }else{
            [NSUserDefaultUtil PutDefaults:@"haveShowOTCGuidView" Value:@"0"];
        }
    };
    [maskView addImages:imageArr imageFrame:imgFrameArr WithTitle:titleArr titleFrame:titleFrameArr WithNext:nextArr WithNextFrame:nextFrameArr TransparentRect:transparentRectArr orderArr:orderArr goOutRect:goOutFrameArr notSeeRect:notSeeFrameArr];
    [maskView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
}


#pragma mark - 购买、出售页 新手引导
- (void)setupOTCBuyOrSellNewGuideView:(BOOL)isBuy WithBlock:(void(^)(MXRGuideMaskView *maskView))view{
    NSArray * imageArr = @[@"new_guid_white",
                           ];
    NSString *str = [NSString stringWithFormat:isBuy ? @"输入购买金额 \n或点击全部买入进行购买" : @"输入出售金额 \n或点击全部卖出进行出售"];
    
    NSArray * titleArr = @[
                           str
                           ];
    NSArray * nextArr = @[
                          @"下一步",
                          ];
    
    CGRect rect1 =CGRectMake(14, [UG_MethodsTool navigationBarHeight]+168, UG_SCREEN_WIDTH-28, UG_AutoSize(151));
    
    NSArray * imgFrameArr = @[
                              
                              [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(35), CGRectGetMaxY(rect1)+UG_AutoSize(20), UG_AutoSize(65), UG_AutoSize(65))],
                              ];
    
    NSArray * titleFrameArr = @[
                                
                                [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(35+65+10), CGRectGetMaxY(rect1)+UG_AutoSize(30), UG_SCREEN_WIDTH-(rect1.origin.x+UG_AutoSize(35+65+10+20)), UG_AutoSize(60))],
                                ];
    NSArray * nextFrameArr = @[
                               
                               [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(30+60+20), UG_AutoSize(108), UG_AutoSize(40))],
                               ];
    
    NSArray *  goOutFrameArr = @[
                          
                          [NSValue valueWithCGRect:CGRectMake(UG_SCREEN_WIDTH-UG_AutoSize(80+40), CGRectGetMaxY(rect1)+UG_AutoSize(30+60+20+50), UG_AutoSize(80), UG_AutoSize(40))],
                          ];
   
    
    NSArray *notSeeFrameArr = @[
                                 [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                 ];
    
    NSArray * transparentRectArr = @[
                                     [NSValue valueWithCGRect:rect1],
                                     ];
    // @[@3]
    // @[@1,@1,@1]
    NSArray * orderArr = @[@1];
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    if (view) {
        view(maskView);
    }
    maskView.goOutBlock = ^{
        if(isBuy)
        {
            [UGNewGuidStatusManager shareInstance].OTCBuyStatus = @"1";
        }else{
            [UGNewGuidStatusManager shareInstance].OTCSellStatus = @"1";
        }
    };
    [maskView addImages:imageArr imageFrame:imgFrameArr WithTitle:titleArr titleFrame:titleFrameArr WithNext:nextArr WithNextFrame:nextFrameArr TransparentRect:transparentRectArr orderArr:orderArr goOutRect:goOutFrameArr notSeeRect:notSeeFrameArr];
    [maskView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - 等待支付页面 新手引导
- (void)setupWaitingForPayNewGuideView:(NSInteger)num WithBlock:(void(^)(MXRGuideMaskView *maskView))view{
    NSArray * imageArr = @[@"new_guid_white",
                           ];
    NSArray * titleArr = @[
                            @"选择对方提供的支付方式进行付款。 \n若没绑定任何支付方式， \n请根据提示前往绑定。"
                           ];
    NSArray * nextArr = @[
                          @"下一步",
                          ];
    
    CGRect rect1 =CGRectMake( UG_AutoSize(14), [UG_MethodsTool navigationBarHeight]+204, UG_SCREEN_WIDTH-28, UG_AutoSize(150)/3.0 * num);
    
    NSArray * imgFrameArr = @[
                              
                              [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(14), CGRectGetMaxY(rect1)+UG_AutoSize(20), UG_AutoSize(65), UG_AutoSize(65))],
                              ];
    
    NSArray * titleFrameArr = @[
                                
                                [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(15+65), CGRectGetMaxY(rect1)+UG_AutoSize(10), UG_SCREEN_WIDTH-UG_AutoSize(15+65), UG_AutoSize(120))],
                                ];
    NSArray * nextFrameArr = @[
                               
                               [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(108))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(10+125), UG_AutoSize(108), UG_AutoSize(40))],
                               ];
    
    NSArray *goOutFrameArr = @[
                                [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                ];
    
    NSArray *notSeeFrameArr = @[
                                [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                ];
    
    NSArray * transparentRectArr = @[
                                     [NSValue valueWithCGRect:rect1],
                                     ];
    // @[@3]
    // @[@1,@1,@1]
    NSArray * orderArr = @[@1];
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    if (view) {
        view(maskView);
    }
    [maskView addImages:imageArr imageFrame:imgFrameArr WithTitle:titleArr titleFrame:titleFrameArr WithNext:nextArr WithNextFrame:nextFrameArr TransparentRect:transparentRectArr orderArr:orderArr goOutRect:goOutFrameArr notSeeRect:notSeeFrameArr];
    [maskView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - 付款页面 新手引导
- (void)setupPayNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view{
    NSArray * imageArr = @[@"new_guid_white",
                           ];
    NSArray * titleArr = @[
                           @"使用您的银行卡或打开您的支付宝、微信、云闪付，向上面的收款账号转账"
                           ];
    NSArray * nextArr = @[
                          @"下一步",
                          ];
    
    CGRect rect1 =CGRectMake(14, [UG_MethodsTool navigationBarHeight]+150, UG_SCREEN_WIDTH-28, UG_AutoSize(204));
    
    NSArray * imgFrameArr = @[
                              
                              [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(20),CGRectGetMaxY(rect1)+UG_AutoSize(20), UG_AutoSize(65), UG_AutoSize(65))],
                              ];
    
    NSArray * titleFrameArr = @[
                                
                                [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(20+65+10), CGRectGetMaxY(rect1)+UG_AutoSize(30), UG_SCREEN_WIDTH-(rect1.origin.x+UG_AutoSize(20+65+10))-UG_AutoSize(20), UG_AutoSize(70))],
                                ];
    NSArray * nextFrameArr = @[
                               
                               [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH- UG_AutoSize(108))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(130), UG_AutoSize(108), UG_AutoSize(40))],
                               ];
    NSArray *goOutFrameArr = @[
                               [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                               ];
    
    NSArray *notSeeFrameArr = @[
                                [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                                ];
    
    NSArray * transparentRectArr = @[
                                     [NSValue valueWithCGRect:rect1],
                                     ];
    // @[@3]
    // @[@1,@1,@1]
    NSArray * orderArr = @[@1];
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    if (view) {
        view(maskView);
    }
    [maskView addImages:imageArr imageFrame:imgFrameArr WithTitle:titleArr titleFrame:titleFrameArr WithNext:nextArr WithNextFrame:nextFrameArr TransparentRect:transparentRectArr orderArr:orderArr goOutRect:goOutFrameArr notSeeRect:notSeeFrameArr];
    [maskView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - 购买已付款页面 新手引导
- (void)setupHavePayNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view{
    NSArray * imageArr = @[@"new_guid_white",
                           ];
    NSArray * titleArr = @[
                           @"付款后，请耐心等待卖家放币 \n若卖家超过2小时未放币，您可进行申诉"
                           ];
    NSArray * nextArr = @[
                          @"知道了",
                          ];
    
    CGRect rect1 =CGRectMake(UG_SCREEN_WIDTH-125-14, [UG_MethodsTool navigationBarHeight]+115, 125, 40);
    
    NSArray * imgFrameArr = @[
                              
                              [NSValue valueWithCGRect:CGRectMake(rect1.origin.x-65-20, rect1.origin.y-UG_AutoSize(10), UG_AutoSize(65), UG_AutoSize(65))],
                              ];
    
    NSArray * titleFrameArr = @[
                                
                                [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(25), CGRectGetMaxY(rect1)+UG_AutoSize(20), UG_SCREEN_WIDTH-2*UG_AutoSize(25), UG_AutoSize(70))],
                                ];
    NSArray * nextFrameArr = @[
                               
                               [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH- UG_AutoSize(108))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(120), UG_AutoSize(108), UG_AutoSize(40))],
                               ];
    NSArray *goOutFrameArr = @[
                               [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                               ];
    
    NSArray *notSeeFrameArr = @[
                                 [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(160))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(170), UG_AutoSize(160), UG_AutoSize(40))],
                                ];
    
    NSArray * transparentRectArr = @[
                                     [NSValue valueWithCGRect:rect1],
                                     ];
    NSArray * orderArr = @[@1];
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    if (view) {
        view(maskView);
    }
    maskView.notSeeBlock = ^(BOOL isSee) {
        if (isSee) {
            [NSUserDefaultUtil PutDefaults:@"haveIsBuyGuidView" Value:@"1"];
        }else{
            [NSUserDefaultUtil PutDefaults:@"haveIsBuyGuidView" Value:@"0"];
        }
    };
    [maskView addImages:imageArr imageFrame:imgFrameArr WithTitle:titleArr titleFrame:titleFrameArr WithNext:nextArr WithNextFrame:nextFrameArr TransparentRect:transparentRectArr orderArr:orderArr goOutRect:goOutFrameArr notSeeRect:notSeeFrameArr];
    [maskView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - 出售未付款页面 新手引导
- (void)setupDoNotPayNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view{
    NSArray * imageArr = @[@"new_guid_white",
                           ];
    NSArray * titleArr = @[
                           @"出售金额已冻结请耐心等待买方付款， \n若买方未在30分钟内进行付款，则订 \n单自动取消"
                           ];
    NSArray * nextArr = @[
                          @"知道了",
                          ];
    
    CGRect rect1 =CGRectMake(UG_SCREEN_WIDTH-145-14, [UG_MethodsTool navigationBarHeight]+95, 145, 60);
    
    NSArray * imgFrameArr = @[
                              
                              [NSValue valueWithCGRect:CGRectMake(rect1.origin.x-65-20, rect1.origin.y-UG_AutoSize(10), UG_AutoSize(65), UG_AutoSize(65))],
                              ];
    
    NSArray * titleFrameArr = @[
                                
                                [NSValue valueWithCGRect:CGRectMake(UG_AutoSize(15), CGRectGetMaxY(rect1)+UG_AutoSize(20), UG_SCREEN_WIDTH-2*UG_AutoSize(15), UG_AutoSize(100))],
                                ];
    NSArray * nextFrameArr = @[
                               
                               [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH- UG_AutoSize(108))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(140), UG_AutoSize(108), UG_AutoSize(40))],
                               ];
    NSArray *goOutFrameArr = @[
                               [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                               ];
    
    NSArray *notSeeFrameArr = @[
                                [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(160))/2.0,CGRectGetMaxY(rect1)+UG_AutoSize(190), UG_AutoSize(160), UG_AutoSize(40))],
                                ];
    
    NSArray * transparentRectArr = @[
                                     [NSValue valueWithCGRect:rect1],
                                     ];
    NSArray * orderArr = @[@1];
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    if (view) {
        view(maskView);
    }
    maskView.notSeeBlock = ^(BOOL isSee) {
        if (isSee) {
            [NSUserDefaultUtil PutDefaults:@"haveIsSellGuidView" Value:@"1"];
        }else{
            [NSUserDefaultUtil PutDefaults:@"haveIsSellGuidView" Value:@"0"];
        }
    };
    [maskView addImages:imageArr imageFrame:imgFrameArr WithTitle:titleArr titleFrame:titleFrameArr WithNext:nextArr WithNextFrame:nextFrameArr TransparentRect:transparentRectArr orderArr:orderArr goOutRect:goOutFrameArr notSeeRect:notSeeFrameArr];
    [maskView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - 我的发布页面 新手引导
- (void)setupMineAdNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view WithHiden:(void(^)(void))hiden{
    NSArray * imageArr = @[@"new_guid_white",
                           ];
    NSArray * titleArr = @[
                           @"交易发布后可以在这里 \n进行下架和修改操作哦"
                           ];
    NSArray * nextArr = @[
                          @"知道了",
                          ];
    
    CGRect rect1 =CGRectMake(14, [UG_MethodsTool navigationBarHeight]+10, UG_SCREEN_WIDTH-28, 165);
    
    NSArray * imgFrameArr = @[
                              
                              [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(40), CGRectGetMaxY(rect1)+20, UG_AutoSize(65), UG_AutoSize(65))],
                              ];
    
    NSArray * titleFrameArr = @[
                                
                                [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(40+65+10), CGRectGetMaxY(rect1)+UG_AutoSize(30), UG_SCREEN_WIDTH-(UG_AutoSize(40+65+10))-14, UG_AutoSize(60))],
                                ];
    NSArray * nextFrameArr = @[
                               
                               [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH- UG_AutoSize(108))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(120), UG_AutoSize(108), UG_AutoSize(40))],
                               ];
    NSArray *goOutFrameArr = @[
                               [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                               ];
    
    NSArray *notSeeFrameArr = @[
                                [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(160))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(170), UG_AutoSize(160), UG_AutoSize(40))],
                                ];
    
    NSArray * transparentRectArr = @[
                                     [NSValue valueWithCGRect:rect1],
                                     ];
    NSArray * orderArr = @[@1];
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    if (view) {
        view(maskView);
    }
    maskView.goOutBlock = ^{
        if (hiden) {
            hiden();
        }
        [UGNewGuidStatusManager shareInstance].AdStatus = @"1";
    };
    maskView.notSeeBlock = ^(BOOL isSee) {
        if (hiden) {
            hiden();
        }
        if (isSee) {
            [NSUserDefaultUtil PutDefaults:@"haveMineAd" Value:@"1"];
        }else{
            [NSUserDefaultUtil PutDefaults:@"haveMineAd" Value:@"0"];
        }
    };
    [maskView addImages:imageArr imageFrame:imgFrameArr WithTitle:titleArr titleFrame:titleFrameArr WithNext:nextArr WithNextFrame:nextFrameArr TransparentRect:transparentRectArr orderArr:orderArr goOutRect:goOutFrameArr notSeeRect:notSeeFrameArr];
    [maskView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - 转币页面 新手引导
- (void)setupTransferNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view{
    NSArray * imageArr = @[@"new_guid_white",
                           ];
    NSArray * titleArr = @[
                           @"输入发送金额，扫码或手动输入收币钱包地址，输入接受用户ID",
                           ];
    NSArray * nextArr = @[
                          @"知道了",
                          ];
    
    CGRect rect1 =CGRectMake(10, [UG_MethodsTool navigationBarHeight]+20, UG_SCREEN_WIDTH-20, 189);
    
    NSArray * imgFrameArr = @[
                              
                              [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(15), CGRectGetMaxY(rect1)+UG_AutoSize(20), UG_AutoSize(65), UG_AutoSize(65))],
                              ];
    
    NSArray * titleFrameArr = @[
                                
                                [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(15+65+10), CGRectGetMaxY(rect1)+UG_AutoSize(20), UG_SCREEN_WIDTH-(UG_AutoSize(15+65+10))-14, UG_AutoSize(90))],
                                ];
    NSArray * nextFrameArr = @[
                               
                                [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH- UG_AutoSize(108))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(120), UG_AutoSize(108), UG_AutoSize(40))],
                               ];
    NSArray *goOutFrameArr = @[
                               [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
                               ];
    
    NSArray *notSeeFrameArr = @[
                               
                                [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(160))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(175), UG_AutoSize(160), UG_AutoSize(40))],

                                [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)]
                                ];
    
    NSArray * transparentRectArr = @[
                                     [NSValue valueWithCGRect:rect1],
                                     ];
    NSArray * orderArr = @[@1];
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    if (view) {
        view(maskView);
    }
    maskView.goOutBlock = ^{
        [UGNewGuidStatusManager shareInstance].TransferStatus = @"1";
    };
    maskView.notSeeBlock = ^(BOOL isSee) {
        if (isSee) {
            [NSUserDefaultUtil PutDefaults:@"haveTransfer" Value:@"1"];
        }else{
            [NSUserDefaultUtil PutDefaults:@"haveTransfer" Value:@"0"];
        }
    };
    [maskView addImages:imageArr imageFrame:imgFrameArr WithTitle:titleArr titleFrame:titleFrameArr WithNext:nextArr WithNextFrame:nextFrameArr TransparentRect:transparentRectArr orderArr:orderArr goOutRect:goOutFrameArr notSeeRect:notSeeFrameArr  ];
    [maskView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
}

#pragma mark - 币币兑换页面 新手引导
- (void)setupConinChangeNewGuideViewWithBlock:(void(^)(MXRGuideMaskView *maskView))view{
    NSArray * imageArr = @[@"new_guid_white",
                           ];
    NSArray * titleArr = @[
                           @"选择要兑换的币种 \n输入卖出UG及兑换币种",
                           ];
    NSArray * nextArr = @[
                          @"知道了",
                          ];
    
    CGRect rect1 =CGRectMake(10, [UG_MethodsTool navigationBarHeight]+9, UG_SCREEN_WIDTH-20, 190);
    
    NSArray * imgFrameArr = @[
                              
                              [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+20, CGRectGetMaxY(rect1)+20, UG_AutoSize(65), UG_AutoSize(65))],
                              ];
    
    NSArray * titleFrameArr = @[
                                
                                [NSValue valueWithCGRect:CGRectMake(rect1.origin.x+UG_AutoSize(20+65+10), CGRectGetMaxY(rect1)+UG_AutoSize(20), UG_SCREEN_WIDTH-(rect1.origin.x+UG_AutoSize(20+65+10))-14, UG_AutoSize(60))],
                                ];
    NSArray * nextFrameArr = @[
                               
                               [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH- UG_AutoSize(108))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(115), UG_AutoSize(108), UG_AutoSize(40))],
                               ];
    NSArray *goOutFrameArr = @[
                               [NSValue valueWithCGRect:CGRectMake(0, 0, 0, 0)],
  
                               ];
    
    NSArray *notSeeFrameArr = @[
                                [NSValue valueWithCGRect:CGRectMake((UG_SCREEN_WIDTH-UG_AutoSize(160))/2.0, CGRectGetMaxY(rect1)+UG_AutoSize(165), UG_AutoSize(160), UG_AutoSize(40))],

                                ];
    NSArray * transparentRectArr = @[
                                     [NSValue valueWithCGRect:rect1],
                                     ];
    NSArray * orderArr = @[@1];
    MXRGuideMaskView *maskView = [MXRGuideMaskView new];
    if (view) {
        view(maskView);
    }
    maskView.goOutBlock = ^{
        [UGNewGuidStatusManager shareInstance].CoinToCoinStatus = @"1";
    };
    maskView.notSeeBlock = ^(BOOL isSee) {
        if (isSee) {
            [NSUserDefaultUtil PutDefaults:@"haveConinChange" Value:@"1"];
        }else{
            [NSUserDefaultUtil PutDefaults:@"haveConinChange" Value:@"0"];
        }
    };
    [maskView addImages:imageArr imageFrame:imgFrameArr WithTitle:titleArr titleFrame:titleFrameArr WithNext:nextArr WithNextFrame:nextFrameArr TransparentRect:transparentRectArr orderArr:orderArr goOutRect:goOutFrameArr notSeeRect:notSeeFrameArr];
    [maskView showMaskViewInView:[UIApplication sharedApplication].keyWindow];
}

@end
