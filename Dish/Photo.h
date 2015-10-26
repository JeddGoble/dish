//
//  Photo.h
//  Dish
//
//  Created by Jedd Goble on 10/25/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import <Parse/Parse.h>

@interface Photo : PFObject

@property (strong, nonatomic) UIImage *image;
@property (nonatomic) double latitude;
@property (nonatomic) double longitude;

@end
