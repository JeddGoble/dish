//
//  FullScreenPhotoViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/27/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "FullScreenPhotoViewController.h"
#import "Photo.h"

@interface FullScreenPhotoViewController () <UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *dishDescriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *likesLabel;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *starImageViewCollection;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;


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
    
    self.mainImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(heartLikeAnimation:)];
    doubleTap.numberOfTapsRequired = 2;
    doubleTap.delegate = self;
    [self.mainImageView addGestureRecognizer:doubleTap];
    
}

- (void) heartLikeAnimation:(UIPinchGestureRecognizer *)sender {
    
    UIImageView *heart = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"whiteheart"]];
    heart.hidden = NO;
    CGFloat width = 60;
    CGFloat height = 60;
    heart.frame = CGRectMake(self.mainImageView.center.x - (width / 2), self.mainImageView.center.y + (height / 2), width, height);
    heart.alpha = 0.5;
    
    [self.view addSubview:heart];
    
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        CGFloat newWidth = width + 100;
        CGFloat newHeight = height + 100;
        heart.frame = CGRectMake(heart.center.x - (newWidth / 2), heart.center.y - (newHeight / 2), newWidth, newHeight);
        heart.alpha = 0.0;
    } completion:^(BOOL finished) {
        heart.hidden = YES;
    }];
    
    
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

- (IBAction)onHeartButtonPressed:(UIButton *)sender {
    
    self.likeButton.backgroundColor = [UIColor colorWithPatternImage:[self imageForScaling:[UIImage imageNamed:@"pinkheartfull"] scaledToSize:CGSizeMake(self.likeButton.frame.size.width, self.likeButton.frame.size.height)]];
    
    
}


- (IBAction)onBackButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (UIImage *)imageForScaling:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}


@end
