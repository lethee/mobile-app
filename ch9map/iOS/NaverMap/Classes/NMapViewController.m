//
//  NMapViewController.m
//  MapViewer
//
//  Created by KJ KIM on 08. 10. 21.
//  Copyright 2008 NHN. All rights reserved.
//

#import "NMapViewController.h"

#import "NMapViewResource.h"

#define kMyLocationStr @"Location"
#define kMapModeStr @"Map mode"
#define kClearMapStr @"Clear map"
#define KTestModeStr @"Test"

#define KMapModeStandardStr @"Standard"
#define KMapModeSatelliteStr @"Satellite"
#define KMapModeHybridStr @"Hybrid"
#define KMapModeTrafficStr @"Traffic"
#define KMapModeBicycleStr @"Bicycle"

#define kMapInvalidCompassValue (-360)


@implementation NMapViewController

- (void) setLogoImageOffset
{
	if (_toolbar && ![_toolbar isHidden]) {
		[_mapView setLogoImageOffsetX:10 offsetY:(10 + _toolbar.frame.size.height)];
	} else {
		[_mapView setLogoImageOffsetX:10 offsetY:10];
	}
}

- (void) setToolbarFrame
{
	CGFloat toolbarHeight = [_toolbar frame].size.height;
	CGRect mainViewBounds = self.view.bounds;
	[_toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
								  CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - toolbarHeight,
								  CGRectGetWidth(mainViewBounds),
								  toolbarHeight)];			

	[self setLogoImageOffset];
}
- (void) addBottomBar
{
	UIToolbar *toolbar = [UIToolbar new];
	toolbar.barStyle = UIBarStyleBlackOpaque;
	
//	UIBarButtonItem *flexItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
//																			   target:nil
//																			   action:nil] autorelease];
	UIBarButtonItem *locItem = [[[UIBarButtonItem alloc] initWithTitle:kMyLocationStr
																 style:UIBarButtonItemStyleBordered
																target:self
																action:@selector(findMyLocation:)] autorelease];
	UIBarButtonItem *mapModeItem = [[[UIBarButtonItem alloc] initWithTitle:kMapModeStr
																	 style:UIBarButtonItemStyleBordered
																	target:self
																	action:@selector(mapModeAction:)] autorelease];
	UIBarButtonItem *clearMapItem = [[[UIBarButtonItem alloc] initWithTitle:kClearMapStr
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(clearMap:)] autorelease];	
	UIBarButtonItem *testModeItem = [[[UIBarButtonItem alloc] initWithTitle:KTestModeStr
																	  style:UIBarButtonItemStyleBordered
																	 target:self
																	 action:@selector(testModeAction:)] autorelease];	
	NSArray *items = [NSArray arrayWithObjects: 
					  locItem,
					  mapModeItem,
					  clearMapItem,
					  testModeItem,
					  nil];
	toolbar.items = items;
	
	// size up the toolbar and set its frame
	[toolbar sizeToFit];
	_toolbar = toolbar;	
	[self setToolbarFrame];
	
	[toolbar.layer setOpacity:0.9];
	
	[self.view addSubview:toolbar];	
}

- (void) setMapViewVisibleBounds
{
	CGRect frameOfParentView = [[_mapView superview] frame];
	frameOfParentView.origin = CGPointZero;
	
	CGRect boundsVisible = frameOfParentView;

	if (![_toolbar isHidden]) {
		boundsVisible.size.height -= _toolbar.frame.size.height;
	}	
	
	[_mapView setBoundsVisible:boundsVisible];	
}

- (void) setCompassHeadingValue:(double)headingValue	{	
	
	if ([_mapView isAutoRotateEnabled]) {		
		
		if (headingValue <= kMapInvalidCompassValue) {
			// stop rotating map view 
			[_mapView setAutoRotateEnabled:NO];			
		} else {					
			// set rotate angle of map view
			[_mapView setRotateAngle:headingValue];	
		}				
	}
}

- (void) stopLocationUpdating {
	NMapLocationManager *lm = [NMapLocationManager getSharedInstance];
	if ([lm isUpdateLocationStarted]) {		
		// stop updating location
		[lm stopUpdateLocationInfo];
		[lm setDelegate:nil];		
	}
	if ([lm isHeadingUpdateStarted]){
		// stop updating heading
		[lm stopUpdatingHeading];
	}			
	
	if ([_mapView isAutoRotateEnabled]) {
		// stop rotating map view 
		[self setCompassHeadingValue:kMapInvalidCompassValue];
	}			
}

- (void)findMyLocation:(id)sender
{	
	NMapLocationManager *lm = [NMapLocationManager getSharedInstance];
	BOOL isAvailableCompass = [lm headingAvailable];
    
    if ([lm locationServiceEnabled] == NO) {
        [self locationManager:lm didFailWithError:NMapLocationManagerErrorTypeDenied];
        return;
    }
	
	if ([lm isUpdateLocationStarted]){
		if (isAvailableCompass && [lm isTrackingEnabled]) {
			if ([_mapView isAutoRotateEnabled]) {
				// stop updating location
				[self stopLocationUpdating];
			} else {
				[_mapView setAutoRotateEnabled:YES];
				
				// start updating heading
				[lm startUpdatingHeading];												
			}
		} else {
			// stop updating location
			[self stopLocationUpdating];
		}		
	}
	else {
		// set delegate
		[lm setDelegate:self];
		
		// start updating location
		[lm startContinuousLocationInfo];
	}
}

- (void)clearOverlays {	
	NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];
	[mapOverlayManager clearOverlays];
	
	[_mapPOIdataOverlay release];
	_mapPOIdataOverlay = nil;
}

- (void)testPOIdata {
	[self clearOverlays];
	
	NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];
	
	// create POI data overlay
	NMapPOIdataOverlay *poiDataOverlay = [mapOverlayManager createPOIdataOverlay];
	
	[poiDataOverlay initPOIdata:3];	
	
	[poiDataOverlay addPOIitemAtLocation:NGeoPointMake(126.979, 37.567) title:@"POI item 1" type:NMapPOIflagTypePin iconIndex:0 withObject:nil];
	[poiDataOverlay addPOIitemAtLocation:NGeoPointMake(126.974, 37.566) title:@"POI item 2" type:NMapPOIflagTypeFrom iconIndex:0 withObject:nil];
	[poiDataOverlay addPOIitemAtLocation:NGeoPointMake(126.984, 37.565) title:@"POI item 3" type:NMapPOIflagTypeTo iconIndex:0 withObject:nil];
	[poiDataOverlay endPOIdata];
	
	// show all POI data
	[poiDataOverlay showAllPOIdata];
	
	[poiDataOverlay release];	
}

- (void)testPathData {
	[self clearOverlays];
	
	NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];	
	
	// create path POI data overlay
	NMapPOIdataOverlay *pathPOIdataOverlay = [mapOverlayManager createPOIdataOverlay];
	
	if (pathPOIdataOverlay) {		
		[pathPOIdataOverlay initPOIdata:4];
		
		[pathPOIdataOverlay addPOIitemAtLocationInUtmk:NPointMake(349652983, 149297368) title:@"From" type:NMapPOIflagTypeFrom iconIndex:0 withObject:nil];
		[pathPOIdataOverlay addPOIitemAtLocationInUtmk:NPointMake(349652966, 149296906) title:nil type:NMapPOIflagTypeNumber iconIndex:0 withObject:nil];
		[pathPOIdataOverlay addPOIitemAtLocationInUtmk:NPointMake(349651062, 149296913) title:nil type:NMapPOIflagTypeNumber iconIndex:1 withObject:nil];
		[pathPOIdataOverlay addPOIitemAtLocationInUtmk:NPointMake(349651376, 149297750) title:@"To" type:NMapPOIflagTypeTo iconIndex:0 withObject:nil];
		
		[pathPOIdataOverlay endPOIdata];
		
		[pathPOIdataOverlay release];
	}
	
	// set path data points
	NMapPathData *pathData = [[NMapPathData alloc] initWithCapacity:9];
	[pathData initPathData:9];		
	[pathData addPathPointLongitude:127.108099 latitude:37.366034 lineType:NMapPathLineTypeSolid];
	[pathData addPathPointLongitude:127.108088 latitude:37.366043 lineType:0];
	[pathData addPathPointLongitude:127.108079 latitude:37.365619 lineType:0];
	[pathData addPathPointLongitude:127.107458 latitude:37.365608 lineType:0];
	[pathData addPathPointLongitude:127.107232 latitude:37.365608 lineType:0];
	[pathData addPathPointLongitude:127.106904 latitude:37.365624 lineType:0];
	[pathData addPathPointLongitude:127.105933 latitude:37.365621 lineType:NMapPathLineTypeDash];
	[pathData addPathPointLongitude:127.105929 latitude:37.366378 lineType:0];
	[pathData addPathPointLongitude:127.106279 latitude:37.366380 lineType:0];
	[pathData endPathData];
	
	// create path data overlay
	NMapPathDataOverlay *pathDataOverlay = [mapOverlayManager createPathDataOverlay:pathData];
	if (pathDataOverlay) {
		// show all path data
		[pathDataOverlay showAllPathData];
		
		[pathDataOverlay release];
	}
	[pathData release];	
}

- (void)testFloatingData {	
	[self clearOverlays];

	NMapOverlayManager *mapOverlayManager = [_mapView mapOverlayManager];
	
	// create POI data overlay
	NMapPOIdataOverlay *poiDataOverlay = [mapOverlayManager createPOIdataOverlay];
	
	// set POI data
	[poiDataOverlay initPOIdata:1];	
	
	NMapPOIitem *poiItem = [poiDataOverlay addPOIitemAtLocation:NGeoPointMake(126.984, 37.565) title:@"Touch & Drag to Move" type:NMapPOIflagTypeTo iconIndex:0 withObject:nil];
	
	// set floating mode
	[poiItem setPOIflagMode:NMapPOIflagModeTouch];
	
	// hide right button on callout
	[poiItem setHasRightCalloutAccessory:NO];
	
	[poiDataOverlay endPOIdata];
	
	// select item
	[poiDataOverlay selectPOIitemAtIndex:0 moveToCenter:YES];
		
	_mapPOIdataOverlay = [poiDataOverlay retain];
	
	[poiDataOverlay release];		
}

- (void)testAutoRotate {
	
	if ([_mapView isAutoRotateEnabled]) {
		[_mapView setAutoRotateEnabled:NO];
	} else {
		[_mapView setAutoRotateEnabled:YES];
		
		[self setCompassHeadingValue:-45.0];		
	}
	
	[self setMapViewVisibleBounds];
}

- (void)clearMap:(id)sender {
	
	[_mapView setMapViewMode:NMapViewModeVector];
	[_mapView setMapViewTrafficMode:NO];
	[_mapView setMapViewBicycleMode:NO];
	
	// clear overlays
	[self stopLocationUpdating];
	if ([[_mapView mapOverlayManager] hasMyLocationOverlay]) {	
		[[_mapView mapOverlayManager] clearMyLocationOverlay];										
	}
	
	[self clearOverlays];
}

- (void)mapModeAction:(id)sender
{	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:kMapModeStr delegate:self 
													cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	[actionSheet addButtonWithTitle:KMapModeStandardStr];
	[actionSheet addButtonWithTitle:KMapModeSatelliteStr];
	[actionSheet addButtonWithTitle:KMapModeHybridStr];
	if ([_mapView mapViewTrafficMode]) {
		[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ Off", KMapModeTrafficStr]];
	} else {
		[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ On", KMapModeTrafficStr]];
	}	
	if ([_mapView mapViewBicycleMode]) {
		[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ Off", KMapModeBicycleStr]];
	} else {
		[actionSheet addButtonWithTitle:[NSString stringWithFormat:@"%@ On", KMapModeBicycleStr]];
	}	
	
	[actionSheet showInView:self.view]; 
	[actionSheet release];
}
- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
	//NSLog(@"actionSheet:%@ clickedButtonAtIndex: %d", [actionSheet title], buttonIndex);
	
	if ([[actionSheet title] isEqualToString:kMapModeStr]) {
		switch (buttonIndex) {
			case 1:
				[_mapView setMapViewMode:NMapViewModeVector];
				break;
			case 2:
				[_mapView setMapViewMode:NMapViewModeSatellite];
				break;
			case 3:
				[_mapView setMapViewMode:NMapViewModeHybrid];
				break;
			case 4:
				[_mapView setMapViewTrafficMode:(![_mapView mapViewTrafficMode])];
				break;	
			case 5:
				[_mapView setMapViewBicycleMode:(![_mapView mapViewBicycleMode])];
				break;				
		}	
	}
	
	if ([[actionSheet title] isEqualToString:KTestModeStr]) {
		switch (buttonIndex) {
			case 1:
				[self testPOIdata];
				break;
			case 2:
				[self testPathData];
				break;		
			case 3:
				[self testFloatingData];
				break;	
			case 4:
				[self testAutoRotate];
				break;		
		}
	}
}

- (void)testModeAction:(id)sender
{
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:KTestModeStr delegate:self 
													cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:nil];
	
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	[actionSheet addButtonWithTitle:@"Test POI data"];
	[actionSheet addButtonWithTitle:@"Test Path data"];
	[actionSheet addButtonWithTitle:@"Test Floating data"];
	[actionSheet addButtonWithTitle:@"Test Auto Rotate"];
	
	[actionSheet showInView:self.view]; 
	[actionSheet release];
}

- (void)loadView {
	CGRect frame = [[UIScreen mainScreen] bounds];	
	frame.origin.y += 20;
	frame.size.height -= 20;
	
	// add the top-most parent view
	UIView *contentView = [[UIView alloc] initWithFrame:frame];
	[contentView setAutoresizingMask: (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight)];
    [contentView setAutoresizesSubviews: YES];
	self.view = contentView;
	[contentView release];	
	
	frame.origin.y = 0;
	
	// create map view
	_mapView = [[NMapView alloc] initWithFrame:frame];
	
	// set delegate to use reverse geocoder API
	[_mapView setReverseGeocoderDelegate:self];
	
	// set delegate for map view
	[_mapView setDelegate:self];	
	
	// set API key for Open MapViewer Library
	[_mapView setApiKey:kApiKey];		
	
	[self.view addSubview:_mapView];			
	[self addBottomBar];	
	
	[self setMapViewVisibleBounds];
}

- (void)didReceiveMemoryWarning {
	NSLog(@"NMapViewController:didReceiveMemoryWarning ...");
	
	// release cached data in the map view
	[_mapView didReceiveMemoryWarning];
	
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview	
}

- (void)viewWillAppear:(BOOL)animated {
	[_mapView viewWillAppear];
}
- (void)viewDidAppear:(BOOL)animated {
	[_mapView viewDidAppear];
}
- (void)viewWillDisappear:(BOOL)animated {
	[_mapView viewWillDisappear];
}
- (void)viewDidDisappear:(BOOL)animated {
	[_mapView viewDidDisappear];
}


- (void)dealloc {
	
	[_mapPOIdataOverlay release];
	
	[_mapView release];
	
	[_toolbar release];
	
    [super dealloc];
}

- (void) applicationWillSuspend {
	NSLog(@"applicationWillSuspend");
}

- (void) applicationWillTerminate {
	NSLog(@"applicationWillTerminate");
}


#pragma mark NMapViewDelegate Method

- (void) onMapView:(NMapView *)mapView initHandler:(NMapError *)error {	
	
	if (error == nil) { // success
		// set map center and level
		[_mapView setMapCenter:NGeoPointMake(126.978371, 37.5666091) atLevel:11];
		
	} else { // fail	
		NSLog(@"onMapView:initHandler: %@", [error description]);
		
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NMapViewer" message:[error description]
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];		
	}
}

- (void) onMapView:(NMapView *)mapView networkActivityIndicatorVisible:(BOOL)visible {
	NSLog(@"onMapView:networkActivityIndicatorVisible: %d", visible);
	
	[UIApplication sharedApplication].networkActivityIndicatorVisible = visible;
}

- (void) onMapView:(NMapView *)mapView didChangeMapLevel:(int)level {
	NSLog(@"onMapView:didChangeMapLevel: %d", level);
}

- (void) onMapView:(NMapView *)mapView didChangeViewStatus:(NMapViewStatus)status {
	NSLog(@"onMapView:didChangeViewStatus: %d", status);
}

- (void) onMapView:(NMapView *)mapView didChangeMapCenter:(NGeoPoint)location {	
	NSLog(@"onMapView:didChangeMapCenter: (%f, %f)", location.longitude, location.latitude);
}

- (void) onMapView:(NMapView *)mapView touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	
}
- (void) onMapView:(NMapView *)mapView touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
}
- (void) onMapView:(NMapView *)mapView touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSSet *allTouches = [event allTouches];
	if ([allTouches count] == 1) {
		UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
		if (touch.tapCount == 1) {
			[_toolbar setHidden:![_toolbar isHidden]];
			
			[self setLogoImageOffset];
			
			[self setMapViewVisibleBounds];
		}
	}
}

- (BOOL) onMapViewIsGPSTracking:(NMapView *)mapView {
	return [[NMapLocationManager getSharedInstance] isTrackingEnabled];
}

#pragma mark NMapPOIdataOverlayDelegate

- (UIImage *) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageWithType:(int)poiFlagType iconIndex:(int)index selectedImage:(UIImage **)selectedImage {
	return [NMapViewResource imageWithType:poiFlagType iconIndex:index selectedImage:selectedImage];
}

- (CGPoint) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay anchorPointWithType:(NMapPOIflagType)poiFlagType {
	return [NMapViewResource anchorPointWithType:poiFlagType];
}

- (UIImage*) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay imageForCalloutOverlayItem:(NMapPOIitem *)poiItem 
		   constraintSize:(CGSize)constraintSize selected:(BOOL)selected 
		  imageForCalloutRightAccessory:(UIImage *)imageForCalloutRightAccessory
						calloutPosition:(CGPoint *)calloutPosition calloutHitRect:(CGRect *)calloutHitRect {
		
	// handle overlapped items
	if (!selected) {
		// check if it is selected by touch event
		if (!poiDataOverlay.focusedBySelectItem) {
			int countOfOverlappedItems = 1;
			
			NSArray *poiData = [poiDataOverlay poiData];
			
			for (NMapPOIitem *item in poiData) {
				// skip selected item
				if (item == poiItem) {
					continue;
				}
				
				// check if overlapped or not
				if (CGRectIntersectsRect([item frame], [poiItem frame])) {
					countOfOverlappedItems++;
				}
			}
			
			if (countOfOverlappedItems > 1) {
				// handle overlapped items
				NSString *strText = [NSString stringWithFormat:@"%d overlapped items for %@", countOfOverlappedItems, poiItem.title];
				
				UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NMapViewer" message:strText
															   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
				[alert show];	
				[alert release];	
				
				// do not show callout overlay
				return nil;
			}			
		}		
	}
	
	return [NMapViewResource imageForCalloutOverlayItem:poiItem constraintSize:constraintSize selected:selected
						  imageForCalloutRightAccessory:imageForCalloutRightAccessory
										calloutPosition:calloutPosition calloutHitRect:calloutHitRect];
}

- (CGPoint) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay calloutOffsetWithType:(NMapPOIflagType)poiFlagType {
	return [NMapViewResource calloutOffsetWithType:poiFlagType];
}

- (BOOL) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didChangeSelectedPOIitemAtIndex:(int)index withObject:(id)object {
	NSLog(@"onMapOverlay:didChangeSelectedPOIitemAtIndex: %d", index);
	
	return YES;
}

- (BOOL) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didDeselectPOIitemAtIndex:(int)index withObject:(id)object {
	NSLog(@"onMapOverlay:didDeselectPOIitemAtIndex: %d", index);
	
	return YES;
}

- (BOOL) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didSelectCalloutOfPOIitemAtIndex:(int)index withObject:(id)object {
	NSLog(@"onMapOverlay:didSelectCalloutOfPOIitemAtIndex: %d", index);
	
	NMapPOIitem *poiItem = [[poiDataOverlay poiData] objectAtIndex:index];
	
	if (poiItem.title) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NMapViewer" message:poiItem.title
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];			
	}
	
	return YES;
}

- (void) onMapOverlay:(NMapPOIdataOverlay *)poiDataOverlay didChangePOIitemLocationTo:(NGeoPoint)location withType:(NMapPOIflagType)poiFlagType {
	NSLog(@"onMapOverlay:didChangePOIitemLocationTo: (%f, %f)", location.longitude, location.latitude);
	
	[_mapView findPlacemarkAtLocation:location];
}

#pragma mark MMapReverseGeocoderDelegate

- (void) location:(NGeoPoint)location didFindPlacemark:(NMapPlacemark *)placemark
{
	NSLog(@"location:(%f, %f) didFindPlacemark: %@", location.longitude, location.latitude, [placemark address]);		
	
	if (_mapPOIdataOverlay) {
		NMapPOIitem *poiItem = [[_mapPOIdataOverlay poiData] objectAtIndex:0];
		
		if (NGeoPointIsEquals([poiItem location], location)) {
			[poiItem setTitle:[placemark address]];
			
			[_mapPOIdataOverlay selectPOIitemAtIndex:0 moveToCenter:NO];			
		}		
	}
}
- (void) location:(NGeoPoint)location didFailWithError:(NMapError *)error
{
	NSLog(@"location:(%f, %f) didFailWithError: %@", location.longitude, location.latitude, [error description]);
}

#pragma mark NMapLocationManagerDelegate

- (void)locationManager:(NMapLocationManager *)locationManager didUpdateToLocation:(CLLocation *)location {
	
	CLLocationCoordinate2D coordinate = [location coordinate];
	
	NGeoPoint myLocation;
	myLocation.longitude = coordinate.longitude;
	myLocation.latitude = coordinate.latitude;
	float locationAccuracy = [location horizontalAccuracy];
	
	[[_mapView mapOverlayManager] setMyLocation:myLocation locationAccuracy:locationAccuracy];
	
	[_mapView setMapCenter:myLocation];
}

- (void)locationManager:(NMapLocationManager *)locationManager didFailWithError:(NMapLocationManagerErrorType)errorType {
	NSString *message = nil;
	
	switch (errorType) {
		case NMapLocationManagerErrorTypeUnknown:
		case NMapLocationManagerErrorTypeCanceled:
		case NMapLocationManagerErrorTypeTimeout:
			message = @"일시적으로 내위치를 확인할 수 없습니다.";
			break;	
		case NMapLocationManagerErrorTypeDenied:
			if ( [[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0f )
				message = @"위치 정보를 확인할 수 없습니다.\n사용자의 위치 정보를 확인하도록 허용하시려면 위치서비스를 켜십시오.";
			else
				message = @"위치 정보를 확인할 수 없습니다.";			
			break;
		case NMapLocationManagerErrorTypeUnavailableArea:
			message = @"현재 위치는 지도내에 표시할 수 없습니다.";			
			break;			
		case NMapLocationManagerErrorTypeHeading:
			[self setCompassHeadingValue:kMapInvalidCompassValue];	
			break;
		default:
			break;
	}
	
	if (message) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"NMapViewer" message:message
													   delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
		[alert show];	
		[alert release];			
	}
	
	if ([_mapView isAutoRotateEnabled]) {
		[self setCompassHeadingValue:kMapInvalidCompassValue];
	}
	
	[[_mapView mapOverlayManager] clearMyLocationOverlay];
}

- (void)locationManager:(NMapLocationManager *)locationManager didUpdateHeading:(CLHeading *)heading {

	double headingValue = [heading trueHeading] < 0.0 ? [heading magneticHeading] : [heading trueHeading];
	[self setCompassHeadingValue:headingValue];	
}

@end
