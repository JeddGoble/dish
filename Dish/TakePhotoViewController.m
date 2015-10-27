//
//  TakePhotoViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/22/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
//

#import "TakePhotoViewController.h"
#import "PostPhotoViewController.h"

@interface TakePhotoViewController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate >
@property UIImage *image;

@end

@implementation TakePhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

- (IBAction)takePictureButtonPressed:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    
    [self presentViewController:picker animated:YES completion:NULL];
    
    
}

- (IBAction)selectPhoto:(UIButton *)sender {
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    
    [self presentViewController:picker animated:YES completion:NULL];
    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.image = image;
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [self performSegueWithIdentifier:@"segue" sender:nil];
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    PostPhotoViewController *dvc = segue.destinationViewController;
    dvc.image = self.image;
}


@end
