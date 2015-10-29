//
//  LoginViewController.h
//  Dish
//
//  Created by Danielle Smith on 10/27/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

// Outlets
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

// Method Declaration
-(void)userlogin;

@end
