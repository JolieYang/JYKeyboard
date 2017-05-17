//
//  ViewController.m
//  Keyboard
//
//  Created by Jolie_Yang on 16/7/20.
//  Copyright © 2016年 Jolie_Yang. All rights reserved.
//

#import "ViewController.h"
#import "NLKeyboardNumberPad.h"
#import "NLKeyboard.h"
#import "NLInputConnection.h"

@interface ViewController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *customLabel;
@property (weak, nonatomic) IBOutlet UITextView *textView;

@property (nonatomic, strong) UITextField *sysKeyboard;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    // 1. 自定义键盘
    NLKeyboardNumberPad *keyboard = [NLKeyboardNumberPad standardShuffledKeyboard];
    self.inputTF.text = @"Rose";
    self.inputTF.secureTextEntry = YES;
    self.inputTF.delegate = self;
    [self.inputTF setInputViewWithKeyboard:keyboard];
    
    // 2.无输入源控件添加输入响应--原生键盘
    UITextField *tf = [[UITextField alloc] init];
    tf.secureTextEntry = YES;
    [self.label setInputViewWithTextField:tf];
//    self.label.textFieldDelegate = self;
    NSLog(@"%@", self.label.associateKeyboardTextField);
    
    // 3.无输入源控件添加输入响应--自定义键盘
    NLKeyboardNumberPad *kb = [NLKeyboardNumberPad standardKeyboard];
    [self.customLabel setInputViewWithKeyboard:kb secureTextEntry:YES delegate:self];
    
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

@end
