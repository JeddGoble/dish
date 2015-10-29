//
//  FullScreenPhotoViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/27/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "FullScreenPhotoViewController.h"
#import "Photo.h"

@interface FullScreenPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *dishDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starImageViewCollection;


@end


@implementation FullScreenPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.userPhoto.image = self.viewingUserPic;
    self.userPhoto.layer.cornerRadius = self.userPhoto.frame.size.height / 2;
    self.userPhoto.clipsToBounds = YES;
    
    self.userName.text = self.viewingUser.username;
    
    self.postTimeLabel.text = [self getTimeAgoForPhoto];
    self.mainImageView.image = self.imageToDisplay;
    self.dishNameLabel.text = self.viewingPhoto.photoTitle_string;
    self.dishDescriptionLabel.text = self.viewingPhoto.photoDesc_string;
    self.likesLabel.text = [NSString stringWithFormat:@"%lu likes", (unsigned long)self.viewingPhoto.usersThatLiked_Array.count];
    
    [self displayDishRating];
    
    
}

- (NSString *) getTimeAgoForPhoto {
    
    NSTimeInterval timeSincePost = [[NSDate date] timeIntervalSinceDate:self.viewingPhoto.createdAt];
    
    NSString *timeForLabel;
    
    if (timeSincePost < 60) {
        timeForLabel = @"now";
    } else if (timeSincePost < 6000) {
        timeForLabel = [NSString stringWithFormat:@"%.fm", timeSincePost / 60];
    } else if (timeSincePost < 86400) {
        timeForLabel = [NSString stringWithFormat:@"%.fh", timeSincePost / 6000];
    } else if (timeSincePost < 604800) {
        timeForLabel = [NSString stringWithFormat:@"%.fd", timeSincePost / 86400];
    } else {
        timeForLabel = [NSString stringWithFormat:@"%.fw", timeSincePost / 604800];
    }
    
    return timeForLabel;
}

- (void) displayDishRating {
    
    int rating = [self.viewingPhoto[@"photoRating_number"] intValue];
    int i = 1;
    
    for (UIImageView *star in self.starImageViewCollection) {
        if (i <= rating) {
            star.image = [UIImage imageNamed:@"starFilled"];
        }
        i++;
    }
    
}



- (IBAction)onBackButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


@end
