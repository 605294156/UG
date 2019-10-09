//
//  UGShareManager.h
//  BiBeiInternational
//
//  Created by conew on 2018/10/22.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UGShareManager : NSObject
+ (instancetype)shareManager;
-(UIActivityViewController *)createWithTitie:(NSString *)title withActivityImage:(UIImage *)image withUrl:(NSURL *)url withType:(NSString *)type;
@end
