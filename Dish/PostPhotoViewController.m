//
//  PostPhotoViewController.m
//  Dish
//
//  Created by Jeremy Alper on 10/25/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "PostPhotoViewController.h"

@interface PostPhotoViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *oneStarButton;
@property (weak, nonatomic) IBOutlet UIButton *twoStarButton;
@property (weak, nonatomic) IBOutlet UIButton *threeStarButton;
@property (weak, nonatomic) IBOutlet UIButton *fourStarButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveStarButton;
@property int rating;
@property (weak, nonatomic) IBOutlet UITextField *dishNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;


@end

@implementation PostPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.imageView.image = self.image;
    
}

- (IBAction)locationButtonPressed:(UIButton *)sender {
    [self performSegueWithIdentifier:@"setLocation" sender:nil];
}


- (IBAction)oneStarButtonPressed:(UIButton *)sender {
    self.rating = 1;
    [sender setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateNormal];
    self.twoStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.threeStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.fourStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.fiveStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
}
- (IBAction)twoStarButtonPressed:(UIButton *)sender {
    self.rating = 2;
    self.oneStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    [sender setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateNormal];
    self.threeStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.fourStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.fiveStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
}
- (IBAction)threeStarButtonPressed:(UIButton *)sender {
    self.rating = 3;
    self.oneStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.twoStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    [sender setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateNormal];
    self.fourStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.fiveStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
}
- (IBAction)fourStarButtonPressed:(UIButton *)sender {
    self.rating = 4;
    self.oneStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.twoStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.threeStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    [sender setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateNormal];
    self.fiveStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
}
- (IBAction)fiveStarButtonPressed:(UIButton *)sender {
    self.rating = 5;
    self.oneStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.twoStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.threeStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.fourStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    [sender setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateNormal];
}

@end
