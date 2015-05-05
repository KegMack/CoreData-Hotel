//
//  RoomTableViewController.m
//  Hotels-CoreData
//
//  Created by User on 5/4/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "RoomTableViewController.h"


@interface RoomTableViewController () <UITableViewDataSource>

@property (nonatomic, strong) NSArray *rooms;

@end

@implementation RoomTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  NSArray *descriptors = @[[[NSSortDescriptor alloc] initWithKey:@"number" ascending:YES]];
  self.rooms = [self.hotel.rooms sortedArrayUsingDescriptors:descriptors];
  self.tableView.dataSource = self;
  self.navigationItem.title = self.hotel.name;
}


// MARK TableView Delegation

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.rooms.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Hotel Cell"];
  Room *room = self.rooms[indexPath.row];
  cell.textLabel.text = [[NSString alloc] initWithFormat:@"Room %@", room.number];
  
  int rate = (int)(room.rate.doubleValue * 100);

  cell.detailTextLabel.text = [[NSString alloc] initWithFormat:@"%@ Beds, $%d per night", room.beds, rate];
  
  return cell;
}


@end
