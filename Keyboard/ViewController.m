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

@interface ViewController ()<UIViewInputDelegate>
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
    AliKeyboard *keyboard = [AliKeyboard standardShuffledKeyboard];
    self.inputTF.text = @"Rose";
    [self.inputTF setCustomKeyboard:keyboard];
    
    // 2.无输入源控件添加输入响应--原生键盘
    [self.label setSystemKeyboardWithConfigBlock:^(JYKeyboardConfig *config) {
        config.keyboardType = UIKeyboardTypeNumberPad;
    }];
    self.label.inputDelegate = self;
    
    // 3.无输入源控件添加输入响应--自定义键盘
    AliKeyboard *kb = [AliKeyboard standardShuffledKeyboard];
    [self.customLabel setCustomKeyboard:kb secureTextEntry:YES];
    
//    UITextField *tf = [[UITextField alloc] init];
//    [self.button setInputViewWithTextField:tf];
}
#pragma mark -- Action
- (IBAction)testAction:(id)sender {
    [self.view endEditing:YES];
}


#pragma mark UIViewInputDelegate
- (BOOL)inputSource:(UIView *)inputSource shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([inputSource isEqual:self.label]) {
        if (self.label.text.length >= 6 && string.length > 0) {
            return NO;
        }
    }
    return YES;
}
- (NSString *)inputSourceDefaultText:(UIView *)inputSource {
    return @"Rose";
}
@end
