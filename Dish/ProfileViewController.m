//
//  ProfileViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/22/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "ProfileViewController.h"

@interface ProfileViewController ()

@property (weak, nonatomic) IBOutlet UILabel *dishesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishesTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *userBioTextView;
@property (weak, nonatomic) IBOutlet UILabel *locationTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *dietTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *orangeControlBar;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *pinButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width * 0.666, self.orangeControlBar.center.y, 50, 50)];
    pinButton.layer.cornerRadius = pinButton.bounds.size.height / 2.0;
    pinButton.backgroundColor = [UIColor whiteColor];
    
    UIImage *pinImage = [UIImage imageNamed:@"orangepin"];
    UIImage *resizedImage = [self imageForScaling:pinImage scaledToSize:CGSizeMake(30.0, 30.0)];
    UIImageView *pinImageView = [[UIImageView alloc] initWithImage:resizedImage];
    pinImageView.frame = pinButton.frame;
    
    
    [self.view addSubview:pinButton];
    [self.view addSubview:pinImageView];
    
}

- (UIImage *)imageForScaling:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}



@end
