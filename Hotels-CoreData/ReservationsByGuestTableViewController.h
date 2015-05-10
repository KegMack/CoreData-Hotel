//
//  ReservationsByGuestTableViewController.h
//  Hotels-CoreData
//
//  Created by User on 5/9/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "VanillaTableViewController.h"
#import "AppDelegate.h"


@interface ReservationsByGuestTableViewController : VanillaTableViewController

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSString *lastName;

@end
