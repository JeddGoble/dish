//
//  DietTypeViewController.m
//  Dish
//
//  Created by Jeremy Alper on 10/26/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "DietTypeViewController.h"

@interface DietTypeViewController () < UITableViewDelegate , UITableViewDataSource >
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property NSMutableArray *arrayOfDietTypes;
@property (strong, nonatomic) PFUser *currentUser;

@end

@implementation DietTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    [userQuery getObjectInBackgroundWithId:@"CdmFf26Zqe" block:^(PFObject * _Nullable user, NSError * _Nullable error) {
        self.currentUser = user;
    }];
    
    self.arrayOfDietTypes = [[NSMutableArray alloc] initWithObjects:
                             @{@"dietType" : @"Vegan",
                               @"isDietType" : @NO},
                             @{@"dietType" : @"Vegetarian",
                               @"isDietType" : @NO},
                             @{@"dietType" : @"Gluten-Free",
                               @"isDietType" : @NO},
                             @{@"dietType" : @"Dairy-Free",
                               @"isDietType" : @NO},
                             @{@"dietType" : @"Paleo",
                               @"isDietType" : @NO},
                             @{@"dietType" : @"Low Carb",
                               @"isDietType" : @NO},
                             @{@"dietType" : @"Healthy",
                               @"isDietType" : @NO}, nil];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfDietTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [[self.arrayOfDietTypes objectAtIndex:indexPath.row] objectForKey:@"dietType"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[self.arrayOfDietTypes objectAtIndex:indexPath.row]];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [dictionary setObject:@NO forKey:@"isDietType"];
        [self.arrayOfDietTypes replaceObjectAtIndex:indexPath.row withObject:dictionary];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [dictionary setObject:@YES forKey:@"isDietType"];
        [self.arrayOfDietTypes replaceObjectAtIndex:indexPath.row withObject:dictionary];
    }
    
}

- (IBAction)postButtonPressed:(UIBarButtonItem *)sender {
    [self.photo setObject:[[self.arrayOfDietTypes objectAtIndex:0] objectForKey:@"isDietType"] forKey:@"dietTypeVegan_bool"];
    [self.photo setObject:[[self.arrayOfDietTypes objectAtIndex:1] objectForKey:@"isDietType"] forKey:@"dietTypeVegetarian_bool"];
    [self.photo setObject:[[self.arrayOfDietTypes objectAtIndex:2] objectForKey:@"isDietType"] forKey:@"dietTypeGlutenFree_bool"];
    [self.photo setObject:[[self.arrayOfDietTypes objectAtIndex:3] objectForKey:@"isDietType"] forKey:@"dietTypeDairyFree_bool"];
    [self.photo setObject:[[self.arrayOfDietTypes objectAtIndex:4] objectForKey:@"isDietType"] forKey:@"dietTypePaleo_bool"];
    [self.photo setObject:[[self.arrayOfDietTypes objectAtIndex:5] objectForKey:@"isDietType"] forKey:@"dietTypeLowCarb_bool"];
    [self.photo setObject:[[self.arrayOfDietTypes objectAtIndex:6] objectForKey:@"isDietType"] forKey:@"dietTypeHealthy_bool"];
    [self.photo setObject:self.currentUser forKey:@"User_pointer"];
    
    [self.photo saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            NSLog(@"The object has been saved");
        } else {
            NSLog(@"There was a problem, check error.description");
        }
    }];
    
}



@end
