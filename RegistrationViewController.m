//
//  RegistrationViewController.m
//  Dish
//
//  Created by Danielle Smith on 10/28/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

// imports
#import "RegistrationViewController.h"
#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "LoginViewController.h"

// delegates
@interface RegistrationViewController ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextFieldDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UIImageView *profileImage;
@property (weak, nonatomic) IBOutlet UITextField *enterUsernameTextfield;
@property (weak, nonatomic) IBOutlet UITextField *enterEmailTextField;
@property (weak, nonatomic) IBOutlet UITextField *enterPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *confirmPasswordTextField;

// Properties
@property UIImage *userImage;

@end

@implementation RegistrationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.enterEmailTextField.delegate = self;
    self.enterPasswordTextField.delegate = self;
    self.enterUsernameTextfield.delegate = self;
    self.confirmPasswordTextField.delegate = self;
    
}

- (IBAction)onSelectProfileImageButtonTapped:(UIButton *)sender {
    
    // Making an instance of UIImagePickerController
    UIImagePickerController *pickerController = [UIImagePickerController new];
    
    // Setting its delegate
    pickerController.delegate = self;
    
    // Setting the sourcetype to the user's photo library
    pickerController.allowsEditing = YES;
    pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    // Presenting the controller
    [self presentViewController:pickerController animated:YES completion:nil];
}

#pragma mark - UIImagePicker Delegate Methods

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    
    // setting the userimage property to the image selected by the user.
    self.userImage = [info objectForKey:UIImagePickerControllerEditedImage];
    
    // setting the profile image to the image selected by the user
    self.profileImage.image = self.userImage;
    
    //dismissing the controller
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)onCreateProfileButtonTapped:(UIButton *)sender {
    
    // Creating and initializing variables for all fields
    NSString *username = self.enterUsernameTextfield.text;
    NSString *email = self.enterEmailTextField.text;
    NSString *password = self.enterPasswordTextField.text;
    NSString *confirmedPassword = self.confirmPasswordTextField.text;
    
    // Make sure all fields have been completed by the user
    if (username.length <= 0 || email.length <= 0 || password.length <= 0 || confirmedPassword.length <= 0 ) {
        
        // Display Alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Inorder to proceed, all fields must be completed." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okayButton = [UIAlertAction actionWithTitle:@"Okay"
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                             }];
        [alert addAction:okayButton];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
        
    }
    
    // Make sure the passwords entered by the user match
    if (password != confirmedPassword){
        
        // Display Alert
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Passwords do not match. Please try again." preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okayButton = [UIAlertAction actionWithTitle:@"Okay"
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                             }];
        [alert addAction:okayButton];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];
        
    }
    
    // Create an instance of the photo selected by user.
    
    NSData *selectedImage = UIImageJPEGRepresentation(self.userImage, 1);
    
    // Create an instance of PFUser
    PFUser *user = [PFUser new];
    
    // Initializing the properties of PFUser
    user.username = username;
    user.password = password;
    user.email = email;
    
    // Check if the user selected an image
    if (selectedImage != nil) {
        
        // if there is an image, convert it to a PFFile
        PFFile *imageFile = [PFFile fileWithName:@"image" data:selectedImage];
        user[@"userProfileImage_data"] = imageFile;
        
        //call the signup method
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
            
            // Message displayed if signup was successful
            NSString *userMessage = @"Registration was successful";
            
            if (!succeeded){
                // Message displayed if signup was unsuccessful
                userMessage = error.localizedDescription;
                
            }
            // Display alert
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:userMessage preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okayButton = [UIAlertAction actionWithTitle:@"Okay"
                                                                 style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                                     if(succeeded){
                                                                         // Dismiss Controller if signup was successful
                                                                         [self dismissViewControllerAnimated:YES completion:nil];
                                         
                                                                     }

                                                                 }];
            [alert addAction:okayButton];
            [self presentViewController:alert
                               animated:YES
                             completion:nil];
                    }];
    }
    

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    return NO;
}
@end
