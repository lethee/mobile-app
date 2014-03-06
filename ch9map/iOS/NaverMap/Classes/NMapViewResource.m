//
//  NMapViewResource.m
//  NaverMap
//
//  Created by KJ KIM on 10. 9. 15..
//  Copyright 2010 NHN. All rights reserved.
//


#import "NMapViewResource.h"


#define kCalloutTextSize 15.0

//
#define kCalloutMarginHoriz 12
#define kCalloutMarginVert 14
#define kCalloutHeightForTag 43

#define kCalloutGapIcon 6
#define kCalloutOffsetLeft 5
#define kCalloutOffsetRight 3
#define kCalloutOffsetRightShadow 2
#define kCalloutTagOffsetLeftCenter 16 // tagImage width = 16 + 7
#define kCalloutSizeMin 89
#define kCalloutTagOffsetLeft 20
#define kCalloutTagOffsetRight 20

#define kCalloutSelectArrowMargin 9

//

//
// To set callout position correctly
//
#define kPinInfoIconOffsetX (0)
#define kPinInfoIconOffsetY (5.0)

#define kNumberIconColor (1.0*0x77/0xFF) 
#define kNumberIconColorOver (1.0) 

@implementation NMapViewResource

static UIImage* makeNumberIconImage(NSString *backImageName, float color, int iconNumber)
{
	UIImage *backImage = [UIImage imageNamed:backImageName];
	if (!backImage) {
		return nil;
	}
	
	CGSize iconSize = backImage.size;
	CGSize imageSize = iconSize;
	imageSize.width += 2;
	imageSize.height += 2;
	
	NSString *iconText = [NSString stringWithFormat:@"%d", iconNumber];
	
	// font size
	CGFloat actualFontSize = 10; // for 3 digits 
	if (iconNumber < 10) actualFontSize = 12; // for 1 digit
	else if (iconNumber < 100) actualFontSize = 11; // for 2 digits
	// text size
	UIFont *font = [UIFont boldSystemFontOfSize:actualFontSize];
	CGSize sizeText = [iconText sizeWithFont:font constrainedToSize:iconSize lineBreakMode:UILineBreakModeTailTruncation];
	
	// create High-Resolution Bitmap Images Programmatically
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
		UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0.0);
	} else {
		UIGraphicsBeginImageContext(imageSize);
	}	
    
    CGContextRef context = UIGraphicsGetCurrentContext();
	
	// set fill color
	//CGContextSetRGBFillColor(context, 1.0, 0.0, 0.0, 1.0);
	//CGContextFillRect(context, CGRectMake(0,0,imageSize.width,imageSize.height));	
	
	// draw background image
	CGPoint pt = CGPointZero;
	pt.x = (imageSize.width - iconSize.width)/2;
	pt.y = (imageSize.height - iconSize.height)/2;
	// to prevent blur effect
	pt.x = roundf(pt.x);
	pt.y = roundf(pt.y);	
	[backImage drawAtPoint:pt blendMode:kCGBlendModeCopy/*kCGBlendModeNormal*/ alpha:1.0];
	
	// draw number
	CGRect rectText;
	rectText.origin.x = pt.x + (iconSize.width - sizeText.width)/2;
	rectText.origin.y = pt.y + (iconSize.height - sizeText.height)/2;
	rectText.size.width = sizeText.width;
	rectText.size.height = sizeText.height;
	// to prevent blur effect
	rectText.origin.x = roundf(rectText.origin.x);
	rectText.origin.y = roundf(rectText.origin.y);
	
	// set fill color
	CGContextSetRGBFillColor(context, color, color, color, 1.0);		
	[iconText drawAtPoint:rectText.origin forWidth:rectText.size.width withFont:font lineBreakMode:UILineBreakModeTailTruncation];			
	
	// get image
	UIImage *iconImage = UIGraphicsGetImageFromCurrentImageContext();	
	
	//NSLog(@"makeNumberIconImage: size=%@", NSStringFromCGSize(iconImage.size));
    
    UIGraphicsEndImageContext();		
	
	return iconImage;
}

+ (UIImage *) imageWithType:(NMapPOIflagType)poiFlagType iconIndex:(int)index selectedImage:(UIImage **)selectedImage
{
	UIImage *image = nil;
	
	switch (poiFlagType) {			
		case NMapPOIflagTypePin:
			if (index >= 0 && index < 1) {
				image = [UIImage imageNamed:@"map_place.png"];
			}
			break;
			
		case NMapPOIflagTypeLocation:
			if (index >= 0 && index < 1) {
				image = [UIImage imageNamed:@"ic_mylocation_on.png"];
				
				if (selectedImage) {
					*selectedImage = [UIImage imageNamed:@"ic_mylocation_on.png"];
				}
			}
			break;
			
		case NMapPOIflagTypeLocationOff:
			if (index >= 0 && index < 1) {
				image = [UIImage imageNamed:@"ic_mylocation_off.png"];
				
				if (selectedImage) {
					*selectedImage = [UIImage imageNamed:@"ic_mylocation_off.png"];
				}
			}
			break;										
			
		case NMapPOIflagTypeCompass:
			if (index >= 0 && index < 1) {
				image = [UIImage imageNamed:@"ic_angle.png"];
				
				if (selectedImage) {
					*selectedImage = [UIImage imageNamed:@"ic_angle.png"];
				}
			}
			break;														
			
		case NMapPOIflagTypeFrom:
			if (index >= 0 && index < 1) {
				image = [UIImage imageNamed:@"start_icon.png"];
				
				if (selectedImage) {
					*selectedImage = [UIImage imageNamed:@"start_icon_over.png"];
				}
			}		
			break;			
			
		case NMapPOIflagTypeTo:
			if (index >= 0 && index < 1) {
				image = [UIImage imageNamed:@"arr_icon.png"];
				
				if (selectedImage) {
					*selectedImage = [UIImage imageNamed:@"arr_icon_over.png"];
				}
			}		
			break;	
			
		case NMapPOIflagTypeNumber:
			// create number icons on demand
			image = makeNumberIconImage(@"by_00.png", kNumberIconColor, (index+1));
			
			if (selectedImage) {				
				*selectedImage = makeNumberIconImage(@"by_00_over.png", kNumberIconColorOver, (index+1));					
			}					
			break;
			
		default:
			break;
	}
	
	if (image) {
		if (selectedImage && (*selectedImage) == nil) {
			*selectedImage = image;
		}
	} else {
		NSAssert2(NO, @"poiIconWithType=> Failed to load for poiFlagType: %d, iconIndex: %d", poiFlagType, index);
	}
	
	return image;
}

+ (CGPoint) anchorPointWithType:(NMapPOIflagType)poiFlagType{

	CGPoint anchorPoint;
	
	switch (poiFlagType) {
		case NMapPOIflagTypePin:			
		case NMapPOIflagTypeFrom:
		case NMapPOIflagTypeTo:
			anchorPoint.x = 0.5;
			anchorPoint.y = 1.0;				
			break;
			
		case NMapPOIflagTypeLocation:
		case NMapPOIflagTypeLocationOff:	
		case NMapPOIflagTypeCompass:
			anchorPoint.x = 0.5;
			anchorPoint.y = 0.5;					
			break;									
			
		case NMapPOIflagTypeNumber:
			anchorPoint.x = 0.5;
			anchorPoint.y = 0.5;				
			break;
			
		default:
			anchorPoint.x = 0.5;
			anchorPoint.y = 1.0;			
			break;
	}
	
	return anchorPoint;
}

+ (UIImage *) imageForRightCalloutWithType:(NMapPOIflagType)poiFlagType selected:(BOOL)selected {
	
	UIImage *arrowIcon = nil;
	
	if (selected)
		arrowIcon = [UIImage imageNamed:@"arrow_off.png"];
	else 
		arrowIcon = [UIImage imageNamed:@"arrow.png"];
	
	return arrowIcon;
}

+ (CGPoint) calloutOffsetWithType:(NMapPOIflagType)poiFlagType {
	
	CGPoint offset;
	
	// check POI flag type
	switch (poiFlagType) {					
		default:
			offset.x = kPinInfoIconOffsetX;
			offset.y = kPinInfoIconOffsetY;	
			break;
			
	}	
	
	return offset;
}

+ (UIImage*) imageForCalloutOverlayItem:(NMapPOIitem *)poiItem constraintSize:(CGSize)constraintSize selected:(BOOL)selected 
	  imageForCalloutRightAccessory:(UIImage *)imageForCalloutRightAccessory
		calloutPosition:(CGPoint *)calloutPosition calloutHitRect:(CGRect *)calloutHitRect
{
	// left
	UIImage *leftImage = [UIImage imageNamed:@"left.png"];
	// right
	UIImage *rightImage = [UIImage imageNamed:@"right.png"];
	// center
	UIImage *centerImage = [UIImage imageNamed:@"center.png"];	
	// tag
	UIImage *tagImage = [UIImage imageNamed:@"bottom.png"];	
	
	NSString *strText = poiItem.title;
	NMapPOIflagType poiFlagType = poiItem.poiFlagType;
	BOOL hasCalloutRightAccessory = poiItem.hasRightCalloutAccessory;
	
	// image for right callout accessory	
	if (imageForCalloutRightAccessory == nil) {
		imageForCalloutRightAccessory = [self imageForRightCalloutWithType:poiFlagType selected:selected];
	}
	
	float rightCalloutMargin = 0.0f;
	
	CGSize rightAccessorySize = CGSizeZero;
	if (!hasCalloutRightAccessory) {
		imageForCalloutRightAccessory = nil;
	} else {
		rightAccessorySize = imageForCalloutRightAccessory.size;
	}
	
	float screenWidth = constraintSize.width;	
	constraintSize.width -= kCalloutOffsetLeft + kCalloutMarginHoriz + kCalloutGapIcon + rightAccessorySize.width + rightImage.size.width + kCalloutOffsetRight;
	constraintSize.height = kCalloutHeightForTag - kCalloutMarginVert*2;
		
	// text size
	CGFloat actualFontSize = [UIFont systemFontSize];
	actualFontSize = kCalloutTextSize;
	UIFont *font = [UIFont systemFontOfSize:actualFontSize];
	CGSize sizeText = [strText sizeWithFont:font constrainedToSize:constraintSize lineBreakMode:UILineBreakModeTailTruncation];
	
	// info image size
	CGRect rectImage = CGRectZero;
	rectImage.size.width = kCalloutMarginHoriz + sizeText.width 
						+ (imageForCalloutRightAccessory ? (kCalloutGapIcon + rightAccessorySize.width) : 0) + rightImage.size.width;
	rectImage.size.height = tagImage.size.height;
	
	rectImage.size.width += rightCalloutMargin;
	
	// adjust minimum size
	float expandedTextSizeWidth = sizeText.width;
	if (rectImage.size.width < kCalloutSizeMin) {
		expandedTextSizeWidth += kCalloutSizeMin - rectImage.size.width;
		
		rectImage.size.width = kCalloutSizeMin;		
	}
	
	// check pin position
	// align at center for info object 
	float x = (screenWidth - rectImage.size.width + kCalloutOffsetRightShadow)/2;
	if (calloutPosition->x < x + leftImage.size.width + kCalloutTagOffsetLeftCenter + kCalloutTagOffsetLeft) {
		calloutPosition->x = leftImage.size.width + kCalloutTagOffsetLeftCenter + kCalloutTagOffsetLeft;
	} else if (calloutPosition->x > x + rectImage.size.width - kCalloutTagOffsetRight - rightImage.size.width) {
		calloutPosition->x = rectImage.size.width - kCalloutTagOffsetRight - rightImage.size.width;
	} else {
		calloutPosition->x -= x; 
	}	
	calloutPosition->x = roundf(calloutPosition->x);	
	
	// create High-Resolution Bitmap Images Programmatically
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 4.0) {
		UIGraphicsBeginImageContextWithOptions(rectImage.size, NO, 0.0);
	} else {
		UIGraphicsBeginImageContext(rectImage.size);
	}	
    
    CGContextRef context = UIGraphicsGetCurrentContext();		
	
	CGPoint pt = CGPointZero;
	
	// draw left image
	const float alpha = 1.0;
	[leftImage drawAtPoint:pt blendMode:kCGBlendModeCopy alpha:alpha];
	
	// draw center image at left
	CGRect rect;
	rect.origin.x = leftImage.size.width;
	rect.origin.y = 0;
	rect.size.width = (calloutPosition->x - kCalloutTagOffsetLeftCenter) - rect.origin.x;
	rect.size.height = centerImage.size.height;
	
	if (rect.size.width > 0) {
		CGContextSaveGState(context);			
		
		CGContextTranslateCTM(context, 0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);	
		
		CGContextSetAlpha(context, alpha);
		CGContextDrawImage(context, rect, centerImage.CGImage);
		
		CGContextRestoreGState(context);
	}
	
	// draw tag
	pt.x = calloutPosition->x - kCalloutTagOffsetLeftCenter;
	pt.y = 0;	
	[tagImage drawAtPoint:pt blendMode:kCGBlendModeCopy alpha:alpha];	
	
	// draw center image at right
	rect.origin.x = pt.x + tagImage.size.width;
	rect.origin.y = 0;
	rect.size.width = rectImage.size.width - rect.origin.x - rightImage.size.width;
	rect.size.height = centerImage.size.height;
	
	if (rect.size.width > 0) {
		CGContextSaveGState(context);			
		
		CGContextTranslateCTM(context, 0, rect.size.height);
		CGContextScaleCTM(context, 1.0, -1.0);	
		
		CGContextSetBlendMode(context, kCGBlendModeCopy);
		CGContextSetAlpha(context, alpha);
		CGContextDrawImage(context, rect, centerImage.CGImage);
		
		CGContextRestoreGState(context);
	}
	
	// draw right image
	pt.x = rect.origin.x + rect.size.width;
	pt.y = 0;
	[rightImage drawAtPoint:pt blendMode:kCGBlendModeCopy alpha:alpha];				
	
	// draw text
	CGRect rectText;
	rectText.origin.x = kCalloutMarginHoriz + (expandedTextSizeWidth - sizeText.width)/2;
	rectText.origin.y = (kCalloutHeightForTag - sizeText.height)/2;
	rectText.size.width = sizeText.width;
	rectText.size.height = sizeText.height;
	// to prevent blur effect
	rectText.origin.x = roundf(rectText.origin.x);
	rectText.origin.y = roundf(rectText.origin.y);
	
	// set fill color
	if (selected) {
		CGContextSetRGBFillColor(context, 0x60/255.0, 0xca/255.0, 0x41/255.0, 1.0);
	} else {
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 1.0);
	}				
	[strText drawAtPoint:rectText.origin forWidth:rectText.size.width withFont:[UIFont systemFontOfSize:actualFontSize] lineBreakMode:UILineBreakModeTailTruncation];		
	
	// draw arrow	
	if (imageForCalloutRightAccessory)
	{
		pt.x = kCalloutMarginHoriz + expandedTextSizeWidth + kCalloutGapIcon;
		pt.y = (kCalloutHeightForTag - rightAccessorySize.height)/2;
		// to prevent blur effect
		pt.x = roundf(pt.x);
		pt.y = roundf(pt.y);
		[imageForCalloutRightAccessory drawAtPoint:pt];		
		
		// set hit rect for overall callout image except tag image
		*calloutHitRect = CGRectMake(0, 0, rectImage.size.width, rectImage.size.height);
		calloutHitRect->size.height -= (tagImage.size.height - centerImage.size.height);
	}
	else
	{
		*calloutHitRect = CGRectZero;
	}
	
	// get image
	UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();	
    
    UIGraphicsEndImageContext();	
	
	return myImage;
}

@end
