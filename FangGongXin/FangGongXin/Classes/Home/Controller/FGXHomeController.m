//
//  FGXHomeController.m
//  FangGongXin
//
//  Created by Apple on 2017/9/20.
//  Copyright © 2017年 YaLeTeCh. All rights reserved.
//

#import "FGXHomeController.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <AMapLocationKit/AMapLocationKit.h>

#import "LoginRegisterController.h"
#import "FGXMeController.h"




@interface FGXHomeController ()<MAMapViewDelegate,AMapSearchDelegate,AMapLocationManagerDelegate>
//高德地图
@property (nonatomic, strong) MAMapView          *mapView;
//坐标红点
@property (nonatomic, strong) UIImageView        *redWaterView;
//定位
@property (nonatomic, strong) UIButton           *locationBtn;
@property (nonatomic, strong) UIImage            *imageLocated;
@property (nonatomic, strong) UIImage            *imageNotLocate;

@property (nonatomic, assign) NSInteger          searchPage;
//缩放地图
@property (nonatomic, strong) UIView             *zoomPannelView;

//头像按钮
@property (nonatomic, strong) UIButton           *headBtn;

//搜索
@property (nonatomic, strong) AMapSearchAPI      *search;

//缩放等级
@property (nonatomic, assign) CGFloat            *zoomL;

//城市
@property (nonatomic, strong) NSString           *city;

//经纬度
//@property (nonatomic) CLLocationDegrees  latitude;
//@property (nonatomic) CLLocationDegrees  longitude;

@property (nonatomic, strong) NSString           *token;

@end

@implementation FGXHomeController


+ (instancetype)FGXWithHomeController{
    return [MainStoryboard instantiateViewControllerWithIdentifier:NSStringFromClass(self)];
}

- (void)viewDidAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    
    [super viewDidAppear:YES];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.token = [[NSUserDefaults standardUserDefaults] valueForKey:FromToken];
    
    //开启 HTTPS 功能
    //地图需要v4.5.0及以上版本才必须要打开此选项（v4.5.0以下版本，需要手动配置info.plist）
    [[AMapServices sharedServices] setEnableHTTPS:YES];
    //设置高德地图appKey
    [AMapServices sharedServices].apiKey = XM_GDMap_Appkey;
    
    //添加控件
    [self.view addSubview:self.mapView];
    [self.view addSubview:self.redWaterView];
    [self.view addSubview:self.locationBtn];
    [self.view addSubview:self.zoomPannelView];
    [self.view addSubview:self.headBtn];
    
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    [self dataWithCloud];

}

#pragma mark - 监听地图缩放
/**
 *  地图将要发生缩放时调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
//- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction{
//    NSLog(@"zoomLevel == %f",_mapView.zoomLevel);
//}

/**
 *  地图缩放结束后调用此接口
 *
 *  @param mapView       地图view
 *  @param wasUserAction 标识是否是用户动作
 */
//- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction{
//    
//    if (_mapView.zoomLevel > 14) {
//        [self.mapView removeOverlays:self.mapView.overlays];
//        //房源数
//        [self dataWithCloud];
//
//        [self.mapView reloadMap];
//    }else if(_mapView.zoomLevel <= 14){
//        [self.mapView removeAnnotations:self.mapView.annotations];
//        //行政区面
//        [self dataWithDistrict];
//        
//        
//    }
//}

- (void)searchLocationWithCoordinate2D:(CLLocationCoordinate2D )coordinate {
    //构造AMapReGeocodeSearchRequest对象
    AMapReGeocodeSearchRequest *regeo = [[AMapReGeocodeSearchRequest alloc] init];
    regeo.location = [AMapGeoPoint locationWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    regeo.radius = 10000;
    regeo.requireExtension = YES;
    
    //发起逆地理编码
    [self.search AMapReGoecodeSearch: regeo];
}
#pragma mark - AMapSearchDelegate
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        //通过AMapReGeocodeSearchResponse对象处理搜索结果
        NSString *city = response.regeocode.addressComponent.city;
        if (!city || [city length] == 0) {
            city = response.regeocode.addressComponent.province; // 直辖市时获取此字段
        }
        self.city = city;
    }
    //行政区面
//    [self dataWithDistrict];

}



#pragma mark --- 地图区域改变完成后会调用此接口
- (void)mapView:(MAMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    //获取屏幕中心点坐标
    MACoordinateRegion region;
    CLLocationCoordinate2D centerCoordinate = mapView.region.center;
    region.center = centerCoordinate;
    [self searchLocationWithCoordinate2D:centerCoordinate];

//    self.latitude = centerCoordinate.latitude;
//    self.longitude = centerCoordinate.longitude;
    
}



#pragma mark - 行政区查询
- (void)dataWithDistrict{
    //行政区划查询
    AMapDistrictSearchRequest *dist = [[AMapDistrictSearchRequest alloc] init];
    dist.keywords = [NSString stringWithFormat:@"%@",self.city];
    dist.requireExtension = YES;
    //行政区查询
    [self.search AMapDistrictSearch:dist];
}

- (void)onDistrictSearchDone:(AMapDistrictSearchRequest *)request response:(AMapDistrictSearchResponse *)response
{
    
    if (response == nil) return;
        // 通过AMapDistrictSearchResponse对象处理搜索结果
        for (AMapDistrict *dist in response.districts)
        {
            
            for (AMapDistrict *di in dist.districts) {
                MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(di.center.latitude, di.center.longitude) radius:1000];
                circle.title  =  di.name;
                circle.subtitle = di.adcode;
                
                //在地图上添加圆
                [_mapView addOverlay: circle];
                
            }
        }
    
    
}

#pragma mark - maoverlay
- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth    = 1.f;
        circleRenderer.strokeColor  = [UIColor colorWithRed:153 /255.0 green:153 /255.0 blue:153 /255.0 alpha:0.3];
        circleRenderer.fillColor    = [UIColor colorWithRed:153 /255.0 green:153 /255.0 blue:153 /255.0 alpha:0.2];
        
        return circleRenderer;
    }
    return nil;
}


#pragma mark - 云图
- (void)dataWithCloud{
    
    //云图查询
    [self localSearchParametersWithTableID:XM_YunTuTableId searchCity:[NSString stringWithFormat:@"%@",self.city] keywords:@""];
}

- (void)localSearchParametersWithTableID:(NSString *)tableID searchCity:(NSString *)searchCity keywords:(NSString *)keyWord{
    
        //这是本地搜索
        AMapCloudPOILocalSearchRequest *placeLocal = [[AMapCloudPOILocalSearchRequest alloc] init];
        [placeLocal setTableID:tableID];
        [placeLocal setCity:searchCity];
        [placeLocal setKeywords:keyWord];
        placeLocal.offset = 100;// 最多只能获取100条数据
        [self.search AMapCloudPOILocalSearch:placeLocal];

    
//    AMapCloudPOIAroundSearchRequest *request = [[AMapCloudPOIAroundSearchRequest alloc]init];
//    [request setTableID:tableID];
//    [request setRadius:10000];
//    request.center = [AMapGeoPoint locationWithLatitude:self.latitude longitude:self.longitude];
//    request.radius = 100000;
//    request.offset = 100;  // 最多只能获取100条数据
//    request.page = 1;  // 第一页
//    
//    [self.search AMapCloudPOIAroundSearch:request];
}
//检索公告回调
- (void)onCloudSearchDone:(AMapCloudSearchBaseRequest *)request response:(AMapCloudPOISearchResponse *)response
{
    if (response == nil)
    {
        return;
    }
    NSMutableArray *annotations = [[NSMutableArray alloc] init];
        for (AMapCloudPOI *poi in response.POIs) {
            
            NSDictionary *coutDic = poi.customFields;
            long  housCount = [coutDic[@"count"] longValue];
            if (housCount != 0)  {
                
                AMapGeoPoint *point = poi.location;
                MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
                annotation.coordinate = CLLocationCoordinate2DMake(point.latitude, point.longitude);
                
                annotation.title = [NSString stringWithFormat:@"房源数:%@",coutDic[@"count"]];
                annotation.subtitle   = poi.address;
                
                [_mapView addAnnotation:annotation];
            }
            
            [annotations addObject:coutDic];
        }
    
}

//检索失败
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@", error);
}

#pragma mark - 设置标注注释和动画效果

- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView*annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
            
            
        }
        annotationView.canShowCallout= YES;       //设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;        //设置标注动画显示，默认为NO
        annotationView.draggable = YES;        //设置标注可以拖动，默认为NO
        
        return annotationView;
    }
    return nil;
}


#pragma mark - 按钮缩放地图
- (UIView *)makeZoomPannelView
{
    
    UIView *ret = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 53, 98)];
    
    UIButton *incBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 53, 49)];
    [incBtn setImage:[UIImage imageNamed:@"increase"] forState:UIControlStateNormal];
    [incBtn sizeToFit];
    [incBtn addTarget:self action:@selector(zoomPlusAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *decBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 49, 53, 49)];
    [decBtn setImage:[UIImage imageNamed:@"decrease"] forState:UIControlStateNormal];
    [decBtn sizeToFit];
    [decBtn addTarget:self action:@selector(zoomMinusAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    [ret addSubview:incBtn];
    [ret addSubview:decBtn];
    
    return ret;
}

- (void)zoomPlusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom + 1) animated:YES];
    self.mapView.showsScale = YES;
}

- (void)zoomMinusAction
{
    CGFloat oldZoom = self.mapView.zoomLevel;
    [self.mapView setZoomLevel:(oldZoom - 1) animated:YES];
    self.mapView.showsScale = NO;
}


//移动到当前用户位置
- (void)MoveCurrentUserPosition{
    
    if (self.mapView.userTrackingMode == MAUserTrackingModeFollow)
    {
        [self.mapView setUserTrackingMode:MAUserTrackingModeNone animated:YES];
    }
    else
    {
        self.searchPage = 1;
        
        [self.mapView setCenterCoordinate:self.mapView.userLocation.coordinate animated:YES];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 0.5 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            // 因为下面这句的动画有bug，所以要延迟0.5s执行，动画由上一句产生
            [self.mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
        });
    }
    [_mapView setZoomLevel:17 animated:YES];
}

//headBtnClick
- (void)headBtnClick{
   
    if (!self.token) {
        LoginRegisterController *loginReg = [[LoginRegisterController alloc]init];
        [self.navigationController pushViewController:loginReg animated:YES];
    }else{
   
        FGXMeController *meC = [FGXMeController FGXWithMeController];
        [self.navigationController pushViewController:meC animated:YES];
    }
    
}


#pragma mark - 懒加载
- (MAMapView *)mapView{
    if (_mapView == nil)
    {
        _mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
        _mapView.backgroundColor = [UIColor whiteColor];
        [_mapView setDelegate:self];
        //设置地图类型
        //        _mapView.mapType = MAMapTypeStandard;
        //设置定位精度
        //    _mapView.desiredAccuracy = kCLLocationAccuracyBest;
        //设置定位距离
        //    _mapView.distanceFilter = 5.0f;
        _mapView.zoomEnabled = YES;
        [_mapView setZoomLevel:16.5 animated:YES];
        //        _mapView.maxZoomLevel = 19;
        //        _mapView.minZoomLevel = 6;
        //开始定位
        _mapView.showsUserLocation = YES;
        //追踪用户地理位置更新
        _mapView.userTrackingMode  = MAUserTrackingModeFollow;
        //地图logo位置
        _mapView.logoCenter = CGPointMake(35, CGRectGetHeight(self.view.bounds)-60);
        // 设置成NO表示关闭指南针；YES表示显示指南针
        _mapView.showsCompass= YES;
        //设置指南针位置
        _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 48);
        //设置成NO表示不显示比例尺；YES表示显示比例尺
        _mapView.showsScale= YES;
        //设置比例尺位置
        _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x,48);

    }
    return _mapView;
}
//中心红点
- (UIImageView *)redWaterView{
    if (!_redWaterView) {
        UIImage *image = [UIImage imageNamed:@"wateRedBlank"];
        self.redWaterView = [[UIImageView alloc] initWithImage:image];
        
        self.redWaterView.frame = CGRectMake(self.view.bounds.size.width/2-image.size.width/2, self.mapView.bounds.size.height/2-image.size.height, image.size.width, image.size.height);
        
        self.redWaterView.center = CGPointMake(CGRectGetWidth(self.view.bounds) / 2, CGRectGetHeight(self.mapView.bounds) / 2 - CGRectGetHeight(self.redWaterView.bounds) / 2);

    }
    return _redWaterView;
}
//定位
- (UIButton *)locationBtn{
    if (!_locationBtn) {
        self.imageLocated = [UIImage imageNamed:@"gpssearchbutton"];
        self.imageNotLocate = [UIImage imageNamed:@"gpsnormal"];
        
        self.locationBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, kScreenH - 108, 40, 40)];
        self.locationBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
        self.locationBtn.backgroundColor = [UIColor whiteColor];
        
        self.locationBtn.layer.cornerRadius = 3;
        [self.locationBtn addTarget:self action:@selector(MoveCurrentUserPosition) forControlEvents:UIControlEventTouchUpInside];
        [self.locationBtn setImage:self.imageNotLocate forState:UIControlStateNormal];

    }
    return _locationBtn;
}
//缩放地图
- (UIView *)zoomPannelView{
    if (!_zoomPannelView) {
       _zoomPannelView = [self makeZoomPannelView];
        _zoomPannelView.center = CGPointMake(self.view.bounds.size.width -  CGRectGetMidX(_zoomPannelView.bounds) - 10,
                                            self.view.bounds.size.height -  CGRectGetMidY(_zoomPannelView.bounds) - 59);
        _zoomPannelView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    }
    return _zoomPannelView;
}
//头像
- (UIButton *)headBtn{
    if (!_headBtn) {
        _headBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_headBtn setFrame:CGRectMake(10, 78, 60, 60)];
        NSLog(@"token ===>%@",self.token);
        if (!self.token) {
            
            [_headBtn setBackgroundImage:[UIImage imageNamed:@"setup-head-default.png"] forState:UIControlStateNormal];
        }else{
            NSString *urlStr = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] valueForKey:FromImage]];
           NSURL *imageUrl =  [NSURL URLWithString:urlStr];
            NSData *imageData = [NSData dataWithContentsOfURL:imageUrl];
           [_headBtn setBackgroundImage:[UIImage imageWithData:imageData] forState:UIControlStateNormal];
        }
        //圆角
        _headBtn.layer.masksToBounds = YES;
        _headBtn.layer.cornerRadius  = 30;
        _headBtn.layer.borderWidth   = 1;
        _headBtn.layer.borderColor   = [[UIColor whiteColor] CGColor];
        [_headBtn addTarget:self action:@selector(headBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _headBtn;
}

@end
