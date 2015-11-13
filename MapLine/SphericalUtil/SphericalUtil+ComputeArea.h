//
//  SphericalUtil+ComputeArea.h
//  MapLine
//
//  Calculate the area based on latitude and longitude
//
//  Created by 李仁兵 on 15/11/13.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import "SphericalUtil.h"

@interface SphericalUtil (ComputeArea)

/*!
 @method - (CGFloat)computeArea:(CLLocationCoordinate2D *)coordinate2Ds andCount:(NSInteger)count;
 @abstract Calculate the area based on latitude and longitude
 @param coordinate2Ds:CLLocationCoordinate2D *;Coordinates array
 @param count:NSInteger;Coordinates array number
 @return area.If the number is less than 3 latitude and longitude returns 0, otherwise it returns the correct area
 */
- (CGFloat)computeArea:(CLLocationCoordinate2D *)coordinate2Ds andCount:(NSInteger)count;
@end
