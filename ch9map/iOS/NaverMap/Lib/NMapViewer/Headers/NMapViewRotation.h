//
//  NMapViewRotation.h
//  NMapViewerLib
//
//  Created by KJ KIM on 10. 04. 27.
//  Copyright 2010 NHN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NMapView (NMapViewRotation)

@property (nonatomic, getter=isAutoRotateEnabled) BOOL autoRotateEnabled;

@property (nonatomic) CGFloat rotateAngle;

@end
