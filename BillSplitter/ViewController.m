//
//  ViewController.m
//  BillSplitter
//
//  Created by Carl Udren on 1/23/16.
//  Copyright © 2016 Carl Udren. All rights reserved.
//

#import "ViewController.h"

@interface ViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *billTextField;
@property (weak, nonatomic) IBOutlet UIStepper *splitStepper;
@property (weak, nonatomic) IBOutlet UILabel *splitLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (weak, nonatomic) IBOutlet UISlider *tipSlider;
@property (weak, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) NSNumberFormatter *number;
- (IBAction)tipStepperDidChange:(UIStepper *)sender;
@property (weak, nonatomic) IBOutlet UIStepper *tipStepper;
@property (assign, nonatomic) float total;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.billTextField becomeFirstResponder];
    
    self.tipStepper.value = self.tipSlider.value;
    
    [self updateTextLabelsWithText];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTextLabelsWithText) name:UITextFieldTextDidChangeNotification object:nil];

}

- (void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.billTextField resignFirstResponder];
}


- (IBAction)stepperChanged:(UIStepper *)sender {
        [self updateTextLabelsWithText];
}


- (IBAction)sliderDidChange:(UISlider *)sender {
    self.tipStepper.value = self.tipSlider.value;
    [self updateTextLabelsWithText];
}


- (IBAction)tipStepperDidChange:(UIStepper *)sender {
    if (self.tipSlider.value > self.tipStepper.value) {
        self.tipStepper.value = ceilf(self.tipStepper.value);
    } else {
        self.tipStepper.value = floorf(self.tipStepper.value);
    }
    self.tipSlider.value = self.tipStepper.value;
    [self updateTextLabelsWithText];
}


- (void) updateTextLabelsWithText{
    self.total = ceilf(100 * [self.billTextField.text floatValue] * (1+(self.tipSlider.value / 100)) / self.splitStepper.value) / 100;
    
    NSString *somestring = [NSString stringWithFormat:@"%1.2f%%", self.tipSlider.value];
    self.tipLabel.text = somestring;
    
    NSString *somestring2 = [NSString stringWithFormat:@"%1.0f", self.splitStepper.value];
    self.splitLabel.text = somestring2;
    
    NSString *somestring3 = [NSString stringWithFormat:@"$%1.2f", self.total];
    self.totalLabel.text = somestring3;
}


@end
