//
//  HotelService.h
//  Hotels-CoreData
//
//  Created by User on 5/7/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
@class CoreDataStack;
@class NSFetchedResultsController;
@class Reservation;
@class Room;

@interface HotelService : NSObject

-(instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack;
-(void)saveContext;
-(void)initializeHotelsFromSeedIfNeeded;
-(NSFetchedResultsController *)fetchedResultsControllerForAllHotels;
-(Reservation *)bookReservationForRoom:(Room *)room startDate:(NSDate *)startDate endDate:(NSDate *)endDate withFirstName:(NSString *)firstName lastName:(NSString *)lastName;
-(NSFetchedResultsController *)fetchedResultsControllerForAvailableRooms:(NSDate*)startDate toDate:(NSDate *)endDate;
-(NSFetchedResultsController *)fetchedResultsControllerForGuestReservationsByLastName:(NSString *)lastName;

@end

