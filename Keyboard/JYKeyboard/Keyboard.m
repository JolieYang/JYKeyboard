//
//  AbstractKeyboard.m
//  Keyboard
//
//  Created by Jolie_Yang on 16/7/20.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "Keyboard.h"
#import <objc/runtime.h>

@interface NLAbstractKeyboard()
@property (nonatomic, strong) UITextField *tf;
@end
@implementation NLAbstractKeyboard
- (void)awakeFromNib {
    [super awakeFromNib];
    NSLog(@"awakeFromNib");
    // 判断是否按键为UILabel,是则添加touchDown事件
    for (UIView *subView in self.randomItems) {
        if ([subView isKindOfClass:[UILabel class]]) {
            subView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onKeyTouch:)];
            [subView addGestureRecognizer:tap];
        }
    }
}
- (void)drawRect:(CGRect)rect {
    NSLog(@"drawRect");
   
}
- (IBAction)onKeyTouch:(id<NLKeyNote>)sender {
    if ([_delegate respondsToSelector:@selector(keyboard:willInsertKey:)]) {
        [_delegate keyboard:self willInsertKey: [sender keyValue]];
    }
    self.tf.text = [NSString stringWithFormat:@"%@%@",self.tf.text, [sender keyValue]];
}
- (IBAction)onDelete:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillDeleteKey:)]) {
        [_delegate keyboardWillDeleteKey:self];
    }
    if (self.tf.text.length == 0) {
        self.tf.text = @"";
    } else {
        self.tf.text = [self.tf.text substringToIndex:self.tf.text.length - 1];
    }
}
- (IBAction)onDone:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillDone:)]) {
        [_delegate keyboardWillDone:self];
    }
    [self.tf resignFirstResponder];
    
    // m2
//    [self endEditing:YES];
}
@end

@implementation UITextField(KeyboardExtension)
// bug: 无法设置textField
- (void)setInputViewWithKeyboard:(id<NLKeyboard>)keyboard {
    self.inputView = (UIView *)keyboard;
}
- (void)setInputViewWithKB:(NLAbstractKeyboard *)keyboard {
    self.inputView = keyboard;
    keyboard.tf = self;
    
    
}
- (void)setInputViewWithKB:(NLAbstractKeyboard *)keyboard secure:(BOOL)secure {
    [self setInputViewWithKB:keyboard];
    keyboard.tf.secureTextEntry = secure;
}
@end

@implementation UITextField (NLKeyboardDelegateImplement)

- (void)keyboard: (id<NLKeyboard>)keyboard willInsertKey:(NSString *)key {
    [self.delegate textField:self shouldChangeCharactersInRange:NSMakeRange(self.textField.text.length - 1, 1) replacementString:key];
}
- (void)keyboardWillDeleteKey:(id<NLKeyboard>)keyboard {
//    [self.delegate textFieldShouldRe]
    
}
- (void)keyboardWillDone:(id<NLKeyboard>)keyboard {
    
}

@end

@implementation UILabel(NLKeyNote)
- (void)awakeFromNib {
    self.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self.superview action:@selector(onKeyTouch:)];
//    [self addGestureRecognizer:tap];
}
//- (instancetype)initWithCoder:(NSCoder *)aDecoder {
//    if (self = [super initWithCoder:aDecoder]) {
//        self.userInteractionEnabled = YES;
//    }
//    return self;
//}
- (NSString *)keyValue {
    return self.text;
}
@end
@implementation UIButton(NLKeyNote)
- (NSString *)keyValue {
    return self.titleLabel.text;
}
@end