//
//  SphericalUtil+ComputePerimeter.m
//  MapLine
//
//  Created by 李仁兵 on 15/11/14.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import "SphericalUtil+ComputePerimeter.h"

@implementation SphericalUtil (ComputePerimeter)
- (CGFloat)computePerimeter:(CLLocationCoordinate2D *)coordinate2Ds andCount:(NSInteger)count
{
    if (count < 2) {
        return 0.0f;
    }
    CGFloat perimeter = 0.0f;
    for (NSInteger i = 0;i < count - 1;i++) {
        CLLocationCoordinate2D start = coordinate2Ds[i];
        CLLocationCoordinate2D end = coordinate2Ds[i+1];
        perimeter += [self getDistance:start andEnd:end];
    }
    return perimeter;
}
@end
