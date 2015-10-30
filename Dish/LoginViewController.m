//
//  LoginViewController.m
//  Dish
//
//  Created by Danielle Smith on 10/27/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>
#import "FeedViewController.h"
@interface LoginViewController ()
@property FeedViewController *feedViewController;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   

    
}



-(void)userlogin {
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

    if (username.length <= 0 || password.length <= 0) {
       
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"Inorder to proceed, all fields must be completed" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okayButton = [UIAlertAction actionWithTitle:@"Okay"
                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                                 
                                                                 
                                                                 
                                                                 
                                                             }];
        [alert addAction:okayButton];
        [self presentViewController:alert
                           animated:YES
                         completion:nil];

          
    } else {
 
[PFUser logInWithUsernameInBackground:username password:password
                                block:^(PFUser *user, NSError *error) {
                                    if (user) {
                                    
                                        [self performSegueWithIdentifier:@"MainStoryboardSegue" sender:nil];
                                        
                                    } else {
                                        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:error.localizedDescription
                                                                            preferredStyle:UIAlertControllerStyleAlert];
                                        UIAlertAction *okayButton = [UIAlertAction actionWithTitle:@"Okay"
                                                                                             style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                                                                                                 
                                                                                                 
                                                                                                 
                                                                                                 
                                                                                             }];
                                        [alert addAction:okayButton];
                                        [self presentViewController:alert
                                                           animated:YES
                                                         completion:nil];
                                    }
                                }];
}

}
- (IBAction)onLoginButtonTapped:(UIButton *)sender {
    
    [self userlogin];
}


@end
