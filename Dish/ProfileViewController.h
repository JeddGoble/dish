//
//  ProfileViewController.h
//  Dish
//
//  Created by Jedd Goble on 10/22/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFUser;

@interface ProfileViewController : UIViewController

@property (strong, nonatomic) PFUser *viewingUser;

@end
