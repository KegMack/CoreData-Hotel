//
//  JSONSeedParser.m
//  Hotels-CoreData
//
//  Created by User on 5/4/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "JSONSeedParser.h"
#import <UIKit/UIKit.h>
#import "Hotel.h"
#import "Room.h"


@implementation JSONSeedParser

+ (void) initHotelsFromJSONSeedInContext:(NSManagedObjectContext *)context {
  
  NSError *error = [[NSError alloc] init];
  NSString *filename = [[NSBundle mainBundle] pathForResource:@"seed" ofType:@"json"];
  NSString *jsonText = [[NSString alloc] initWithContentsOfFile:filename encoding:NSUTF8StringEncoding error:NULL];
  if (!jsonText) {
    NSLog(@"%@ could not be read.", filename);
  }
  
  NSDictionary *json = [NSJSONSerialization JSONObjectWithData:[jsonText dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:&error];
  
  NSArray *jsonHotels = json[@"Hotels"];
  for(NSDictionary *jsonHotel in jsonHotels) {

    NSEntityDescription *hotelEntity = [NSEntityDescription entityForName:@"Hotel" inManagedObjectContext:context];
    Hotel *hotel = [[Hotel alloc] initWithEntity:hotelEntity insertIntoManagedObjectContext:context];
    
    hotel.stars = [jsonHotel objectForKey:@"stars"];
    hotel.name = [jsonHotel objectForKey:@"name"];
    hotel.location = [jsonHotel objectForKey:@"location"];
    
    /// seed photos
    if([hotel.name isEqualToString:@"Fancy Estates"]) {
      [hotel addOutsidePhoto: [UIImage imageNamed:@"FancyHotel.jpeg"]];
      [hotel addInsidePhoto:[UIImage imageNamed:@"FancyRoom.jpg"]];
    }
    else if ([hotel.name isEqualToString:@"Okay Motel"]) {
      [hotel addOutsidePhoto:[UIImage imageNamed:@"SeedyHotel.jpeg"]];
      [hotel addInsidePhoto:[UIImage imageNamed:@"SeedyRoom.jpg"]];
    }
    else if ([hotel.name isEqualToString:@"Solid Stay"]) {
      [hotel addOutsidePhoto:[UIImage imageNamed:@"NiceHotel.jpeg"]];
      [hotel addInsidePhoto:[UIImage imageNamed:@"NiceRoom.jpeg"]];
    }
    else if ([hotel.name isEqualToString:@"Decent Inn"]) {
      [hotel addOutsidePhoto:[UIImage imageNamed:@"DecentHotel.jpeg"]];
      [hotel addInsidePhoto:[UIImage imageNamed:@"DecentRoom.jpeg"]];
    }
    
    NSArray *jsonRooms = [jsonHotel objectForKey:@"rooms"];
    
    for(NSDictionary *jsonRoom in jsonRooms) {
      
      NSEntityDescription *roomEntity = [NSEntityDescription entityForName:@"Room" inManagedObjectContext:context];
      Room *room = [[Room alloc] initWithEntity:roomEntity insertIntoManagedObjectContext:context];
      
      room.number = [jsonRoom objectForKey:@"number"];
      room.beds = [jsonRoom objectForKey:@"beds"];
      room.rate = [jsonRoom objectForKey:@"rate"];
      room.hotel = hotel;
    }
  }
  
  
  NSError *saveError;
  [context save:&saveError];
  if (saveError) {
    NSLog(@"JSONSeedParser Error: %@",saveError.localizedDescription);
  } else {
    NSLog(@"New Hotel seed successfully created and saved");
  }
  
}


@end
