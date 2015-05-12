//
//  StartDateViewController.m
//  Hotels-CoreData
//
//  Created by User on 5/5/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "StartDateViewController.h"
#import "EndDateViewController.h"


@interface StartDateViewController ()

@end

@implementation StartDateViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.6 blue:0 alpha:1];

  self.datePicker.minimumDate = [[NSDate alloc] init];

  [self.nextButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
  self.instructionsLabel.font = [UIFont fontWithName:@"Zapfino" size:21];
  self.instructionsLabel.minimumScaleFactor = 0.5;
  self.instructionsLabel.adjustsFontSizeToFitWidth = true;
  self.instructionsLabel.textAlignment = NSTextAlignmentCenter;
  self.instructionsLabel.text = @"Select Arrival Date";
  [self.instructionsLabel sizeToFit];


}

-(void)nextPressed {
    
  EndDateViewController *endDateVC = [[EndDateViewController alloc] init];
  endDateVC.startDate = self.datePicker.date;
  [self.navigationController pushViewController:endDateVC animated:true];
  
}



@end
