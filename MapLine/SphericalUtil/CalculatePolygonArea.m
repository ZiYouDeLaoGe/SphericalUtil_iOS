//
//  CalculatePolygonArea.m
//  MapLine
//
//  Created by 李仁兵 on 15/11/13.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import "CalculatePolygonArea.h"

#define EARTH_RADIUS 6371009.0f

@implementation CalculatePolygonArea

double toRadians(double angdeg) {
    return angdeg/180.0f * M_PI;
}

double polarTriangleArea(double tan1, double lng1, double tan2, double lng2) {
    double deltaLng = lng1 - lng2;
    double t = tan1 * tan2;
    return 2 * atan2(t * sin(deltaLng), 1 + t * cos(deltaLng));
}

- (CGFloat)computeSignedArea:(CLLocationCoordinate2D *)coordinate2Ds andRadius:(CGFloat)radius andCount:(NSInteger)count
{
    if (count < 3) {
        return 0.0f;
    }
    double total = 0;
    CLLocationCoordinate2D prev = coordinate2Ds[count -1];
    
    double prevTanLat = tan((M_PI / 2 - toRadians(prev.latitude)) / 2);
    double prevLng = toRadians(prev.longitude);
    for (NSInteger i = 0;i<count;i++) {
        CLLocationCoordinate2D point = coordinate2Ds[i];
        double tanLat = tan((M_PI / 2 - toRadians(point.latitude)) / 2);
        double lng = toRadians(point.longitude);
        total += polarTriangleArea(tanLat, lng, prevTanLat, prevLng);
        prevTanLat = tanLat;
        prevLng = lng;
    }
    return total * (radius * radius);
    return 0.0f;
}

- (CGFloat)computeArea:(CLLocationCoordinate2D *)coordinate2Ds andCount:(NSInteger)count
{
    return fabs([self computeSignedArea:coordinate2Ds andRadius:EARTH_RADIUS andCount:count]);
}
@end
