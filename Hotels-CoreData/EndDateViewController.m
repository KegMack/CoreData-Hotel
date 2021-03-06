//
//  EndDateViewController.m
//  Hotels-CoreData
//
//  Created by User on 5/5/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "EndDateViewController.h"
#import "AvailabilityTableViewController.h"

@interface EndDateViewController ()

@end

@implementation EndDateViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRed:0.4 green:0.5 blue:0 alpha:1];
  NSDate *nextDay = [[NSCalendar currentCalendar] dateByAddingUnit:NSCalendarUnitDay value:1 toDate:self.startDate options:0];
  [self.datePicker setDate:nextDay animated:false];
  self.datePicker.minimumDate = nextDay;
  [self.nextButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
  
  self.instructionsLabel.font = [UIFont fontWithName:@"Zapfino" size:21];
  self.instructionsLabel.minimumScaleFactor = 0.5;
  self.instructionsLabel.adjustsFontSizeToFitWidth = true;
  self.instructionsLabel.textAlignment = NSTextAlignmentCenter;
  self.instructionsLabel.text = @"Select Departure Date";
  [self.instructionsLabel sizeToFit];
}



-(void)nextPressed {
  
  AvailabilityTableViewController *availabilityTableVC = [[AvailabilityTableViewController alloc] init];
  availabilityTableVC.startDate = self.startDate;
  availabilityTableVC.endDate = self.datePicker.date;
  [self.navigationController pushViewController:availabilityTableVC animated:true];
}

@end
