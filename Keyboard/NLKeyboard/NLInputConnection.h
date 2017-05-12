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
- (NSString*)inputInitText;
- (NSString*)inputDisplayText;
- (void)keyboard:(id<NLKeyboard>)keyboard textField:(UITextField*)textField doUpdateText:(NSString*)text;
@optional
- (NSString*)inputText;
@end

@interface UIView (NLInputConnection)<UITextFieldDelegate, NLInputConnection>
@property (nonatomic, assign) id<UITextFieldDelegate> textFieldDelegate;
@property (nonatomic, retain, readonly) UITextField *associateKeyboardTextField;
- (void)setInputViewWithTextField:(UITextField*)textField;
- (void)setInputViewWithKeyboard:(id<NLKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry delegate:(id<UITextFieldDelegate>)delegate;
@end

@interface UILabel (NLInputConnection)<NLInputConnection>

@end