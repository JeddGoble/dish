//
//  SettingsTableViewController.h
//  Dish
//
//  Created by Jedd Goble on 10/26/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PFObject;
@class PFUser;

@interface SettingsViewController : UITableViewController

@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) UIImage *profileImage;

@end
