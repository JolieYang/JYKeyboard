//
//  JYViewInput.h
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYKeyboard;

@protocol JYViewInput
@required
- (NSString*)inputText;
@optional
- (void)keyboard:(id<JYKeyboard>)keyboard textField:(UITextField*)textField doUpdateText:(NSString*)text;
- (NSString*)inputInitText;
- (NSString*)inputDisplayText;
@end

@protocol UIViewInputDelegate <NSObject>

@end

@interface UIView (JYViewInput)<UITextFieldDelegate, JYViewInput>
@property (nonatomic, retain, readonly) UITextField *associateKeyboardTextField;
@property (nonatomic, assign) id<UIViewInputDelegate> delegate;

- (void)setInputViewWithTextField:(UITextField*)textField;// TODO --> setInputViewWithOriginKB
- (void)setInputViewWithKeyboard:(id<JYKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry;
@end
