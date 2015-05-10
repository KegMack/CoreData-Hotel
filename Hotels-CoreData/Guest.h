//
//  Guest.h
//  Hotels-CoreData
//
//  Created by User on 5/9/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Reservation;

@interface Guest : NSManagedObject

@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSSet *reservation;
@end

@interface Guest (CoreDataGeneratedAccessors)

- (void)addReservationObject:(Reservation *)value;
- (void)removeReservationObject:(Reservation *)value;
- (void)addReservation:(NSSet *)values;
- (void)removeReservation:(NSSet *)values;

@end
