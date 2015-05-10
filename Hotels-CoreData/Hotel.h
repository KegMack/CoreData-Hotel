//
//  Hotel.h
//  Hotels-CoreData
//
//  Created by User on 5/9/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@class Room;

@interface Hotel : NSManagedObject

@property (nonatomic, retain) NSString * location;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * stars;
@property (nonatomic, retain) NSData * outsidePhoto;
@property (nonatomic, retain) NSData * insidePhoto;
@property (nonatomic, retain) NSSet *rooms;
@end

@interface Hotel (CoreDataGeneratedAccessors)

- (void)addRoomsObject:(Room *)value;
- (void)removeRoomsObject:(Room *)value;
- (void)addRooms:(NSSet *)values;
- (void)removeRooms:(NSSet *)values;

- (void)addOutsidePhoto:(UIImage *)photo;
- (UIImage *)getOutsidePhoto;
- (void)addInsidePhoto:(UIImage *)photo;
- (UIImage *)getInsidePhoto;

@end
