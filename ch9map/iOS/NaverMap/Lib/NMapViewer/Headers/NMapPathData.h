//
//  NMapPathData.h
//  NaverMap
//
//  Created by KJ KIM on 10. 10. 20..
//  Copyright 2010 NHN. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "NMapPathSegment.h"

@interface NMapPathData : NSObject {

	// path segments with same line type
	NSMutableArray *_pathSegments;
	
	// bounds of path data in UTMK coordinates
	NRect _boundsInUtmk;
	
	// current path segment
	NMapPathSegment *_pathSegment;	
	// path line type for the current path segment
	NMapPathLineType _lineType;
	
	// origin of view frame after zoom level changed.
	NGRect _viewPortOrigin;
	// zoom level at which mViewFrameOrigin was fixed.
	int _zoomLevel;
}

@property (nonatomic, readonly) NGRect viewPortOrigin;

/**
 * 	Bounds of path data in UTMK coordinates.
 * 
 * 	Note: The given bounds is used for adjusting the zoom level to show all path data within NMapView.
 * 
 * 	@param left	minimum value of longitude.
 * 	@param top	maximum value of latitude.
 * 	@param right maximum value of longitude.
 * 	@param bottom minimum value of latitude.	
 */
@property (nonatomic, assign) NRect boundsInUtmk;

- (BOOL) isValidBounds;

- (id)initWithCapacity:(int)capacity;

/**
 * 	returns count of path segments
 */
- (int) countOfPathSegments;

- (NMapPathSegment *) pathSegmentAtIndex:(int)index;

/**
 * 	Initialize path data.
 * 
 *  @param count total number of path points.	 
 */
- (void) initPathData:(int)count;

/**
 * 	Add a path point in UTMK coordinates.
 * 
 * 	@param utmkX x coordinates of a path point.
 *  @param utmkX y coordinates of a path point.
 * 	@param lineType path line type to the next point, useful for transit traffic route.
 * 			This could be 0 for intermediate or end of path points.
 * 	@param isControlPoint set true to show this point regardless of zoom levels. default value is false.
 * 				Some path points could be hidden to optimize rendering performance if this value was set to false.
 * 
 * 	@see NMapPathLineType
 */
- (void) addPathPointUtmkX:(int)utmkX utmkY:(int)utmkY lineType:(NMapPathLineType)lineType controlPoint:(BOOL)controlPoint;

/**
 * 	Add a path point in UTMK coordinates.
 * 
 * 	@param utmkX x coordinates of a path point.
 *  @param utmkX y coordinates of a path point.
 * 	@param lineType path line type to the next point, useful for transit traffic route.
 * 			This could be 0 for intermediate or end of path points.
 * 
 * 	@see NMapPathLineType
 */
- (void) addPathPointUtmkX:(int)utmkX utmkY:(int)utmkY lineType:(NMapPathLineType)lineType;

/**
 * 	Add a path point in GRS coordinates.
 * 
 * 	@param longitude x coordinates of a path point.
 *  @param latitude y coordinates of a path point.
 * 	@param lineType path line type to the next point, useful for transit traffic route.
 * 			This could be 0 for intermediate or end of path points.
 * 	@param isControlPoint set true to show this point regardless of zoom levels. default value is false.
 * 				Some path points could be hidden to optimize rendering performance if this value was set to false.
 * 
 * 	@see NMapPathLineType
 */
- (void) addPathPointLongitude:(double)longitude latitude:(double)latitude lineType:(NMapPathLineType)lineType controlPoint:(BOOL)controlPoint;

/**
 * 	Add a path point in GRS coordinates.
 * 
 * 	@param longitude x coordinates of a path point.
 *  @param latitude y coordinates of a path point.
 * 	@param lineType path line type to the next point, useful for transit traffic route.
 * 			This could be 0 for intermediate or end of path points.
 * 
 * 	@see NMapPathLineStyle
 */
- (void) addPathPointLongitude:(double)longitude latitude:(double)latitude lineType:(NMapPathLineType)lineType;

/**
 * 	End of path data.
 * 
 * 	Note: The bounds of path data is computed during addPathPoint().
 * 
 */
- (void) endPathData;
- (void) endPathDataWithBounds:(NRect)boundsInUtmk;

/**
 * 	Get bounds offset of the path data with respect to the bounds after zoom levels changed.
 * 
 * 	Note: This is used to not evaluate screen pixel coordinates for every rendering of path data without changing zoom levels. 
 * 
 * 	@return bounds offset in screen coordinates.
 * 	 
 */
- (CGPoint) boundsOffset:(NMapView *)mapView;

- (void) layoutChanged;

@end
