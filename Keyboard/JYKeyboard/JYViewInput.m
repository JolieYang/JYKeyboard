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
    !configBlock?:configBlock(kbConfig);
    [self setSystemKeyboardWithConfigObject: kbConfig];
}

- (void)setSystemKeyboardWithConfigObject:(JYKeyboardConfig *)config {
    [self commitInit];
    [self configTextField:self.associateKeyboardTextField configer:config];
    
    // 键盘配置之后再执行文本更新
    [self updateDisplayText];
}


- (void)setCustomKeyboard:(id<JYKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry {
    [self commitInit];
    self.associateKeyboardTextField.secureTextEntry = secureTextEntry;
    [self.associateKeyboardTextField setCustomKeyboard:keyboard];
    
    // 键盘配置之后再执行文本更新
    [self updateDisplayText];
}

- (void)commitInit {
    NSAssert(![self systemCanInputSource], @"Only Support to Can't Input Control");
    UITextField *tf = [UITextField new];
    tf.delegate = self;
    tf.hidden = YES;
    [self addSubview:tf];
    self.associateKeyboardTextField = tf;
    
    // 目前只支持UILabel,UIButton的默认赋值
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        self.associateKeyboardTextField.text = label.text;
    } else if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        self.associateKeyboardTextField.text = button.titleLabel.text;
    }
    
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
                                                      if ([self.inputDelegate respondsToSelector:@selector(inputSource:didChangeText:)]) {
                                                          [self.inputDelegate inputSource:self didChangeText:self.associateKeyboardTextField.text];
                                                      }
                                                      [self updateDisplayText];
                                                  }];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.inputDelegate respondsToSelector:@selector(inputSource:shouldChangeCharactersInRange:replacementString:)]) {
        return [self.inputDelegate inputSource:self shouldChangeCharactersInRange:range replacementString:string];
    } else {
        return YES;
    }
}
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.inputDelegate respondsToSelector:@selector(inputSourceShouldClear:)]) {
        return [self.inputDelegate inputSourceShouldClear:self];
    } else {
        return YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.inputDelegate respondsToSelector:@selector(inputSourceShouldReturn:)]) {
        return [self.inputDelegate inputSourceShouldReturn:self];
    } else {
        return YES;
    }
}

#pragma mark -- SetUp
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

- (void)dismissKB {
    [self.associateKeyboardTextField resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateDisplayText {
    if ([self.inputDelegate respondsToSelector:@selector(inputSource:updateDisplayText:)]) {
        [self.inputDelegate inputSource:self updateDisplayText:[self inputDisplayText]];
    } else {
        [self defaultUpdateDisplayText];
    }
}

// 目前仅支持UILabel,UIButton默认显示
- (void)defaultUpdateDisplayText {
    NSString *displayText = [self inputDisplayText];
    
    if ([self isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)self;
        label.text = displayText;
    } else if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        [button setTitle:displayText forState:UIControlStateNormal];
    } else {
        
    }
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
    
    return displayText;
}

#pragma mark -- Runtime Getter/Setter
- (void)setAssociateKeyboardTextField:(UITextField *)associateKeyboardTextField {
    return objc_setAssociatedObject(self, &associateKeyboardTextFieldKey, associateKeyboardTextField, OBJC_ASSOCIATION_RETAIN);
}
- (UITextField *)associateKeyboardTextField {
    return objc_getAssociatedObject(self, &associateKeyboardTextFieldKey);
}

- (void)setInputDelegate:(id<UIViewInputDelegate>)inputDelegate {
    // 设置初始文本
    if ([inputDelegate respondsToSelector:@selector(inputSourceDefaultText:)]) {
        self.associateKeyboardTextField.text = [inputDelegate inputSourceDefaultText:self];
        [self updateDisplayText];
    }
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