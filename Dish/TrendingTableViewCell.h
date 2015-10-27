//
//  TrendingTableViewCell.h
//  Dish
//
//  Created by Danielle Smith on 10/27/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <ParseUI/ParseUI.h>

@interface TrendingTableViewCell : UITableViewCell

// outlets
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet PFImageView *userProfileImage;


@end
