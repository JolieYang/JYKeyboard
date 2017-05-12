//
//  NLKeyboard.m
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "NLKeyboard.h"

@implementation NLAbstractKeyboard
- (void)keysRandomLayout {
    
}
- (IBAction)onKeyTouch:(id<NLKeyNote>)sender {
    if ([_delegate respondsToSelector:@selector(keyboard:willInsertKey:)]) {
        [_delegate keyboard:self willInsertKey:[sender keyValue]];
    }
    [[_delegate textField] insertText:[sender keyValue]];
}
- (IBAction)onDelete:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillDeleteKey:)]) {
        [_delegate keyboardWillDeleteKey:self];
    }
    NSString *originText = [_delegate textField].text;
    [_delegate textField].text = [originText substringToIndex:originText.length - 1];
                                  
}
- (IBAction)onDone:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillDone:)]) {
        [_delegate keyboardWillDone:self];
    }
    [[_delegate textField] resignFirstResponder];
}
- (IBAction)onClear:(id)sender {
    if (_delegate) {
        [_delegate keyboardWillClear:self];
    }
}

@end

@implementation UILabel(NLKeyNote)
- (NSString *)keyValue {
    return self.text;
}
@end
@implementation UIButton(NLKeyNote)
- (NSString *)keyValue {
    return self.titleLabel.text;
}
@end

@implementation UITextField(NLkeyboardExtension)
- (void)setInputViewWithKeyboard:(id<NLKeyboard>)keyboard {
    self.inputView = (UIView *)keyboard;
    NLAbstractKeyboard *kb = (NLAbstractKeyboard *)keyboard;
    kb.delegate = self;
    
    [self.inputView reloadInputViews];
}
@end

@implementation UITextField(NLKeyboardDelegateImplement)
- (UITextField *)textField {
    return self;
}
@end