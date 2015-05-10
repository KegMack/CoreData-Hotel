//
//  AvailabilityTableViewController.m
//  Hotels-CoreData
//
//  Created by User on 5/5/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "AvailabilityTableViewController.h"
#import "ReservationViewController.h"
#import "AppDelegate.h"
#import "Room.h"
#import "Hotel.h"
#import "ImageResizer.h"
#import "HotelService.h"

@interface AvailabilityTableViewController () <NSFetchedResultsControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation AvailabilityTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor blackColor];
  self.navigationItem.title = @"Reserve Your Room";
  
  self.tableView.delegate = self;
  self.tableView.dataSource = self;
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier: @"Available Room Cell"];
  
  CGSize screenSize = [[UIScreen mainScreen] bounds].size;   // crappy way to do it, but can't get width of view or tableview.... not a final solution, but works for now
  [self initializeTableViewHeaderForSize:screenSize];

}

-(void)viewDidAppear:(BOOL)animated {
  
  [super viewDidAppear:animated];
  AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
  self.fetchedResultsController = [appDelegate.hotelService fetchedResultsControllerForAvailableRooms:self.startDate toDate:self.endDate];
  self.fetchedResultsController.delegate = self;
  NSError *fetchError;
  [NSFetchedResultsController deleteCacheWithName:self.fetchedResultsController.cacheName];
  [self.fetchedResultsController performFetch:&fetchError];
  [self.tableView reloadData];

}

-(void)initializeTableViewHeaderForSize:(CGSize)size {
  CGFloat labelHeight = 40;
  
  self.dateFormatter = [[NSDateFormatter alloc] init];
  self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
  self.tableView.tableHeaderView = nil;
  UIImage *image = [UIImage imageNamed:@"checkin.jpg"];
  CGFloat aspectRatio = image.size.width / image.size.height;
  UIImage *resizedImage = [ImageResizer resizeImage:image toSize:CGSizeMake(size.width, size.width / aspectRatio)];
  UIImageView *imageView =  [[UIImageView alloc] initWithImage:resizedImage];
  imageView.contentMode = UIViewContentModeScaleAspectFill;
  imageView.backgroundColor = [UIColor blackColor];
  self.tableView.tableHeaderView = imageView;
  [self.tableView.tableHeaderView sizeToFit];
  
  UILabel *dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, labelHeight)];
  dateLabel.textAlignment = NSTextAlignmentCenter;
  dateLabel.backgroundColor = [UIColor blackColor];
  dateLabel.textColor = [UIColor whiteColor];
  dateLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline];
  dateLabel.alpha = 0.8;
  dateLabel.text = [NSString stringWithFormat:@"%@ - %@", [self.dateFormatter stringFromDate:self.startDate],[self.dateFormatter stringFromDate: self.endDate]];
  [imageView addSubview:dateLabel];
}


- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator {
  [self initializeTableViewHeaderForSize:size];
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
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Available Room Cell"];
  cell.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0 alpha:1];
  [self configureCell:cell forIndexPath:indexPath];
  return cell;
}

- (void)configureCell:(UITableViewCell *)cell forIndexPath:(NSIndexPath *)indexPath {
  Room *room = [self.fetchedResultsController objectAtIndexPath:indexPath];
  cell.textLabel.text = [[NSString alloc] initWithFormat:@"Room %@", room.number];
  int rate = (int)(room.rate.doubleValue * 100);
  cell.textLabel.text = [[NSString alloc] initWithFormat:@"Room %@ - %@ Beds, $%d/night",room.number, room.beds, rate];
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section  {
  id<NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
  Room *room = (Room *)sectionInfo.objects[0];
  Hotel *hotel = room.hotel;
  NSString *stars = [self returnNStars: [hotel.stars intValue]];
  NSString *description = [[NSString alloc] initWithFormat:@"%@ - %@ - %@", hotel.name, stars, hotel.location];
  return description;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
  view.tintColor = [UIColor colorWithRed:0.6 green:0.6 blue:0 alpha:1];
}

- (NSString *)returnNStars:(int)n {
  NSString *stars = @"";
  for (int i=0; i<n; i++) {
    stars = [stars stringByAppendingString:@"⭐️"];
  }
  return stars;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  ReservationViewController *reservationVC = [[ReservationViewController alloc] init];
  reservationVC.startDate = self.startDate;
  reservationVC.endDate = self.endDate;
  Room *room = [self.fetchedResultsController objectAtIndexPath:indexPath];
  reservationVC.room = room;
  
  [self.tableView deselectRowAtIndexPath:indexPath animated:false];
  [self.navigationController pushViewController:reservationVC animated:true];
}


@end
