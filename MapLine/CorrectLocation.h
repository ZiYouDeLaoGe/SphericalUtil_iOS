//
//  CorrectLocation.h
//  OAConnect
//
//  Created by 李仁兵 on 14-4-26.
//  Copyright (c) 2014年 zengxiangrong. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
/**
 abstract:用来矫正地图位置信息
 */

@interface CorrectLocation : NSObject
+ (CLLocation *)transformToMars:(CLLocation *)location;
@end
