//
//  ReservationViewController.m
//  Hotels-CoreData
//
//  Created by User on 5/7/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "AppDelegate.h"
#import "ReservationViewController.h"
#import "Guest.h"
#import "Reservation.h"
#import "Hotel.h"
#import "ImageResizer.h"


@interface ReservationViewController ()

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UITextField *firstNameTextField;
@property (nonatomic, strong) UITextField *lastNameTextField;
@property (nonatomic, strong) UIButton *submitButton;
@property (nonatomic, strong) UILabel *reservationInfoLabel;

@property (nonatomic) CGFloat availableVerticalSpaceForImage;
@property (nonatomic) CGFloat totalVerticalMarginSpace;
@property (nonatomic) BOOL isLaidOut;

@end

@implementation ReservationViewController

CGFloat MIN_IMAGE_HEIGHT = 80.0;

-(void)loadView {
  self.view = [[UIView alloc] init];
  self.view.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0 alpha:1];
  self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
  self.firstNameTextField = [[UITextField alloc] init];
  self.lastNameTextField = [[UITextField alloc] init];
  self.submitButton = [[UIButton alloc] init];
  self.reservationInfoLabel = [[UILabel alloc] init];
  [self constrainSubviews];
}

- (void)viewDidLoad {
  [super viewDidLoad];
  self.isLaidOut = false;
  [self initializeNameFields];
  [self initializeReservationInfoLabel];
  [self initializeSubmitButton];
  self.navigationItem.title = @"Finalize Reservation";
}

-(BOOL)shouldAutorotate {
  return NO;
}

- (void)initializeNameFields {
  self.firstNameTextField.placeholder = @"First Name";
  self.lastNameTextField.placeholder = @"Last Name";
  
  self.firstNameTextField.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:1];
  self.lastNameTextField.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0 alpha:1];

  self.firstNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  self.lastNameTextField.autocorrectionType = UITextAutocorrectionTypeNo;
  
}

- (void)initializeSubmitButton {
  self.submitButton.backgroundColor = [UIColor colorWithRed:0.3 green:0.3 blue:0 alpha:1];
  [self.submitButton setTitle:@"Submit" forState:UIControlStateNormal];
  [self.submitButton addTarget:self action:@selector(submitReservation) forControlEvents:UIControlEventTouchUpInside];

}

- (void)initializeImageView {
  UIImage *image = [self.room.hotel getInsidePhoto];
  if(image.size.height > self.totalVerticalMarginSpace) {
    image = [self resizeImage:image];
  }
  self.imageView.image = image;
  self.imageView.contentMode = UIViewContentModeScaleAspectFit;
  self.imageView.backgroundColor = [UIColor blackColor];
  [self.imageView sizeThatFits:image.size];
}

- (void)initializeReservationInfoLabel {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  dateFormatter.dateStyle = NSDateFormatterMediumStyle;
  NSString *formattedStartDate = [dateFormatter stringFromDate:self.startDate];
  NSString *formattedEndDate = [dateFormatter stringFromDate:self.endDate];
  NSString *hotelAdjective = [self hotelDescriptorFromRating:self.room.hotel.stars];

  self.reservationInfoLabel.numberOfLines = 0;
  self.reservationInfoLabel.textAlignment = NSTextAlignmentCenter;
  self.reservationInfoLabel.font = [UIFont fontWithName:@"Zapfino" size:12];
  self.reservationInfoLabel.text = [NSString stringWithFormat:@" Reservation at the %@ \n %@-star %@\n in %@\n Room %@ \n from %@ \n through %@ ", hotelAdjective ,self.room.hotel.stars, self.room.hotel.name, self.room.hotel.location, self.room.number, formattedStartDate, formattedEndDate];

}

- (void)submitReservation {
  
  if([self.firstNameTextField.text isEqualToString:@""]) {
    [self shake:self.firstNameTextField];
  }
  else if ([self.lastNameTextField.text isEqualToString:@""]) {
    [self shake:self.lastNameTextField];
  }
  else {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate.hotelService bookReservationForRoom:self.room startDate:self.startDate endDate:self.endDate withFirstName:self.firstNameTextField.text lastName:self.lastNameTextField.text];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Reservation confirmed!" message:@"Thank you. \n Would you now like to reserve additional rooms for the same dates, or return to the Main Menu?" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *keepBookingAction = [UIAlertAction actionWithTitle:@"More Rooms" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      [self.navigationController popViewControllerAnimated:true];
    }];
    [alertController addAction:keepBookingAction];
    UIAlertAction *homeAction = [UIAlertAction actionWithTitle:@"Start Over" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
      [self.navigationController popToRootViewControllerAnimated:true];
    }];
    [alertController addAction:homeAction];
    [self presentViewController:alertController animated:true completion:nil];
  }
}

// MARK:  Methods to dynamically resize room image based on available screen size

- (void)viewDidLayoutSubviews {
  if(!self.isLaidOut) {
    self.availableVerticalSpaceForImage = self.view.frame.size.height - [self totalUsedVerticalSpace];
    if(self.availableVerticalSpaceForImage > MIN_IMAGE_HEIGHT) {
      [self initializeImageView];
    }
    self.isLaidOut = true;
  }
}

- (CGFloat)totalUsedVerticalSpace {
  CGFloat usedSpace = self.totalVerticalMarginSpace;
  for(UIView *subView in self.view.subviews) {
    usedSpace += subView.frame.size.height;
  }
  usedSpace -= self.imageView.frame.size.height;
  return usedSpace;
}

- (UIImage *)resizeImage:(UIImage *)image {
  double aspectRatio = image.size.width / image.size.height;
  CGSize newSize = CGSizeMake(aspectRatio * self.availableVerticalSpaceForImage, self.availableVerticalSpaceForImage);
  return [ImageResizer resizeImage:image toSize:newSize];
}


//Helper Methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
  [self.view endEditing:YES];
}

- (NSString *)hotelDescriptorFromRating:(NSNumber *)stars {
  int index = stars.intValue;
  switch (index) {
    case 0:
      return @"rat-infested";
      break;
    case 1:
      return @"dilapidated";
      break;
    case 2:
      return @"seedy";
      break;
    case 3:
      return @"comfortable";
      break;
    case 4:
      return @"highly accomodating";
      break;
    case 5:
      return @"insanely extravagant";
      break;
    default:
      return @"";
      break;
  }
}

-(void) shake:(UIView *)viewToShake {
  [UIView animateWithDuration:0.25 delay:0 usingSpringWithDamping:0 initialSpringVelocity:10 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
    viewToShake.transform = CGAffineTransformMakeTranslation(5, 0);
  } completion:^(BOOL finished) {
    viewToShake.transform = CGAffineTransformMakeTranslation(0, 0);
  }];
}

//MARK: AutoLayout

- (void)constrainSubviews   {
  
  NSDictionary *views = @{ @"imageView" : self.imageView, @"firstName" : self.firstNameTextField, @"lastName" : self.lastNameTextField, @"submit" : self.submitButton, @"reservationInfo" : self.reservationInfoLabel};
  
  for (NSString* key in views) {
    UIView *subView = [views objectForKey:key];
    [self.view addSubview:subView];
    [subView setTranslatesAutoresizingMaskIntoConstraints:false];
    
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0.0];
    [self.view addConstraint:centerX];
    
    if([subView isKindOfClass:[UITextField class]]) {
      NSLayoutConstraint *labelWidth = [NSLayoutConstraint constraintWithItem:subView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:0.7 constant:0.0];
      [self.view addConstraint:labelWidth]; 
    }
  }
  
  NSArray *verticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-80-[firstName(30)]-10-[lastName(30)]-10-[imageView]-10-[reservationInfo]-20-[submit(40)]-20-|" options:0 metrics:nil views:views];
  [self.view addConstraints:verticalConstraints];
  
  // add total margin space based on arbitrary spacing values in VisualFormat. Crappy programming structure, but currently don't know how to put variables for spaces between margins in VisualFormat.
  self.totalVerticalMarginSpace = 80 + 10 + 10 + 10 + 20 + 20;
  
}

@end
