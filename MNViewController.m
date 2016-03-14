//
//  MNViewController.m
//  iOS Google Maps Info Window Customisation
//
//  Created by Naresh Reddy M on 04/03/16.
//  Copyright © 2016 Naresh Reddy M. All rights reserved.
//


#import "MNViewController.h"

#define infoWindowHeight                                80
#define infoWindowWidth                                 280
#define  markerHeight                                   35
#define  markerWidth                                    (markerHeight * 0.54)

#define CLCOORDINATE_EPSILON                            0.005f
#define CLCOORDINATES_EQUAL2( coord1, coord2 )          (fabs(coord1.latitude - coord2.latitude) < CLCOORDINATE_EPSILON && fabs(coord1.longitude - coord2.longitude) < CLCOORDINATE_EPSILON)

@interface MNViewController ()<GMSMapViewDelegate>
@property (strong, nonatomic) GMSMapView *googleMapView;

@property (strong, nonatomic) MNGMSInfoWindow *displayedInfoWindow;
@property (strong, nonatomic) GMSMarker *currentlyTappedMarker;
@end
@implementation MNViewController
-(void)setCurrentlyTappedMarker:(GMSMarker *)currentlyTappedMarker
{
    _currentlyTappedMarker = currentlyTappedMarker;
    if(currentlyTappedMarker == nil)
        [self.displayedInfoWindow removeFromSuperview];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // 1) get shared instance of MNGMSInfoWindow & configure its appearecnce
    self.displayedInfoWindow = [MNGMSInfoWindow sharedInstance];
    [[self.displayedInfoWindow layer] setBorderWidth:1.0];
    [self.displayedInfoWindow setBackgroundColor:[[UIColor yellowColor] colorWithAlphaComponent:0.5]];
    
     // 2) design your content view with your UIContorls and set it as the content view of shared instance of MNGMSInfoWindow.
    [self.displayedInfoWindow setContentView:[self getContentView]];


    // 3) show google map on your selv.view
    self.googleMapView = [GMSMapView mapWithFrame:self.view.frame camera:[GMSCameraPosition cameraWithTarget:CLLocationCoordinate2DMake(17.842222, 84.125545) zoom:7]];
    [self.googleMapView setDelegate:self];
    [self.view addSubview:self.googleMapView];
    
    // 4) Add a couple of markers to show infow window
    GMSMarker *marker1 = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(17.842222, 84.125545)];
    [marker1 setIcon:[self getScaledImage:[GMSMarker markerImageWithColor:[UIColor greenColor]] scaledToSize:CGSizeMake(markerWidth, markerHeight)]];
    [marker1 setMap:self.googleMapView];
    
    GMSMarker *marker2 = [GMSMarker markerWithPosition:CLLocationCoordinate2DMake(17.532222, 84.125545)];
    [marker2 setIcon:[self getScaledImage:[GMSMarker markerImageWithColor:[UIColor redColor]] scaledToSize:CGSizeMake(markerWidth, markerHeight)]];
    [marker2 setMap:self.googleMapView];
}

// Implement GMSMapView's Delegates
- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    if(self.currentlyTappedMarker)
    {
        CGPoint markerPoint = [self.googleMapView.projection pointForCoordinate:self.currentlyTappedMarker.position];
        self.displayedInfoWindow.frame = CGRectMake(markerPoint.x - (infoWindowWidth / 2), markerPoint.y - (markerHeight + infoWindowHeight) , infoWindowWidth, infoWindowHeight);
    }
}
-(BOOL)mapView:(GMSMapView *)mapView didTapMarker:(GMSMarker *)marker
{
    if(self.currentlyTappedMarker == marker)
    {
        self.currentlyTappedMarker = nil;
        // Infow window was hidden
        // DO YOUR WORK .....
        

    
    }
    else
    {
        self.currentlyTappedMarker = marker;
        CLLocationCoordinate2D mapCameraLoc = mapView.camera.target;
        
        // animate google map's camera is targeting to somewhere other than current selected marker only!
        if(CLCOORDINATES_EQUAL2(mapCameraLoc, marker.position) == false)
            [self.googleMapView animateToLocation:marker.position];
            
        // Get Tapped marker's coordinates from google map view
        CGPoint markerPoint = [self.googleMapView.projection pointForCoordinate:self.currentlyTappedMarker.position];
        
        // Caliculate and set frame for the custom infow Window
        [self.displayedInfoWindow setFrame:(CGRect){markerPoint.x - (infoWindowWidth / 2), markerPoint.y - (markerHeight + infoWindowHeight) , infoWindowWidth, infoWindowHeight}];
        [self.view addSubview:self.displayedInfoWindow];
        // Infow window was Shown
        // DO YOUR WORK .....
       
        
        
    }
    return true;
}
-(void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{


    // set frame for Custom infow window if there is any selected marker only.
    if(self.currentlyTappedMarker)
    {
        self.currentlyTappedMarker = nil;
        // Infow window was hidden
        // DO YOUR WORK .....
        
    }
}
#pragma mark Helpers
-(void)buttonActionHandler:(UIButton *)sender
{
    // Custom infow window subview's callbacks .
    if(self.currentlyTappedMarker) self.currentlyTappedMarker = nil;
    // Infow window was hidden
    // DO YOUR WORK .....
    
    [[[UIAlertView alloc] initWithTitle:@"Infow Window Customisation" message:[[sender titleForState:UIControlStateNormal] stringByAppendingString:@" Tapped"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
    NSLog(@"%@ Tapped",[sender titleForState:UIControlStateNormal]);
}
- (UIImage *)getScaledImage:(UIImage*)originalImage scaledToSize:(CGSize)size
{
    // resize your GMSMarker's Icon to your requires CGSize
    if (CGSizeEqualToSize(originalImage.size, size)) return originalImage;
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    [originalImage drawInRect:CGRectMake(0.0f, 0.0f, size.width, size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

-(MNGMSInfoWindowContentView *)getContentView
{
    // Design Your Custom Content View With needed UIControls 
    MNGMSInfoWindowContentView *contentV = [MNGMSInfoWindowContentView new];
    [contentV setFrame:(CGRect){5,5,infoWindowWidth - 10,infoWindowHeight - 10}];
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button1 setFrame:(CGRect){20,0,40,40}];
    [button1 setCenter:(CGPoint){button1.center.x,CGRectGetHeight(contentV.frame) /2}];
    [button1 addTarget:self action:@selector(buttonActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    [[button1 layer] setCornerRadius:20];
    [button1 setTitle:@"Play" forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor greenColor]];
    [contentV addSubview:button1];
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeSystem];
    [button2 setFrame:(CGRect){CGRectGetWidth(contentV.frame) - 60,0,40,40}];
    [button2 setCenter:(CGPoint){button2.center.x,CGRectGetHeight(contentV.frame) /2}];
    [[button2 layer] setCornerRadius:20];
    [button2 setTitle:@"Right" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonActionHandler:) forControlEvents:UIControlEventTouchUpInside];
    [button2 setBackgroundColor:[UIColor greenColor]];
    [contentV addSubview:button2];

    [contentV setBackgroundColor:[UIColor whiteColor]];
    [[contentV layer] setBorderWidth:1.0];
    return contentV;
}
-(void)dealloc
{
    self.currentlyTappedMarker = nil;
    self.displayedInfoWindow = nil;
}
@end
