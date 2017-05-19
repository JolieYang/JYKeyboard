//
//  JYViewInput.h
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYKeyboard.h"

@protocol JYKeyboard;
@class JYKeyboardConfig;

typedef void(^JYViewInputSystemKeyboardConfigBlock)(JYKeyboardConfig *config);

@protocol UIViewInputDelegate <NSObject>
@optional
- (NSString *)inputSourceDefaultText:(UIView *)inputSource;

- (BOOL)inputSource:(UIView *)inputSource shouldChangeText:(NSString *)text replacementString:(NSString *)string;
- (void)inputSource:(UIView *)inputSource didChangeText:(NSString *)text;
- (void)inputSource:(UIView *)inputSource updateDisplayText:(NSString *)displayText;

- (BOOL)inputSourceShouldClear:(UIView *)inputSource;
- (BOOL)inputSourceShouldReturn:(UIView *)inputSource;
@end

@interface UIView (JYViewInput)<UITextFieldDelegate,JYKeyboardDelegate,UITextViewDelegate, UISearchBarDelegate>
@property (nonatomic, retain, readonly) UITextField *associateKeyboardTextField;
@property (nonatomic, assign) id<UIViewInputDelegate> viewInputDelegate;

// 无输入源控件设置原生键盘
- (void)noInputControlSetSystemKeyboardWithConfigBlock:(JYViewInputSystemKeyboardConfigBlock)configBlock;

// 支持所有控件，无论控件本身是否有输入源
- (void)setCustomKeyboard:(id<JYKeyboard>)keyboard;
- (void)setCustomKeyboard:(id<JYKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry;

- (BOOL)systemCanInputSource;
@end

@interface JYKeyboardConfig : NSObject<UITextInputTraits>
@end
