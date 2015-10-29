//
//  FullScreenPhotoViewController.h
//  Dish
//
//  Created by Jedd Goble on 10/27/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Photo;
@class PFUser;

@interface FullScreenPhotoViewController : UIViewController

@property (strong, nonatomic) PFUser *viewingUser;
@property (strong, nonatomic) UIImage *viewingUserPic;
@property (strong, nonatomic) Photo *viewingPhoto;
@property (strong, nonatomic) UIImage *imageToDisplay;

@end
