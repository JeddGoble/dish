//
//  TrendingViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/22/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

// Imported Files
#import "TrendingViewController.h"
#import "TrendingTableViewCell.h"
#import "ProfileViewController.h"
#import <ParseUI/ParseUI.h>
#import <Parse/Parse.h>

// Delegates
@interface TrendingViewController () <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *trendingTableView;
@property (weak, nonatomic) IBOutlet UISearchBar *trendingSearchBar;

// Properties
@property NSArray *userArray;

@end

@implementation TrendingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
// Setting Delegates
    self.trendingSearchBar.delegate = self;

//Instanciating array
    self.userArray = [NSArray new];
    
//change the color of the navigation bar
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:103.0/255.0 green:59.0/255.0 blue:183.0/255.0 alpha:1.0f];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidAppear:(BOOL)animated {
    
    if (![PFUser currentUser]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndRegistration" bundle:nil];
        UIViewController *tempVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
        [self presentViewController:tempVC animated:YES completion:nil];
    }
}

#pragma mark - TableView Delegate Methods

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

// Creating the same number of rows in the tableview as indexes in the array
    return self.userArray.count;
}


-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TrendingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TrendingCell"];

    PFUser *user = [self.userArray objectAtIndex:indexPath.row];
    PFFile *userProfileImage = user[@"userProfileImage_data"];
    cell.userProfileImage.file = userProfileImage;
  
    cell.userProfileImage.layer.cornerRadius = cell.userProfileImage.frame.size.height/2;
    cell.userProfileImage.layer.masksToBounds = YES;
    cell.userProfileImage.layer.borderWidth = 0;
    cell.userProfileImage.contentMode = UIViewContentModeScaleAspectFill;
      [cell.userProfileImage loadInBackground];

    
    cell.usernameLabel.text = user[@"username"];
    
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    ProfileViewController *tempVC = [storyboard instantiateViewControllerWithIdentifier:@"ProfileID"];
    tempVC.viewingUser = [self.userArray objectAtIndex:indexPath.row];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self.navigationController pushViewController:tempVC animated:YES];
}


#pragma mark - Searchbar Delegate Methods

-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
// Pulling PFUser objects from parse when text in the searchbar is changed
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];

// Filtering the results for usernames that match the searchtext
    [query whereKey:@"username" matchesRegex:searchText modifiers:@"i"];

// Storing the userobjects in an array called objects
    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {

// Setting the value of the userArray to objects
        self.userArray = objects;
    
        [self.trendingTableView reloadData];
    }];
}

@end
