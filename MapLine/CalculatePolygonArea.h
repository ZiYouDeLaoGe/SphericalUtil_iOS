//
//  CalculatePolygonArea.h
//  MapLine
//
//  根据经纬度计算多边形面积
//
//  Created by 李仁兵 on 15/11/13.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface CalculatePolygonArea : NSObject
- (CGFloat)computeArea:(CLLocationCoordinate2D *)coordinate2Ds andCount:(NSInteger)count;
@end
