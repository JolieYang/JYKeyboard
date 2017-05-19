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
static void *viewInputDelegateKey = &viewInputDelegateKey;

- (void)noInputControlSetSystemKeyboardWithConfigBlock:(JYViewInputSystemKeyboardConfigBlock)configBlock {
    JYKeyboardConfig *kbConfig = [JYKeyboardConfig new];
    !configBlock?:configBlock(kbConfig);
    [self noInputControlSetSystemKeyboardWithConfigObject: kbConfig];
}

- (void)noInputControlSetSystemKeyboardWithConfigObject:(JYKeyboardConfig *)config {
    NSAssert(![self systemCanInputSource], @"noInputControlSetSystemKeyboardWithConfigObject Method Only Support to Can't Input Control");
    [self commitInit];
    [self configTextField:self.associateKeyboardTextField configer:config];
    
    // 键盘配置之后再执行文本更新
    [self updateDisplayText];
}

- (void)setCustomKeyboard:(id<JYKeyboard>)keyboard {
    [self setCustomKeyboard:keyboard secureTextEntry:NO];
}

- (void)setCustomKeyboard:(id<JYKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry {
    if ([self systemCanInputSource]) {
        if ([self isKindOfClass:[UISearchBar class]]) {
            UISearchBar *searchBar = (UISearchBar *)self;
            searchBar.inputViewController.inputView = (UIInputView *)keyboard;
        } else if ([self isKindOfClass:[UITextField class]]){
            UITextField *tf = (UITextField *)self;
            tf.inputView = (UIView *)keyboard;
            tf.delegate = self;
            self.associateKeyboardTextField = tf;
        } else if ([self isKindOfClass:[UITextView class]]) {
            UITextView *tv = (UITextView *)self;
            tv.inputView = (UIView *)keyboard;
        }
        
        [self.inputView reloadInputViews];
    } else {
        [self noInputControlSetCustomKeyboard:keyboard secureTextEntry:secureTextEntry];
        
        [self.associateKeyboardTextField.inputView reloadInputViews];
    }
    
    JYAbstractKeyboard *kb = (JYAbstractKeyboard *)keyboard;
    kb.delegate = self;
}

- (void)noInputControlSetCustomKeyboard:(id<JYKeyboard>)keyboard secureTextEntry:(BOOL)secureTextEntry {
    [self commitInit];
    self.associateKeyboardTextField.secureTextEntry = secureTextEntry;
    self.associateKeyboardTextField.inputView = (UIView *)keyboard;
    
    // 键盘配置之后再执行文本更新
    [self updateDisplayText];
}

- (void)commitInit {
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
    [self addTextFieldNotification];
}

- (void)addTapGesture {
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [tap addTarget:self action:@selector(tapGestureAction)];
    [self addGestureRecognizer:tap];
}

#pragma mark Action
- (void)tapGestureAction {
    [self.associateKeyboardTextField becomeFirstResponder];
    [self addTextFieldNotification];
}

- (void)addTextFieldNotification {
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
                                                      if ([self.viewInputDelegate respondsToSelector:@selector(inputSource:didChangeText:)]) {
                                                          [self.viewInputDelegate inputSource:self didChangeText:self.associateKeyboardTextField.text];
                                                      }
                                                      [self updateDisplayText];
                                                  }];
}
#pragma mark -- JYKeyboardDelegate ps: 所有控件设置自定义键盘
- (UIView *)inputSource {
    return self;
}

- (BOOL)keyboard:(id<JYKeyboard>)keyboard shouldChangeText:(NSString *)text replacementString:(NSString *)string {
    if ([self.viewInputDelegate respondsToSelector:@selector(inputSource:shouldChangeText:replacementString:)]) {
        return [self.viewInputDelegate inputSource:self shouldChangeText:text replacementString:string];
    } else {
        return YES;
    }
}

- (void)keyboard:(id<JYKeyboard>)keyboard didChangeToText:(NSString *)text {
    if ([self.viewInputDelegate respondsToSelector:@selector(inputSource:didChangeText:)]) {
        [self.viewInputDelegate inputSource:self didChangeText:text];
    }
    [self updateDisplayText];
}
- (BOOL)keyboardWillDone:(id<JYKeyboard>)keyboarda {
    if ([self.viewInputDelegate respondsToSelector:@selector(inputSourceShouldReturn:)]) {
        return [self.viewInputDelegate inputSourceShouldReturn:self];
    } else {
        return YES;
    }
}
- (BOOL)keyboardWillClear:(id<JYKeyboard>)keyboard {
    if ([self.viewInputDelegate respondsToSelector:@selector(inputSourceShouldClear:)]) {
        return [self.viewInputDelegate inputSourceShouldClear:self];
    } else {
        return YES;
    }
}
#pragma mark -- UITextFieldDelegate ps: 无输入源控件设置原生键盘
- (BOOL)textFieldShouldClear:(UITextField *)textField {
    if ([self.viewInputDelegate respondsToSelector:@selector(inputSourceShouldClear:)]) {
        return [self.viewInputDelegate inputSourceShouldClear:self];
    } else {
        return YES;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self.viewInputDelegate respondsToSelector:@selector(inputSourceShouldReturn:)]) {
        return [self.viewInputDelegate inputSourceShouldReturn:self];
    } else {
        return YES;
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([self.viewInputDelegate respondsToSelector:@selector(inputSource:shouldChangeText:replacementString:)]) {
        return [self.viewInputDelegate inputSource:self shouldChangeText:textField.text replacementString:string];
    }
    return YES;
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
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)updateDisplayText {
    if ([self.viewInputDelegate respondsToSelector:@selector(inputSource:updateDisplayText:)]) {
        [self.viewInputDelegate inputSource:self updateDisplayText:[self inputDisplayText]];
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

- (void)setViewInputDelegate:(id<UIViewInputDelegate>)viewInputDelegate {
    // 设置初始文本
    if ([viewInputDelegate respondsToSelector:@selector(inputSourceDefaultText:)]) {
        if (self.associateKeyboardTextField) {
            self.associateKeyboardTextField.text = [viewInputDelegate inputSourceDefaultText:self];
        } else {
            [self updateInputSourceText:[viewInputDelegate inputSourceDefaultText:self]];
        }
        [self updateDisplayText];
    }
    return objc_setAssociatedObject(self, viewInputDelegateKey, viewInputDelegate, OBJC_ASSOCIATION_ASSIGN);
}
- (id<UIViewInputDelegate>)viewInputDelegate {
    return objc_getAssociatedObject(self, viewInputDelegateKey);
}

#pragma mark tool
- (void)updateInputSourceText:(NSString *)text {
    if ([self systemCanInputSource] || [self isKindOfClass:[UILabel class]]) {
        [self setValue:text forKey:@"text"];
    } else if ([self isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)self;
        [button setTitle:text forState:UIControlStateNormal];
    } else {
        NSLog(@"Please Implement updateDisplayText Protocol to Update InputSource Display");
    }
    
}
- (BOOL)systemCanInputSource {
    if ([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]] || [self isKindOfClass:[UISearchBar class]]) {
        return YES;
    }
    return NO;
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