//
//  NLKeyboard.h
//  Keyboard
//
//  Created by Jolie_Yang on 2017/5/12.
//  Copyright © 2017年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NLKeyboardDelegate;
@protocol NLKeyboard;
@protocol NLKeyNote;

@protocol NLKeyboard <NSObject>
- (void)keysRandomLayout;
- (IBAction)onKeyTouch:(id<NLKeyNote>)sender;
- (IBAction)onDelete:(id)sender;
- (IBAction)onDone:(id)sender;
- (IBAction)onClear:(id)sender;
@end

@interface NLAbstractKeyboard: UIView<NLKeyboard>
@property (nonatomic, strong) IBOutletCollection(UIView) NSArray *randomItems;
@property (nonatomic, assign) id<NLKeyboardDelegate> delegate;
@end

@protocol NLKeyboardDelegate <NSObject>
// ps: 无法共用同一个自定义keyboard对象
- (UIView *)inputSource;
@optional
- (void)keyboard:(id<NLKeyboard>)keyboard willInsertKey:(NSString*)key;
- (void)keyboardWillDeleteKey:(id<NLKeyboard>)keyboard;
- (void)keyboardWillDone:(id<NLKeyboard>)keyboard;
- (void)keyboardWillClear:(id<NLKeyboard>)keyboard;
@end

#pragma mark -- 按键
@protocol NLKeyNote <NSObject>
- (NSString *)keyValue;
@end
@interface UILabel (NLKeyNote)<NLKeyNote>
@end
@interface UIButton (NLKeyNote)<NLKeyNote>
@end

#pragma mark -- 自带输入源控件设置自定义键盘
@protocol NLInputSource <NSObject>
- (void)setInputViewWithKeyboard:(id<NLKeyboard>)keyboard;
@end

@interface UITextField (NLkeyboardExtension)<NLKeyboardDelegate,NLInputSource>
@end

@interface UITextView(NLKeyboardExtension)<NLKeyboardDelegate, NLInputSource>
@end

@interface UISearchBar(NLKeyboardExtension)<NLKeyboardDelegate, NLInputSource>
@end

#pragma mark -- 无输入源对象设置键盘


#pragma mark -- Tool
@interface NSArray(Extension)
- (NSArray *)shuffled;// 返回随机后的数组
@end

