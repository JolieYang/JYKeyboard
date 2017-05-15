//
//  NLKeyboardNumberPad.m
//  NLKeyboard
//
//  Created by su on 16/4/11.
//  Copyright © 2016年 suzw. All rights reserved.
//

#import "NLKeyboardNumberPad.h"

@implementation NLKeyboardNumberPad
+ (id)securityKeyboard {
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
}
+ (id)standardKeyboard {
    NLKeyboardNumberPad *keyboard = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] objectAtIndex:1];
    keyboard.randomItems = nil;
    
    return keyboard;
}
+ (id)standardShuffledKeyboard {
    NLKeyboardNumberPad *keyboard = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] objectAtIndex:1];
    
    return keyboard;
}

#pragma mark NLKeyboardDelegate
- (void)keyboard: (id<NLKeyboard>)keyboard willInsertKey:(NSString *)key {
    NSLog(@"willInsertKey");
}

- (void)keyboardWillDeleteKey:(id<NLKeyboard>)keyboard {
    NSLog(@"willDelgete");
}
- (void)keyboardWillDone:(id<NLKeyboard>)keyboard {
    NSLog(@"willDone");
}

@end
