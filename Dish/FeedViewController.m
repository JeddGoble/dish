//
//  FeedViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/22/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "FeedViewController.h"
#import <Parse/Parse.h>
#import "CommentsViewController.h"
#import "Photo.h"

@interface FeedViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSMutableArray *arrayOfUsersFollowing;
@property (strong, nonatomic) NSMutableArray *arrayOfPhotos;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) PFUser *userForFilter;
@property NSDate *currentDate;
@property NSInteger photosDisplayed;
@property BOOL endOfPhotos;

@end

@implementation FeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setBackgroundColor:[UIColor colorWithRed:83.0 / 255.0 green:33.0 / 255.0 blue:168.0 / 255.0 alpha:1.0]];
    [[UITabBar appearance] setTintColor:[UIColor whiteColor]];
    
    self.endOfPhotos = NO;
    self.currentDate = [NSDate date];
    self.photosDisplayed = 10;
    
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
                photoQuery.limit = 10;
                photoQuery.skip = self.photosDisplayed - 10;
                [photoQuery orderByDescending:@"createdAt"];
                [photoQuery includeKey:@"User_pointer"];
                [photoQuery whereKey:@"User_pointer" containedIn:self.arrayOfUsersFollowing];
                [photoQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
                    if (!error) {
                        for (PFObject *object in objects) {
                            [self.arrayOfPhotos addObject:object];
                        }
                        [self.tableView reloadData];
                        if (self.arrayOfPhotos.count < self.photosDisplayed) {
                            self.endOfPhotos = YES;
                        }
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
    NSTimeInterval secondsAgo = [self.currentDate timeIntervalSinceDate:photoDate];
    
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
    
    if (indexPath.row == 0) {
        return self.view.frame.size.width;
    }
    
    if (indexPath.row == 1) {
        return 130;
        
    }
    
    else return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.arrayOfPhotos.count;
}

- (void)commentTapped:(UIGestureRecognizer *)gestureRecognizer {
    
    Photo *photo = [self.arrayOfPhotos objectAtIndex:[self.tableView indexPathForCell:[gestureRecognizer.view superview]].section];

    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Profile" bundle:nil];
    CommentsViewController *dvc = [storyboard instantiateViewControllerWithIdentifier:@"Comments"];
    dvc.viewingPhoto = photo;
    [self presentViewController:dvc animated:YES completion:nil];
    
}

- (void)doubleTapped:(UIGestureRecognizer *)gestureRecognizer{
    PFObject *photo = [self.arrayOfPhotos objectAtIndex:[self.tableView indexPathForCell:gestureRecognizer.view].section];


    if (![[photo objectForKey:@"usersThatLiked_array"] containsObject:self.currentUser]) {
    [photo addObject:self.currentUser forKey:@"usersThatLiked_array"];
    [photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"The object has been saved");
            [self.tableView reloadData];
        } else {
            NSLog(@"There was a problem, check error.description");
        }
    }];

        PFObject *notification = [PFObject objectWithClassName:@"Notification"];
        [notification setObject:self.currentUser forKey:@"sourceUser_pointer"];
        [notification setObject:[photo objectForKey:@"User_pointer"] forKey:@"targetUser_pointer"];
        [notification setObject:photo forKey:@"Photo_pointer"];
        [notification setObject:@"like" forKey:@"notificationType_string"];
        [notification saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (succeeded) {
                NSLog(@"The object has been saved");
            } else {
                NSLog(@"There was a problem with notification");
            }
        }];

    
    }

    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"photoCell"];
        cell = nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"photoCell"];
            
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] init];
            [gestureRecognizer addTarget:self action:@selector(doubleTapped:)];
            
            gestureRecognizer.numberOfTapsRequired = 2;
            [cell addGestureRecognizer:gestureRecognizer];
            
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
        } else {
            return cell;
        }
    }
    
    if (indexPath.row == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"detailCell"];
        cell = nil;
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"detailCell"];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            UILabel *dishName = [[UILabel alloc] init];
            dishName.frame = CGRectMake(10, 10, 150, 20);
            dishName.text = [[self.arrayOfPhotos objectAtIndex:indexPath.section] objectForKey:@"photoTitle_string"];
            dishName.textColor = [UIColor purpleColor];
            [cell addSubview:dishName];
            
            UIImageView *starOne = [[UIImageView alloc] init];
            UIImageView *starTwo = [[UIImageView alloc] init];
            UIImageView *starThree = [[UIImageView alloc] init];
            UIImageView *starFour = [[UIImageView alloc] init];
            UIImageView *starFive = [[UIImageView alloc] init];
            
            starOne.frame = CGRectMake(7, 40, 20, 20);
            starTwo.frame = CGRectMake(27, 40, 20, 20);
            starThree.frame = CGRectMake(47, 40, 20, 20);
            starFour.frame = CGRectMake(67, 40, 20, 20);
            starFive.frame = CGRectMake(87, 40, 20, 20);
            
            [cell addSubview:starOne];
            [cell addSubview:starTwo];
            [cell addSubview:starThree];
            [cell addSubview:starFour];
            [cell addSubview:starFive];
            
            int rating = [[[self.arrayOfPhotos objectAtIndex:indexPath.section] objectForKey:@"photoRating_number"] intValue];
            switch (rating) {
                case 5: starFive.image = [UIImage imageNamed:@"starFilled"];
                    starFour.image = [UIImage imageNamed:@"starFilled"];
                    starThree.image = [UIImage imageNamed:@"starFilled"];
                    starTwo.image = [UIImage imageNamed:@"starFilled"];
                    starOne.image = [UIImage imageNamed:@"starFilled"];
                    break;
                    
                case 4: starFive.image = [UIImage imageNamed:@"starEmpty"];
                    starFour.image = [UIImage imageNamed:@"starFilled"];
                    starThree.image = [UIImage imageNamed:@"starFilled"];
                    starTwo.image = [UIImage imageNamed:@"starFilled"];
                    starOne.image = [UIImage imageNamed:@"starFilled"];
                    break;
                    
                case 3: starFive.image = [UIImage imageNamed:@"starEmpty"];
                    starFour.image = [UIImage imageNamed:@"starEmpty"];
                    starThree.image = [UIImage imageNamed:@"starFilled"];
                    starTwo.image = [UIImage imageNamed:@"starFilled"];
                    starOne.image = [UIImage imageNamed:@"starFilled"];
                    break;
                    
                case 2: starFive.image = [UIImage imageNamed:@"starEmpty"];
                    starFour.image = [UIImage imageNamed:@"starEmpty"];
                    starThree.image = [UIImage imageNamed:@"starEmpty"];
                    starTwo.image = [UIImage imageNamed:@"starFilled"];
                    starOne.image = [UIImage imageNamed:@"starFilled"];
                    break;
                    
                case 1: starFive.image = [UIImage imageNamed:@"starEmpty"];
                    starFour.image = [UIImage imageNamed:@"starEmpty"];
                    starThree.image = [UIImage imageNamed:@"starEmpty"];
                    starTwo.image = [UIImage imageNamed:@"starEmpty"];
                    starOne.image = [UIImage imageNamed:@"starFilled"];
                    break;
                    
            }
            
            UILabel *numberOfLikes = [[UILabel alloc] init];
            numberOfLikes.frame = CGRectMake(115, 41, 150, 20);
            numberOfLikes.text = [NSString stringWithFormat:@"%lu likes", [[[self.arrayOfPhotos objectAtIndex:indexPath.section] objectForKey:@"usersThatLiked_array"] count]];
            numberOfLikes.textColor = [UIColor purpleColor];
            [cell addSubview:numberOfLikes];
            
            UIImageView *like = [[UIImageView alloc] init];
            like.frame = CGRectMake(self.view.frame.size.width - 27, 40, 20, 20);
            if ([[[self.arrayOfPhotos objectAtIndex:indexPath.section] objectForKey:@"usersThatLiked_array"] containsObject:self.currentUser]) {
                like.image = [UIImage imageNamed:@"pinkheartfull"];
            } else {
                like.image = [UIImage imageNamed:@"pinkheart"];
            }
            [cell addSubview:like];
            
            UIButton *commentButton = [[UIButton alloc] init];
            commentButton.frame = CGRectMake(self.view.frame.size.width - 52, 40, 20, 20);
            [commentButton setBackgroundImage:[UIImage imageNamed:@"comments"] forState:UIControlStateNormal];
            [cell addSubview:commentButton];
            
            UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] init];
            [gestureRecognizer addTarget:self action:@selector(commentTapped:)];
            
            gestureRecognizer.numberOfTapsRequired = 1;
            [commentButton addGestureRecognizer:gestureRecognizer];
            
            
            
            
            
            UILabel *photoDesc = [[UILabel alloc] init];
            photoDesc.numberOfLines = 0;
            photoDesc.frame = CGRectMake(10, 70, self.view.frame.size.width - 20, 80);
            photoDesc.text = [[self.arrayOfPhotos objectAtIndex:indexPath.section] objectForKey:@"photoDesc_string"];
            photoDesc.textColor = [UIColor blackColor];
            photoDesc.font = [UIFont systemFontOfSize:12];
            [photoDesc sizeToFit];
            [cell addSubview:photoDesc];
            
            [cell layoutSubviews];
            
            
            return cell;
        } else {
            return cell;
        }
    }
    
    return nil;
}



- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.endOfPhotos) {

    NSInteger lastSectionIndex = [tableView numberOfSections] - 1;
    if (indexPath.section == lastSectionIndex && indexPath.row == 0) {
        // This is the last cell
        self.photosDisplayed = [tableView numberOfSections] + 10;
        [self queryNewPhotos];
        
    }
    }
}








@end
