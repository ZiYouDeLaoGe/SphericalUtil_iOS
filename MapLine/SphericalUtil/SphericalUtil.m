//
//  SphericalUtil.m
//  MapLine
//
//  Created by 李仁兵 on 15/11/13.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import "SphericalUtil.h"

@implementation SphericalUtil
- (CGFloat)getDistance:(CLLocationCoordinate2D)start andEnd:(CLLocationCoordinate2D)end
{
    CGFloat lat1 = (M_PI / 180) * start.latitude;
    CGFloat lat2 = (M_PI / 180) * end.latitude;
    CGFloat lon1 = (M_PI / 180) * start.longitude;
    CGFloat lon2 = (M_PI / 180) * end.longitude;
    CGFloat d = acos(sin(lat1) * sin(lat2) + cos(lat1) * cos(lat2) * cos(lon2 - lon1))
				* EARTH_RADIUS;
    return d;
}
@end
