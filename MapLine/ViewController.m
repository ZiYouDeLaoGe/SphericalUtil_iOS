//
//  ViewController.m
//  MapLine
//
//  Created by 李仁兵 on 15/11/6.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "CalculatePolygonArea.h"
//#import "LocationOperate.c"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define START_LOCATION @"开始测量"
#define STOP_LOCATION @"停止测量"

#define DEFAULT_MALLOC_NUM 1

CLLocationCoordinate2D * _coordinates = NULL;
CLLocationCoordinate2D * _endLocations = NULL;
NSInteger _assignmentNum = 0; //赋值次数
NSInteger _distributionNum = 0;//分配内存次数

void freeCoordinates()
{
    _assignmentNum = 0;
    _distributionNum = 0;
    if(_coordinates){
        free(_coordinates);
    }
    if(_coordinates != NULL){
        _coordinates = NULL;
    }
}

void freeEndLocations()
{
    if (_endLocations) {
        free(_endLocations);
    }
    if (_endLocations != NULL) {
        _endLocations = NULL;
    }
}

CLLocationCoordinate2D * getCoordinates(CLLocationCoordinate2D coordinate2D)
{
    printf("开始为位置分配内存");
    if (!_coordinates) {
        _coordinates = malloc(DEFAULT_MALLOC_NUM*sizeof(CLLocationCoordinate2D));
    }
    if ((_assignmentNum+1) == (_distributionNum + 1)*DEFAULT_MALLOC_NUM) {
        CLLocationCoordinate2D * tempCoorinates = _coordinates;
        _coordinates = realloc(tempCoorinates,DEFAULT_MALLOC_NUM*sizeof(CLLocationCoordinate2D));
        tempCoorinates = NULL;
        _distributionNum ++;
    }
    _coordinates[_assignmentNum] = coordinate2D;
    _assignmentNum++;
    printf("结束为位置分配内存");
    return _coordinates;
}

BOOL isHaveCoordinate2D(CLLocationCoordinate2D coordinate2D)
{
    
    for (long i = 0;i<_assignmentNum;i++) {
        CLLocationCoordinate2D tempCoordinate2D = _coordinates[i];
        if (tempCoordinate2D.latitude == coordinate2D.latitude && tempCoordinate2D.longitude == coordinate2D.longitude) {
            return YES;
        }
    }
    return NO;
}

long getAssignmentNum()
{
    return _assignmentNum;
}

@interface ViewController ()
<
 MAMapViewDelegate
>
{
    MAMapView * _gdMapView;
    MAPolyline * _commonPolyline;
    MAPolylineView * _polylineView;
    
    MAPolyline * _endpolyline;
    MAPolylineView * _endPolyLineView;
    
    UIButton * _startBtn;
    BOOL _isLocation;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _gdMapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _gdMapView.userTrackingMode = MAUserTrackingModeFollow;
    _gdMapView.showsUserLocation = YES;

    _gdMapView.delegate = self;
    [_gdMapView setZoomLevel:18.5 animated:YES];
    [self.view addSubview:_gdMapView];
    
    
    _isLocation = NO;
    
    _startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_startBtn setBackgroundColor:[UIColor redColor]];
    [_startBtn addTarget:self action:@selector(locationControl) forControlEvents:UIControlEventTouchUpInside];
    [_startBtn setTitle:START_LOCATION forState:UIControlStateNormal];
    _startBtn.frame = CGRectMake(20,100, 150, 40);
    [self.view addSubview:_startBtn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

- (void)dealloc
{
    [self gdMapRemoveLine];
    freeCoordinates();
    freeEndLocations();
    _gdMapView.delegate = nil;
}

- (void)locationControl
{
    _isLocation = !_isLocation;
    if (_isLocation) {
        [self gdMapRemoveLine];
        freeCoordinates();
        [_startBtn setTitle:STOP_LOCATION forState:UIControlStateNormal];
    }else{
        [self creatEndLine];
        [_startBtn setTitle:START_LOCATION forState:UIControlStateNormal];
        
        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%lf平方米",[[[CalculatePolygonArea alloc] init] computeArea:_coordinates andCount:_assignmentNum]] preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
            NSLog(@"取消");
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
            NSLog(@"好的");
        }];
        [alertVC addAction:cancelAction];
        [alertVC addAction:okAction];
        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
}

- (void)gdMapRemoveLine
{
    if (_commonPolyline) {
        [_gdMapView removeOverlay:_commonPolyline];
        _commonPolyline = nil;
    }
    if (_polylineView) {
        [_polylineView removeFromSuperview];
        _polylineView = nil;
    }
    
    if (_endpolyline) {
        [_gdMapView removeOverlay:_endpolyline];
        _endpolyline = nil;
    }
    if (_endPolyLineView) {
        [_endPolyLineView  removeFromSuperview];
        _endPolyLineView = nil;
    }
    
}

//生成最后两点的线
- (void)creatEndLine
{
    if (!_endLocations) {
        freeEndLocations();
    }
    _endLocations =  malloc(2*sizeof(CLLocationCoordinate2D));
    if (_assignmentNum > 2) {
        _endLocations[0] = _coordinates[0];
        _endLocations[1] = _coordinates[_assignmentNum-1];
        if (_endpolyline) {
            [_gdMapView removeOverlay:_endpolyline];
        }
        _endpolyline = [MAPolyline polylineWithCoordinates:_endLocations count:2];
        //在地图上添加折线对象
        [_gdMapView addOverlay: _endpolyline];
    }
}


#pragma mark - MAMapViewDelegate

-(void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation
updatingLocation:(BOOL)updatingLocation
{
    if(updatingLocation && _isLocation)
    {
        NSLog(@"开始生成MAPolyline");
        //取出当前位置的坐标
        NSLog(@"latitude : %f,longitude: %f",userLocation.coordinate.latitude,userLocation.coordinate.longitude);
        NSLog(@"海拔高度 = %lf",userLocation.location.altitude);
        if (!isHaveCoordinate2D(userLocation.coordinate)) {
            if (_commonPolyline) {
                [_gdMapView removeOverlay:_commonPolyline];
                _commonPolyline = nil;
            }
            _commonPolyline = [MAPolyline polylineWithCoordinates:getCoordinates(userLocation.coordinate) count:_assignmentNum];
            //在地图上添加折线对象
            [_gdMapView addOverlay: _commonPolyline];
        }
        NSLog(@"结束生成MAPolyline");
    }
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if (overlay == _commonPolyline && _isLocation)
    {
        NSLog(@"开始生成MAOverlayView");
        if (_polylineView) {
            [_polylineView removeFromSuperview];
            _polylineView = nil;
        }
        _polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        _polylineView.lineWidth = 5.f;
        _polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        _polylineView.lineJoin = kCGLineJoinBevel;//连接类型
        _polylineView.lineCap = kCGLineCapRound;//端点类型
        NSLog(@"结束生成MAOverlayView");
        return _polylineView;
    }
    if (overlay == _endpolyline && !_isLocation) {
        _endPolyLineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        _endPolyLineView.lineWidth = 5.f;
        _endPolyLineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        _endPolyLineView.lineJoin = kCGLineJoinBevel;//连接类型
        _endPolyLineView.lineCap = kCGLineCapRound;//端点类型
        return _endPolyLineView;
    }
    return nil;
}

- (void)mapView:(MAMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MAAnnotationView *view = views[0];
    // 放到该方法中用以保证userlocation的annotationView已经添加到地图上了。
    if ([view.annotation isKindOfClass:[MAUserLocation class]])
    {
        MAUserLocationRepresentation *pre = [[MAUserLocationRepresentation alloc] init];
        pre.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        pre.strokeColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        pre.lineWidth = 0;
        pre.lineDashPattern = @[@6, @3];
        [_gdMapView updateUserLocationRepresentation:pre];
        view.calloutOffset = CGPointMake(0, 0);
    } 
}

@end
