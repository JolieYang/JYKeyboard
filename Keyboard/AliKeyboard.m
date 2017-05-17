//
//  AliKeyboard.m
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/17.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "AliKeyboard.h"

@implementation AliKeyboard
+ (id)standardShuffledKeyboard {
    AliKeyboard *kb = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:self options:nil] firstObject];
    
    return kb;
}

@end
