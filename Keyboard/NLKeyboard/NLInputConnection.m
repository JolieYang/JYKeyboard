//
//  NLInputConnection.m
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import "NLInputConnection.h"

@implementation UIView(NLInputConnection)
- (NSString*)inputInitText {
    return nil;
}
- (NSString*)inputDisplayText {
    return nil;
}
- (void)setInputViewWithTextField:(UITextField*)textField {
    
}
- (void)keyboard:(id<NLKeyboard>)keyboard textField:(UITextField*)textField doUpdateText:(NSString*)text {
    
}

@end

@implementation UILabel(NLInputConnection)


@end