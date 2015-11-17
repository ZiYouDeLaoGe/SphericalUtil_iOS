//
//  MapManager.h
//  MapLine
//
//  Created by 李仁兵 on 15/11/6.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@protocol MapManagerDelegate <NSObject>
- (void)alertToUserOpenLocationFunc;//提醒用户开启定位功能
- (void)faildGetLongitudeAndLatitude;
- (void)succeedSendLocationCoordinate2D:(CLLocationCoordinate2D)coordinate2D andCLLocation:(CLLocation *)location;
@end

@interface MapManager : NSObject
@property (nonatomic,weak)id<MapManagerDelegate> delegate;

- (void)startUpdatingLocationMap;

- (void)stopUpdatingLocationMap;

@end
