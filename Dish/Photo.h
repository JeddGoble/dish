//
//  Photo.h
//  Dish
//
//  Created by Jedd Goble on 10/25/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import <Parse/Parse.h>


@interface Photo : PFObject <PFSubclassing>

@property (strong, nonatomic) NSString *objectID;
@property (strong, nonatomic) NSString *photoDesc_string;
@property (strong, nonatomic) NSString *photoTitle_string;
@property (strong, nonatomic) NSData *photo_data;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) NSDate *createdAt;
@property (strong, nonatomic) NSDate *updatedAt;


+ (NSString *) parseClassName;


@end
