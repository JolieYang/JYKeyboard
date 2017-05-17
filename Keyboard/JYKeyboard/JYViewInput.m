//
//  JYViewInput.m
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "JYViewInput.h"
#import "JYKeyboard.h"
#import <objc/runtime.h>

@implementation UIView(JYViewInput)
static NSString *secureText = @"●";
static void *associateKeyboardTextFieldKey = &associateKeyboardTextFieldKey;
static void *delegateKey = &delegateKey;

- (void)setInputViewWithTextField:(UITextField*)textField {
    textField.hidden = YES;
    [self addSubview:textField];
    self.associateKeyboardTextField = textField;
    
    self.associateKeyboardTextField.returnKeyType = UIReturnKeyDone;
    self.associateKeyboardTextField.enablesReturnKeyAutomatically = YES;
    if ([self inputInitText]) {
        self.associateKeyboardTextField.text = [self inputInitText];
    } else {
        if ([self isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)self;
            self.associateKeyboardTextField.text = label.text;
        } else if ([self isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton *)self;
            self.associateKeyboardTextField.text = button.titleLabel.text;
        }
    }
    // 执行文本更新
    [self inputDisplayText];
    
    [self addTapGesture];
}

- (void)ShowText {
    
}


- (void)setInputViewWithKeyboard:(id<JYKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry {
    UITextField *tf = [UITextField new];
    [self addSubview:tf];
    self.associateKeyboardTextField = tf;
    
    self.associateKeyboardTextField.secureTextEntry = secureTextEntry;
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
                                                          [self keyboard:(id<JYKeyboard>)self.associateKeyboardTextField.inputView textField:self.associateKeyboardTextField doUpdateText:[self inputDisplayText]];
                                                      }
                                                  }];
}

- (void)dismissKB {
    [self.associateKeyboardTextField resignFirstResponder];
    [self.associateKeyboardTextField removeFromSuperview];
    self.associateKeyboardTextField = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -- JYViewInput
- (NSString*)inputText {
    return self.associateKeyboardTextField.text;
}
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
    
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        label.text = displayText;
    } else if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        [button setTitle:displayText forState:UIControlStateNormal];
    } else {
        
    }
    
    return displayText;
}
#pragma mark -- Runtime Getter/Setter
- (void)setAssociateKeyboardTextField:(UITextField *)associateKeyboardTextField {
    return objc_setAssociatedObject(self, &associateKeyboardTextFieldKey, associateKeyboardTextField, OBJC_ASSOCIATION_RETAIN);
}
- (UITextField *)associateKeyboardTextField {
    return objc_getAssociatedObject(self, &associateKeyboardTextFieldKey);
}

- (void)setDelegate:(id<UIViewInputDelegate>)delegate {
    return objc_setAssociatedObject(self, &delegateKey, delegate, OBJC_ASSOCIATION_ASSIGN);
}

- (id<UIViewInputDelegate>)delegate {
    return objc_getAssociatedObject(self, &delegateKey);
}

@end
