//
//  SphericalUtil.h
//  MapLine
//
//  Created by 李仁兵 on 15/11/13.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MAMapKit/MAMapKit.h>

@interface SphericalUtil : NSObject
/**
 Extended attributes or parameters or methods that you need
 */
/*!
 @method - (CGFloat)getDistance:(CLLocationCoordinate2D)start andEnd:(CLLocationCoordinate2D)end;
 @abstract 计算两点之间的距离
 @param start:CLLocationCoordinate2D 起始经纬度
 @param end:CLLocationCoordinate2D 结束经纬度
 @return 两点之间距离，单位m
 */
- (CGFloat)getDistance:(CLLocationCoordinate2D)start andEnd:(CLLocationCoordinate2D)end;
@end

#import "SphericalUtil+ComputeArea.h"
#import "SphericalUtil+ComputePerimeter.h"
#define EARTH_RADIUS 6371009.0f
