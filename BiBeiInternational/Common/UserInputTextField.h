//
//  UserInputTextField.h
//  UserInputTextField
//
//  Created by zsm on 2018/5/11.
//  Copyright © 2018年 XinHuoKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserInputTextField;

@protocol UserInputTextFieldDelegate <NSObject>

//工具类 自定义实现代理方法

/**
 需要使用代理的时候可根据需要在代理中添加实现方法

 @param textField textField 继承自UITextField
 @param range range 继承自UITextField
 @param string string 继承自UITextField
 @param hasDot 是否有输入过小数点
 @return 返回是否可输入
 */
- (BOOL)userInputTextField:(UserInputTextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string hasDot:(BOOL)hasDot;

@end

@interface UserTextFieldHelper : NSObject <UITextFieldDelegate>

@property (nonatomic, weak) UserInputTextField *helpObject;

@property (nonatomic, assign) BOOL hasDot;

@property (nonatomic, weak) id<UserInputTextFieldDelegate> delegate;


@end


/**
 控制输入小数点
 */
@interface UserInputTextField : UITextField

@property (nonatomic, strong)UserTextFieldHelper *helper;

@end
