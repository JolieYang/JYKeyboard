//
//  JYKeyboard.h
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JYKeyboardDelegate;
@protocol JYKeyboard;
@protocol JYKeyNote;

@protocol JYKeyboard <NSObject>
- (IBAction)onKeyTouch:(id<JYKeyNote>)sender;
- (IBAction)onDelete:(id)sender;
@optional
- (IBAction)onDone:(id)sender;
- (IBAction)onClear:(id)sender;
- (void)keysRandomLayout;
@end

@interface JYAbstractKeyboard: UIView<JYKeyboard>
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *randomItems;
@property (nonatomic, assign) id<JYKeyboardDelegate> delegate;
@end

@protocol JYKeyboardDelegate <NSObject>
- (UIView *)inputSource;
@optional
// ps: 无法共用同一个自定义keyboard对象
- (void)keyboard:(id<JYKeyboard>)keyboard willInsertKey:(NSString*)key;
- (void)keyboardWillDeleteKey:(id<JYKeyboard>)keyboard;
- (void)keyboardWillDone:(id<JYKeyboard>)keyboard;
- (void)keyboardWillClear:(id<JYKeyboard>)keyboard;
@end

#pragma mark -- 按键
@protocol JYKeyNote <NSObject>
- (NSString *)keyValue;
@end
@interface UILabel (JYKeyNote)<JYKeyNote>
@end
@interface UIButton (JYKeyNote)<JYKeyNote>
@end

@protocol JYInputSource <NSObject>
- (void)setCustomKeyboard:(id<JYKeyboard>)keyboard;
- (BOOL)systemCanInputSource;
@end

#pragma mark -- 自带输入源控件&&无输入源对象设置键盘
@interface UIView (JYKeyboardExtension)<JYInputSource,JYKeyboardDelegate>
@end

#pragma mark -- Tool
@interface NSArray(Extension)
- (NSArray *)shuffled;// 返回随机后的数组
@end

