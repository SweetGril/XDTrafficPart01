//
//  CLLocation+Additions.h
//  TBSport
//
//  Created by weixing.jwx on 15/4/28.
//  Copyright (c) 2015年 taobao. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

static const double kDegreesToRadians = M_PI / 180.0;
static const double kRadiansToDegrees = 180.0 / M_PI;


/*
 *  CLCoordinateRect
 *
 *  Discussion:
 *    A structure that contains a coordinate bounding box (rect).
 *
 *  Fields:
 *    topLeft:
 *      The coordinate at the top-left corner of the bounding box.
 *    bottomRight:
 *      The coordinate at the bottom-right corner of the bounding box.
 */
typedef struct {
    CLLocationCoordinate2D topLeft;
    CLLocationCoordinate2D bottomRight;
} CLCoordinateRect;

@interface CLLocation(Additions)

+ (CLLocationDistance) distanceFromCoordinate:(CLLocationCoordinate2D)fromCoord toCoordinate:(CLLocationCoordinate2D) toCoord;

- (CLLocationDistance) distanceFromCoordinate:(CLLocationCoordinate2D) fromCoord;

- (CLLocationSpeed) speedTravelledFromLocation:(CLLocation*)fromLocation;

// returns the bounding box which contains all CLLocations in locations array
+ (CLCoordinateRect) boundingBoxContainingLocations:(NSArray*)locations;

- (CLLocationCoordinate2D)marsCoordinate;

@end
