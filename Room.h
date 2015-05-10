//
//  Room.h
//  Hotels-CoreData
//
//  Created by User on 5/5/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Hotel, Reservation;

@interface Room : NSManagedObject

@property (nonatomic, retain) NSNumber * beds;
@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSDecimalNumber * rate;
@property (nonatomic, retain) Hotel *hotel;
@property (nonatomic, retain) NSSet *reservation;

@end

@interface Room (CoreDataGeneratedAccessors)

- (void)addReservationObject:(Reservation *)value;
- (void)removeReservationObject:(Reservation *)value;
- (void)addReservation:(NSSet *)values;
- (void)removeReservation:(NSSet *)values;

@end
