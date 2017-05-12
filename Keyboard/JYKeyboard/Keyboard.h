//
//  AbstractKeyboard.h
//  Keyboard
//
//  Created by Jolie_Yang on 16/7/20.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol NLKeyNote;
@protocol NLKeyboardDelegate;

@class NLAbstractKeyboard;

@protocol NLKeyboard <NSObject>
- (IBAction)onKeyTouch:(id<NLKeyNote>)sender;
- (IBAction)onDelete:(id)sender;
//- (IBAction)onClear:(id)sender;
- (IBAction)onDone:(id)sender;
@end

@protocol NLKeyboardDelegate <NSObject>
@required
- (void)keyboard: (id<NLKeyboard>)keyboard willInsertKey:(NSString *)key;
- (void)keyboardWillDeleteKey:(id<NLKeyboard>)keyboard;
- (void)keyboardWillDone:(id<NLKeyboard>)keyboard;
@optional

- (UITextField*)textField;
@end

@protocol NLKeyNote <NSObject>
- (NSString *)keyValue;
@end

@interface NLAbstractKeyboard : UIView<NLKeyboard>
@property (nonatomic, strong)IBOutletCollection(UIView) NSArray *randomItems;
@property (nonatomic, strong)IBOutletCollection(UIView) NSArray *randomAccesoryItems;
@property (nonatomic, strong) id<NLKeyboardDelegate> delegate;
@end



@interface UITextField(KeyboardExtension)
- (void)setInputViewWithKeyboard:(id<NLKeyboard>)keyboard;
- (void)setInputViewWithKB:(NLAbstractKeyboard *)keyboard;
- (void)setInputViewWithKB:(NLAbstractKeyboard *)keyboard secure:(BOOL)secure;
@end
@interface UITextField (NLKeyboardDelegateImplement)<NLKeyboardDelegate>
@end

@interface UILabel(NLKeyNote)<NLKeyNote>
@end

@interface UIButton(NLKeyNote)<NLKeyNote>
@end


