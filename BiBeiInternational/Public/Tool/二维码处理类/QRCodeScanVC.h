//
//  QRCodeScanVC.h
//  BiBeiInternational
//
//  Created by keniu on 2019/7/23.
//  Copyright © 2019 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//扫描成功回调
typedef void(^QrcodeScanResult)(NSString *resultString);

@interface QRCodeScanVC : UIViewController

@property (nonatomic,copy)QrcodeScanResult QrcodeScanResult;

@end

NS_ASSUME_NONNULL_END
