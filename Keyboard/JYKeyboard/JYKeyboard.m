//
//  JYKeyboard.m
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "JYKeyboard.h"
#import "JYViewInput.h"

typedef NS_ENUM(NSInteger, JYChangeText) {
    JYChangeTextInsert = 0,
    JYChangeTextDelete = 1
};

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
    [self changeText:sender changeTextType:JYChangeTextInsert];
}
- (IBAction)onDelete:(id)sender {
    [self changeText:nil changeTextType:JYChangeTextDelete];
}
- (IBAction)onDone:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillDone:)]) {
        BOOL shouldDone = [_delegate keyboardWillDone:self];
        if (!shouldDone) return;
    }
    
    [self hideKeybaord];
}
- (IBAction)onHide:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillHide:)]) {
        BOOL willHide = [_delegate keyboardWillHide:self];
        if (!willHide) return;
    }
    
    [self hideKeybaord];
}
- (IBAction)onClear:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillClear:)]) {
        BOOL willClear = [_delegate keyboardWillClear:self];
        if (!willClear) return;
    }
    
    [self clearText];
}

#pragma mark -- Tool
- (void)changeText:(id<JYKeyNote>)sender changeTextType:(JYChangeText)changeTextType {
    id<UIKeyInput> inputObject;
    NSString *currentText;
    
    if ([[_delegate inputSource] systemCanInputSource]) {
        inputObject = (id<UIKeyInput>)[_delegate inputSource];
    } else {
        inputObject = [_delegate inputSource].associateKeyboardTextField;
    }
    
    currentText = [((UIControl *)inputObject) valueForKey:@"text"];
    if ([_delegate respondsToSelector:@selector(keyboard:shouldChangeText:replacementString:)]) {
        BOOL shouldChange = [_delegate keyboard:self shouldChangeText:currentText replacementString:[sender keyValue]];
        if (!shouldChange) return;
    }
    
    if (changeTextType == JYChangeTextInsert) {
        if ([_delegate respondsToSelector:@selector(keyboard:willInsertKey:)]) {
            [_delegate keyboard:self willInsertKey:[sender keyValue]];
        }
        
        [inputObject insertText:[sender keyValue]];
    } else if (changeTextType == JYChangeTextDelete) {
        if ([_delegate respondsToSelector:@selector(keyboardWillDeleteKey:)]) {
            [_delegate keyboardWillDeleteKey:self];
        }
        
        [inputObject deleteBackward];
    }
    
    currentText = [((UIControl *)inputObject) valueForKey:@"text"];
    [self didChangeToText:currentText];
}

- (void)didChangeToText:(NSString *)text {
    if ([_delegate respondsToSelector:@selector(keyboard:didChangeToText:)]) {
        [_delegate keyboard:self didChangeToText:text];
    }
}


- (void)clearText {
    if ([[_delegate inputSource] systemCanInputSource]) {
        UIView *inputSource = [_delegate inputSource];
        [inputSource setValue:nil forKey:@"text"];
    } else {
        [_delegate inputSource].associateKeyboardTextField.text = nil;
    }
}
- (void)hideKeybaord {
    if ([[_delegate inputSource] systemCanInputSource]) {
        UIView *inputSource = [_delegate inputSource];
        if ([inputSource isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)inputSource;
            if (textField.delegate && [textField.delegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
                BOOL ret = [textField.delegate textFieldShouldEndEditing:textField];
                [textField endEditing:ret];
            } else {
                [textField resignFirstResponder];
            }
        } else if ([inputSource isKindOfClass:[UITextView class]]) {
            UITextView *textView = (UITextView *)inputSource;
            if (textView.delegate && [textView.delegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
                BOOL ret = [textView.delegate textViewShouldEndEditing:textView];
                [textView endEditing:ret];
            } else {
                [textView resignFirstResponder];
            }
        } else if ([inputSource isKindOfClass:[UISearchBar class]]) {
            UISearchBar *searchBar = (UISearchBar *)inputSource;
            if (searchBar.delegate && [searchBar.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
                BOOL ret = [searchBar.delegate searchBarShouldEndEditing:searchBar];
                [searchBar endEditing:ret];
            } else {
                [searchBar resignFirstResponder];
            }
        }
    } else {
        [[_delegate inputSource].associateKeyboardTextField resignFirstResponder];
    }
}
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

@implementation NSArray(Extension)
- (NSArray *)shuffled {
    return [self sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        int32_t randomResult = (int32_t)arc4random() % 3 - 1; // arc4random() 返回值为 u_int32_t，不能为负数，先转为 int32_t
        return randomResult;
    }];
}
@end
