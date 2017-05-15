//
//  NLKeyboardNumberPad.h
//  NLKeyboard
//
//  Created by su on 16/4/11.
//  Copyright © 2016年 suzw. All rights reserved.
//

#import "NLKeyboard.h"

@interface NLKeyboardNumberPad : NLAbstractKeyboard<UITextFieldDelegate>
/**
 随机数字键盘，按键无点击效果
 */
+ (id)securityKeyboard;
/**
 顺序数字键盘，按键有点击效果
 */
+ (id)standardKeyboard;
/**
 随机数字键盘，按键有点击效果
 */
+ (id)standardShuffledKeyboard;
@end
