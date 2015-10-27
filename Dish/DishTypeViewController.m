//
//  DishTypeViewController.m
//  Dish
//
//  Created by Jeremy Alper on 10/26/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "DishTypeViewController.h"
#import "DietTypeViewController.h"

@interface DishTypeViewController () < UITableViewDelegate, UITableViewDataSource >
@property NSMutableArray *arrayOfDishTypes;
@property (weak, nonatomic) IBOutlet UILabel *myName;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation DishTypeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.arrayOfDishTypes = [[NSMutableArray alloc] initWithObjects:
                               @{@"dishType" : @"Thai",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"Chinese",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"Japanese",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"Indian",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"Middle Eastern",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"French",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"Italian",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"Mediterranean",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"Ethiopian",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"American",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"Mexican",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"Southern",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"BBQ",
                                 @"isDishType" : @NO},
                               @{@"dishType" : @"Cajun",
                                 @"isDishType" : @NO}, nil];
  
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.arrayOfDishTypes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [[self.arrayOfDishTypes objectAtIndex:indexPath.row] objectForKey:@"dishType"];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithDictionary:[self.arrayOfDishTypes objectAtIndex:indexPath.row]];
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        cell.accessoryType = UITableViewCellAccessoryNone;
        [dictionary setObject:@NO forKey:@"isDishType"];
        [self.arrayOfDishTypes replaceObjectAtIndex:indexPath.row withObject:dictionary];
    } else {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
        [dictionary setObject:@YES forKey:@"isDishType"];
        [self.arrayOfDishTypes replaceObjectAtIndex:indexPath.row withObject:dictionary];
        
    }

}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    DietTypeViewController *dvc = segue.destinationViewController;
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:0] objectForKey:@"isDishType"] forKey:@"dishTypeThai_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:1] objectForKey:@"isDishType"] forKey:@"dishTypeChinese_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:2] objectForKey:@"isDishType"] forKey:@"dishTypeJapanese_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:3] objectForKey:@"isDishType"] forKey:@"dishTypeIndian_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:4] objectForKey:@"isDishType"] forKey:@"dishTypeMiddleEastern_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:5] objectForKey:@"isDishType"] forKey:@"dishTypeFrench_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:6] objectForKey:@"isDishType"] forKey:@"dishTypeItalian_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:7] objectForKey:@"isDishType"] forKey:@"dishTypeMediterranean_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:8] objectForKey:@"isDishType"] forKey:@"dishTypeEthiopian_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:9] objectForKey:@"isDishType"] forKey:@"dishTypeAmerican_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:10] objectForKey:@"isDishType"] forKey:@"dishTypeMexican_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:11] objectForKey:@"isDishType"] forKey:@"dishTypeSouthern_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:12] objectForKey:@"isDishType"] forKey:@"dishTypeBBQ_bool"];
    [self.photo setObject:[[self.arrayOfDishTypes objectAtIndex:13] objectForKey:@"isDishType"] forKey:@"dishTypeCajun_bool"];
    dvc.photo = self.photo;

}














@end
