//
//  JSONSeedParser.m
//  Hotels-CoreData
//
//  Created by User on 5/4/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "JSONSeedParser.h"
#import "AppDelegate.h"
#import "Hotel.h"
#import "Room.h"


@implementation JSONSeedParser

+ (void) initHotelsFromJSONSeed {
  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  
  NSError *error = [[NSError alloc] init];
  NSString *filename = [[NSBundle mainBundle] pathForResource:@"seed" ofType:@"json"];
  NSString *jsonText = [[NSString alloc] initWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:NULL];
  if (!jsonText) {
    NSLog(@"%@ could not be read.", filename);
  }
  
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonText dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
  
  NSArray *jsonHotels = json[@"Hotels"];
  for(NSDictionary *jsonHotel in jsonHotels) {

    NSEntityDescription *hotelEntity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:appDelegate.managedObjectContext];
    Hotel *hotel = [[Hotel alloc] initWithEntity:hotelEntity insertIntoManagedObjectContext:appDelegate.managedObjectContext];
    
    hotel.stars = [jsonHotel objectForKey:@"stars"];
    hotel.name = [jsonHotel objectForKey:@"name"];
    hotel.location = [jsonHotel objectForKey:@"location"];
    NSArray *jsonRooms = [jsonHotel objectForKey:@"rooms"];
    
    for(NSDictionary *jsonRoom in jsonRooms) {
      
      NSEntityDescription *roomEntity = [NSEntityDescription entityForName:@"Room" inManagedObjectContext:appDelegate.managedObjectContext];
      Room *room = [[Room alloc] initWithEntity:roomEntity insertIntoManagedObjectContext:appDelegate.managedObjectContext];
      
      room.number = [jsonRoom objectForKey:@"number"];
      room.beds = [jsonRoom objectForKey:@"beds"];
      room.rate = [jsonRoom objectForKey:@"rate"];
      room.hotel = hotel;
      [hotel addRoomsObject:room];
    }

  }
  
  NSError *saveError;
  [appDelegate.managedObjectContext save:&saveError];
  if (saveError) {
    NSLog(@"JSONSeedParser Error: %@",saveError.localizedDescription);
  } else {
    NSLog(@"New Hotel seed successfully created and saved");
  }
  
}


@end
