//
//  MainMenuViewController.m
//  Hotels-CoreData
//
//  Created by User on 5/7/15.
//  Copyright (c) 2015 Craig_Chaillie. All rights reserved.
//

#import "MainMenuTableViewController.h"
#import "HotelListViewController.h"
#import "StartDateViewController.h"
#import "GuestNameViewController.h"

@interface MainMenuTableViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong,nonatomic) NSArray *options;

@end

@implementation MainMenuTableViewController

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0 alpha:1];
  self.tableView.estimatedRowHeight = 100;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
  self.tableView.dataSource = self;
  self.tableView.delegate = self;
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"OptionCell"];
  
  NSDictionary *navBarSettings = @{ NSForegroundColorAttributeName : [UIColor blackColor], NSFontAttributeName : [UIFont fontWithName:@"Trebuchet-BoldItalic" size:20] };
  [self.navigationController.navigationBar setTitleTextAttributes:navBarSettings];

  self.navigationItem.title = @"Main Menu";
  self.options = @[@"Browse Hotels",@"Book a Room", @"Look Up Reservations"];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OptionCell" forIndexPath:indexPath];
  cell.textLabel.textAlignment = NSTextAlignmentCenter;
  cell.textLabel.font = [UIFont fontWithName:@"Zapfino" size:24];
  cell.textLabel.minimumScaleFactor = 0.5;
  cell.textLabel.adjustsFontSizeToFitWidth = YES;
  cell.textLabel.text = self.options[indexPath.row];
  cell.backgroundColor = [UIColor colorWithRed:0.6 green:0.6 blue:0 alpha:1];
  return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  switch (indexPath.row) {
    case 0: {
      HotelListViewController *hotelListVC = [[HotelListViewController alloc] init];
      [self.navigationController pushViewController:hotelListVC animated:true];
      break;
    }
    case 1: {
      StartDateViewController *startDateVC = [[StartDateViewController alloc] init];
      [self.navigationController pushViewController:startDateVC animated:true];
      break;
    }
    case 2: {
      GuestNameViewController *guestNameVC = [[GuestNameViewController alloc] init];
      [self.navigationController pushViewController:guestNameVC animated:true];
      break;
    }
    default:
      break;
  }
}

@end
