//
//  MapManager.m
//  MapLine
//
//  Created by 李仁兵 on 15/11/6.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import "MapManager.h"
#import "CorrectLocation.h"

#define DISTANCEFILTER 1

@interface MapManager ()
<CLLocationManagerDelegate>
{
    CLLocationManager * _locationManager;
}
@end

@implementation MapManager

- (instancetype)init
{
    if (self = [super init]) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.delegate = self;
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        _locationManager.distanceFilter = DISTANCEFILTER;
    }
    return self;
}

- (void)dealloc
{
    [_locationManager stopUpdatingLocation];
    _locationManager.delegate = nil;
}

- (void)startUpdatingLocationMap
{
    //是否启用定位服务，通常如果用户没有启用定位服务可以提示用户打开定位服务
    if([CLLocationManager locationServicesEnabled]) {
        
        //用户尚未决定是否启用定位
        if(CLLocationManager.authorizationStatus == kCLAuthorizationStatusNotDetermined){
            
            if (_locationManager && [_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                [_locationManager requestWhenInUseAuthorization];//调用了这句,就会弹出允许框了.
            }
        }
        
        //用户已经明确禁止应用使用定位服务或者当前系统定位服务处于关闭状态
        if(CLLocationManager.authorizationStatus == kCLAuthorizationStatusDenied){
            if (_delegate && [_delegate respondsToSelector:@selector(alertToUserOpenLocationFunc)]) {
                [_delegate alertToUserOpenLocationFunc];
            }
            return;
        }
        [_locationManager startUpdatingLocation];
    }else{
        
        if (_delegate && [_delegate respondsToSelector:@selector(alertToUserOpenLocationFunc)]) {
            [_delegate alertToUserOpenLocationFunc];
        }
        
    }
}

- (void)stopUpdatingLocationMap
{
    [_locationManager stopUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    NSLog(@"didUpdateLocations:(NSArray *)locations");
    CLLocation *newLocation = locations[0];
//    NSLog(@"旧的经度：%f,旧的纬度：%f",newLocation.coordinate.longitude,newLocation.coordinate.latitude);
    //地理位置偏移转换
    newLocation = [CorrectLocation transformToMars:newLocation];
    CLLocationCoordinate2D coordinate2D = newLocation.coordinate;
//    NSLog(@"转换后的经度：%f,转换后的纬度：%f",newCoordinate.longitude,newCoordinate.latitude);
    if (_delegate && [_delegate respondsToSelector:@selector(succeedSendLocationCoordinate2D:andCLLocation:)]) {
        [_delegate succeedSendLocationCoordinate2D:coordinate2D andCLLocation:locations[0]];
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    if (_delegate && [_delegate respondsToSelector:@selector(faildGetLongitudeAndLatitude)]) {
        [_delegate faildGetLongitudeAndLatitude];
    }
}
@end
