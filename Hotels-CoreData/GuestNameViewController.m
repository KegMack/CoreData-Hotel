//
//  GuestNameViewController.m
//  Hotels-CoreData
//
//  Created by User on 5/9/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "GuestNameViewController.h"
#import "AppDelegate.h"
#import "ReservationsByGuestTableViewController.h"

@interface GuestNameViewController ()

@property (nonatomic, strong) UITextField *lastNameTextField;
@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UILabel *infoLabel;

@end

@implementation GuestNameViewController

-(void)loadView {
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0 blue:0.5 alpha:1];
  self.lastNameTextField = [[UITextField alloc] init];
  self.searchButton = [[UIButton alloc] init];
  self.infoLabel = [[UILabel alloc] init];
  [self constrainSubviews];
}


- (void)viewDidLoad {
  [super viewDidLoad];
  [self initializeNameField];
  [self initializeInfoLabel];
  [self initializeSearchButton];
  self.navigationItem.title = @"Search for Reservation";
}

- (void)initializeNameField {
  self.lastNameTextField.placeholder = @"Last Name";
  self.lastNameTextField.backgroundColor = [UIColor lightGrayColor];
  self.lastNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  
}

- (void)initializeSearchButton {
  self.searchButton.backgroundColor = [UIColor colorWithRed:0.3 green:0 blue:0.3 alpha:1];
  [self.searchButton setTitle:@"Search" forState:UIControlStateNormal];
  [self.searchButton addTarget:self action:@selector(searchForReservation) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)initializeInfoLabel {
  self.infoLabel.numberOfLines = 0;
  self.infoLabel.textAlignment = NSTextAlignmentCenter;
  self.infoLabel.adjustsFontSizeToFitWidth = true;
  self.infoLabel.minimumScaleFactor = 0.5;
  self.infoLabel.font = [UIFont fontWithName:@"Verdana-Italic" size:24];
  self.infoLabel.text = [NSString stringWithFormat:@"Please enter the last name of the reservation, then click below. \n\nLeave text field blank to display all reservations \n\nNote: Name fields are case-sensitive."];
}

- (void)searchForReservation {

//if ([self.lastNameTextField.text isEqualToString:@""]) {
//    [self shake:self.lastNameTextField];
//  }
//  else {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    NSFetchedResultsController *fetchedResultsController = [appDelegate.hotelService fetchedResultsControllerForGuestReservationsByLastName:self.lastNameTextField.text];
    
    if(fetchedResultsController) {
      ReservationsByGuestTableViewController *reservationsVC = [[ReservationsByGuestTableViewController alloc] init];
      reservationsVC.fetchedResultsController = fetchedResultsController;
      reservationsVC.lastName = self.lastNameTextField.text;
      [self.navigationController pushViewController:reservationsVC animated:true];
      
    } else {
      UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"No Matches" message:@"There are no reservations for a guest with that last name." preferredStyle:UIAlertControllerStyleAlert];
      UIAlertAction *action = [UIAlertAction actionWithTitle:@"Okie Dokie" style:UIAlertActionStyleCancel handler: nil];
      [alertController addAction:action];
      [self presentViewController:alertController animated:true completion:nil];
    }
//  }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

-(void) shake:(UIView *)viewToShake {
  [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0 initialSpringVelocity:10 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    viewToShake.transform = CGAffineTransformMakeTranslation(5, 0);
  } completion:^(BOOL finished) {
    viewToShake.transform = CGAffineTransformMakeTranslation(0, 0);
  }];
}

- (void)constrainSubviews   {
  
  NSDictionary *views = @{@"lastName" : self.lastNameTextField, @"search" : self.searchButton, @"info" : self.infoLabel};
  
  for (NSString* key in views) {
    UIView *subView = [views objectForKey:key];
    [self.view addSubview:subView];
    [subView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self.view addConstraint:centerX];

  }
  
  NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[lastName(30)]-10-[info]-30-[search(40)]-30-|" options:0 metrics:nil views:views];
  [self.view addConstraints:verticalConstraints];
  
  NSLayoutConstraint *textFieldWidth = [NSLayoutConstraint constraintWithItem:self.lastNameTextField attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.7 constant:0.0];
  [self.view addConstraint:textFieldWidth];

  NSLayoutConstraint *infoLabelWidth = [NSLayoutConstraint constraintWithItem:self.infoLabel attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.9 constant:0.0];
  [self.view addConstraint:infoLabelWidth];

  
  
}


@end
