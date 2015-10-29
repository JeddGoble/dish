//
//  LoginInformation.h
//  Dish
//
//  Created by Danielle Smith on 10/28/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginInformation : NSObject

// Properties
@property NSString *username;
@property NSString *userEmail;
@property NSString *userPassword;

@property BOOL failedLogin;
@property BOOL validLogin;
@property BOOL loginAlreadyExists;

// Method Declarations
-(BOOL)loginAlreadyExists;
-(BOOL)storeLoginInformationinParse;
-(BOOL)validLoginforUser:(NSString *)username;

-(void)saveUsernameToUserDefaults;
-(void)saveUserPasswordToUserDefaults;
-(void)saveuserEmailToUserDefaults;

-(NSString *)retrieveUsernameFromUserDefaults;
-(NSString *) retrievePasswordFromUserDefaults;
-(NSString *)retrieveEmailFromUserDefaults;


@end
