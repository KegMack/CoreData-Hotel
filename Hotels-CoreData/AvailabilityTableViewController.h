//
//  AvailabilityTableViewController.h
//  Hotels-CoreData
//
//  Created by User on 5/5/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VanillaTableViewController.h"

@interface AvailabilityTableViewController : VanillaTableViewController

@property (strong,nonatomic) NSDate *startDate;
@property (strong,nonatomic) NSDate *endDate;

@end
