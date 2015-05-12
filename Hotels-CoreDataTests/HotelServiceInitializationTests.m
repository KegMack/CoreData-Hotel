//
//  HotelServiceInitializationTests.m
//  Hotels-CoreData
//
//  Created by User on 5/10/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HotelService.h"
#import "CoreDataStack.h"
#import "Hotel.h"
#import "Room.h"
#import "Guest.h"
#import "Reservation.h"


@interface HotelServiceInitializationTests : XCTestCase
@property (strong, nonatomic) CoreDataStack *coreDataStack;
@property (strong, nonatomic) HotelService *hotelService;
@end

@implementation HotelServiceInitializationTests

- (void)setUp {
  [super setUp];
  self.coreDataStack = [[CoreDataStack alloc] initForTesting];
  self.hotelService = [[HotelService alloc] initWithCoreDataStack:self.coreDataStack];

}

- (void)tearDown {
  self.coreDataStack = nil;
  self.hotelService = nil;
  [super tearDown];
}

- (void)seedDatabaseWithHotels {
  Hotel *hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  hotel.name = @"MMM";
  hotel.location = @"MMM";
  Hotel *hotel2 = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  hotel2.name = @"BBB";
  hotel2.location = @"YYY";
  Hotel *hotel3 = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  hotel3.name = @"YYY";
  hotel3.location = @"BBB";
  [self.coreDataStack saveContext];
}

- (void)testForEmptySaveContext {
  [self.hotelService saveContext];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  NSError *error = nil;
  NSUInteger count = [self.coreDataStack.managedObjectContext countForFetchRequest:request error:&error];
  XCTAssertTrue(count == 0, @"Found data in empty context");
}

- (void)testForSaving {
  Hotel *hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  hotel.name = @"TestName";
  hotel.location = @"TestLocation";
  [self.hotelService saveContext];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  NSError *error = nil;
  NSUInteger count = [self.coreDataStack.managedObjectContext countForFetchRequest:request error:&error];
  XCTAssertTrue(count == 1, @"Hotel from context not saved");
}

- (void)testForJSONSeeding {
  [self.hotelService initializeHotelsFromSeedIfNeeded];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  NSError *error = nil;
  NSUInteger count = [self.coreDataStack.managedObjectContext countForFetchRequest:request error:&error];
  XCTAssertTrue(count == 4, @"Hotels from from JSON seed not in context");
}

- (void)testForJSONSeedingData {
  [self.hotelService initializeHotelsFromSeedIfNeeded];
  NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  NSError *error = nil;
  NSArray *hotels = [self.coreDataStack.managedObjectContext executeFetchRequest:request error:&error];
  for(Hotel *hotel in hotels) {
    XCTAssertNotNil(hotel.name, @"hotel not named");
    XCTAssertNotNil(hotel.location, @"hotel has no location");
    XCTAssertNotNil(hotel.stars, @"hotel has no stars");
    XCTAssertNotNil(hotel.insidePhoto, @"hotel has no inside photo");
    XCTAssertNotNil(hotel.outsidePhoto, @"hotel has no outside photo");
    for(Room *room in hotel.rooms) {
      XCTAssertNotNil(room.number, @"room has no number");
      XCTAssertNotNil(room.beds, @"room has no beds");
      XCTAssertNotNil(room.rate, @"room has no rate");
    }
  }
}

- (void)testFetchedResultsControllerForAllHotelsIsReturned {
  NSFetchedResultsController * frc = [self.hotelService fetchedResultsControllerForAllHotels];
  XCTAssertNotNil(frc, @"fetched results controller is nil");
}

- (void)testFetchedResultsControllerForAllHotelsHasHotels {
  [self seedDatabaseWithHotels];
  NSFetchedResultsController * frc = [self.hotelService fetchedResultsControllerForAllHotels];
  NSError *error;
  [frc performFetch:&error];
  XCTAssertTrue(frc.fetchedObjects.count == 3, @"fetched results controller does not have the correct amount of hotels");
}

- (void)testFetchedResultsControllerForAllHotelsIsSortingByName {
  [self seedDatabaseWithHotels];
  Hotel *hotel = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  hotel.name = @"ZZZ";
  hotel.location = @"Test";
  Hotel *hotel2 = [NSEntityDescription insertNewObjectForEntityForName:@"Hotel" inManagedObjectContext:self.coreDataStack.managedObjectContext];
  hotel2.name = @"AAA";
  hotel2.location = @"Test";
  [self.coreDataStack saveContext];
  NSFetchedResultsController * frc = [self.hotelService fetchedResultsControllerForAllHotels];
  NSError *error;
  [frc performFetch:&error];
  Hotel *firstHotel = frc.fetchedObjects.firstObject;
  Hotel *lastHotel = frc.fetchedObjects.lastObject;
  XCTAssertTrue([firstHotel.name isEqualToString:hotel2.name], @"first hotel name is not first alphabetically.");
  XCTAssertTrue([lastHotel.name isEqualToString:hotel.name], @"last hotel name is not last alphabetically.");
}

- (void)testBookReservationForRoom {
  [self.hotelService initializeHotelsFromSeedIfNeeded];
  NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Hotel"];
  NSError *error;
  NSArray *hotels = [self.coreDataStack.managedObjectContext executeFetchRequest:request error:&error];
  Hotel *hotel = hotels.firstObject;
  Room *room = hotel.rooms.anyObject;
  NSDate *startDate = [[NSDate alloc] init];
  NSDate *endDate = [[NSDate alloc] initWithTimeIntervalSinceNow:1000];
  NSString *firstName = @"Testy";
  NSString *lastName = @"McTester";
  Reservation *reservation = [self.hotelService bookReservationForRoom:room startDate:startDate endDate:endDate withFirstName:firstName lastName:lastName];
  XCTAssertTrue(reservation.startDate.timeIntervalSinceReferenceDate == startDate.timeIntervalSinceReferenceDate, @"start date not in reservation");
  XCTAssertTrue(reservation.endDate.timeIntervalSinceReferenceDate == endDate.timeIntervalSinceReferenceDate, @"end date not in reservation");
  XCTAssertTrue([reservation.guest.firstName isEqualToString:firstName], @"Reservation first name not correct");
  XCTAssertTrue([reservation.guest.lastName isEqualToString:lastName], @"Reservation last name incorrect");
  XCTAssertTrue(reservation.room == room, @"Reservation not in correct room");
}


@end
