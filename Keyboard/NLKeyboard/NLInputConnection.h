//
//  NLInputConnection.h
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NLKeyboard;

@protocol NLInputConnection
@required
- (NSString*)inputText;
@optional
- (void)keyboard:(id<NLKeyboard>)keyboard textField:(UITextField*)textField doUpdateText:(NSString*)text;
- (NSString*)inputInitText;
- (NSString*)inputDisplayText;
@end

@interface UIView (NLInputConnection)<UITextFieldDelegate, NLInputConnection>
@property (nonatomic, retain, readonly) UITextField *associateKeyboardTextField;
@property (nonatomic, assign) id<UITextFieldDelegate> textFieldDelegate;

- (void)setInputViewWithTextField:(UITextField*)textField;
- (void)setInputViewWithKeyboard:(id<NLKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry delegate:(id<UITextFieldDelegate>)delegate;
@end

@interface UILabel (NLInputConnection)<NLInputConnection>
@end