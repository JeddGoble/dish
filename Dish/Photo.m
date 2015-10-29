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
@dynamic createdAt;
@dynamic updatedAt;
@dynamic usersThatLiked_Array;

+ (void) load {
    [self registerSubclass];
}

+ (NSString *) parseClassName {
    return @"Photo";
}

@end
