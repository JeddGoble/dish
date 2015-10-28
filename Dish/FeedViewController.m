//
//  FeedViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/22/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSMutableArray *arrayOfUsersFollowing;
@property (strong, nonatomic) NSMutableArray *arrayOfPhotos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PFUser *userForFilter;
@property NSDate *currentDate;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.currentDate = [NSDate date];
    
    if (self.arrayOfUsersFollowing == nil) {
        self.arrayOfUsersFollowing = [[NSMutableArray alloc] init];
    }
    
    if (self.arrayOfPhotos == nil) {
        self.arrayOfPhotos = [[NSMutableArray alloc] init];
    }
    
    [self queryNewPhotos];
    
    
}

- (void)queryNewPhotos {
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    [userQuery getObjectInBackgroundWithId:@"CdmFf26Zqe" block:^(PFObject * _Nullable user, NSError * _Nullable error) {
        self.currentUser = user;
        
        PFQuery *followQuery = [PFQuery queryWithClassName:@"Follow"];
        [followQuery whereKey:@"followedBy_pointer" equalTo:self.currentUser];
        [followQuery findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
            if (!error) {
                for (PFObject *object in objects) {
                    [self.arrayOfUsersFollowing addObject:[object objectForKey:@"following_pointer"]];
                }

                PFQuery *photoQuery = [PFQuery queryWithClassName:@"Photo"];
                [photoQuery includeKey:@"User_pointer"];
                [photoQuery whereKey:@"User_pointer" containedIn:self.arrayOfUsersFollowing];
                [photoQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    if (!error) {
                        for (PFObject *object in objects) {
                            [self.arrayOfPhotos addObject:object];
                        }
                        [self.tableView reloadData];
                    }
                }];
            } else {
                NSLog(@"Error");
            }
        }];
        
    }];
    
}



- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] init];
    header.backgroundColor = [UIColor whiteColor];
    header.alpha = 0.9;
    
    UILabel *userName = [[UILabel alloc] init];
    userName.frame = CGRectMake(50, 0, 100, 50);
    userName.text = [[[self.arrayOfPhotos objectAtIndex:section] objectForKey:@"User_pointer"] objectForKey:@"username"];
    userName.textColor = [UIColor blackColor];
    
    PFFile *photoFile = [[[self.arrayOfPhotos objectAtIndex:section] objectForKey:@"User_pointer"] objectForKey:@"userProfileImage_data"];
    [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            UIImageView *userImage = [[UIImageView alloc] init];
            userImage.image = image;
            userImage.frame = CGRectMake(5,5,40,40);
            userImage.layer.cornerRadius = 20;
            userImage.clipsToBounds = YES;
            [header addSubview:userImage];
        }
    }];
    
    PFObject *photo = [self.arrayOfPhotos objectAtIndex:section];
    NSDate *photoDate = photo.createdAt;
    NSTimeInterval secondsAgo = [self.currentDate timeIntervalSinceDate:self.currentDate];
    
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.textColor = [UIColor blackColor];
    dateLabel.frame = CGRectMake(self.view.frame.size.width - 50, 0, 50, 50);
    
    if (secondsAgo < 3600) {
        dateLabel.text = [NSString stringWithFormat:@"%im",(int)(secondsAgo / 60)];
    } else if (secondsAgo < 86400) {
        dateLabel.text = [NSString stringWithFormat:@"%ih",(int)(secondsAgo / 3600)];
    } else {
        dateLabel.text = [NSString stringWithFormat:@"%id",(int)(secondsAgo / 86400)];
    }
    
    [header addSubview:userName];
    [header addSubview:dateLabel];
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.view.frame.size.width;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayOfPhotos.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
    cell.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
    PFFile *photoFile = [[self.arrayOfPhotos objectAtIndex:indexPath.section] objectForKey:@"photo_data"];
    [photoFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
        if (!error) {
            UIImage *image = [UIImage imageWithData:data];
            UIImageView *photoImage = [[UIImageView alloc] initWithImage:image];
            photoImage.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.width);
            [cell addSubview:photoImage];
        }
    }];
        return cell;
}


@end
