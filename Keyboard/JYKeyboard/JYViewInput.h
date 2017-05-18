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

@protocol JYViewInput
@required
- (NSString*)inputText;
@optional
- (void)keyboard:(id<JYKeyboard>)keyboard textField:(UITextField*)textField doUpdateText:(NSString*)text;
- (NSString*)inputInitText;
- (NSString*)inputDisplayText;
@end

// TODO
@protocol UIViewInputDelegate <NSObject>
@optional
- (void)inputSource:(UIView *)inputSource shouldChangeCharactersInRange:(NSRange *)range replacementString:(NSString *)string;
- (void)inputSource:(UIView *)inputSourece didChangeText:(NSString *)text;
- (BOOL)inputSourceShouldClear:(UIView *)inputSource;
- (BOOL)inputSourceShouldReturn:(UIView *)inputSource;
@end

@interface UIView (JYViewInput)<UITextFieldDelegate, JYViewInput>
@property (nonatomic, retain, readonly) UITextField *associateKeyboardTextField;
@property (nonatomic, assign) id<UIViewInputDelegate> inputDelegate;

- (void)setSystemKeyboardWithConfigBlock:(JYViewInputSystemKeyboardConfigBlock)configBlock;
- (void)setInputViewWithKeyboard:(id<JYKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry;
@end

@interface JYKeyboardConfig : NSObject<UITextInputTraits>
@end
