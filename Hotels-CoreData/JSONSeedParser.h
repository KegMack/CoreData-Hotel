//
//  JSONSeedParser.h
//  Hotels-CoreData
//
//  Created by User on 5/4/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface JSONSeedParser : NSObject

+ (void) initHotelsFromJSONSeedInContext:(NSManagedObjectContext *)context;

@end
