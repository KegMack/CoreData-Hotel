//
//  ReservationsByGuestTableViewController.m
//  Hotels-CoreData
//
//  Created by User on 5/9/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "ReservationsByGuestTableViewController.h"
#import "Guest.h"
#import "Reservation.h"
#import "Hotel.h"
#import "Room.h"

@interface ReservationsByGuestTableViewController () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation ReservationsByGuestTableViewController 

- (void)viewDidLoad {
  [super viewDidLoad];
  self.navigationItem.title = self.lastName;
  self.tableView.backgroundColor = [UIColor colorWithRed:0.3 green:0 blue:0.3 alpha:1];
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  self.fetchedResultsController.delegate = self;
  NSError *fetchError;
  [self.fetchedResultsController performFetch:&fetchError];
  
  [self.tableView registerClass:[UITableViewCell class]forCellReuseIdentifier:@"Guest Cell"];
  
  self.dateFormatter = [[NSDateFormatter alloc] init];
  self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
}

//MARK: FetchedResultsControllerDelegation

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


//MARK Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return self.fetchedResultsController.sections.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if ([[self.fetchedResultsController sections] count] > 0) {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
  } else
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Guest Cell"];
  cell.backgroundColor = [UIColor colorWithRed:0.7 green:0 blue:0.7 alpha:1];
  [self configureCell:cell forIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
  Reservation *reservation = [self.fetchedResultsController objectAtIndexPath:indexPath];
  NSString *startDate = [self.dateFormatter stringFromDate:reservation.startDate];
  NSString *endDate = [self.dateFormatter stringFromDate:reservation.endDate];
  cell.textLabel.text = [[NSString alloc] initWithFormat:@"%@ - %@", startDate, endDate ];
  cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"'%@', room %@",reservation.room.hotel.name, reservation.room.number];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  {
  
  id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  Reservation *reservation = (Reservation *)sectionInfo.objects[0];
  Guest *guest = reservation.guest;
  NSString *guestName = [[NSString alloc] initWithFormat:@"%@ %@", guest.firstName, guest.lastName];
  return guestName;
}

@end
