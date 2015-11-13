//
//  SphericalUtil+ComputeArea.h
//  MapLine
//
//  Created by 李仁兵 on 15/11/13.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import "SphericalUtil.h"

@interface SphericalUtil (ComputeArea)
- (CGFloat)computeArea:(CLLocationCoordinate2D *)coordinate2Ds andCount:(NSInteger)count;
@end
