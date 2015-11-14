//
//  SphericalUtil+ComputePerimeter.h
//  MapLine
//
//  Created by 李仁兵 on 15/11/14.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import "SphericalUtil.h"

@interface SphericalUtil (ComputePerimeter)
- (CGFloat)computePerimeter:(CLLocationCoordinate2D *)coordinate2Ds andCount:(NSInteger)count;
@end
