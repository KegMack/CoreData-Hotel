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
  //self.datePicker.backgroundColor = [UIColor colorWithRed:0.7 green:0.8 blue:0 alpha:0.5];

  [self.nextButton addTarget:self action:@selector(nextPressed) forControlEvents:UIControlEventTouchUpInside];
  self.instructionsLabel.font = [UIFont fontWithName:@"Zapfino" size:23];
  self.instructionsLabel.text = @"Select Arrival Date";
  
  
  //  self.dateFormatter = [[NSDateFormatter alloc] init];
  //  //self.dateFormatter.dateStyle = NSDateFormatterShortStyle;
  //  self.dateFormatter.dateFormat = @"MMMM/yyyy";
}

-(void)nextPressed {
  
  NSDate *selectedDate = self.datePicker.date;
  
  EndDateViewController *endDateVC = [[EndDateViewController alloc] init];
  endDateVC.startDate = selectedDate;
  [self.navigationController pushViewController:endDateVC animated:true];
  
  //  NSString *dateString = [self.dateFormatter stringFromDate:selectedDate];
  //
  //  NSLog(@"%@",dateString);
  //
  //  NSDate *dateFromString = [self.dateFormatter dateFromString:dateString];
  
  // NSLog(@"%@",dateFromString);
  //  NSDate *now = [NSDate date];
  //  NSLog(@"now: %@",now);
  //  NSDate *then = [NSDate date];
  //  NSLog(@"then: %@",then);
  //  NSCalendar *calendar = [NSCalendar currentCalendar];
  //  NSTimeInterval interval = [then timeIntervalSinceDate:now];
  //
  //
  //
  //    NSDateComponents *nowComponents = [calendar components:NSCalendarUnitDay | NSCalendarUnitYear | NSCalendarUnitMonth fromDate:now];
  //  NSLog(@"%ld",(long)nowComponents.day);
  //  nowComponents.month = 6;
  //
  //  NSDate *threeHoursFromNow = [calendar dateByAddingUnit:NSCalendarUnitHour value:3 toDate:now options:nil];
  //
  //  NSDate *monthFromToday = [calendar dateFromComponents:nowComponents];
  //  
  //  NSLog(@"%@",monthFromToday);
  
  
}



@end
