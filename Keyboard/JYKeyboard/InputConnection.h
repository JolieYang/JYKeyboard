//
//  InputConnection.h
//  Keyboard
//
//  Created by Jolie_Yang on 16/7/25.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Keyboard.h"

@protocol NLKeyboard;

@protocol NLInputConnection <NSObject>
- (void)keyboard:(id<NLKeyboard>)keyboard textField:(UITextField*)textField doUpdateText:(NSString*)text;
@end

@interface UIView(NLInputConnection)<UITextFieldDelegate, NLInputConnection>
@property (nonatomic, assign) id<UITextFieldDelegate> textFieldDelegate;
//@property (nonatomic, retain, readonly) UITextField *associatedKeyboardTextField;
@property (nonatomic, retain) UITextField *associatedKeyboardTextField;

- (void)setInputViewWithTextField:(UITextField *)textField;

- (void)setInputViewWithKeyboard:(id<NLKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry delegate:(id<UITextFieldDelegate>)delegate;
- (void)setInputViewWithKB:(NLAbstractKeyboard *)keyboard secureTextEntry:(BOOL)secureTextEntry delegate:(id<UITextFieldDelegate>)delegate;
@end

@interface UILabel(NLInputConnection)<NLInputConnection>
@end
