//
//  DatePickerViewController.h
//  Hotels-CoreData
//
//  Created by User on 5/5/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerViewController : UIViewController

@property (strong,nonatomic) UIDatePicker *datePicker;
@property (strong,nonatomic) UILabel *instructionsLabel;
@property (strong,nonatomic) UIButton *nextButton;

@end
