//
//  ViewController.m
//  Keyboard
//
//  Created by Jolie_Yang on 16/7/20.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "ViewController.h"
#import "AliKeyboard.h"
#import "JYKeyboard.h"
#import "JYViewInput.h"

@interface ViewController ()<UIViewInputDelegate, JYKeyboardDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *customLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIView *customView;

@property (nonatomic, strong) UITextField *sysKeyboard;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    // 1. 有输入源控件设置自定义键盘
    // 1.1 UITextField
    AliKeyboard *textFieldKB = [AliKeyboard standardShuffledKeyboard];
    self.inputTF.viewInputDelegate = self;
    self.inputTF.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.inputTF setCustomKeyboard:textFieldKB];
    
    // 1.2 UITextView
    AliKeyboard *textViewKB = [AliKeyboard standardShuffledKeyboard];
    [self.textView setCustomKeyboard:textViewKB secureTextEntry:YES];
    self.textView.viewInputDelegate = self;
    
    // 2.无输入源控件添加输入响应--原生键盘
    [self.label noInputControlSetSystemKeyboardWithConfigBlock:^(JYKeyboardConfig *config) {
        config.keyboardType = UIKeyboardTypeNumberPad;
    }];
    self.label.viewInputDelegate = self;
    
    // 3.无输入源控件添加输入响应--自定义键盘
    // 3.1 UILabel
    AliKeyboard *labelKB = [AliKeyboard standardShuffledKeyboard];
    [self.customLabel setCustomKeyboard:labelKB];
    self.customLabel.viewInputDelegate = self;
    
    // 3.2 UIView
    AliKeyboard *viewKB = [AliKeyboard standardShuffledKeyboard];
    self.customView.viewInputDelegate = self;
    [self.customView setCustomKeyboard:viewKB secureTextEntry:NO];
}
#pragma mark -- Action
- (IBAction)testAction:(id)sender {
    [self.view endEditing:YES];
}

#pragma mark -- UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    return NO;
}

#pragma mark UIViewInputDelegate
- (BOOL)inputSource:(UIView *)inputSource shouldChangeText:(NSString *)text replacementString:(NSString *)string {
    if ([inputSource isEqual:self.inputTF]) {
        if (self.inputTF.text.length >= 6 && string.length > 0) {
            return NO;
        }
    }
    return YES;
}

- (NSString *)inputSourceDefaultText:(UIView *)inputSource {
    return @"Rose";
}
- (void)inputSource:(UIView *)inputSourece didChangeText:(NSString *)text {
    
}

- (BOOL)inputSourceShouldClear:(UIView *)inputSource {
    return YES;
}
- (BOOL)inputSourceShouldReturn:(UIView *)inputSource {
    return YES;
}

@end
