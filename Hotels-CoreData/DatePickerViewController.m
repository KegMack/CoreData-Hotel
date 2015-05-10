//
//  DatePickerViewController.m
//  Hotels-CoreData
//
//  Created by User on 5/5/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "DatePickerViewController.h"

@interface DatePickerViewController ()

@end

@implementation DatePickerViewController

-(void)loadView {
  
  UIView *rootView = [[UIView alloc] init];
  rootView.backgroundColor = [UIColor whiteColor];
  self.view = rootView;
  
  self.datePicker = [[UIDatePicker alloc] init];
  self.datePicker.datePickerMode = UIDatePickerModeDate;
  [self.view addSubview:self.datePicker];
  [self.datePicker setTranslatesAutoresizingMaskIntoConstraints:false];
  
  self.instructionsLabel = [[UILabel alloc] init];
  [self.instructionsLabel setTranslatesAutoresizingMaskIntoConstraints:false];
  [self.view addSubview:self.instructionsLabel];
  
  self.nextButton = [[UIButton alloc] init];
  [self.nextButton setTitle:@"Next" forState:UIControlStateNormal];
  [self.nextButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
  [self.nextButton setTranslatesAutoresizingMaskIntoConstraints:false];
  [self.view addSubview:self.nextButton];
  
  [self addConstraintsToSuperView];
  
}

- (void)viewDidLoad {
  [super viewDidLoad];
}

-(void)addConstraintsToSuperView {
  
  NSLayoutConstraint *datePickerCenterX = [NSLayoutConstraint constraintWithItem:self.datePicker attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
  NSLayoutConstraint *datePickerCenterY = [NSLayoutConstraint constraintWithItem:self.datePicker attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0.0];
  [self.view addConstraints:@[datePickerCenterX, datePickerCenterY]];
  
  NSDictionary *views = @{@"instructionsLabel" : self.instructionsLabel, @"nextButton" : self.nextButton, @"datePicker" : self.datePicker};
  
  NSLayoutConstraint *labelCenterX = [NSLayoutConstraint constraintWithItem:self.instructionsLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
  [self.view addConstraint:labelCenterX];
  NSArray *labelYConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[instructionsLabel]-[datePicker]" options:0 metrics:nil views:views];
  [self.view addConstraints:labelYConstraints];
  
  NSLayoutConstraint *buttonCenterX = [NSLayoutConstraint constraintWithItem:self.nextButton attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
  [self.view addConstraint:buttonCenterX];
  NSArray *buttonYConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[datePicker]-20-[nextButton]" options:0 metrics:nil views:views];
  [self.view addConstraints:buttonYConstraints];
}

@end