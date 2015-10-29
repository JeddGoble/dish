//
//  NotificationsViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/22/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "NotificationsViewController.h"
#import <Parse/Parse.h>

@interface NotificationsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSArray *arrayOfNotifications;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    [userQuery getObjectInBackgroundWithId:@"CdmFf26Zqe" block:^(PFObject * _Nullable user, NSError * _Nullable error) {
        self.currentUser = user;
    
        PFQuery *notificationsQuery = [PFQuery queryWithClassName:@"Notification"];
//        [notificationsQuery whereKey:@"targetUser_pointer" equalTo:self.currentUser];
        [notificationsQuery includeKey:@"sourceUser_pointer"];
        [notificationsQuery includeKey:@"Photo_pointer"];
            [notificationsQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
               
                self.arrayOfNotifications = objects;
                [self.tableView reloadData];
            }];
    
    }];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfNotifications.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PFObject *notification = [self.arrayOfNotifications objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell = nil;
    if (cell == nil) {
        
        if ([notification objectForKey:@"notificationType_string"] == [NSString stringWithFormat:@"like"]) {
            
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ liked your photo.", [[notification objectForKey:@"sourceUser_pointer"] objectForKey:@"username"]];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", notification.createdAt];
    
    return cell;
            
        }
        
        if ([notification objectForKey:@"notification_type"] == [NSString stringWithFormat:@"like"]) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.textLabel.text = [NSString stringWithFormat:@"%@ began following you.", [[notification objectForKey:@"sourceUser_pointer"] objectForKey:@"username"]];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", notification.createdAt];
            
            return cell;
        }
        
    }
    return cell;
}



@end
