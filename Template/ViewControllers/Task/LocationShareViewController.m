//
//  LocationShareViewController.m
//  HHPOChat
//
//  Created by Dipin on 8/29/17.
//  Copyright © 2017 CPD. All rights reserved.
//

#import "LocationShareViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "NearLocation.h"
#import "NearByTableViewCell.h"
#import "MKMapView+ZoomLevel.h"
#import "MBProgressHUD.h"
#import "CommonFunction.h"
#import "URLConstants.h"




#define kFourSquare @"54X53BEVGQ5RBXZ4QUKZOYFISV22CNU3W2U03W5GQM4NIJ4A"

#define kTopNearConstraint 224

#define kMapViewHeightConstraint 160

#define ZOOM_LEVEL 10

#define kSearchString @"kSearchString"
#define kReloadImage [[UIImage imageNamed:@"reload_location.png"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate]

@interface LocationShareViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource,CLLocationManagerDelegate>
{
    
    __weak IBOutlet NSLayoutConstraint *widthReloadCpnstraints;
    __weak IBOutlet UIButton *btnReload;
    __weak IBOutlet NSLayoutConstraint *widthCancelConstraints;
    __weak IBOutlet UIButton *btnCancel;
    __weak IBOutlet UISearchBar *searchBarNav;
    
    
    NSMutableArray *recentSearches;
    NSMutableArray *nearByDetails;
    
    __weak IBOutlet NSLayoutConstraint *heightMapviewConstraint;
    __weak IBOutlet NSLayoutConstraint *topNearByTblConstraint;
    
    CLLocation *userCurrentLocation;
    
    CLLocationManager *locationManager;
    
    
    MKPointAnnotation *longPressAnnotation;
    
    MKPointAnnotation *currentLocationAnnotation;
    
    UITapGestureRecognizer *tapGesture;
    
    BOOL isFindNearestLocation;
    
    BOOL isDragging;
    
    BOOL locationSelected;

    float safeAreaInsetBottom;
    
    BOOL isActivityShowed;

}

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@property (nonatomic,strong) CLLocationManager *locationManager;

@end

@implementation LocationShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.view.backgroundColor = kThemeBGColor;

    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
//    btnReload.tintColor = kNavigationButtonColor;
//    btnCancel.tintColor = kNavigationButtonColor;
//    _tblRecentSearch.backgroundColor = kThemeBGColor;
//    _tblLocationNearby.backgroundColor = kThemeBGColor;
    [btnReload setImage:kReloadImage forState:UIControlStateNormal];
    
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setDefaultTextAttributes:@{NSForegroundColorAttributeName:kThemeTextColor}];
//    searchBarNav.tintColor = kThemeTextColor;

//    _tblRecentSearch.separatorColor = kThemeTableSeperatorColor;
//    _tblLocationNearby.separatorColor = kThemeTableSeperatorColor;
    
    safeAreaInsetBottom = 0.0;
    if (@available(iOS 11.0, *)) {
        safeAreaInsetBottom = [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    [self showActivity];

//    [self performSelectorInBackground:@selector(checkLocationService) withObject:nil];

    [self checkLocationService];
    
    nearByDetails = [[NSMutableArray alloc] init];
    recentSearches = [[NSMutableArray alloc] init];
    
    _tblRecentSearch.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    _tblLocationNearby.tableFooterView=[[UIView alloc] initWithFrame:CGRectZero];
    
    UILongPressGestureRecognizer *tapRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressTap:)];
    
    tapRecognizer.minimumPressDuration= 0.5;
    
    [self.mapView addGestureRecognizer:tapRecognizer];
    
    
    currentLocationAnnotation = [[MKPointAnnotation alloc] init];
    
    CADisplayLink *link = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateViewsBasedOnMapRegion:)];
    [link addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];

}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    isFindNearestLocation=NO;
    
    [self.locationManager startUpdatingLocation];

}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self.locationManager stopUpdatingLocation];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)showActivity
{
    if (isActivityShowed) {
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    }
    isActivityShowed = YES;
    
     [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
-(void)hideActivity
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    isActivityShowed = NO;
}
-(void)longPressTap:(UILongPressGestureRecognizer*)recognizer
{
    if (recognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    CGPoint touchPoint = [recognizer locationInView:self.mapView];
    
    CLLocationCoordinate2D location = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    
    if (longPressAnnotation) {
        
        [self.mapView removeAnnotation:longPressAnnotation];
    }
    
    if (!longPressAnnotation) {
        
        longPressAnnotation= [[MKPointAnnotation alloc] init];
    }
    longPressAnnotation.coordinate = location;
    //
    [self.mapView addAnnotation:longPressAnnotation];
    
    NSLog(@"Location found from Map: %f %f",location.latitude,location.longitude);
    
    //    [self selectedLocationApi:location];
    
    NSString *strUrl =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&key=%@",location.latitude,location.longitude,kGoogleServerKey];

    [self selectedLocationApi:location withUrl:strUrl completionHandler:^(NSArray *places) {
        
        if (places.count > 0) {
            
            NSDictionary *place =[places firstObject];
            
            //                    NSDictionary *location = [place[@"geometry"] objectForKey:@"location"];
            
            //                    CLLocationCoordinate2D coord;
            //
            //                    coord.latitude = [location[@"lat"] doubleValue];
            //
            //                    coord.longitude = [location[@"lng"] doubleValue];
            
            //                    MKPointAnnotation *point1 = [[MKPointAnnotation alloc] init];
            //
            //                    point1.title = place[@"formatted_address"];
            //
            //                    point1.coordinate = selectedCordinate;
            
            //                    [self.mapView addAnnotation:point1];
            
            longPressAnnotation.title=place[@"formatted_address"];
            
            [self.mapView addAnnotation:longPressAnnotation];
            
            
        }
    }];
}

#pragma mark- WEBSERVICE
-(void)nearestWS
{
//    [CommonFunction removeLoaderFromViewController:self];
//    [CommonFunction showLoaderInViewController:self];
    
    [self showActivity];

    // http://ncalculators.com/area-volume/circle-calculator.htm (radius to meter converter)
//    NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=5000&sensor=true&key=%@",userCurrentLocation.coordinate.latitude,userCurrentLocation.coordinate.longitude,kGoogleServerKey];
    
    if([CommonFunction isActiveInternet])
    {
        NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=5000&sensor=true&key=%@",userCurrentLocation.coordinate.latitude,userCurrentLocation.coordinate.longitude,kGoogleServerKey];
        
        [self selectedLocationApi:currentLocationAnnotation.coordinate withUrl:strUrl completionHandler:^(NSArray *places) {
            
            if (places.count > 0) {
                
                for (NSDictionary *place in places) {
                    
                    
                    NSString *iconUrl=@"";// = [self getPhotosURL:place[@"photos"]];
                    
                    //                    if ([place[@"photos"] count]>0) {
                    //
                    //                        iconUrl = [self getPhotosURL:[place[@"photos"] lastObject]];
                    //                    }
                    
                    NSDictionary *location = [place[@"geometry"] objectForKey:@"location"];
                    
                    NSString *LocId= place[@"id"];
                    
                    NSString *name;
                    
                    if (place[@"name"]) {
                        
                        name = place[@"name"];
                    }
                    else{
                        name=place[@"vicinity"];
                    }
                    
                    NearLocation *objLocation =[[NearLocation alloc] initWithImageName:iconUrl title:name withLatitude:[location[@"lat"] doubleValue] withLongtitude:[location[@"lng"] doubleValue] withLocationId:LocId withAddress:place[@"vicinity"]];
                    // do something with the icon URL
                    
                    [nearByDetails addObject:objLocation];
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    //When json is loaded stop the indicator
                    
//                    [CommonFunction removeLoaderFromViewController:self];
                    
                    [self.tblLocationNearby setHidden:NO];
                    [self.tblRecentSearch setHidden:YES];
                    
                    [self.tblLocationNearby reloadData];
                    
                    [self hideActivity];

                    [self getAddressFromCordinate:currentLocationAnnotation.coordinate];
                    
                });
                
            }
            else{
                [CommonFunction removeLoaderFromViewController:self];
                
            }
        }];
    }
    else{
        //                    [CommonFunction removeLoaderFromViewController:self];
        
        [self hideActivity];
        
        [CommonFunction displayTheToastWithMsg:@"No internet connection !" duration:1.5];
        
    }
}
#pragma mark- Mapview Delegate

//- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
//{
//    NSLog(@"clicked");
//}
- (MKAnnotationView *) mapView: (MKMapView *) mapView viewForAnnotation: (id<MKAnnotation>) annotation {
  
    MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [mapView dequeueReusableAnnotationViewWithIdentifier: @"annotation_ID"];
    if (annotationView == nil) {
        annotationView = [[MKPinAnnotationView alloc] initWithAnnotation: annotation reuseIdentifier: @"annotation_ID"];
    } else {
        annotationView.annotation = annotation;
    }
    
    if ([annotation.title isEqualToString:@"Send this location"]) {
        
        annotationView.pinTintColor = UIColor.greenColor;
        
        //        annotationView.leftCalloutAccessoryView = nil;
        
    }
    else{
        
        annotationView.pinTintColor = UIColor.redColor;
        
        //        annotationView.leftCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        
        
    }
    annotationView.animatesDrop = YES;
    annotationView.canShowCallout=YES;
    
    return annotationView;
}
-(void) calloutTapped:(UITapGestureRecognizer*) sender {
    
    if ([sender.view isKindOfClass:[MKAnnotationView class]]) {
        
        id<MKAnnotation> annotation = ((MKAnnotationView*)sender.view).annotation;
        
        NSLog(@"Annotation name=%@\n cordinate latitude %f",annotation.title,annotation.coordinate.latitude);
        
        NearLocation *objLocation =[[NearLocation alloc] initWithImageName:@"" title:annotation.title withLatitude:annotation.coordinate.latitude withLongtitude:annotation.coordinate.longitude withLocationId:0 withAddress:annotation.subtitle];
        
        [self selectedLocation:objLocation];
        
        
    }
    // code to  display whatever is required next.
    
    // To get the annotation associated with the callout that caused this event:
    //    id<MKAnnotation> annotation = ((MKAnnotationView*)sender.view).annotation;
    
    
}
- (void)mapView:(MKMapView *)mapView regionWillChangeAnimated:(BOOL)animated
{
    NSLog(@"Started moving");
    
    isDragging=YES;
}
- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    if (heightMapviewConstraint.constant != kMapViewHeightConstraint) {
        
        currentLocationAnnotation.coordinate = mapView.region.center;
        
//        NSString *strUrl =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",currentLocationAnnotation.coordinate.latitude,currentLocationAnnotation.coordinate.longitude];
        
        [self getAddressFromCordinate:currentLocationAnnotation.coordinate];

      /*  [self selectedLocationApi:currentLocationAnnotation.coordinate withUrl:strUrl completionHandler:^(NSArray *places) {
            
            if (places.count > 0) {
                
                NSDictionary *place =[places firstObject];
                
                currentLocationAnnotation.title=place[@"formatted_address"];
                if ([place[@"address_components"] count]>0) {

                    currentLocationAnnotation.subtitle=[[place[@"address_components"] firstObject] objectForKey:@"long_name"];

                }
                
//                [self.mapView addAnnotation:currentLocationAnnotation];
                
                
            }
        }];*/
        
    }
    
    NSLog(@"End moving");
    
    isDragging=NO;
}

-(void)getAddressFromCordinate:(CLLocationCoordinate2D)location
{
    NSString *strUrl =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&key=%@",location.latitude,location.longitude,kGoogleServerKey];

    [self selectedLocationApi:currentLocationAnnotation.coordinate withUrl:strUrl completionHandler:^(NSArray *places) {
        
        if (places.count > 0) {
            
            NSDictionary *place =[places firstObject];
            
            currentLocationAnnotation.title=place[@"formatted_address"];
            if ([place[@"address_components"] count]>0) {
                
                currentLocationAnnotation.subtitle=[[place[@"address_components"] firstObject] objectForKey:@"long_name"];
                
            }
            
            //                [self.mapView addAnnotation:currentLocationAnnotation];
            
            
        }
    }];
}

- (void)updateViewsBasedOnMapRegion:(CADisplayLink *)link
{
    // update whatever it is you need to update
    
    if (isDragging) {
        
        CLLocationCoordinate2D center = self.mapView.region.center;
        center.latitude += self.mapView.region.span.latitudeDelta * 0.05;
        //        [self.mapView setCenterCoordinate:center animated:YES];
        
        //         currentLocationAnnotation.coordinate = self.mapView.region.center;
        
        //        currentLocationAnnotation.coordinate = center;
        
        [CATransaction begin];
        [CATransaction setAnimationDuration:2];
        currentLocationAnnotation.coordinate = center;
        [CATransaction commit];
        
    }
}


- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    //    NSLog(@"Tapped");
    
}
- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                         action:@selector(calloutTapped:)];
    [view addGestureRecognizer:tapGesture];
    
}
- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    [view removeGestureRecognizer:tapGesture];
}

#pragma mark-ADDRESS FROM LOCATION

-(void)getAddressFromCordinate
{
    if([CommonFunction isActiveInternet])
    {
        NSString *strUrl =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true&key=%@",userCurrentLocation.coordinate.latitude,userCurrentLocation.coordinate.longitude,kGoogleServerKey];
        
        //   strUrl =  [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=5000&sensor=true&key=%@",userCurrentLocation.coordinate.latitude,userCurrentLocation.coordinate.longitude,kGoogleServerKey]
        
        [self selectedLocationApi:userCurrentLocation.coordinate withUrl:strUrl completionHandler:^(NSArray *places) {
            
            if (places.count > 0) {
                
                NSDictionary *place =[places firstObject];
                
                NSString *address=@"";
                
                if (place[@"formatted_address"]) {
                    
                    address= place[@"formatted_address"];
                    
                }
                if ([place[@"address_components"] count]>0) {
                    
                    currentLocationAnnotation.subtitle=[[place[@"address_components"] firstObject] objectForKey:@"long_name"];
                    
                }
                currentLocationAnnotation.title =address;
                
                NearLocation *objLocation =[[NearLocation alloc] initWithImageName:@"" title:currentLocationAnnotation.title withLatitude:userCurrentLocation.coordinate.latitude withLongtitude:userCurrentLocation.coordinate.longitude withLocationId:0 withAddress:currentLocationAnnotation.subtitle];
                
                [self selectedLocation:objLocation];
                
            }
            else
            {
                locationSelected = NO;
            }
        }];
    }
    else
    {
        locationSelected = NO;

        [CommonFunction displayTheToastWithMsg:@"No internet connection !" duration:1.5];
    }


}
#pragma mark - Class Functions

- (void)checkLocationService
{
    if ([CLLocationManager locationServicesEnabled]){
        
        NSLog(@"Location Services Enabled");
        
        if ([CLLocationManager authorizationStatus]==kCLAuthorizationStatusDenied){

            UIAlertController *alertController=   [UIAlertController
                                                   alertControllerWithTitle:@"App Permission Denied"
                                                   message:@"To re-enable, please go to Settings \n and turn on Location Service for \nthis app."
                                                   preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* yesButton = [UIAlertAction
                                        actionWithTitle:@"OK"
                                        style:UIAlertActionStyleDefault
                                        handler:^(UIAlertAction * action) {
                                            //Handle your yes please button action here
                                            
                                            
                                        }];
            
            [alertController addAction:yesButton];
            
            [self presentViewController:alertController animated:YES completion:nil];

        }
        else{
            
            
            if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [self.locationManager requestWhenInUseAuthorization];
            }

            [self.locationManager startUpdatingLocation];
            userCurrentLocation = [[CLLocation alloc] init];
        }
    }
    
}

//- (void) locationManager:(CLLocationManager *) manager didUpdateToLocation:(CLLocation *) newLocation fromLocation:(CLLocation *) oldLocation
//{
//    userCurrentLocation = newLocation;
//    
////    self.mapView.showsUserLocation = YES;
//
//    
//    if (!isFindNearestLocation) {
//     
//        isFindNearestLocation = YES;
//        
//        [self nearestWS];
//
//    }
//    
//    
//}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    NSLog(@"current location%@", [locations lastObject]);
    
    userCurrentLocation = [locations lastObject];
    
    //    self.mapView.showsUserLocation = YES;
    
    if (!isFindNearestLocation) {
        
        isFindNearestLocation = YES;
        
//        currentLocationAnnotation.coordinate = self.mapView.region.center;
        
        currentLocationAnnotation.coordinate =CLLocationCoordinate2DMake(userCurrentLocation.coordinate.latitude, userCurrentLocation.coordinate.latitude);// self.mapView.region.center;

        
        [self nearestWS];
        
    }
}
- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    
//    if (DEBUG) {
//        NSLog(@"Error = %@",[error localizedFailureReason]);
//
//    }
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status;
{
    [self checkLocationService];
}


- (void)configureNearbyCell:(NearByTableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    NearLocation *objNear= [nearByDetails objectAtIndex:indexPath.row];
    
    cell.lblTitle.text = objNear.title;
    
    cell.lblSubtitle.text= objNear.address;
//    cell.lblTitle.textColor = kThemeTextColor;
//    cell.lblSubtitle.textColor = kThemeTextColor;

}

- (void)configureRecentSearchCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath
{
    //        NSDictionary *cellDetails = [recentSearches objectAtIndex:indexPath.row];
    
    UIImageView *image=(UIImageView*)[cell viewWithTag:1];
    UILabel *nameLbl=(UILabel*)[cell viewWithTag:2];
    //
    image.image = [UIImage imageNamed:@"LocationSearchGray"];
    nameLbl.text=[recentSearches objectAtIndex:indexPath.row];
    
//    nameLbl.textColor = kThemeTextColor;
//    cell.textLabel.text =[recentSearches objectAtIndex:indexPath.row];
}

#pragma mark - Actions

- (IBAction)actionCancel:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)actionReload:(id)sender
{
    
    isFindNearestLocation=NO;
    
    [self.locationManager requestLocation];
    
    searchBarNav.text=@"";
    
//    nearByDetails[0] = @{@"image" : [UIImage imageNamed:@"mylocation_blue.png"] , @"text" : @"Send Your Location", @"subtitle" : @"Accurate to 10m"};
//    
//    if (heightMapviewConstraint.constant == kMapViewHeightConstraint) {
//        
//        nearByDetails[1] = @{@"image" : [UIImage imageNamed:@"expand_blue.png"] , @"text" : @"Hide places", @"subtitle" : @""};
//        
//    }
//    else{
//        
//        nearByDetails[1] = @{@"image" : [UIImage imageNamed:@"expand_blue.png"] , @"text" : @"Show places", @"subtitle" : @""};
//        
//    }
    
//    if(nearByDetails.count > 2)
//    {
//        [nearByDetails removeObjectsInRange:NSMakeRange(2, nearByDetails.count-2)];
//        
//    }
    
    [self nearestWS];
    
}


#pragma mark- TableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == _tblLocationNearby) {
        return nearByDetails.count;
    }
    else
    {
        return recentSearches.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblLocationNearby) {
        
        NearByTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"nearByListcell" forIndexPath:indexPath];
        
        if (indexPath.row < nearByDetails.count) {
            
            [self configureNearbyCell:cell withIndexPath:indexPath];
            
        }
        //            cell.backgroundColor = kThemeBGColor;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
        
//        cell.backgroundColor = kThemeBGColor;
        [self configureRecentSearchCell:cell withIndexPath:indexPath];
        
        return cell;
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tblLocationNearby) {
        NearLocation *objNear= [nearByDetails objectAtIndex:indexPath.row];
        
        NSLog(@"name =%@ and cordinate=%f",objNear.title,objNear.latitude);
        
        [self.delegate locationSelectionPressed:objNear];
        
        [self dismissViewControllerAnimated:YES completion:nil];

//        [self selectedLocation:objNear];
    }
    else
    {
        searchBarNav.text= [recentSearches objectAtIndex:indexPath.row];
        
        [self searchBarSearchButtonClicked:searchBarNav];
    }
    
}

- (void)HidePlaces {
    
    
    [UIView animateWithDuration:0.35f animations:^{
        
        if (safeAreaInsetBottom > 0) {
            heightMapviewConstraint.constant = [UIScreen mainScreen].bounds.size.height-195;

        }
        else
        {
            heightMapviewConstraint.constant = [UIScreen mainScreen].bounds.size.height-175;

        }
        
        self.tblLocationNearby.scrollEnabled = NO;
        
        nearByDetails[1] = @{@"image" : [UIImage imageNamed:@"collapse_blue.png"] , @"text" : @"Show places", @"subtitle" : @""};
        
        [self.view layoutIfNeeded];
        
        //        [self.tblLocationNearby reloadData];
        
        NSIndexPath *indexPath =[NSIndexPath indexPathForRow:1 inSection:0];
        
        [self.tblLocationNearby reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
        [self.mapView setZoomEnabled:YES];
        
        [self.mapView setCenterCoordinate:userCurrentLocation.coordinate zoomLevel:ZOOM_LEVEL animated:NO];
        
        NSArray *annotations = [self createAnnotations];
        
        [self.mapView addAnnotations:annotations];
        
    }];
    
    currentLocationAnnotation.title = @"Send this location";
    currentLocationAnnotation.coordinate = userCurrentLocation.coordinate;
    [self.mapView addAnnotation:currentLocationAnnotation];
    
    
}
- (void)showPlaces {
    
    [UIView animateWithDuration:0.35f animations:^{
        
        heightMapviewConstraint.constant = kMapViewHeightConstraint;
        
        self.tblLocationNearby.scrollEnabled = YES;
        
        nearByDetails[1] = @{@"image" : [UIImage imageNamed:@"expand_blue.png"] , @"text" : @"Hide places", @"subtitle" : @""};
        
        [self.view layoutIfNeeded];
        
        [self.tblLocationNearby reloadData];
        
        [self.mapView removeAnnotations:self.mapView.annotations];
        
        
    }];
    
}

-(NSMutableArray*)createAnnotations
{
    
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
    
    for (NearLocation *row in nearByDetails) {
        
        if ([row isKindOfClass:[NearLocation class]]) {
            
            double latitude = row.latitude;
            
            double longitude = row.longtitude;
            
            NSString *title = row.title;
            
            //Create coordinates from the latitude and longitude values
            
            CLLocationCoordinate2D coord;
            
            coord.latitude = latitude;
            
            coord.longitude = longitude;
            
            MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
            
            point.title = title;
            point.coordinate = coord;
            //            [self.mapView addAnnotation:point];
            
            [annotations addObject:point];
            
        }
        
        
    }
    
    return annotations;
    
}

- (void)selectedLocationApi:(CLLocationCoordinate2D)selectedCordinate withUrl:(NSString*)strUrl completionHandler:(void (^)(NSArray*))completionBlock{
    
    NSArray *places;
    
//    NSString *strUrl =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true",selectedCordinate.latitude,selectedCordinate.longitude];
    
    NSURL *url = [NSURL URLWithString:strUrl];
    NSError *error = nil;
    NSData *json = [NSData dataWithContentsOfURL:url options:0 error:&error];
    
    if (json) {
        
        NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:json
                                                                 options:kNilOptions
                                                                   error:&error];
        
        if ([jsonDict[@"results"] isKindOfClass:[NSArray class]]) {
            
            places =jsonDict[@"results"];
            
            completionBlock(places);
            
        }
        else
        {
            completionBlock(nil);
        }
    }
    
}
-(NSString*)getPhotosURL:(NSDictionary*)photos
{
    //    NSString *width = photos[@"width"];
    
    //    NSString *urlString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%@&photoreference=%@&key=%@",width,photos[@"photo_reference"]];
    
    NSString *urlString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=50&photoreference=%@&key=%@",photos[@"photo_reference"],kGoogleServerKey];
    
    //    NSString *urlString =[NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=2048&photoreference=CmRaAAAAWAymixLQfVIwypEoxiQYtvrVna2xBMjDcEu5mYV7E2XvwaMF1-tWKZwkIjGBXjurm0xd1blHgkKijrlsx4muzYlO4LfuDJRI4sv-eYmcLPfGghEOMEX4L46qDgmKHSw-EhCrTF-KJyvn657CBmaSyQ2mGhTrvyiOTChJqMYWMs9gFMsVLjrH8w&key=AIzaSyCORlYxTdokMz0q6XbzTE5tvwHvBGd5SA8"];
    
    
    return urlString;
}
#pragma mark - SearchBar Delegates

#pragma mark - SearchBar Delegates

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    widthCancelConstraints.constant = -5;
    widthReloadCpnstraints.constant = 0;
    [searchBar setShowsCancelButton:YES animated:YES];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
        
        NSUserDefaults *userDefault= [NSUserDefaults standardUserDefaults];
        
        if ([userDefault objectForKey:kSearchString]) {
            
            recentSearches = [[userDefault objectForKey:kSearchString] mutableCopy];
            
        }
        
        [self.tblLocationNearby setHidden:YES];
        [self.tblRecentSearch setHidden:NO];
        
        [self.tblRecentSearch setBackgroundColor:[UIColor whiteColor]];
        
        [self.tblRecentSearch reloadData];
        
    }completion:nil];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    widthCancelConstraints.constant = 67;
    widthReloadCpnstraints.constant = 30;
    [searchBar setShowsCancelButton:noErr animated:YES];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }completion:nil];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    widthCancelConstraints.constant = 67;
    widthReloadCpnstraints.constant = 30;
    [searchBar setShowsCancelButton:noErr animated:YES];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
        
        [self.tblLocationNearby setHidden:NO];
        [self.tblRecentSearch setHidden:YES];
        
    }completion:nil];
    [searchBar resignFirstResponder];
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [CommonFunction removeLoaderFromViewController:self];
    [CommonFunction showLoaderInViewController:self];
    widthCancelConstraints.constant = 67;
    widthReloadCpnstraints.constant = 30;
    [searchBar setShowsCancelButton:noErr animated:YES];
    [UIView animateWithDuration:0.4 animations:^{
        [self.view layoutIfNeeded];
    }completion:nil];
    [searchBar resignFirstResponder];
    
    
    NSUserDefaults *userDefault= [NSUserDefaults standardUserDefaults];
    
    if ([userDefault objectForKey:kSearchString]) {
        
        recentSearches = [[userDefault objectForKey:kSearchString] mutableCopy];
        
    }
    
    if (![recentSearches containsObject:searchBar.text]) {
        
        [recentSearches addObject:searchBar.text];
        
        [userDefault setObject:recentSearches forKey:kSearchString];
        
        [userDefault synchronize];
    }
    
//    [nearByDetails removeAllObjects];
    
//    nearByDetails[0] = @{@"image" : [UIImage imageNamed:@"mylocation_blue.png"] , @"text" : @"Send Your Location", @"subtitle" : @"Accurate to 10m"};
//    
//    heightMapviewConstraint.constant =kMapViewHeightConstraint;
//    
//    nearByDetails[1] = @{@"image" : [UIImage imageNamed:@"expand_blue.png"] , @"text" : @"Hide places", @"subtitle" : @""};

    NSString *searchBarText = searchBar.text;
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = searchBarText;
    request.region = _mapView.region;
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:request];
    [search startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
//        self.matchingItems = response.mapItems;
        
        NSArray *result = response.mapItems;
        
        for (MKMapItem *mapItem in result) {
            
            CLLocationCoordinate2D cordinate =mapItem.placemark.coordinate;
            
//            NSDictionary *addressDict = mapItem.placemark.addressDictionary;
            
//            NearLocation *objLocation =[[NearLocation alloc] initWithImageName:nil title:mapItem.name withLatitude:cordinate.latitude withLongtitude:cordinate.longitude withLocationId:0 withAddress:addressDict[@"Street"]];
            // do something with the icon URL
            
            NearLocation *objLocation =[[NearLocation alloc] initWithImageName:nil title:mapItem.name withLatitude:cordinate.latitude withLongtitude:cordinate.longitude withLocationId:0 withAddress:[self parseAddress:mapItem.placemark]];

            
            [nearByDetails addObject:objLocation];
        }
        
        [self.tblLocationNearby setHidden:NO];
        [self.tblRecentSearch setHidden:YES];
        
        [self.tblLocationNearby reloadData];
        
        
        [CommonFunction removeLoaderFromViewController:self];
        
    }];
    
}

- (NSString *)parseAddress:(MKPlacemark *)selectedItem {
    // put a space between "4" and "Melrose Place"
    NSString *firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? @" " : @"";
    // put a comma between street and city/state
    NSString *comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? @", " : @"";
    // put a space between "Washington" and "DC"
    NSString *secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? @" " : @"";
    NSString *addressLine = [NSString stringWithFormat:@"%@%@%@%@%@%@%@",
                             (selectedItem.subThoroughfare == nil ? @"" : selectedItem.subThoroughfare),
                             firstSpace,
                             (selectedItem.thoroughfare == nil ? @"" : selectedItem.thoroughfare),
                             comma,
                             // city
                             (selectedItem.locality == nil ? @"" : selectedItem.locality),
                             secondSpace,
                             // state
                             (selectedItem.administrativeArea == nil ? @"" : selectedItem.administrativeArea)
                             ];
    return addressLine;
}
  

-(void)selectedLocation:(NearLocation*)location
{
    NSLog(@"Location name =%@",location.title);
    
    UIAlertController *alertController=   [UIAlertController
                                           alertControllerWithTitle:@"Location"
                                           message:[NSString stringWithFormat:@"name =%@ and cordinate=%f",location.title,location.latitude]
                                           preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"OK"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    //Handle your yes please button action here
                                    if (location) {
                                        
                                        [self.delegate locationSelectionPressed:location];

                                    }
                                }];
    
    [alertController addAction:yesButton];
    
    //[[self presentViewController:alertController animated:YES completion:nil];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

/*
 -(void)nearestApiCall
 {
 [CommonFunction showLoaderInViewController:self];
 
 dispatch_queue_t img_queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
 dispatch_async(img_queue, ^{
 
 //        NSString *strUrl =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true_or_false",kFourSquare];
 
 //        NSString *strUrl =[NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?latlng=%f,%f&sensor=true_or_false",userCurrentLocation.coordinate.latitude,userCurrentLocation.coordinate.longitude];
 
 //        NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=500&type=restaurant&keyword=cruise&key=%@",userCurrentLocation.coordinate.latitude,userCurrentLocation.coordinate.longitude,kGoogleApiKey];
 
 NSString *strUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%f,%f&radius=5000&sensor=true&key=%@",userCurrentLocation.coordinate.latitude,userCurrentLocation.coordinate.longitude,kGoogleServerKey];
 
 NSURL *url = [NSURL URLWithString:strUrl];
 NSError *error = nil;
 NSData *json = [NSData dataWithContentsOfURL:url options:0 error:&error];
 
 if(!error) {
 NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:json
 options:kNilOptions
 error:&error];
 //            NSLog(@"JSON: %@", jsonDict);
 
 if ([jsonDict[@"results"] isKindOfClass:[NSArray class]]) {
 
 NSArray *places =jsonDict[@"results"];
 
 
 if(nearByDetails.count > 2)
 {
 [nearByDetails removeObjectsInRange:NSMakeRange(2, nearByDetails.count-2)];
 
 }
 for (NSDictionary *place in places) {
 
 
 NSString *iconUrl=@"";// = [self getPhotosURL:place[@"photos"]];
 
 //                    if ([place[@"photos"] count]>0) {
 //
 //                        iconUrl = [self getPhotosURL:[place[@"photos"] lastObject]];
 //                    }
 
 NSDictionary *location = [place[@"geometry"] objectForKey:@"location"];
 
 NSString *LocId= place[@"id"];
 
 NSString *name;
 
 if (place[@"name"]) {
 
 name = place[@"name"];
 }
 else{
 name=place[@"vicinity"];
 }
 
 NearLocation *objLocation =[[NearLocation alloc] initWithImageName:iconUrl title:name withLatitude:[location[@"lat"] doubleValue] withLongtitude:[location[@"lng"] doubleValue] withLocationId:LocId withAddress:place[@"vicinity"]];
 // do something with the icon URL
 
 [nearByDetails addObject:objLocation];
 }
 
 dispatch_async(dispatch_get_main_queue(), ^{
 //When json is loaded stop the indicator
 
 [CommonFunction showLoaderInViewController:self];
 
 [self.tblLocationNearby setHidden:NO];
 [self.tblRecentSearch setHidden:YES];
 
 [self.tblLocationNearby reloadData];
 
 });
 
 }
 
 }
 
 });
 
 }
 */
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
