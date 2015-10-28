//
//  FullScreenPhotoViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/27/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "FullScreenPhotoViewController.h"

@interface FullScreenPhotoViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *postTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mainImageView;
@property (weak, nonatomic) IBOutlet UILabel *dishNameLabel;




@end


@implementation FullScreenPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}



- (IBAction)onBackButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}


@end
