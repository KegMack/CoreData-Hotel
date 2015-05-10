//
//  CoreDataStack.h
//  Hotels-CoreData
//
//  Created by User on 5/7/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface CoreDataStack : NSObject


@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (strong,nonatomic) NSManagedObjectContext *backgroundContext;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;
- (instancetype)initForTesting;


@end