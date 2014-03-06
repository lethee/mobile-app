//
//  MapPOIDetailViewController.h
//  MobileMap
//
//  Created by Byung-Wan Lim on 2/15/12.
//  Copyright (c) 2012 Daum Communications. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <DaumMap/MTMapPOIItem.h>

@interface MapPOIDetailViewController : UIViewController {
	MTMapPOIItem* _poiItem;
}

- (id)initWithMapPOIItem:(MTMapPOIItem*)poiItem;

@end
