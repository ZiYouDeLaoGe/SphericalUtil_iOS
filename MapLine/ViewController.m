//
//  ViewController.m
//  MapLine
//
//  Created by 李仁兵 on 15/11/6.
//  Copyright © 2015年 李仁兵. All rights reserved.
//

#import "ViewController.h"
#import <MAMapKit/MAMapKit.h>
#import "SphericalUtil.h"

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define START_LOCATION @"开始测量"
#define STOP_LOCATION @"停止测量"

#define DEFAULT_MALLOC_NUM 100

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
    if (_assignmentNum == (_distributionNum + 1)*DEFAULT_MALLOC_NUM) {
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
    MAPolygon * _commonPolygon;
    MAPolygonView * _polygonView;
    
//    MAPolyline * _endpolyline;
//    MAPolylineView * _endPolyLineView;
    
    UIButton * _startBtn;
    BOOL _isLocation;
    
    UILabel * _infoLabel;
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
    
    
    _infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, SCREEN_HEIGHT - 120, SCREEN_WIDTH - 40, 100)];
    _infoLabel.textColor = [UIColor whiteColor];
    _infoLabel.backgroundColor = [UIColor redColor];
    _infoLabel.numberOfLines = 0;
    _infoLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:_infoLabel];
    
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
        [_startBtn setTitle:START_LOCATION forState:UIControlStateNormal];
        
//        UIAlertController * alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%lf平方米",[[[SphericalUtil alloc] init] computeArea:_coordinates andCount:_assignmentNum]] preferredStyle:UIAlertControllerStyleAlert];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action){
//            NSLog(@"取消");
//        }];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好的" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action){
//            NSLog(@"好的");
//        }];
//        [alertVC addAction:cancelAction];
//        [alertVC addAction:okAction];
//        [self presentViewController:alertVC animated:YES completion:nil];
    }
    
}

- (void)gdMapRemoveLine
{
    if (_commonPolygon) {
        [_gdMapView removeOverlay:_commonPolygon];
        _commonPolygon = nil;
    }
    if (_polygonView) {
        [_polygonView removeFromSuperview];
        _polygonView = nil;
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
        NSLog(@"水平精度 = %lf",userLocation.location.horizontalAccuracy);
        if(userLocation.location.horizontalAccuracy > 0){
//            horizontalAccuracy的值越大，那么定义的圆就越大，因此位置精度就越低。如果horizontalAccuracy的值为负，则表明coordinate的值无效。
            if (!isHaveCoordinate2D(userLocation.coordinate)) {
                if (_commonPolygon) {
                    [_gdMapView removeOverlay:_commonPolygon];
                    _commonPolygon = nil;
                }
                _commonPolygon = [MAPolygon polygonWithCoordinates:getCoordinates(userLocation.coordinate) count:_assignmentNum];
                _infoLabel.text = [NSString stringWithFormat:@"周长 = %lf米\n面积 = %lf平方米\n海拔 = %lf米",[[[SphericalUtil alloc] init] computePerimeter:_coordinates andCount:_assignmentNum],[[[SphericalUtil alloc] init] computeArea:_coordinates andCount:_assignmentNum],userLocation.location.altitude];
                //在地图上添加折线对象
                [_gdMapView addOverlay: _commonPolygon];
            }
        }
        NSLog(@"结束生成MAPolyline");
    }
}

- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    if (overlay == _commonPolygon && _isLocation)
    {
        NSLog(@"开始生成MAOverlayView");
        if (_polygonView) {
            [_polygonView removeFromSuperview];
            _polygonView = nil;
        }
        _polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        _polygonView.lineWidth = 1.f;
        _polygonView.strokeColor = [UIColor colorWithRed:78/255.0f green:187/255.0f blue:15/255.0f alpha:1.0];
        _polygonView.fillColor = [UIColor colorWithRed:255/255.0f green:114/255.0f blue:0/255.0f alpha:0.5];
        _polygonView.lineJoin = kCGLineJoinBevel;//连接类型
        _polygonView.lineCap = kCGLineCapRound;//端点类型
        NSLog(@"结束生成MAOverlayView");
        return _polygonView;
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
