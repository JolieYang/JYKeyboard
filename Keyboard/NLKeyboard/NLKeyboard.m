//
//  NLKeyboard.m
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "NLKeyboard.h"
@interface NLAbstractKeyboard()<NLKeyboardDelegate>
@end

@implementation NLAbstractKeyboard
- (void)awakeFromNib {
    
}
- (void)willMoveToWindow:(UIWindow *)newWindow {
    if (newWindow) {
        if (_randomItems) {
            [self keysRandomLayout];
        }
    }
}

- (void)loadRandomItems {
    // M1: 保存键值，打乱items顺序，修改item的键值,
//    NSMutableArray *orderValueItmes = [NSMutableArray arrayWithCapacity:_randomItems.count];
//    [_randomItems enumerateObjectsUsingBlock:^(id<NLKeyNote> keyNote, NSUInteger idx, BOOL * _Nonnull stop) {
//        [orderValueItmes addObject:[keyNote keyValue]];
//    }];
//    _randomItems = [_randomItems shuffled];
//    [_randomItems enumerateObjectsUsingBlock:^(id<NLKeyNote> keyNote, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([keyNote isKindOfClass:[UIButton class]]) {
//            [(UIButton *)keyNote setTitle:orderValueItmes[idx] forState:UIControlStateNormal];
//        } else if ([keyNote isKindOfClass:[UILabel class]]) {
//            ((UILabel *)keyNote).text = orderValueItmes[idx];
//        } else {
//            
//        }
//    }];
    
    // 考虑到自定义ImageView为按键的情况，使用Method2.
    // M2: 保存frame值，打乱item，修改item的frame。要点，即使可以对randomItem进行深拷贝，但数组中的元素还是无法深拷贝，因而会出现bug。
    NSMutableArray *xArray = [NSMutableArray arrayWithCapacity:_randomItems.count];
    NSMutableArray *yArray = [NSMutableArray arrayWithCapacity:_randomItems.count];
    NSMutableArray *widthArray = [NSMutableArray arrayWithCapacity:_randomItems.count];
    NSMutableArray *heightArray = [NSMutableArray arrayWithCapacity:_randomItems.count];
    [_randomItems enumerateObjectsUsingBlock:^(id<NLKeyNote> keyNote, NSUInteger idx, BOOL * _Nonnull stop) {
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
#pragma mark NLKeyboard
- (void)keysRandomLayout {
    [self loadRandomItems];
}
- (IBAction)onKeyTouch:(id<NLKeyNote>)sender {
    if ([_delegate respondsToSelector:@selector(keyboard:willInsertKey:)]) {
        [_delegate keyboard:self willInsertKey:[sender keyValue]];
    }
    if ([_delegate textField]) {
        [[_delegate textField] insertText:[sender keyValue]];
    }
}
- (IBAction)onDelete:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillDeleteKey:)]) {
        [_delegate keyboardWillDeleteKey:self];
    }
    if ([_delegate textField]) {
        NSString *originText = [_delegate textField].text;
        [_delegate textField].text = [originText substringToIndex:originText.length - 1];
    }
    
}
- (IBAction)onDone:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillDone:)]) {
        [_delegate keyboardWillDone:self];
    }
    if ([_delegate textField]) {
        [[_delegate textField] resignFirstResponder];
    }
}
- (IBAction)onClear:(id)sender {
    if ([_delegate respondsToSelector:@selector(keyboardWillClear:)]) {
        [_delegate keyboardWillClear:self];
    }
    if ([_delegate textField]) {
        [_delegate textField].text = nil;
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
- (void)keyboard:(id<NLKeyboard>)keyboard willInsertKey:(NSString*)key {
    
}
- (void)keyboardWillDeleteKey:(id<NLKeyboard>)keyboard {
    
}
- (void)keyboardWillDone:(id<NLKeyboard>)keyboard {
    
}
- (UITextField *)textField {
    return self;
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
