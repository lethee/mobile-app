//
//  DaumMapSampleViewController.m
//  DaumMapLibrarySample
//
//  Created by Byung-Wan Lim on 2/15/12.
//  Copyright (c) 2012 Daum Communications. All rights reserved.
//

#import "DaumMapSampleViewController.h"
#import <DaumMap/MTMapPolyLine.h>
#import "MapPOIDetailViewController.h"

#define LOCATION_TRACK_ACTION_SHEET_TITLE @"Location Tracking"
#define MAP_TYPE_ACTION_SHEET_TITLE @"Map Type"
#define MAP_MOVE_ACTION_SHEET_TITLE @"Map Move"
#define MAP_OVERLAY_ACTION_SHEET_TITLE @"Overlay"

@implementation DaumMapSampleViewController

@synthesize poiItem = _poiItem;
@synthesize reverseGeoCoder = _reverseGeoCoder;

- (void)didReceiveMemoryWarning {
  [super didReceiveMemoryWarning];
  // Release any cached data, images, etc that aren't in use.
	
	[_mapView didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)attachToolbar {
	
	[_toolbar release];
	_toolbar = [[UIToolbar alloc] init];
	_toolbar.barStyle = UIBarStyleBlack;
	
	UIBarButtonItem* userLocationItem = [[[UIBarButtonItem alloc] initWithTitle:@"Loc."
                                                                        style:UIBarButtonItemStyleBordered
                                                                       target:self
                                                                       action:@selector(onUserLocationItemSelected:)] autorelease];
	UIBarButtonItem* mapTypeItem = [[[UIBarButtonItem alloc] initWithTitle:@"Map"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(mapTypeItemSelected:)] autorelease];
	UIBarButtonItem* mapMoveItem = [[[UIBarButtonItem alloc] initWithTitle:@"Move"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(mapMoveItemSelected:)] autorelease];
	UIBarButtonItem* mapOverlayItem = [[[UIBarButtonItem alloc] initWithTitle:@"Overlay"
                                                                      style:UIBarButtonItemStyleBordered
                                                                     target:self
                                                                     action:@selector(mapOverlayItemSelected:)] autorelease];
	
	NSArray *items = [NSArray arrayWithObjects:
                    userLocationItem,
                    mapTypeItem,
                    mapMoveItem,
                    mapOverlayItem,
                    nil];
	_toolbar.items = items;
	
	BOOL isIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
	if (isIPad) {
		_toolbar.frame = CGRectMake(0, 0, 768, 44);
	} else {
		_toolbar.frame = CGRectMake(0, 0, 320, 44);
	}
	
	[self.view addSubview:_toolbar];
}

- (void)_onCloseTouched {
	
	if (_mapView != nil) {
		[_mapView release];
		_mapView = nil;
	}
	
	[self dismissModalViewControllerAnimated:YES];
}

- (void)attachCloseButton {
	UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	closeButton.frame = CGRectMake(10, 0 + 44 + 10, 60, 30);
	[closeButton setTitle:@"Close" forState:UIControlStateNormal];
	[closeButton addTarget:self action:@selector(_onCloseTouched) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:closeButton];
}

- (void)viewDidLoad {
  [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
	CGSize screenSize = [[UIScreen mainScreen] bounds].size;
	CGFloat screenWidth = screenSize.width; // 320(iPhone) 768(iPad)
	CGFloat screenHeight = screenSize.height; // 480(iPhone) 1024(iPad) 568(iPhone5)
	CGRect mapViewFrame = CGRectMake(0, 0 + 44, screenWidth, screenHeight - 44 - 20);
  
	[MTMapView setMapTilePersistentCacheEnabled:YES];
	
	_mapView = [[MTMapView alloc] initWithFrame:mapViewFrame];
	[_mapView setDaumMapApiKey:@"c95ec8893b088369813bd53b0910818930b4dc90"];
	_mapView.delegate = self;
	_mapView.baseMapType = MTMapTypeStandard; //MTMapTypeHybrid;
	[self.view addSubview:_mapView];
	
	[self attachToolbar];
	[self attachCloseButton];
}

- (void)viewDidUnload {
  [super viewDidUnload];
  // Release any retained subviews of the main view.
  // e.g. self.myOutlet = nil;
	
	[_mapView release];
	_mapView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return (interfaceOrientation == UIDeviceOrientationPortrait);
	
  // Return YES for supported orientations
	//	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
	//	    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
	//	} else {
	//	    return YES;
	//	}
}

#pragma mark Actions

- (void)onUserLocationItemSelected:(id)sender {
	
	BOOL isIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:LOCATION_TRACK_ACTION_SHEET_TITLE
                                                           delegate:self
                                                  cancelButtonTitle:isIPad? nil : @"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	[actionSheet addButtonWithTitle:@"User Location On"];
	[actionSheet addButtonWithTitle:@"User Location+Heading On"];
	[actionSheet addButtonWithTitle:@"Off"];
	[actionSheet addButtonWithTitle:@"Show Location Marker"];
	[actionSheet addButtonWithTitle:@"Hide Location Marker"];
	[actionSheet addButtonWithTitle:@"Reverse Geo Coding"];
	
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)mapTypeItemSelected:(id)sender {
	
	BOOL isIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:MAP_TYPE_ACTION_SHEET_TITLE
                                                           delegate:self
                                                  cancelButtonTitle:isIPad? nil : @"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	[actionSheet addButtonWithTitle:@"Standard"];
	[actionSheet addButtonWithTitle:@"Satellite"];
	[actionSheet addButtonWithTitle:@"Hybrid"];
	
	if (_mapView.useHDMapTile) {
		[actionSheet addButtonWithTitle:@"HD Map Tile Off"];
	} else {
		[actionSheet addButtonWithTitle:@"HD Map Tile On"];
	}
	
	if ([MTMapView isMapTilePersistentCacheEnabled]) {
		[actionSheet addButtonWithTitle:@"Clear Map Tile Cache"];
	}
	
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)mapMoveItemSelected:(id)sender {
	
	BOOL isIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:MAP_MOVE_ACTION_SHEET_TITLE
                                                           delegate:self
                                                  cancelButtonTitle:isIPad? nil : @"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	[actionSheet addButtonWithTitle:@"Move to"];
	[actionSheet addButtonWithTitle:@"Zoom to"];
	[actionSheet addButtonWithTitle:@"Move and Zoom to"];
	[actionSheet addButtonWithTitle:@"Zoom In"];
	[actionSheet addButtonWithTitle:@"Zoom Out"];
	
	if (_mapView.mapRotationAngle == 0.0f) {
		[actionSheet addButtonWithTitle:@"Rotate Map 60"];
	} else {
		[actionSheet addButtonWithTitle:@"Unrotate Map"];
	}
	
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)mapOverlayItemSelected:(id)sender {
	
	BOOL isIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
	
	UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:MAP_OVERLAY_ACTION_SHEET_TITLE
                                                           delegate:self
                                                  cancelButtonTitle:isIPad? nil : @"Cancel"
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:nil];
	actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
	
	[actionSheet addButtonWithTitle:@"Add POI Items"];
	[actionSheet addButtonWithTitle:@"Remove a POI Item"];
	[actionSheet addButtonWithTitle:@"Remove All POI items"];
	[actionSheet addButtonWithTitle:@"Add Polyline1"];
	[actionSheet addButtonWithTitle:@"Add Polyline2"];
	[actionSheet addButtonWithTitle:@"Remove All Polylines"];
	
	[actionSheet showInView:self.view];
	[actionSheet release];
}

- (void)actionSheet:(UIActionSheet*)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
	
	BOOL isIPad = [[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad;
	if (isIPad) {
		buttonIndex += 1; // no cancel button
	}
	
	if ([[actionSheet title] isEqualToString:LOCATION_TRACK_ACTION_SHEET_TITLE]) {
		
		switch (buttonIndex) {
			case 1: // Location On
			{
				_mapView.currentLocationTrackingMode = MTMapCurrentLocationTrackingOnWithoutHeading;
			}
				break;
			case 2: // Location+Heading On
			{
				_mapView.currentLocationTrackingMode = MTMapCurrentLocationTrackingOnWithHeading;
			}
				break;
			case 3: // Off
			{
				_mapView.currentLocationTrackingMode = MTMapCurrentLocationTrackingOff;
			}
				break;
			case 4: // Show Location Marker
			{
				_mapView.showCurrentLocationMarker = YES;
			}
				break;
			case 5: // Hide Location Marker
			{
				_mapView.showCurrentLocationMarker = NO;
			}
				break;
			case 6:
			{
				MTMapReverseGeoCoder* reverseGeoCoder = [[MTMapReverseGeoCoder alloc] initWithMapPoint:_mapView.mapCenterPoint withDelegate:self withOpenAPIKey:@"c95ec8893b088369813bd53b0910818930b4dc90"];
				self.reverseGeoCoder = reverseGeoCoder;
				[reverseGeoCoder startFindingAddress];
				[reverseGeoCoder release];
				
			}
				break;
		}
		
	} else if ([[actionSheet title] isEqualToString:MAP_TYPE_ACTION_SHEET_TITLE]) {
		
		switch (buttonIndex) {
			case 1: // Standard
			{
				_mapView.baseMapType = MTMapTypeStandard;
			}
				break;
			case 2: // Satellite
			{
				_mapView.baseMapType = MTMapTypeSatellite;
			}
				break;
			case 3: // Hybrid
			{
				_mapView.baseMapType = MTMapTypeHybrid;
			}
				break;
			case 4: // HD Map Tile On/Off
			{
				if (_mapView.useHDMapTile == YES) {
					_mapView.useHDMapTile = NO;
				} else {
					_mapView.useHDMapTile = YES;
				}
			}
				break;
			case 5: // Clear Map Tile Cache
			{
				[MTMapView clearMapTilePersistentCache];
			}
				break;
		}
		
	} else if ([[actionSheet title] isEqualToString:MAP_MOVE_ACTION_SHEET_TITLE]) {
		
		switch (buttonIndex) {
			case 1: // Move to
			{
				[_mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.53737528, 127.00557633)] animated:YES];
			}
				break;
			case 2: // Zoom to
			{
				[_mapView setZoomLevel:4 animated:YES];
			}
				break;
			case 3: // Move and Zoom to
			{
				[_mapView setMapCenterPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(33.41, 126.52)] zoomLevel:9 animated:YES];
			}
				break;
			case 4: // Zoom In
			{
				[_mapView zoomInAnimated:YES];
			}
				break;
			case 5: // Zoom Out
			{
				[_mapView zoomOutAnimated:YES];
			}
				break;
			case 6: //Rotate Map 60, Unrotate Map
			{
				if (_mapView.mapRotationAngle == 0.0f) {
					[_mapView setMapRotationAngle:60.0f animated:YES];
				} else {
					[_mapView setMapRotationAngle:0.0f animated:YES];
				}
			}
				break;
		}
		
	} else if ([[actionSheet title] isEqualToString:MAP_OVERLAY_ACTION_SHEET_TITLE]) {
		
		switch (buttonIndex) {
			case 1: // Add POI Items
			{
				[_mapView removeAllPOIItems];
				
				self.poiItem = [MTMapPOIItem poiItem];
				self.poiItem.itemName = @"City on a Hill";
				self.poiItem.mapPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.541889,127.095388)];
				self.poiItem.markerType = MTMapPOIItemMarkerTypeBluePin;
				self.poiItem.showAnimationType = MTMapPOIItemShowAnimationTypeDropFromHeaven;
				
				MTMapPOIItem* poiItem2 = [MTMapPOIItem poiItem];
				poiItem2.itemName = @"압구정";
				poiItem2.mapPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.527896,127.036245)];
				poiItem2.markerType = MTMapPOIItemMarkerTypeRedPin;
				poiItem2.showAnimationType = MTMapPOIItemShowAnimationTypeNoAnimation; //MTMapPOIItemShowAnimationTypeDropFromHeaven;
				poiItem2.tag = 153;
				
				MTMapPOIItem* poiItem3 = [MTMapPOIItem poiItem];
				poiItem3.itemName = @"다음커뮤니케이션";
				poiItem3.userObject = [NSString stringWithFormat:@"item%d", 3];
				poiItem3.mapPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.537229,127.005515)];
				poiItem3.markerType = MTMapPOIItemMarkerTypeCustomImage;
				poiItem3.showAnimationType = MTMapPOIItemShowAnimationTypeSpringFromGround;
				poiItem3.customImageName = @"custom_poi_marker.png";
        //				poiItem3.customImageAnchorPointOffset = MTMapImageOffsetMake(30,0);
				
				MTMapPOIItem* poiItem4 = [MTMapPOIItem poiItem];
				poiItem4.itemName = @"서울숲";
				poiItem4.mapPoint = [MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.545024,127.03923)];
				poiItem4.markerType = MTMapPOIItemMarkerTypeYellowPin;
				poiItem4.showAnimationType = MTMapPOIItemShowAnimationTypeDropFromHeaven;
				poiItem4.showDisclosureButtonOnCalloutBalloon = NO;
				poiItem4.tag = 276;
				poiItem4.draggable = YES;
				
				[_mapView addPOIItems:[NSArray arrayWithObjects:self.poiItem, poiItem2, poiItem3, poiItem4, nil]];
				
				[_mapView fitMapViewAreaToShowAllPOIItems];
			}
				break;
			case 2: // Remove POI Item1
			{
				MTMapPOIItem* poiItem = [_mapView findPOIItemByTag:276];
				[_mapView removePOIItem:poiItem];
			}
				break;
			case 3: // Remove All POI items
			{
				[_mapView removeAllPOIItems];
			}
				break;
			case 4: // Add Polyline1
			{
				MTMapPolyline* existingPolyline = [_mapView findPolylineByTag:1000];
				if (existingPolyline != nil) {
					[_mapView removePolyline:existingPolyline];
				}
				
				MTMapPolyline* polyline1 = [MTMapPolyline polyLine];
				polyline1.tag = 1000;
				polyline1.polylineColor = [UIColor colorWithRed:1.0f green:0.2f blue:0.0f alpha:0.5f];
				[polyline1 addPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.537229,127.005515)]];
				[polyline1 addPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.545024,127.03923)]];
				[polyline1 addPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.527896,127.036245)]];
				[polyline1 addPoint:[MTMapPoint mapPointWithGeoCoord:MTMapPointGeoMake(37.541889,127.095388)]];
				
				[_mapView addPolyline:polyline1];
				[_mapView fitMapViewAreaToShowPolyline:polyline1];
				
			}
				break;
			case 5: // Add Polyline2
			{
				
				MTMapPOIItem* existingPOIItemStart = [_mapView findPOIItemByTag:10001];
				if (existingPOIItemStart != nil) {
					[_mapView removePOIItem:existingPOIItemStart];
				}
				
				MTMapPOIItem* existingPOIItemEnd = [_mapView findPOIItemByTag:10002];
				if (existingPOIItemEnd != nil) {
					[_mapView removePOIItem:existingPOIItemEnd];
				}
				
				MTMapPolyline* existingPolyline = [_mapView findPolylineByTag:2000];
				if (existingPolyline != nil) {
					[_mapView removePolyline:existingPolyline];
				}
				
				
				MTMapPOIItem* poiItemStart = [MTMapPOIItem poiItem];
				poiItemStart.itemName = @"출발";
				poiItemStart.tag = 10001;
				poiItemStart.mapPoint = [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(475334.0,1101210.0)];
				poiItemStart.markerType = MTMapPOIItemMarkerTypeCustomImage;
				poiItemStart.showAnimationType = MTMapPOIItemShowAnimationTypeSpringFromGround;
				poiItemStart.customImageName = @"custom_poi_marker_start.png";
				poiItemStart.customImageAnchorPointOffset = MTMapImageOffsetMake(42,2);
				
				MTMapPOIItem* poiItemEnd = [MTMapPOIItem poiItem];
				poiItemEnd.itemName = @"도착";
				poiItemEnd.tag = 10002;
				poiItemEnd.mapPoint = [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(485016.0,1118034.0)];
				poiItemEnd.markerType = MTMapPOIItemMarkerTypeCustomImage;
				poiItemEnd.showAnimationType = MTMapPOIItemShowAnimationTypeSpringFromGround;
				poiItemEnd.customImageName = @"custom_poi_marker_end.png";
				poiItemEnd.customImageAnchorPointOffset = MTMapImageOffsetMake(42,2);
				
				[_mapView addPOIItems:[NSArray arrayWithObjects:poiItemStart, poiItemEnd, nil]];
				
				MTMapPolyline* polyline2 = [MTMapPolyline polyLine];
				polyline2.tag = 2000;
				polyline2.polylineColor = [UIColor colorWithRed:0.0f green:0.0f blue:1.0f alpha:0.8f];
				[polyline2 addPoints:[NSArray arrayWithObjects:
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(475334.0,1101210.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(474300.0,1104123.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(473873.0,1105377.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(473302.0,1107097.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(473126.0,1109606.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(473063.0,1110548.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(473435.0,1111020.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(474068.0,1111714.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(475475.0,1112765.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(476938.0,1113532.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(478725.0,1114391.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(479453.0,1114785.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(480145.0,1115145.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(481280.0,1115237.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(481777.0,1115164.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(482322.0,1115923.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(482832.0,1116322.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(483384.0,1116754.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(484401.0,1117547.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(484893.0,1117930.0)],
                              [MTMapPoint mapPointWithWCONG:MTMapPointPlainMake(485016.0,1118034.0)],
                              nil]];
				
				[_mapView addPolyline:polyline2];
				[_mapView fitMapViewAreaToShowPolyline:polyline2];
			}
				break;
			case 6: // Remove All Polylines
			{
				[_mapView removeAllPolylines];
			}
				break;
		}
	}
}

#pragma mark MTMapViewDelegate

// Open API Key authentication
- (void)MTMapView:(MTMapView*)mapView openAPIKeyAuthenticationResultCode:(int)resultCode resultMessage:(NSString*)resultMessage {
	NSLog(@"MTMapView Open API Key Authentication Result : code=%d, message=%@", resultCode, resultMessage);
}


// Map View Event
- (void)MTMapView:(MTMapView*)mapView centerPointMovedTo:(MTMapPoint*)mapCenterPoint {
	MTMapPointGeo mapCenterPointGeo = mapCenterPoint.mapPointGeo;
	NSLog(@"MTMapView centerPointMovedTo (%f,%f)", mapCenterPointGeo.latitude, mapCenterPointGeo.longitude);
}

- (void)MTMapView:(MTMapView*)mapView zoomLevelChangedTo:(MTMapZoomLevel)zoomLevel {
	NSLog(@"MTMapView zoomLevelChangedTo (%d)", zoomLevel);
}

- (void)MTMapView:(MTMapView*)mapView singleTapOnMapPoint:(MTMapPoint*)mapPoint {
	MTMapPointGeo mapPointGeo = mapPoint.mapPointGeo;
	NSLog(@"MTMapView singleTapOnMapPoint (%f,%f)", mapPointGeo.latitude, mapPointGeo.longitude);
	//	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DaumMapSample"
	//														message:[NSString stringWithFormat:@"Single-Tap on (%f,%f)", mapPointGeo.latitude, mapPointGeo.longitude]
	//													   delegate:nil
	//											  cancelButtonTitle:@"OK"
	//											  otherButtonTitles:nil];
	//	[alertView show];
	//	[alertView release];
}

- (void)MTMapView:(MTMapView*)mapView doubleTapOnMapPoint:(MTMapPoint*)mapPoint {
	MTMapPointGeo mapPointGeo = mapPoint.mapPointGeo;
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DaumMapSample"
                                                      message:[NSString stringWithFormat:@"Double-Tap on (%f,%f)", mapPointGeo.latitude, mapPointGeo.longitude]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

- (void)MTMapView:(MTMapView*)mapView longPressOnMapPoint:(MTMapPoint*)mapPoint {
	MTMapPointGeo mapPointGeo = mapPoint.mapPointGeo;
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DaumMapSample"
                                                      message:[NSString stringWithFormat:@"Long-Press on (%f,%f)", mapPointGeo.latitude, mapPointGeo.longitude]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

// User Location
- (void)MTMapView:(MTMapView*)mapView updateCurrentLocation:(MTMapPoint*)location withAccuracy:(MTMapLocationAccuracy)accuracy {
	MTMapPointGeo currentLocationPointGeo = location.mapPointGeo;
	NSLog(@"MTMapView updateCurrentLocation (%f,%f) accuracy (%f)", currentLocationPointGeo.latitude, currentLocationPointGeo.longitude, accuracy);
}

- (void)MTMapView:(MTMapView*)mapView updateDeviceHeading:(MTMapRotationAngle)headingAngle {
	NSLog(@"MTMapView updateDeviceHeading (%f) degrees", headingAngle);
}

// MTMapPOIItem
- (BOOL)MTMapView:(MTMapView*)mapView selectedPOIItem:(MTMapPOIItem*)poiItem {
	NSLog(@"MTMapPOIItem(0x%0x) is selected", (int)poiItem);
	
	if (poiItem.tag == 10001 || poiItem.tag == 10002) {
		// donot show callout balloon for "출발" "도착" POI Item
		return NO;
	}
	
	return YES; // YES : show callout balloon
}

- (void)MTMapView:(MTMapView*)mapView touchedCalloutBalloonOfPOIItem:(MTMapPOIItem*)poiItem {
	
	if (poiItem == self.poiItem) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DaumMapSample"
                                                        message:@"Touched the callout-balloon of item1"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	if (poiItem.tag == 153) {
		
		NSLog(@"POIItem2 : %f %f", poiItem.mapPoint.mapPointWCONG.x, poiItem.mapPoint.mapPointWCONG.y);
		NSString* addressForThisItem = [MTMapReverseGeoCoder findAddressForMapPoint:poiItem.mapPoint  withOpenAPIKey:@"c95ec8893b088369813bd53b0910818930b4dc90"];
		
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DaumMapSample"
                                                        message:[NSString stringWithFormat:@"Touched the callout-balloon of item2 (address : %@)", addressForThisItem]
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
	
	if ([poiItem.userObject isKindOfClass:[NSString class]]
      && [(NSString*)poiItem.userObject isEqualToString:@"item3"]) {
		
		MapPOIDetailViewController* poiDetailViewController = [[MapPOIDetailViewController alloc] initWithMapPOIItem:poiItem];
		[self presentModalViewController:poiDetailViewController animated:YES];
		[poiDetailViewController release];
	}
	
	if (poiItem.tag == 276) {
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DaumMapSample"
                                                        message:@"Touched the callout-balloon of item4"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
		[alertView show];
		[alertView release];
	}
}

- (void)MTMapView:(MTMapView*)mapView draggablePOIItem:(MTMapPOIItem*)poiItem movedToNewMapPoint:(MTMapPoint*)newMapPoint {
	MTMapPointGeo newMapPointGeo = newMapPoint.mapPointGeo;
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DaumMapSample"
                                                      message:[NSString stringWithFormat:@"Draggable MTMapPOIItem(%@) has moved to new point (%f,%f)", poiItem.itemName, newMapPointGeo.latitude, newMapPointGeo.longitude]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
	[alertView show];
	[alertView release];
}

#pragma -


#pragma mark MTMapReverseGeoCoderDelegate

- (void)MTMapReverseGeoCoder:(MTMapReverseGeoCoder*)rGeoCoder foundAddress:(NSString*)addressString {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DaumMapSample"
                                                      message:[NSString stringWithFormat:@"Center Point Address = [%@]", addressString]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	self.reverseGeoCoder = nil;
}

- (void)MTMapReverseGeoCoder:(MTMapReverseGeoCoder*)rGeoCoder failedToFindAddressWithError:(NSError*)error {
	UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"DaumMapSample"
                                                      message:[NSString stringWithFormat:@"Reverse Geo-Coding Failed with Error : %@", error.localizedDescription]
                                                     delegate:nil
                                            cancelButtonTitle:@"OK"
                                            otherButtonTitles:nil];
	[alertView show];
	[alertView release];
	self.reverseGeoCoder = nil;
}

#pragma -

@end