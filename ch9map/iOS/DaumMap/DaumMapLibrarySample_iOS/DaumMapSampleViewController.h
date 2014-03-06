//
//  DaumMapSampleViewController.h
//  DaumMapLibrarySample
//
//  Created by Byung-Wan Lim on 2/15/12.
//  Copyright (c) 2012 Daum Communications. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <DaumMap/MTMapView.h>
#import <DaumMap/MTMapPOIItem.h>
#import <DaumMap/MTMapReverseGeoCoder.h>

@interface DaumMapSampleViewController : UIViewController <UIActionSheetDelegate, MTMapViewDelegate, MTMapReverseGeoCoderDelegate> {
	MTMapView* _mapView;
	UIToolbar* _toolbar;
	MTMapPOIItem* _poiItem;
	MTMapReverseGeoCoder* _reverseGeoCoder;
}

@property (nonatomic, retain) MTMapPOIItem* poiItem;
@property (nonatomic, retain) MTMapReverseGeoCoder* reverseGeoCoder;

@end