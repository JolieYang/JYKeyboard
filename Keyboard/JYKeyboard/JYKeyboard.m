//
//  JYKeyboard.m
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "JYKeyboard.h"
#import "JYViewInput.h"

@interface JYAbstractKeyboard()<JYKeyboardDelegate>
@end

@implementation JYAbstractKeyboard

- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        if (_randomItems) {
            [self keysRandomLayout];
        }
    }
}

#pragma mark JYKeyboard Protocol
- (void)keysRandomLayout {
    [self loadRandomItems];
}
- (IBAction)onKeyTouch:(id<JYKeyNote>)sender {
    if ([_delegate respondsToSelector:@selector(keyboard:willInsertKey:)]) {
        [_delegate keyboard:self willInsertKey:[sender keyValue]];
    }
    if ([_delegate inputSource]) {
        id<UIKeyInput> inputObjcet = (id<UIKeyInput>)[_delegate inputSource];
        [inputObjcet insertText:[sender keyValue]];
    }
}
- (IBAction)onDelete:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillDeleteKey:)]) {
        [_delegate keyboardWillDeleteKey:self];
    }
    if ([_delegate inputSource]) {
        id<UIKeyInput> inputObjcet = (id<UIKeyInput>)[_delegate inputSource];
        [inputObjcet deleteBackward];
    }
    
}
- (IBAction)onDone:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillDone:)]) {
        [_delegate keyboardWillDone:self];
    }
    
    if ([_delegate inputSource]) {
        UIView *inputSource = [_delegate inputSource];
        if ([inputSource isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)inputSource;
            if (textField.delegate && [textField.delegate respondsToSelector:@selector(keyboardWillDone:)]) {
                BOOL ret = [textField.delegate textFieldShouldEndEditing:textField];
                [textField endEditing:ret];
            } else {
                [textField resignFirstResponder];
            }
        } else if ([inputSource isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)inputSource;
            if (textView.delegate && [textView.delegate respondsToSelector:@selector(keyboardWillDone:)]) {
                BOOL ret = [textView.delegate textViewShouldEndEditing:textView];
                [textView endEditing:ret];
            } else {
                [textView resignFirstResponder];
            }
        } else if ([inputSource isKindOfClass:[UISearchBar class]]) {
            UISearchBar *searchBar = (UISearchBar *)inputSource;
            if (searchBar.delegate && [searchBar.delegate respondsToSelector:@selector(keyboardWillDone:)]) {
                BOOL ret = [searchBar.delegate searchBarShouldEndEditing:searchBar];
                [searchBar endEditing:ret];
            } else {
                [searchBar resignFirstResponder];
            }
        }
    }
}
- (IBAction)onClear:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillClear:)]) {
        [_delegate keyboardWillClear:self];
    }
    if ([_delegate inputSource]) {
        UIView *inputSource = [_delegate inputSource];
        if ([inputSource isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)inputSource;
            textField.text = nil;
        } else if ([inputSource isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)inputSource;
            textView.text = nil;
        } else if ([inputSource isKindOfClass:[UISearchBar class]]) {
            UISearchBar *searchBar = (UISearchBar *)inputSource;
            searchBar.text = nil;
        }
    }
}

#pragma mark -- Tool
- (void)loadRandomItems {
    // 保存frame值，打乱item，修改item的frame。要点，即使可以对randomItem进行深拷贝，但数组中的元素还是无法深拷贝，因而会出现bug。
    NSMutableArray *xArray = [NSMutableArray arrayWithCapacity:_randomItems.count];
    NSMutableArray *yArray = [NSMutableArray arrayWithCapacity:_randomItems.count];
    NSMutableArray *widthArray = [NSMutableArray arrayWithCapacity:_randomItems.count];
    NSMutableArray *heightArray = [NSMutableArray arrayWithCapacity:_randomItems.count];
    [_randomItems enumerateObjectsUsingBlock:^(id<JYKeyNote> keyNote, NSUInteger idx, BOOL * _Nonnull stop) {
        UIView *view = (UIView *)keyNote;
        CGPoint originPoint = view.frame.origin;
        CGSize originSize = view.frame.size;
        [xArray addObject:[NSNumber numberWithDouble:originPoint.x]];
        [yArray addObject:[NSNumber numberWithDouble:originPoint.y]];
        [widthArray addObject:[NSNumber numberWithDouble:originSize.width]];
        [heightArray addObject:[NSNumber numberWithDouble:originSize.height]];
    }];
    
    _randomItems = [_randomItems shuffled];
    
    [_randomItems enumerateObjectsUsingBlock:^(UIView *keyNoteView, NSUInteger idx, BOOL * _Nonnull stop) {
        [keyNoteView setFrame:CGRectMake([xArray[idx] doubleValue], [yArray[idx] doubleValue], [widthArray[idx] doubleValue], [heightArray[idx] doubleValue])];
    }];
}

@end

@implementation UILabel(JYKeyNote)
- (NSString *)keyValue {
    return self.text;
}
@end
@implementation UIButton(JYKeyNote)
- (NSString *)keyValue {
    return self.titleLabel.text;
}
@end
#pragma mark -- 自带输入源控件&&无输入源对象设置键盘
@implementation UIView (JYKeyboardExtension)
- (void)setCustomKeyboard:(id<JYKeyboard>)keyboard {
    if ([self systemCanInputSource]) {
        if ([self isKindOfClass:[UISearchBar class]]) {
            self.inputViewController.inputView = (UIInputView *)keyboard;
        } else if ([self isKindOfClass:[UITextField class]]){
            UITextField *tf = (UITextField *)self;
            tf.inputView = (UIView *)keyboard;
        } else if ([self isKindOfClass:[UITextView class]]) {
            UITextView *tv = (UITextView *)self;
            tv.inputView = (UIView *)keyboard;
        }
        JYAbstractKeyboard *kb = (JYAbstractKeyboard *)keyboard;
        kb.delegate = self;
        
        [self.inputView reloadInputViews];
    } else {
        [self setCustomKeyboard:keyboard secureTextEntry:NO];
    }
}
- (UIView *)inputSource {
    return self;
}

- (BOOL)systemCanInputSource {
    if ([self isKindOfClass:[UITextField class]] || [self isKindOfClass:[UITextView class]] || [self isKindOfClass:[UISearchBar class]]) {
        return YES;
    }
    return NO;
}
@end
@implementation NSArray(Extension)
- (NSArray *)shuffled {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        int32_t randomResult = (int32_t)arc4random() % 3 - 1; // arc4random() 返回值为 u_int32_t，不能为负数，先转为 int32_t
        return randomResult;
    }];
}
@end
