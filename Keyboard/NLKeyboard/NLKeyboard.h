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

@protocol NLKeyNote <NSObject>
- (NSString *)keyValue;
@end
@protocol NLInputSource <NSObject>
- (void)setInputViewWithKeyboard:(id<NLKeyboard>)keyboard;
@end

@protocol NLKeyboardDelegate <NSObject>
- (void)keyboard:(id<NLKeyboard>)keyboard willInsertKey:(NSString*)key;
- (void)keyboardWillDeleteKey:(id<NLKeyboard>)keyboard;
- (void)keyboardWillDone:(id<NLKeyboard>)keyboard;
@optional
- (void)keyboardWillClear:(id<NLKeyboard>)keyboard;
// ps: 无法共用同一个自定义keyboard
- (UIView *)inputSource;
@end

@interface UILabel (NLKeyNote)<NLKeyNote>
@end
@interface UIButton (NLKeyNote)<NLKeyNote>
@end

@interface UITextField (NLkeyboardExtension)
- (void)setInputViewWithKeyboard:(id<NLKeyboard>)keyboard;
@end
@interface UITextField (NLKeyboardDelegateImplement)<NLKeyboardDelegate>
@end

@interface UITextView(NLKeyboardExtension)<NLInputSource>
@end
@interface UISearchBar(NLKeyboardExtension)<NLInputSource>
@end

@interface NSArray(Extension)
- (NSArray *)shuffled;// 返回随机后的数组
@end

