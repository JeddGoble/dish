//
//  ProfileViewController.m
//  Dish
//
//  Created by Jedd Goble on 10/22/15.
//  Copyright © 2015 Mobile Makers. All rights reserved.
// Test

#import "ProfileViewController.h"
#import <Parse/Parse.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "Photo.h"
#import "SettingsViewController.h"
#import "FullScreenPhotoViewController.h"

@interface ProfileViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *dishesCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *dishesTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *profilePhotoImageView;
@property (weak, nonatomic) IBOutlet UILabel *followersCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followingCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *followersTextLabel;
@property (weak, nonatomic) IBOutlet UILabel *usernameTextLabel;
@property (weak, nonatomic) IBOutlet UITextView *biographyTextView;
@property (weak, nonatomic) IBOutlet UILabel *locationTextLabel;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segController;
@property (weak, nonatomic) IBOutlet UIScrollView *traitsView;
@property (weak, nonatomic) IBOutlet UIButton *mapRefreshButton;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIButton *editSettingsButton;

@property (strong, nonatomic) NSArray *userLikes;
@property (strong, nonatomic) NSArray *userDislikes;


@property (weak, nonatomic) IBOutlet UIButton *locationButton;


@property (strong, nonatomic) NSMutableArray *photoObjects;
@property (strong, nonatomic) NSMutableArray *downloadedImages;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[UITabBar appearance] setBackgroundColor:[UIColor yellowColor]];
    [[UITabBar appearance] setTintColor:[UIColor yellowColor]];
    
    self.mapView.hidden = YES;
    self.traitsView.hidden = YES;
    self.locationButton.hidden = YES;
    self.mapRefreshButton.hidden = YES;
    
    self.collectionView.delegate = self;
    self.locationManager.delegate = self;
    self.mapView.delegate = self;
    
    self.mapView.showsUserLocation = YES;
    self.locationManager = [CLLocationManager new];
    
    [self initiatePageWithFeed];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [self.collectionView reloadData];
    
    if (![PFUser currentUser]) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"LoginAndRegistration" bundle:nil];
        UIViewController *tempVC = [storyboard instantiateViewControllerWithIdentifier:@"LoginScreen"];
        [self presentViewController:tempVC animated:YES completion:nil];
    }
    
}

- (void) initiatePageWithFeed {
    
    [self.spinner startAnimating];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    self.locationTextLabel.alpha = 0.6;
    
    
    if (!self.viewingUser) {
        self.viewingUser = [PFUser currentUser];
    }
    
    
    if (self.viewingUser == [PFUser currentUser]) {
        self.followButton.hidden = YES;
        self.editSettingsButton.hidden = NO;
    } else {
        self.followButton.hidden = NO;
        self.editSettingsButton.hidden = YES;
    }
    
    
    self.photoObjects = [[NSMutableArray alloc] init];
    self.downloadedImages = [[NSMutableArray alloc] init];
    
    self.profilePhotoImageView.layer.cornerRadius = self.profilePhotoImageView.frame.size.height / 2;
    self.profilePhotoImageView.clipsToBounds = YES;
    
    PFQuery *userQuery = [PFQuery queryWithClassName:@"_User"];
    [userQuery getObjectInBackgroundWithId:self.viewingUser.objectId block:^(PFObject * _Nullable user, NSError * _Nullable error) {
        self.viewingUser = user;
        
        self.usernameTextLabel.text = self.viewingUser.username;
        self.userLikes = [[NSArray alloc] initWithArray:user[@"likes_array"]];
        self.userDislikes = [[NSArray alloc] initWithArray:user[@"dislikes_array"]];
        self.locationTextLabel.text = user[@"hometown_string"];
        self.biographyTextView.text = user[@"bio_string"];
        self.biographyTextView.font = [UIFont systemFontOfSize:14.0];
        self.biographyTextView.textColor = [UIColor whiteColor];
        self.followersCountLabel.text = [NSString stringWithFormat:@"%@", user[@"followerCount_number"]];
        self.followingCountLabel.text = [NSString stringWithFormat:@"%@", user[@"followingCount_number"]];
        
        PFFile *profilePicture = user[@"userProfileImage_data"];
        [profilePicture getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
            UIImage *profileImage = [UIImage imageWithData:data];
            self.profilePhotoImageView.image = profileImage;
        }];
        
        [self getSixUserPhotos:self.viewingUser withCompletion:^(NSArray *photos) {
            
            for (Photo *photo in photos) {
                
                [photo.photo_data getDataInBackgroundWithBlock:^(NSData * _Nullable data, NSError * _Nullable error) {
                    
                    UIImage *image = [UIImage imageWithData:data];
                    [self.downloadedImages addObject:image];
    
                    [self.photoObjects addObject:photo];
                    
                    [self.collectionView reloadData];
                }];
                
            }
            
            [self.spinner stopAnimating];
            
        }];
        
    }];
}

- (void) getSixUserPhotos:(PFUser *)viewingUser withCompletion:(void (^)(NSArray *photos))complete {
    
    PFQuery *photoIDQuery = [Photo query];
    [photoIDQuery whereKey:@"User_pointer" equalTo:viewingUser];
    [photoIDQuery setLimit:6];
    [photoIDQuery findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {
        
        
        complete(objects);
    }];
    
}

- (IBAction)onSegmentedControllerValueChanged:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        self.collectionView.hidden = NO;
        self.traitsView.hidden = YES;
        self.mapView.hidden = YES;
        self.locationButton.hidden = YES;
        self.mapRefreshButton.hidden = YES;
        [self.locationManager stopUpdatingLocation];
    } else if (sender.selectedSegmentIndex == 1) {
        self.collectionView.hidden = YES;
        self.traitsView.hidden = NO;
        self.mapView.hidden = YES;
        self.locationButton.hidden = YES;
        self.mapRefreshButton.hidden = YES;
        [self.locationManager stopUpdatingLocation];
        [self switchToTraitView];
    } else if (sender.selectedSegmentIndex == 2) {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager startUpdatingLocation];
        self.collectionView.hidden = YES;
        self.traitsView.hidden = YES;
        self.mapView.hidden = NO;
        self.mapRefreshButton.hidden = NO;
        self.locationButton.hidden = NO;
    }
    
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ProfilePhotoCellID" forIndexPath:indexPath];
    
    CGFloat width = (self.view.frame.size.width / 2) - 15;
    CGFloat height = width;
    
    UIImage *image = [self.downloadedImages objectAtIndex:indexPath.item];
    
    UIImage *resizedImage = [self imageForScaling:image scaledToSize:CGSizeMake(width, height)];
    
    cell.backgroundColor = [UIColor colorWithPatternImage:resizedImage];
    
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    
    return self.photoObjects.count;
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat width = (self.view.frame.size.width / 2) - 15;
    CGFloat height = width;
    
    CGSize cellSize = CGSizeMake(width, height);
    
    return cellSize;
    
}


- (UIImage *)imageForScaling:(UIImage *)image scaledToSize:(CGSize)newSize {
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    
    return newImage;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    return 10;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets inset = UIEdgeInsetsMake(10, 10, 10, 10);
    
    return inset;
    
}


#pragma Traits View

- (void) switchToTraitView {
    
    UILabel *likesLabel = [UILabel new];
    likesLabel.text = [NSString stringWithFormat:@"Likes"];
    likesLabel.textAlignment = NSTextAlignmentCenter;
    likesLabel.textColor = [UIColor grayColor];
    likesLabel.font = [UIFont systemFontOfSize:17.0];
    
    [likesLabel sizeToFit];
    [self.traitsView addSubview:likesLabel];
    
    likesLabel.frame = CGRectMake((self.traitsView.frame.size.width / 2) - (likesLabel.frame.size.width / 2), 10, likesLabel.frame.size.width, likesLabel.frame.size.height);
    
    //    NSArray *traitTags = [[NSArray alloc] initWithObjects:@"paleo", @"kosher", @"shellfish", @"hamburgers", @"bubble gum", @"rocks", nil];
    CGFloat xOrigin = 20;
    int row = 1;
    
    for (NSString *trait in self.userLikes) {
        
        
        UILabel *traitsLabel = [self createLabelWithColor:[UIColor colorWithRed:83.0 / 255.0 green:33.0 / 255.0 blue:168.0 / 255.0 alpha:1.0] andText:trait];
        [self.traitsView addSubview:traitsLabel];
        
        if (xOrigin + traitsLabel.frame.size.width + 30 > self.traitsView.frame.size.width) {
            xOrigin = 20;
            row++;
        }
        
        traitsLabel.frame = CGRectMake(xOrigin, (row * 40) + 10, traitsLabel.frame.size.width + 20, traitsLabel.frame.size.height + 8);
        traitsLabel.layer.cornerRadius = traitsLabel.frame.size.height / 2;
        
        xOrigin = xOrigin + traitsLabel.frame.size.width + 10;
        
    }
    
    if (xOrigin != 20) {
        row++;
    }
    
    xOrigin = 20;
    row++;
    
    UILabel *dislikesLabel = [UILabel new];
    dislikesLabel.text = [NSString stringWithFormat:@"Allergies and Dislikes"];
    dislikesLabel.textAlignment = NSTextAlignmentCenter;
    dislikesLabel.textColor = [UIColor grayColor];
    dislikesLabel.font = [UIFont systemFontOfSize:17.0];
    
    [dislikesLabel sizeToFit];
    [self.traitsView addSubview:dislikesLabel];
    
    dislikesLabel.frame = CGRectMake((self.traitsView.frame.size.width / 2) - (dislikesLabel.frame.size.width / 2), (row * 40) + 10, dislikesLabel.frame.size.width, dislikesLabel.frame.size.height);
    
    row++;
    
    //    NSArray *dislikeTraits = [[NSArray alloc] initWithObjects:@"dieting", @"core data", @"anything healthy", @"xcode autolayout", nil];
    
    
    for (NSString *dislike in self.userDislikes) {
        
        
        UILabel *dislikeLabel = [self createLabelWithColor:[UIColor blackColor] andText:dislike];
        [self.traitsView addSubview:dislikeLabel];
        
        if (xOrigin + dislikeLabel.frame.size.width + 30 > self.traitsView.frame.size.width) {
            xOrigin = 20;
            row++;
        }
        
        dislikeLabel.frame = CGRectMake(xOrigin, (row * 40) + 10, dislikeLabel.frame.size.width + 20, dislikeLabel.frame.size.height + 8);
        dislikeLabel.layer.cornerRadius = dislikeLabel.frame.size.height / 2;
        
        xOrigin = xOrigin + dislikeLabel.frame.size.width + 10;
        
    }
    
    
    
}

- (UILabel *) createLabelWithColor:(UIColor *)color andText:(NSString *)labelText {
    UILabel *label = [UILabel new];
    label.text = labelText;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    label.backgroundColor = color;
    [label sizeToFit];
    label.clipsToBounds = YES;
    
    return label;
    
}

- (IBAction)onFollowButtonTapped:(UIButton *)sender {
    PFObject *newFollow = [PFObject objectWithClassName:@"Follow"];
    newFollow[@"followedBy_pointer"] = [PFUser currentUser];
    newFollow[@"following_pointer"] = self.viewingUser;
    [newFollow saveInBackgroundWithBlock:^(BOOL succeeded, NSError * _Nullable error) {
        if (succeeded) {
            NSLog(@"Follow was successful");
            [self.followButton setTitle:@"Following" forState:UIControlStateNormal];
        } else {
            NSLog(@"Follow failed");
        }
    }];
    
}




#pragma MapView Handling

- (IBAction)onLocationButtonPressed:(UIButton *)sender {
    
    if (self.mapView.userLocation.coordinate.latitude != 0.0) {
        
        double span;
        
        if (self.mapView.region.span.longitudeDelta > 10.0) {
            span = 1.0;
        } else {
            span = self.mapView.region.span.longitudeDelta;
        }
        
        MKCoordinateSpan coordinateSpan;
        coordinateSpan.latitudeDelta = span;
        coordinateSpan.longitudeDelta = span;
        
        MKCoordinateRegion region;
        region.center = self.mapView.userLocation.coordinate;
        region.span = coordinateSpan;
        
        [self.mapView setRegion:region animated:YES];
    } else {
        NSError *error = [NSError new];
        [self failedWithError:error];
    }
    
}

- (IBAction)onMapRefreshButtonPressed:(UIButton *)sender {
    
    for (PFObject *photo in self.photoObjects) {
        PFObject *locationPointer = photo[@"Location_pointer"];
        
        NSLog(@"%@", locationPointer);
        
        PFQuery *locationQuery = [PFQuery queryWithClassName:@"Location"];
        
        [locationQuery getObjectInBackgroundWithId:locationPointer.objectId block:^(PFObject * _Nullable location, NSError * _Nullable error) {
            
            NSNumber *lat = location[@"latitude_number"];
            NSNumber *lon = location[@"longitude_number"];
            
            double latDouble = [lat doubleValue];
            double lonDouble = [lon doubleValue];
            
            MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
            
            annotation.coordinate = CLLocationCoordinate2DMake(latDouble, lonDouble);
            
            [self.mapView addAnnotation:annotation];
            
        }];
    }
    
}





#pragma MapView Delegates



- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKAnnotationView *pin = [MKAnnotationView new];
    
    if (annotation == self.mapView.userLocation) {
        return nil;
    }
    
    pin.image = [UIImage imageNamed:@"forkpin"];
    
    return pin;
    
}

#pragma Prepare for segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    
    
    if ([segue.identifier isEqualToString:@"settingsSegue"]) {
        
        SettingsViewController *tempVC = segue.destinationViewController;
        tempVC.currentUser = self.viewingUser;
        
        
    } else if ([segue.identifier isEqualToString:@"fullScreenPhotoSegue"]) {
        
        NSIndexPath *indexPath = [self.collectionView indexPathForCell:sender];
        
        FullScreenPhotoViewController *tempVC = segue.destinationViewController;
        
        tempVC.viewingUserPic = self.profilePhotoImageView.image;
        tempVC.viewingUser = self.viewingUser;
        tempVC.viewingPhoto = [self.photoObjects objectAtIndex:indexPath.item];
        tempVC.imageToDisplay = [self.downloadedImages objectAtIndex:indexPath.item];
        
    }
    
    
}


#pragma Failed alert

- (void)failedWithError:(NSError *)error {
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Could not find your location. Try again later." preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *bummer = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:bummer];
    
    [self presentViewController:alertController animated:YES completion:nil];
}



@end
