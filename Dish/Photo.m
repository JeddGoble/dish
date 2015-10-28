//
//  Photo.m
//  Dish
//
//  Created by Jedd Goble on 10/25/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "Photo.h"
#import <Parse/PFObject+Subclass.h>

@implementation Photo

@dynamic objectID;
@dynamic photoDesc_string;
@dynamic photoTitle_string;
@dynamic photo_data;
@dynamic image;
@dynamic createdAt;
@dynamic updatedAt;

- (void)setPhoto_data:(NSData *)photo_data {
    
    self.photo_data = photo_data;
    self.image = [UIImage imageWithData:photo_data];
    
    
}

+ (void) load {
    [self registerSubclass];
}

+ (NSString *) parseClassName {
    return @"Photo";
}

@end
