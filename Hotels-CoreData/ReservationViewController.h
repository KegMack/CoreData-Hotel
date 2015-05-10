//
//  ReservationViewController.h
//  Hotels-CoreData
//
//  Created by User on 5/7/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Room.h"

@interface ReservationViewController : UIViewController

@property (strong, nonatomic) NSDate *startDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) Room *room;

@end
