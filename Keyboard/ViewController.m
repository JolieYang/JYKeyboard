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

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextField *inputTF;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, strong) UITextField *sysKeyboard;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//    id<NLKeyboard> keyboard = [NLKeyboardNumberPad standardKeyboard];
//    [self.inputTF setInputViewWithKeyboard:keyboard];
    NLKeyboardNumberPad *keyboard = [NLKeyboardNumberPad standardKeyboard];
//    NLKeyboardNumberPad *keyboard = [NLKeyboardNumberPad securityKeyboard];
//    [self.inputTF setInputViewWithKB: keyboard secure:NO];
    id<NLKeyboardDelegate> tf = self.inputTF;
    [self.inputTF setInputViewWithKeyboard:keyboard];
    
    
//    self.sysKeyboard = [[UITextField alloc] initWithFrame:self.label.frame];
//    [self.sysKeyboard setFrame:CGRectMake(0, 0, self.label.frame.size.width, self.label.frame.size.height)];
//    self.sysKeyboard.delegate = self;
//    self.sysKeyboard.secureTextEntry = YES;
//    self.label.userInteractionEnabled = YES;
//    UITapGestureRecognizer *ges = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
//    [self.label addGestureRecognizer:ges];
//    self.sysKeyboard.text = @"rose";
//    [self.label addSubview:self.sysKeyboard];
//    [self.label setInputViewWithTextField:sysKeyboard];
    
}
- (void)test:(UITapGestureRecognizer *)recognizer {
    self.label.text = nil;
    UIView *view = recognizer.view;
//    UITextField *tf = [[UITextField alloc] initWithFrame:view.frame];
    [self.sysKeyboard setFrame:view.frame];
    [self.sysKeyboard becomeFirstResponder];
    self.label.text = self.sysKeyboard.text;
}
- (IBAction)touchUpInsideButton:(id)sender {
    self.label.text = [NSString stringWithFormat:@"%@ : %@", self.button.titleLabel.text, self.button.currentTitle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
