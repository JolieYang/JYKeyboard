//
//  NLInputConnection.m
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "NLInputConnection.h"
#import "NLKeyboard.h"
#import <objc/runtime.h>

@implementation UIView(NLInputConnection)
static NSString *secureText = @"●";
static char *textFieldDelegateKey = "textFieldDelegateKey";
static void *associateKeyboardTextFieldKey = &associateKeyboardTextFieldKey;
static void *delegateKey = &delegateKey;

- (void)setInputViewWithTextField:(UITextField*)textField {
//    textField.hidden = YES;
    [self addSubview:textField];
    self.associateKeyboardTextField = textField;
    self.associateKeyboardTextField.returnKeyType = UIReturnKeyDone;
    self.associateKeyboardTextField.enablesReturnKeyAutomatically = YES;
    self.associateKeyboardTextField.delegate = self.textFieldDelegate;
    if ([self inputInitText]) {
        self.associateKeyboardTextField.text = [self inputInitText];
    }
    // 执行文本更新
    [self inputDisplayText];
    
    [self addTapGesture];
}

- (void)setInputViewWithKeyboard:(id<NLKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry delegate:(id<UITextFieldDelegate>)delegate {
    UITextField *tf = [UITextField new];
    [self addSubview:tf];
    self.associateKeyboardTextField = tf;
    self.associateKeyboardTextField.secureTextEntry = secureTextEntry;
    self.associateKeyboardTextField.delegate = delegate;
    self.associateKeyboardTextField.text = [self inputInitText];
    [self inputDisplayText];
    [self.associateKeyboardTextField setInputViewWithKeyboard:keyboard];
    
    [self addTapGesture];
}

- (void)addTapGesture {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapGesture)];
    [self addGestureRecognizer:tap];
}

#pragma mark Action
- (void)tapGesture {
    [self.associateKeyboardTextField becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserverForName:UIKeyboardWillHideNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self dismissKB];
                                                  }];
    [[NSNotificationCenter defaultCenter] addObserverForName:UITextFieldTextDidChangeNotification
                                                      object:nil
                                                       queue:nil
                                                  usingBlock:^(NSNotification * _Nonnull note) {
                                                      [self inputText];
                                                      [self inputDisplayText];
                                                      if ([self respondsToSelector:@selector(keyboard:textField:doUpdateText:)]) {
                                                          [self keyboard:(id<NLKeyboard>)self.associateKeyboardTextField.inputView textField:self.associateKeyboardTextField doUpdateText:[self inputDisplayText]];
                                                      }
                                                  }];
}

- (void)dismissKB {
    [self.associateKeyboardTextField resignFirstResponder];
    [self.associateKeyboardTextField removeFromSuperview];
    self.associateKeyboardTextField = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- NLInputConnection
- (NSString*)inputText {
    return self.associateKeyboardTextField.text;
}
- (NSString*)inputInitText {
    return nil;
}

#pragma mark -- Runtime Getter/Setter
- (void)setAssociateKeyboardTextField:(UITextField *)associateKeyboardTextField {
    return objc_setAssociatedObject(self, &associateKeyboardTextFieldKey, associateKeyboardTextField, OBJC_ASSOCIATION_COPY);
}
- (UITextField *)associateKeyboardTextField {
    UITextField *tf;
    for (int i = 0; i < self.subviews.count; i++) {
        UIView *subview = [self.subviews objectAtIndex:i];
        if ([subview isKindOfClass:[UITextField class]]) {
            tf = (UITextField *)subview;
            return tf;
        }
    }
    
    return objc_getAssociatedObject(self, &associateKeyboardTextFieldKey);
}

//- (void)setDelegate:(id<NLInputConnection>)delegate {
//    if ([delegate inputInitText]) {
//        self.associateKeyboardTextField.text = [delegate inputInitText];
//    }
//    return objc_setAssociatedObject(self, delegateKey, delegate, OBJC_ASSOCIATION_COPY_NONATOMIC);
//}
//
//- (id<NLInputConnection>)delegate {
//    return objc_getAssociatedObject(self, &delegateKey);
//}

- (void)setTextFieldDelegate:(id<UITextFieldDelegate>)textFieldDelegate {
    return objc_setAssociatedObject(self, textFieldDelegateKey, textFieldDelegate, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (id<UITextFieldDelegate>)textFieldDelegate {
    return objc_getAssociatedObject(self, textFieldDelegateKey);
}

@end

@implementation UILabel(NLInputConnection)
#pragma mark NLInputConnection
- (NSString*)inputInitText {
    return nil;
}
- (NSString*)inputDisplayText {
    NSString *displayText = [[NSString alloc] init];
    if (self.associateKeyboardTextField.secureTextEntry) {
        for (int i = 0; i < self.associateKeyboardTextField.text.length; i++) {
            displayText = [displayText stringByAppendingString:secureText];
        }
    } else {
        displayText = [self.associateKeyboardTextField.text copy];
    }
    
    self.text = displayText;
    return displayText;
}

@end