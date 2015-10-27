//
//  SetLocationViewController.m
//  Dish
//
//  Created by Jeremy Alper on 10/26/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "SetLocationViewController.h"


@interface SetLocationViewController () <UITableViewDataSource , UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SetLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"Test Restaurant %li", (long)indexPath.row + 1];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    self.ppvc.locationTextField.text = cell.textLabel.text;
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
