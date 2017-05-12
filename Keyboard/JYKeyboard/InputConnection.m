//
//  InputConnection.m
//  Keyboard
//
//  Created by Jolie_Yang on 16/7/25.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "InputConnection.h"

@implementation UIView(NLInputConnection)

//@dynamic textFieldDelegate;
//@dynamic associatedKeyboardTextField;

- (void)awakeFromNib {
    NSLog(@"awakeFromNib");
    self.associatedKeyboardTextField = [[UITextField alloc] initWithFrame:self.frame];
}

- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect");
}

- (void)setInputViewWithTextField:(UITextField *)textField {
    [self enabledTextField];
}
- (void)setInputViewWithKeyboard:(id<NLKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry delegate:(id<UITextFieldDelegate>)delegate {
    
}

- (void)setInputViewWithKB:(NLAbstractKeyboard *)keyboard secureTextEntry:(BOOL)secureTextEntry delegate:(id<UITextFieldDelegate>)delegate {
    self.associatedKeyboardTextField.inputView = (UIView *)keyboard;
}
- (void)enabledTextField {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(addKeyboard:)];
    [self addGestureRecognizer:ges];
}
- (void)addKeyboard:(UITapGestureRecognizer *)recognizer {
    UIView *view = recognizer.view;
    [view becomeFirstResponder];
}

- (void)keyboard:(id<NLKeyboard>)keyboard textField:(UITextField*)textField doUpdateText:(NSString*)text {
    
}
@end

@implementation UILabel(NLInputConnection)
//- (id)initWithFrame:(CGRect)frame {
//    if (self = [super initWithFrame:frame]) {
////        self.multipleTouchEnabled = YES;
//    }
//    self.text = @"Rose";
//    return self;
//}
//- (id)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        if ([self respondsToSelector:@selector(setInputViewWithTextField:)]) {
//            
//        }
//    }
//    return self;
//}

- (void)keyboard:(id<NLKeyboard>)keyboard textField:(UITextField*)textField doUpdateText:(NSString*)text {
    NSLog(@"doUpdateText");
}
@end