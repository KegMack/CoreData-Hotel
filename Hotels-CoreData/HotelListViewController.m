//
//  HotelListViewController.m
//  Hotels-CoreData
//
//  Created by User on 5/4/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "HotelListViewController.h"
#import "RoomTableViewController.h"
#import "JSONSeedParser.h"
#import "Hotel.h"
#import "Room.h"

@interface HotelListViewController () <UITableViewDataSource, UITableViewDelegate>


@property (strong,nonatomic) NSArray *hotels;

@end

@implementation HotelListViewController


//MARK: Initialization

- (void)viewDidLoad {
  [super viewDidLoad];
  [self initializeHotels];
  self.navigationItem.title = @"Hotels";
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"Hotel Cell"];
  
  UIImageView *imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hotel.jpg"]];
  self.tableView.tableHeaderView = imageView;
  [self.tableView.tableHeaderView sizeToFit];
}

- (void)initializeHotels {
  [self fetchHotels: 1];
}

- (void)fetchHotels:(int)attempts {   // recurses by # of attempts if fetch request fails
  
  AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
  NSFetchRequest *hotelFetch = [NSFetchRequest fetchRequestWithEntityName:@"Hotel"];
  
  NSError *fetchError;
  NSArray * results = [appDelegate.managedObjectContext executeFetchRequest:hotelFetch error:&fetchError];
  if (fetchError) {
    NSLog(@"%@",fetchError.localizedDescription);
  }
  else if (results.count <= 0) {
    if(attempts > 0) {
      [JSONSeedParser initHotelsFromJSONSeed];
      attempts--;
      [self fetchHotels:attempts];
    } else {
      NSLog(@"Could not initialize hotels from JSON Seed File");
    }
  } else {
    self.hotels = results;
  }
}



// MARK: TableView Delegation

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.hotels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Hotel Cell"];
  Hotel *hotel = self.hotels[indexPath.row];
  NSString *stars = [self returnNStars:[hotel.stars intValue]];
  cell.textLabel.text = [[NSString alloc] initWithFormat: @"%@     %@", hotel.name, stars];
  cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ -- %lu rooms",hotel.location, (unsigned long)hotel.rooms.count];
  
  return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  RoomTableViewController *roomVC = [[RoomTableViewController alloc] init];
  roomVC.hotel = self.hotels[indexPath.row];
  [self.navigationController pushViewController:roomVC animated:true];
  
}

- (NSString *)returnNStars:(int)n {
  NSString *stars = @"";
  for (int i=0; i<n; i++) {
    stars = [stars stringByAppendingString:@"⭐️"];
  }
  return stars;
}


@end
