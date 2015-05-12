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
#import "Hotel.h"

@interface HotelListViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation HotelListViewController


//MARK: Initialization

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0 alpha:1];
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  
  self.fetchedResultsController = [appDelegate.hotelService fetchedResultsControllerForAllHotels];
  self.fetchedResultsController.delegate = self;
  NSError *fetchError;
  [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
  [self.fetchedResultsController performFetch:&fetchError];
  
  self.navigationItem.title = @"Hotels";
  [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"Hotel Cell"];
  
  UIImageView *imageView =  [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Hotel.jpg"]];
  imageView.contentMode = UIViewContentModeScaleAspectFit;
  imageView.backgroundColor = [UIColor blackColor];
  self.tableView.tableHeaderView = imageView;
  [self.tableView.tableHeaderView sizeToFit];
  
}


//MARK:  FetchedResultsController delegation

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView beginUpdates];
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
  [self.tableView endUpdates];
}

-(void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
  
  switch (type) {
    case NSFetchedResultsChangeInsert:
      [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeDelete:
      [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    case NSFetchedResultsChangeUpdate:
      [self configureCell:[self.tableView cellForRowAtIndexPath:indexPath] forIndexPath:indexPath];
      break;
    case NSFetchedResultsChangeMove:
      [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
      [self.tableView insertRowsAtIndexPaths:@[newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
      break;
    default:
      break;
  }
  
}
// MARK: TableView Delegation

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.fetchedResultsController.fetchedObjects.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Hotel Cell"];
  [self configureCell:cell forIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
  Hotel *hotel = (Hotel *)[self.fetchedResultsController objectAtIndexPath:indexPath];
  NSString *stars = [self returnNStars:[hotel.stars intValue]];
  cell.backgroundColor = [UIColor colorWithRed:0.1 green:0.1 blue:0 alpha:1];
  cell.textLabel.textColor = [UIColor whiteColor];
  cell.detailTextLabel.textColor = [UIColor yellowColor];
  cell.textLabel.text = [[NSString alloc] initWithFormat: @"%@     %@", hotel.name, stars];
  cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ -- %lu rooms",hotel.location, (unsigned long)hotel.rooms.count];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  RoomTableViewController *roomVC = [[RoomTableViewController alloc] init];
  roomVC.hotel = [self.fetchedResultsController objectAtIndexPath:indexPath];
  [self.navigationController pushViewController:roomVC animated:true];
  [tableView deselectRowAtIndexPath:indexPath animated:false];
}

- (NSString *)returnNStars:(int)n {
  NSString *stars = @"";
  for (int i=0; i<n; i++) {
    stars = [stars stringByAppendingString:@"⭐️"];
  }
  return stars;
}


@end
