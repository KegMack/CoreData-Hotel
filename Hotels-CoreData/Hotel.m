//
//  Hotel.m
//  Hotels-CoreData
//
//  Created by User on 5/9/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "Hotel.h"
#import "Room.h"


@implementation Hotel

@dynamic location;
@dynamic name;
@dynamic stars;
@dynamic outsidePhoto;
@dynamic insidePhoto;
@dynamic rooms;


- (void)addOutsidePhoto:(UIImage *)photo {
  self.outsidePhoto = UIImageJPEGRepresentation(photo, 1.0);
}

- (UIImage *)getOutsidePhoto {
  return [[UIImage alloc] initWithData:self.outsidePhoto];
}

- (void)addInsidePhoto:(UIImage *)photo {
  self.insidePhoto = UIImageJPEGRepresentation(photo, 1.0);
}

- (UIImage *)getInsidePhoto {
  return [[UIImage alloc] initWithData:self.insidePhoto];
}

@end
