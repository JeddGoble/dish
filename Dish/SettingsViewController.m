//
//  SettingsTableViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/26/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "SettingsViewController.h"
#import <Parse/Parse.h>

@interface SettingsViewController () <UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationTextField;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;



@end

@implementation SettingsViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    
    self.usernameTextField.delegate = self;
    self.usernameTextField.tag = 1;
    
    self.locationTextField.delegate = self;
    self.locationTextField.tag = 2;
    self.emailTextField.delegate = self;
    self.emailTextField.tag = 3;
    
    self.usernameTextField.text = self.currentUser.username;
    self.biographyTextView.text = self.currentUser[@"bio_string"];
    self.locationTextField.text = self.currentUser[@"hometown_string"];
    
    self.profileImageView.layer.cornerRadius = self.profileImageView.frame.size.height / 2;
    self.profileImageView.clipsToBounds = YES;

    
    PFFile *profilePicture = self.currentUser[@"userProfileImage_data"];
    [profilePicture getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
        UIImage *profileImage = [UIImage imageWithData:data];
        self.profileImageView.image = profileImage;
        
        [self.tableView reloadData];
    }];
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}


- (void) saveBio {
    NSString *newBio = self.biographyTextView.text;
    if (newBio.length > 160) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Exceeded 160 characters. Please shorten your bio and try again." message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *ok = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:nil];
        
        [alertController addAction:ok];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        PFQuery *writeToBio = [PFQuery queryWithClassName:@"_User"];
        
        [writeToBio getObjectInBackgroundWithId:self.currentUser.objectId block:^(PFObject * _Nullable currentUser, NSError * _Nullable error) {
            currentUser[@"bio_string"] = newBio;
            [currentUser saveInBackground];
        }];
    }
}


- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if (textField.tag == 1) {
        [self saveUsername];
    } else if (textField.tag == 2) {
        [self saveLocation];
    } else if (textField.tag == 3) {
        [self saveEmail];
    }
    
}

- (void) saveUsername {
    
    
}


- (void) saveLocation {
    self.currentUser[@"hometown_string"] = self.locationTextField.text;
    [self.currentUser saveInBackground];
}

- (void) saveEmail {
    
}

- (IBAction)onDoneButtonTapped:(UIButton *)sender {
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (IBAction)onDietButtonTapped:(UIButton *)sender {
    
}

- (IBAction)onSetProfilePictureTapped:(UIButton *)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.profileImageView.image = chosenImage;
    
}

- (IBAction)onChangePasswordButtonTapped:(UIButton *)sender {
}

- (IBAction)onLogOutButtonTapped:(UIButton *)sender {
    [PFUser logOut];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndRegistration" bundle:nil];
    UIViewController *tempVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
    [self.navigationController pushViewController:tempVC animated:YES];
    
}


- (IBAction)onSaveButtonPressed:(UIButton *)sender {
    [self saveBio];
    [self saveEmail];
    [self saveLocation];
    [self saveUsername];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}












@end
