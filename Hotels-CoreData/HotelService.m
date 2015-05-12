//
//  HotelService.m
//  Hotels-CoreData
//
//  Created by User on 5/7/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "HotelService.h"
#import "JSONSeedParser.h"
#import "CoreDataStack.h"
#import "Reservation.h"
#import "Room.h"
#import "Guest.h"

@interface HotelService ()

@property (strong,nonatomic) CoreDataStack *coreDataStack;

@end


@implementation HotelService

-(instancetype)initWithCoreDataStack:(CoreDataStack *)coreDataStack {
  self = [super init];
  if (self) {
    self.coreDataStack = coreDataStack;
  }
  return self;
}

- (void)saveContext {
  [self.coreDataStack saveContext];
}

- (void)initializeHotelsFromSeedIfNeeded {
  
  //Using countForFetchRequest as quickest/cheapest way I found to verify if any hotels exist.  If none, then seed.
  //Is there a better way to verify???
  
  NSFetchRequest *probe = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  NSError *error = nil;
  NSUInteger count = [self.coreDataStack.managedObjectContext countForFetchRequest:probe error:&error];
  if (!error && count <=0) {
    [JSONSeedParser initHotelsFromJSONSeedInContext:self.coreDataStack.managedObjectContext];
  }
}


-(NSFetchedResultsController *)fetchedResultsControllerForAllHotels {
  
  NSFetchRequest *hotelFetch = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  NSSortDescriptor *hotelSort = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:true];
  hotelFetch.sortDescriptors = @[hotelSort];
  NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:hotelFetch managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:nil cacheName:nil];
  return fetchedResultsController;
}

-(Reservation *)bookReservationForRoom:(Room *)room startDate:(NSDate *)startDate endDate:(NSDate *)endDate withFirstName:(NSString *)firstName lastName:(NSString *)lastName {
  
  Reservation *reservation = [NSEntityDescription insertNewObjectForEntityForName:@"Reservation" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  reservation.room = room;
  reservation.startDate = startDate;
  reservation.endDate = endDate;
  
  Guest *guest = [NSEntityDescription insertNewObjectForEntityForName:@"Guest" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  guest.firstName = firstName;
  guest.lastName = lastName;
  reservation.guest = guest;
  
  NSError *saveError;
  [self.coreDataStack.managedObjectContext save:&saveError];
  
  if (saveError) {
    NSLog(@"Error saving: %@", saveError);
    return nil;
  }
  
  return reservation;
}


-(NSFetchedResultsController *)fetchedResultsControllerForGuestReservationsByLastName:(NSString *)lastName {
  
  NSFetchRequest *reservationRequest = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
  
  if(![lastName isEqualToString:@""]) {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"guest.lastName == %@", lastName];
    reservationRequest.predicate = predicate;
  }
  
  NSError *error = nil;
  NSUInteger count = [self.coreDataStack.managedObjectContext countForFetchRequest:reservationRequest error:&error];
  if (error || count <=0) {
    return nil;
  }
  else {
    NSSortDescriptor *firstNameSort = [NSSortDescriptor sortDescriptorWithKey:@"guest.firstName" ascending:true];
    NSSortDescriptor *dateSort = [NSSortDescriptor sortDescriptorWithKey:@"startDate" ascending:true];
    reservationRequest.sortDescriptors = @[firstNameSort, dateSort];
    NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:reservationRequest managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:@"guest.firstName" cacheName:nil];
    return fetchedResultsController;
  }
}

-(NSFetchedResultsController *)fetchedResultsControllerForAvailableRooms:(NSDate*)startDate toDate:(NSDate *)endDate {
  
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Reservation"];
  NSPredicate *predicate = [NSPredicate predicateWithFormat:@"startDate <= %@ AND endDate >= %@",endDate,startDate];
  request.predicate = predicate;
  NSError *fetchError;
  NSArray *results = [self.coreDataStack.managedObjectContext executeFetchRequest:request error:&fetchError];
  
  NSMutableArray *badRooms = [[NSMutableArray alloc] init];
  for (Reservation *reservation in results) {
    [badRooms addObject:reservation.room];
  }
  
  NSFetchRequest *roomRequest = [NSFetchRequest fetchRequestWithEntityName:@"Room"];
  NSPredicate *roomPredicate = [NSPredicate predicateWithFormat:@"NOT self IN %@", badRooms];
  NSSortDescriptor *hotelNameSort = [NSSortDescriptor sortDescriptorWithKey:@"hotel.name" ascending:true];
  NSSortDescriptor *roomSort = [NSSortDescriptor sortDescriptorWithKey:@"number" ascending:true];

  roomRequest.sortDescriptors = @[hotelNameSort, roomSort];
  roomRequest.predicate = roomPredicate;
  NSFetchedResultsController *fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:roomRequest managedObjectContext:self.coreDataStack.managedObjectContext sectionNameKeyPath:@"hotel.name" cacheName:@"Available rooms cache"];

  return fetchedResultsController;
  
}


@end
