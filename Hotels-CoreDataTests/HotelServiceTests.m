//
//  HotelServiceTests.m
//  Hotels-CoreData
//
//  Created by User on 5/10/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "HotelService.h"
#import "CoreDataStack.h"

@interface HotelServiceTests : XCTestCase

@property (nonatomic, strong) HotelService *hotelService;

@end

@implementation HotelServiceTests

- (void)setUp {
  [super setUp];
  CoreDataStack *coreDataStack = [[CoreDataStack alloc] initForTesting];
  self.hotelService = [[HotelService alloc] initWithCoreDataStack:coreDataStack];
  [self.hotelService initializeHotelsFromSeedIfNeeded];
  
}



- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}



- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
