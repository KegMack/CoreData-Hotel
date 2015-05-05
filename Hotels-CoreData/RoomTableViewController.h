//
//  RoomTableViewController.h
//  Hotels-CoreData
//
//  Created by User on 5/4/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "VanillaTableViewController.h"
#import "Hotel.h"
#import "Room.h"

@interface RoomTableViewController : VanillaTableViewController

@property (nonatomic, strong) Hotel *hotel;

@end
