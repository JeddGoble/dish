//
//  InitialScreenViewController.m
//  Dish
//
//  Created by Danielle Smith on 10/29/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "InitialScreenViewController.h"
#import <Parse/Parse.h>
#import "FeedViewController.h"
#import "LoginViewController.h"

@interface InitialScreenViewController ()
@property PFUser *currentUser;
@property BOOL userLoggedIn;
@end

@implementation InitialScreenViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.currentUser = [PFUser currentUser];
}

-(void)viewDidAppear:(BOOL)animated {
    [self checkCurrentUser];
}

- (void)checkCurrentUser {
    
   
    
    if(self.currentUser) {
        
        [self performSegueWithIdentifier:@"CurrentUserFeedSegue" sender:nil];
        
        
    } else {

        [self performSegueWithIdentifier:@"LoginSegue" sender:nil];
    }
}


@end
