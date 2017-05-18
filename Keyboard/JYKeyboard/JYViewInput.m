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
static void *inputDelegateKey = &inputDelegateKey;

- (void)setSystemKeyboardWithConfigBlock:(JYViewInputSystemKeyboardConfigBlock)configBlock {
    JYKeyboardConfig *kbConfig = [JYKeyboardConfig new];
    !kbConfig?:configBlock(kbConfig);
    [self setSystemKeyboardWithConfigObject: kbConfig];
}

- (void)setSystemKeyboardWithConfigObject:(JYKeyboardConfig *)config {
    [self commitInit];
    [self configTextField:self.associateKeyboardTextField configer:config];
}


- (void)setInputViewWithKeyboard:(id<JYKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry {
//    UITextField *tf = [UITextField new];
//    [self addSubview:tf];
//    self.associateKeyboardTextField = tf;
//    
//    self.associateKeyboardTextField.secureTextEntry = secureTextEntry;
//    self.associateKeyboardTextField.text = [self inputInitText];
//    [self inputDisplayText];
//    
//    [self addTapGesture];
    
    [self commitInit];
    self.associateKeyboardTextField.secureTextEntry = secureTextEntry;
    
    [self.associateKeyboardTextField setInputViewWithKeyboard:keyboard];
}



- (void)commitInit {
    UITextField *tf = [UITextField new];
    tf.hidden = YES;
    [self addSubview:tf];
    self.associateKeyboardTextField = tf;
    
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
//    [self.associateKeyboardTextField removeFromSuperview];
//    self.associateKeyboardTextField = nil;
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

#pragma mark -- Tool
- (void)configTextField:(UITextField *)tf configer:(JYKeyboardConfig *)config {
    if (config) {
        tf.autocapitalizationType = !(config.autocapitalizationType==UITextAutocapitalizationTypeNone)?:config.autocapitalizationType;
        tf.autocorrectionType = !(config.autocorrectionType==UITextAutocorrectionTypeDefault)?:config.autocorrectionType;
        tf.spellCheckingType = !(config.spellCheckingType==UITextSpellCheckingTypeDefault)?:config.spellCheckingType;
        tf.keyboardType = !(config.keyboardType==UIKeyboardTypeDefault)?:config.keyboardType;
        tf.keyboardAppearance = !(config.keyboardAppearance==UIKeyboardAppearanceDefault)?:config.keyboardAppearance;
        tf.returnKeyType = !(config.returnKeyType==UIReturnKeyDefault)?:config.returnKeyType;
        tf.enablesReturnKeyAutomatically = config.enablesReturnKeyAutomatically;
        tf.secureTextEntry = config.isSecureTextEntry;
    }
}

#pragma mark -- Runtime Getter/Setter
- (void)setAssociateKeyboardTextField:(UITextField *)associateKeyboardTextField {
    return objc_setAssociatedObject(self, &associateKeyboardTextFieldKey, associateKeyboardTextField, OBJC_ASSOCIATION_RETAIN);
}
- (UITextField *)associateKeyboardTextField {
    return objc_getAssociatedObject(self, &associateKeyboardTextFieldKey);
}

- (void)setInputDelegate:(id<UIViewInputDelegate>)inputDelegate {
    return objc_setAssociatedObject(self, inputDelegateKey, inputDelegate, OBJC_ASSOCIATION_ASSIGN);
}
- (id<UIViewInputDelegate>)inputDelegate {
    return objc_getAssociatedObject(self, inputDelegateKey);
}
@end

@implementation JYKeyboardConfig
@synthesize autocapitalizationType;
@synthesize autocorrectionType;
@synthesize spellCheckingType;
@synthesize keyboardType;
@synthesize keyboardAppearance;
@synthesize returnKeyType;
@synthesize enablesReturnKeyAutomatically;
@synthesize secureTextEntry;

- (instancetype)init {
    if (self = [super init]) {
    }
    return self;
}
@end