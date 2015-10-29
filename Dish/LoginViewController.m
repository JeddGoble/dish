//
//  LoginViewController.m
//  Dish
//
//  Created by Danielle Smith on 10/27/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


//-(BOOL) checkCurrentUser {
//    PFUser *currentUser = [PFUser]
//    if (currentUser) {
//        //call delegate method to pass userobject
//    } else {
//        
//    };
//}

-(void)userlogin {
    
    NSString *username = self.usernameTextField.text;
    NSString *password = self.passwordTextField.text;

    if (username.length <= 0 || password.length <= 0) {
         
    }
    
[PFUser logInWithUsernameInBackground:username password:password
                                block:^(PFUser *user, NSError *error) {
                                    if (user) {
                                        NSLog(@"Successful Login");
                                    } else {
                                        NSLog(@"Successful Login");
                                    }
                                }];
}

// sign up
//- (void)myMethod {
//    PFUser *user = [PFUser user];
//    user.username = @"my name";
//    user.password = @"my pass";
//    user.email = @"email@example.com";
//    
//    // other fields can be set just like with PFObject
//    user[@"phone"] = @"415-392-0202";
//    
//    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
//        if (!error) {   // Hooray! Let them use the app now.
//        } else {   NSString *errorString = [error userInfo][@"error"];   // Show the errorString somewhere and let the user try again.
//        }
//    }];
//}

//logout user
//[PFUser logOut];
//PFUser *currentUser = [PFUser currentUser]; // this will now be nil

//setting current user
//
//[PFUser becomeInBackground:@"session-token-here" block:^(PFUser *user, NSError *error) {
//    if (error) {
//        // The token could not be validated.
//    } else {
//        // The current user is now set to user.
//    }
//}];
@end
