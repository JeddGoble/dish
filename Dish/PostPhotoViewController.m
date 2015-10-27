//
//  PostPhotoViewController.m
//  Dish
//
//  Created by Jeremy Alper on 10/25/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "PostPhotoViewController.h"
#import "SetLocationViewController.h"
#import "Photo.h"
#import "DishTypeViewController.h"

@interface PostPhotoViewController () <UITextFieldDelegate, UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *oneStarButton;
@property (weak, nonatomic) IBOutlet UIButton *twoStarButton;
@property (weak, nonatomic) IBOutlet UIButton *threeStarButton;
@property (weak, nonatomic) IBOutlet UIButton *fourStarButton;
@property (weak, nonatomic) IBOutlet UIButton *fiveStarButton;
@property (weak, nonatomic) IBOutlet UITextField *dishNameTextField;
@property (weak, nonatomic) IBOutlet UITextView *dishDescriptionTextView;
@property (weak, nonatomic) IBOutlet UIButton *resignFirstResponderButton;
@property (strong, nonatomic) PFObject *photo;


@end

@implementation PostPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.photo = [PFObject objectWithClassName:@"Photo"];
    [self.photo setObject:[PFFile fileWithData:UIImageJPEGRepresentation(self.image, 0.1)] forKey:@"photo_data"];
    self.imageView.image = self.image;
    [self.oneStarButton setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateHighlighted];
    [self.twoStarButton setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateHighlighted];
    [self.threeStarButton setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateHighlighted];
    [self.fourStarButton setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateHighlighted];
    [self.fiveStarButton setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateHighlighted];
    [self.resignFirstResponderButton setHidden:YES];
    
}


- (IBAction)locationButtonPressed:(UIButton *)sender {
[self performSegueWithIdentifier:@"setLocationSegue" sender:nil];    

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"setLocationSegue"]) {
        SetLocationViewController *dvc = segue.destinationViewController;
        dvc.ppvc = self;
    }
    if ([segue.identifier isEqualToString:@"nextSegue"]) {
        
        [self.photo setObject:self.dishNameTextField.text forKey:@"photoTitle_string"];
        [self.photo setObject:self.dishDescriptionTextView.text forKey:@"photoDesc_string"];
        DishTypeViewController *dvc = segue.destinationViewController;
        dvc.photo = self.photo;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    [self.resignFirstResponderButton setHidden:NO];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self.dishNameTextField resignFirstResponder];
    [self.resignFirstResponderButton setHidden:YES];
    return NO;
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    [self.resignFirstResponderButton setHidden:NO];
}

- (IBAction)resignFirstResponderButtonPressed:(UIButton *)sender {
    [self.dishNameTextField resignFirstResponder];
    [self.dishDescriptionTextView resignFirstResponder];
    [self.resignFirstResponderButton setHidden:YES];
}


- (IBAction)oneStarButtonPressed:(UIButton *)sender {
    [self.photo setObject:@1 forKey:@"photoRating_number"];
    [sender setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateNormal];
    self.twoStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.threeStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.fourStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.fiveStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
}
- (IBAction)twoStarButtonPressed:(UIButton *)sender {
    [self.photo setObject:@2 forKey:@"photoRating_number"];
    self.oneStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    [sender setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateNormal];
    self.threeStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.fourStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.fiveStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
}
- (IBAction)threeStarButtonPressed:(UIButton *)sender {
    [self.photo setObject:@3 forKey:@"photoRating_number"];
    self.oneStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.twoStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    [sender setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateNormal];
    self.fourStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
    self.fiveStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
}
- (IBAction)fourStarButtonPressed:(UIButton *)sender {
    [self.photo setObject:@4 forKey:@"photoRating_number"];
    self.oneStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.twoStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.threeStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    [sender setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateNormal];
    self.fiveStarButton.imageView.image = [UIImage imageNamed:@"starEmpty"];
}
- (IBAction)fiveStarButtonPressed:(UIButton *)sender {
    [self.photo setObject:@5 forKey:@"photoRating_number"];
    self.oneStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.twoStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.threeStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    self.fourStarButton.imageView.image = [UIImage imageNamed:@"starFilled"];
    [sender setImage:[UIImage imageNamed:@"starFilled"] forState:UIControlStateNormal];
}

@end
