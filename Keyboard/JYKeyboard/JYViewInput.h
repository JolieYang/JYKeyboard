//
//  JYViewInput.h
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYKeyboard;
@class JYKeyboardConfig;

typedef void(^JYViewInputSystemKeyboardConfigBlock)(JYKeyboardConfig *config);

@protocol UIViewInputDelegate <NSObject>
@optional
- (NSString *)inputSourceDefaultText:(UIView *)inputSource;

- (BOOL)inputSource:(UIView *)inputSource shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)inputSource:(UIView *)inputSourece didChangeText:(NSString *)text;
- (void)inputSource:(UIView *)inputSource updateDisplayText:(NSString *)displayText;

- (BOOL)inputSourceShouldClear:(UIView *)inputSource;
- (BOOL)inputSourceShouldReturn:(UIView *)inputSource;
@end

@interface UIView (JYViewInput)<UITextFieldDelegate>
@property (nonatomic, retain, readonly) UITextField *associateKeyboardTextField;
@property (nonatomic, assign) id<UIViewInputDelegate> inputDelegate;

- (void)setSystemKeyboardWithConfigBlock:(JYViewInputSystemKeyboardConfigBlock)configBlock;
- (void)setCustomKeyboard:(id<JYKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry;
@end

@interface JYKeyboardConfig : NSObject<UITextInputTraits>
@end
