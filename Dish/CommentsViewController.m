//
//  CommentsViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/28/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "CommentsViewController.h"
#import "Photo.h"
#import <Parse/Parse.h>

@interface CommentsViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *comments;

@end

@implementation CommentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 60.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    self.comments = [NSMutableArray new];
    
    PFQuery *getComments = [PFQuery queryWithClassName:@"Comment"];
    [getComments whereKey:@"Photo_pointer" equalTo:self.viewingPhoto];
    [getComments findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        [self.comments addObject:self.viewingPhoto.photoDesc_string];
        
        for (PFObject *comment in objects) {
            [self.comments addObject:comment[@"comment_string"]];
            
        }
        
        [self.tableView reloadData];
    }];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CommentCellID"];
    
    cell.textLabel.text = [self.comments objectAtIndex:indexPath.row];
    
    return cell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.comments.count;
}


- (IBAction)onBackButtonPressed:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}



@end
