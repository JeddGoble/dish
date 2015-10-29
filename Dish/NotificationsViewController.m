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
@property NSDateFormatter *formatter;

@end

@implementation NotificationsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.formatter = [[NSDateFormatter alloc] init];
    [self.formatter setDateStyle:NSDateFormatterMediumStyle];
    
    self.tableView.rowHeight = 50;
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    [userQuery getObjectInBackgroundWithId:@"CdmFf26Zqe" block:^(PFObject * _Nullable user, NSError * _Nullable error) {
        self.currentUser = user;
        
        PFQuery *notificationsQuery = [PFQuery queryWithClassName:@"Notification"];
        //        [notificationsQuery whereKey:@"targetUser_pointer" equalTo:self.currentUser];
        [notificationsQuery orderByDescending:@"createDate"];
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
            
            PFFile *photoFile = [[notification objectForKey:@"Photo_pointer"] objectForKey:@"photo_data"];
            [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    UIImageView *photo = [[UIImageView alloc] init];
                    photo.frame = CGRectMake(2, 2, 46, 46);
                    photo.image = image;
                    [cell addSubview:photo];
                }
            }];
            
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.frame = CGRectMake(55, 5, self.view.frame.size.width - 55, 20);
            textLabel.text = [NSString stringWithFormat:@"%@ liked your photo.", [[notification objectForKey:@"sourceUser_pointer"] objectForKey:@"username"]];
            [cell addSubview:textLabel];
            
            UILabel *date = [[UILabel alloc] init];
            date.frame = CGRectMake(55, 25, self.view.frame.size.width - 55, 20);
            date.text = [NSString stringWithFormat:@"%@", [self.formatter stringFromDate:notification.createdAt]];
            date.font = [UIFont systemFontOfSize:11];
            date.textColor = [UIColor grayColor];
            [cell addSubview:date];
            
            return cell;
            
        }
        
        if ([notification objectForKey:@"notificationType_string"] == [NSString stringWithFormat:@"follow"]) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            PFFile *photoFile = [[notification objectForKey:@"sourceUser_pointer"] objectForKey:@"userProfileImage_data"];
            [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    UIImageView *photo = [[UIImageView alloc] init];
                    photo.frame = CGRectMake(2, 2, 46, 46);
                    photo.image = image;
                    photo.layer.cornerRadius = 23;
                    photo.clipsToBounds = YES;
                    [cell addSubview:photo];
                }
            }];
            
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.frame = CGRectMake(55, 5, self.view.frame.size.width - 55, 20);
            textLabel.text = [NSString stringWithFormat:@"%@ started following you.", [[notification objectForKey:@"sourceUser_pointer"] objectForKey:@"username"]];
            [cell addSubview:textLabel];
            
            UILabel *date = [[UILabel alloc] init];
            date.frame = CGRectMake(55, 25, self.view.frame.size.width - 55, 20);
            date.text = [NSString stringWithFormat:@"%@", [self.formatter stringFromDate:notification.createdAt]];
            date.font = [UIFont systemFontOfSize:11];
            date.textColor = [UIColor grayColor];
            [cell addSubview:date];
            
            return cell;
            
        }
        
        if ([notification objectForKey:@"notificationType_string"] == [NSString stringWithFormat:@"comment"]) {
            
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
            PFFile *photoFile = [[notification objectForKey:@"Photo_pointer"] objectForKey:@"photo_data"];
            [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                if (!error) {
                    UIImage *image = [UIImage imageWithData:data];
                    UIImageView *photo = [[UIImageView alloc] init];
                    photo.frame = CGRectMake(2, 2, 46, 46);
                    photo.image = image;
                    [cell addSubview:photo];
                }
            }];
            
            UILabel *textLabel = [[UILabel alloc] init];
            textLabel.frame = CGRectMake(55, 5, self.view.frame.size.width - 55, 20);
            textLabel.text = [NSString stringWithFormat:@"%@ commented on your photo.", [[notification objectForKey:@"sourceUser_pointer"] objectForKey:@"username"]];
            [cell addSubview:textLabel];
            
            UILabel *date = [[UILabel alloc] init];
            date.frame = CGRectMake(55, 25, self.view.frame.size.width - 55, 20);
            date.text = [NSString stringWithFormat:@"%@", [self.formatter stringFromDate:notification.createdAt]];
            date.font = [UIFont systemFontOfSize:11];
            date.textColor = [UIColor grayColor];
            [cell addSubview:date];
            
            return cell;
            
        }
        
    }
    return cell;
}



@end
